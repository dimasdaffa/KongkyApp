# 🏗️ KongkyApp Architecture Guide

---

## Table of Contents

1. [The Big Picture](#the-big-picture)
2. [Priority 1: Service Layer (EventService)](#priority-1-service-layer)
3. [Priority 2: Auth Service Layer](#priority-2-auth-service-layer)
4. [Priority 3: Clean Up the Model](#priority-3-clean-up-the-model)
5. [Priority 4: Protocols for Testability](#priority-4-protocols-for-testability)
6. [Priority 5: Break Up Large Views](#priority-5-break-up-large-views)
7. [OOP Concepts Summary](#oop-concepts-summary)
8. [Final Project Structure](#final-project-structure)

---

## The Big Picture

### Before Refactoring

```
View → ViewModel → Firebase (directly)
```

The problem? Everything was tangled together:
- `HomeViewModel` imported Firebase and called `Firestore.firestore()` directly
- `AuthViewModel` imported Firebase and called `Auth.auth()` directly
- Views like `CreateEventView` also imported `FirebaseAuth` to get user info
- All toast UI, form fields, and keyboard logic was copy-pasted between files

### After Refactoring

```
View → ViewModel → Service (Protocol) → Firebase
```

Now each layer has **one job** and only talks to its neighbor.

### The Restaurant Analogy 🍽️

| Layer | Restaurant | KongkyApp |
|-------|-----------|-----------|
| **View** | Dining room | Shows UI to the user. Doesn't cook. |
| **ViewModel** | Waiter | Takes orders (user actions), asks kitchen, brings food (data) back |
| **Service** | Kitchen | Actually cooks (talks to Firebase). Hidden from customers |
| **Model** | Recipe/Menu | Describes what the food is. Doesn't cook or serve |

**Golden Rule: Each layer only talks to the layer next to it.**

---

## Priority 1: Service Layer

### What We Did
Created `EventService.swift` — moved ALL Firestore database code out of `HomeViewModel`.

### Before ❌
```swift
// HomeViewModel.swift — Firebase code mixed with UI state
import FirebaseFirestore      // ❌ ViewModel knows about Firebase

class HomeViewModel: ObservableObject {
    private var db = Firestore.firestore()  // ❌ Direct Firebase reference
    
    func fetchEvents() {
        db.collection("activities").addSnapshotListener { ... }  // ❌ Firebase call here
    }
    
    func addEvent(event: Event) {
        try db.collection("activities").addDocument(from: event)  // ❌ Firebase call here
    }
}
```

### After ✅
```swift
// EventService.swift — Firebase code isolated
class EventService: EventServiceProtocol {
    private let db = Firestore.firestore()
    
    func fetchEvents(completion: @escaping ([Event]) -> Void) {
        db.collection("activities").addSnapshotListener { ... }
    }
}

// HomeViewModel.swift — Clean! No Firebase imports
class HomeViewModel: ObservableObject {
    private let eventService: EventServiceProtocol  // ✅ Uses protocol
    
    func fetchEvents() {
        eventService.fetchEvents { events in  // ✅ Delegates to service
            self.events = events
        }
    }
}
```

### Why It's Best Practice
1. **If you switch from Firebase to Supabase** → you only change `EventService.swift`, not 10 files
2. **Single Responsibility** → ViewModel manages UI state. Service manages database.
3. **Testability** → You can create a `MockEventService` with fake data for testing

### 📁 Files
- `Services/EventService.swift` — The Firebase kitchen
- `ViewModels/HomeViewModel.swift` — The clean waiter

---

## Priority 2: Auth Service Layer

### What We Did
Same pattern as Priority 1, but for authentication. Moved all `Auth.auth()` calls from `AuthViewModel` into `AuthService.swift`.

### Before ❌
```swift
// AuthViewModel.swift
Auth.auth().createUser(withEmail: email, password: password) { result, error in
    // Messy nested callbacks mixing Firebase + UI state
}
```

### After ✅
```swift
// AuthService.swift
func register(email:password:fullName:completion:) {
    Auth.auth().createUser(...) { ... }  // Firebase stays here
}

// AuthViewModel.swift — Uses clean Result type
authService.register(email: email, password: password, fullName: fullName) { result in
    switch result {
    case .success(let user):  // Clean success handling
        self.userSession = user
    case .failure(let error):  // Clean error handling
        self.errorMessage = error.localizedDescription
    }
}
```

### New Concept: `Result<Success, Failure>`
Instead of using `(Bool, String?)` to indicate success/failure, Swift has a built-in `Result` type:
```swift
// Old way ❌
completion(true)   // What does true mean?
completion(false)  // Why did it fail? Need a separate error variable.

// Result way ✅
completion(.success(user))     // Clearly succeeded, here's the user
completion(.failure(error))    // Clearly failed, here's why
```

### 📁 Files
- `Services/AuthService.swift` — Firebase Auth kitchen
- `ViewModels/AuthViewModel.swift` — Clean waiter with Result type

---

## Priority 3: Clean Up the Model

### What We Did
1. Separated `EventParticipant` into its own file
2. Created `CurrentUser.swift` to replace scattered `Auth.auth().currentUser` calls in Views

### Why Separate EventParticipant?

**Before:** Both `Event` and `EventParticipant` lived in `Event.swift`
**After:** Each struct has its own file

This is the **Single Responsibility Principle (SRP):**
> Every file should have ONE reason to change.

If you add a new field to `EventParticipant` (like `avatarURL`), you edit `EventParticipant.swift` — not `Event.swift`.

### Why Create CurrentUser?

**Before ❌** — Views importing Firebase directly:
```swift
// CreateEventView.swift
import FirebaseAuth                              // ❌ View knows about Firebase
let email = Auth.auth().currentUser?.email ?? ""  // ❌ Messy, repeated everywhere
```

**After ✅** — Clean facade:
```swift
// CurrentUser.swift (Utilities/)
struct CurrentUser {
    static var email: String {
        Auth.auth().currentUser?.email ?? ""
    }
    static var displayName: String {
        Auth.auth().currentUser?.displayName ?? "Kongky User"
    }
}

// CreateEventView.swift — No Firebase import needed!
let email = CurrentUser.email        // ✅ Clean, readable
let name = CurrentUser.displayName   // ✅ One place to change
```

This is the **Facade Pattern:**
> A simple interface that hides complex internals.

### 📁 Files
- `Models/EventParticipant.swift` — Own file (SRP)
- `Utilities/CurrentUser.swift` — Facade for auth info

---

## Priority 4: Protocols for Testability

### What We Did
Created `EventServiceProtocol` and `AuthServiceProtocol` — contracts that services must follow.

### What Is a Protocol?
A protocol is like a **job description**. It says:
> "Anyone who wants to be an EventService must have these functions."

But it does NOT say HOW to implement them.

```swift
// The "job description"
protocol EventServiceProtocol {
    func fetchEvents(completion: @escaping ([Event]) -> Void)
    func addEvent(_ event: Event)
    func updateEvent(_ event: Event)
    func deleteEvent(_ event: Event)
}

// The "real employee" (uses Firebase)
class EventService: EventServiceProtocol { ... }

// The "intern" (uses fake data, for testing)
class MockEventService: EventServiceProtocol {
    func fetchEvents(completion: @escaping ([Event]) -> Void) {
        completion([Event.sampleEvent])  // Fake data!
    }
}
```

### Why Protocols + Dependency Injection?

```swift
class HomeViewModel: ObservableObject {
    private let eventService: EventServiceProtocol  // TYPE = Protocol
    
    // Default = real Firebase, but you can inject a mock
    init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
    }
}

// In the real app:
let vm = HomeViewModel()  // Uses EventService() by default

// In unit tests or previews:
let vm = HomeViewModel(eventService: MockEventService())  // Uses fake data
```

This is **"Program to an interface, not an implementation"** — one of the most important OOP principles.

### 📁 Files
- `Services/Protocols/EventServiceProtocol.swift`
- `Services/Protocols/AuthServiceProtocol.swift`

---

## Priority 5: Break Up Large Views

### What We Did
1. Created reusable UI components (`StyledTextField`, `CategoryPicker`, `ToastView`)
2. Replaced duplicated code in 3 View files with those components
3. Moved `hideKeyboard()` extension to its own file

### The Problem: Copy-Paste Code

`CreateEventView` and `EditEventView` had **identical** form fields — labels, text fields, category pickers, toast notifications. That's ~100 lines of copy-pasted UI in each file.

**Why is copy-paste bad?**
- Bug in the title field? Fix it in `CreateEventView`... but forget `EditEventView`. 🐛
- Want to change the toast style? Change it in 3 places. Miss one? Inconsistent UI.

### The Solution: Reusable Components

```swift
// BEFORE ❌ — 20 lines per text field, repeated everywhere
VStack(alignment: .leading, spacing: 8) {
    Text("ACTIVITY TITLE")
        .font(.caption2)
        .fontWeight(.bold)
        .foregroundColor(.themeTextVariant)
        .tracking(1)
    TextField("What are we doing?", text: $title)
        .padding(16)
        .background(Color.themePrimary.opacity(0.05))
        .cornerRadius(16)
}

// AFTER ✅ — 1 line! Same result.
StyledTextField(label: "ACTIVITY TITLE", placeholder: "What are we doing?", text: $title)
```

```swift
// Toast: Before = 28 lines. After = 1 line.
ToastView(icon: "sparkles", message: "Activity successfully created!")
```

### Line Count Comparison

| File | Before | After | Lines Saved |
|------|--------|-------|-------------|
| `CreateEventView.swift` | 488 | ~380 | ~108 |
| `EditEventView.swift` | 523 | ~430 | ~93 |
| `ActivityDetailView.swift` | 469 | ~443 | ~26 |

### New Concept: `@Binding`

Reusable components don't OWN data — the parent View does. `@Binding` creates a **two-way connection**:

```swift
// Parent (CreateEventView) OWNS the data
@State private var title = ""  // Source of truth

// Child (StyledTextField) BORROWS it via @Binding
struct StyledTextField: View {
    @Binding var text: String  // Two-way link to parent's @State
}

// When StyledTextField changes text, the parent's title updates too!
StyledTextField(label: "TITLE", placeholder: "...", text: $title)
//                                                       ^ the $ means "pass as binding"
```

Think of it like a **TV remote**: the remote (child) controls the TV (parent), but the TV is the source of truth.

### 📁 Files
- `Views/Components/EventFormFields.swift` — `StyledTextField`, `CategoryPicker`, `ToastView`
- `Extensions/View+Keyboard.swift` — Moved from CreateEventView

---

## OOP Concepts Summary

Here's every concept used in this refactoring, in order of importance:

| # | Concept | One-Line Explanation | Where Used |
|---|---------|---------------------|------------|
| 1 | **Separation of Concerns** | Each class/file has ONE job | ViewModels vs Services |
| 2 | **Protocol** | A contract — "what" not "how" | `EventServiceProtocol` |
| 3 | **Dependency Injection** | Pass dependencies from outside, don't hardcode | `HomeViewModel.init(eventService:)` |
| 4 | **Single Responsibility (SRP)** | One file = one reason to change | `EventParticipant.swift` |
| 5 | **Don't Repeat Yourself (DRY)** | Write once, reuse everywhere | `StyledTextField`, `ToastView` |
| 6 | **Facade Pattern** | Simple interface hiding complexity | `CurrentUser.email` |
| 7 | **Encapsulation** | Hide internal details | Firebase hidden inside Services |
| 8 | **Result Type** | Clean success/failure without booleans | `AuthService.register()` |
| 9 | **@Binding** | Two-way parent ↔ child data connection | `StyledTextField(text: $title)` |

---

## Final Project Structure

```
KongkyApp/
├── KongkyApp.swift                     ← App entry point
│
├── Models/                             ← Pure data structures
│   ├── Event.swift
│   └── EventParticipant.swift
│
├── Services/                           ← ALL Firebase code lives here
│   ├── Protocols/
│   │   ├── EventServiceProtocol.swift  ← Contract
│   │   └── AuthServiceProtocol.swift   ← Contract
│   ├── EventService.swift              ← Firestore CRUD
│   └── AuthService.swift               ← Firebase Auth
│
├── ViewModels/                         ← UI state management
│   ├── AuthViewModel.swift             ← Calls AuthService
│   └── HomeViewModel.swift             ← Calls EventService
│
├── Views/                              ← Pure UI (no Firebase imports)
│   ├── Auth/
│   │   ├── LoginView.swift
│   │   ├── RegisterView.swift
│   │   └── ForgotPasswordView.swift
│   ├── Components/
│   │   ├── EventFormFields.swift       ← Reusable: StyledTextField, CategoryPicker, ToastView
│   │   ├── EventRowView.swift
│   │   ├── LoadingView.swift
│   │   └── SkeletonView.swift
│   ├── Dashboard/
│   │   ├── DashboardView.swift
│   │   ├── CreateEventView.swift
│   │   ├── EditEventView.swift
│   │   └── __components/
│   ├── Detail/
│   │   ├── ActivityDetailView.swift
│   │   └── ParticipantListView.swift
│   ├── Event/
│   │   └── EventView.swift
│   ├── Onboarding/
│   │   └── OnboardingInterestsView.swift
│   ├── Profile/
│   │   ├── ProfileView.swift
│   │   ├── SettingsView.swift
│   │   ├── MyActivitiesView.swift
│   │   ├── SavedEventsView.swift
│   │   └── EditInterestsView.swift
│   ├── Splash/
│   │   └── SplashView.swift
│   └── MainTabView.swift
│
├── Extensions/                         ← Reusable modifiers & helpers
│   ├── ColorTheme.swift
│   ├── SpringyButton.swift
│   └── View+Keyboard.swift
│
└── Utilities/                          ← App-wide helpers
    └── CurrentUser.swift               ← Facade for Auth.auth().currentUser
```

---

## What's Next?

Here are some things you can do as you grow:

| When You... | You Should... |
|------------|--------------|
| Add a new Firebase collection | Create a new Service + Protocol pair |
| Need user profile data | Create `UserService` + `AppUser` model |
| Want unit tests | Create `MockEventService` conforming to the protocol |
| Add a new form screen | Reuse `StyledTextField`, `CategoryPicker`, `ToastView` |
| Need a new helper | Add it to `Utilities/` or `Extensions/` |

**The architecture is now your foundation. Every new feature follows the same pattern:** Model → Service → ViewModel → View. 🚀
