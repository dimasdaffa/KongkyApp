# KongkyApp

> A social group event planning and cost-splitting iOS application built with SwiftUI & Firebase.

KongkyApp helps communities organize group activities — from board game nights and futsal sessions to shared meals — with a built-in cost-splitting system that reduces the individual price as more people join.

---

## Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [App Flow](#app-flow)
- [Features & Requirements](#features--requirements)
  - [1. Splash Screen](#1-splash-screen)
  - [2. Authentication](#2-authentication)
  - [3. Onboarding — Interest Selection](#3-onboarding--interest-selection)
  - [4. Dashboard (Home)](#4-dashboard-home)
  - [5. Event List](#5-event-list)
  - [6. Activity Detail](#6-activity-detail)
  - [7. Event CRUD](#7-event-crud)
  - [8. Profile](#8-profile)
- [Data Model](#data-model)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)

---

## Overview

**KongkyApp** (from _kongkow_ — Indonesian slang for "hanging out") is a mobile-first platform that lets users discover, create, join, and manage group activities. Its signature feature is **dynamic cost-splitting**: the total event cost is divided among participants, so the per-person price drops as more people join.

## Tech Stack

| Layer        | Technology                |
|------------- |---------------------------|
| UI Framework | SwiftUI                   |
| Language     | Swift                     |
| Backend      | Firebase (Firestore)      |
| Auth         | Firebase Authentication   |
| IDE          | Xcode                     |
| Min Target   | iOS 26+                   |

## Architecture

The project follows the **MVVM (Model-View-ViewModel)** pattern:

```
Model       →  Event.swift (data + business logic)
ViewModel   →  HomeViewModel.swift (state management & Firebase CRUD)
Views       →  SwiftUI views organized by feature module
```

## App Flow

```
Splash Screen
  └─► Login / Register (Authentication)
        └─► Onboarding — Select Interests
              └─► Main Tab View
                    ├── Events Tab      (list of all activities)
                    ├── Home Tab        (dashboard with search & categories)
                    └── Profile Tab     (user info & settings)
```

---

## Features & Requirements

### 1. Splash Screen

| Requirement | Description |
|---|---|
| Animated intro | Displays a branded splash animation on launch |
| Auto-transition | Automatically navigates to auth once the animation completes |

### 2. Authentication

| Requirement | Description |
|---|---|
| Login | Email/password login screen |
| Register | Account creation screen for new users |
| Session state | Tracks `isAuthenticated` to gate access to the main app |

### 3. Onboarding — Interest Selection

| Requirement | Description |
|---|---|
| Category grid | Displays available interest categories in a responsive 2-column grid: **Board Game, Tea Time, Sport, Watch Party, Share Meal, Music** |
| Multi-select | Users can select multiple interests with haptic feedback and spring animations |
| Validation | "Continue" button is disabled until at least one interest is selected |
| Navigation | On continue, presents the main `TabView` as a full-screen cover |

### 4. Dashboard (Home)

| Requirement | Description |
|---|---|
| Welcome header | Greets the user by name |
| Search bar | Real-time text search filtering events by title or location |
| Category pills | Horizontally scrollable filter chips: **Recommended, Movie, Sports, Board Game** — with haptic feedback on tap |
| Event cards | Vertically scrolling list of `DashboardEventCard` components, each linking to the detail view |
| Skeleton loading | Shows 3 skeleton cards while data is loading |
| Empty state | Displays a "No activities found" message when filters return no results |
| FAB (Create) | Floating action button that opens the Create Event form as a sheet |

### 5. Event List

| Requirement | Description |
|---|---|
| Grouped sections | Events are grouped by timeframe: **This Week**, **Next Week**, **Completed** |
| Completed style | Completed events render at 50% opacity |
| List cells | Each row shows: date badge, category icon, title, location, and time |
| Skeleton loading | Shows 4 skeleton rows while data is loading |
| Navigation | Tapping a row navigates to the Activity Detail view |

### 6. Activity Detail

| Requirement | Description |
|---|---|
| Event image | Image placeholder area (250pt tall) |
| Info card | Title with category icon, and full description |
| Organizer card | Avatar, organizer name, and session label |
| Participant visualizer | Overlapping circle avatars showing filled/available slots, "+X" overflow indicator, and available seat count — links to a full participant list |
| Pricing & details | Individual price (with "invite more" hint showing next price drop), total price, date, and location |
| Cost-splitting logic | `currentIndividualPrice = totalCost / filledSlots` — dynamically drops as participants increase |
| Join button | Sticky glassmorphism "Join Activity" button at the bottom with haptic feedback; shows success alert on tap |
| Save/unsave | Heart icon in the toolbar to toggle save state with haptic feedback |

### 7. Event CRUD

| Requirement | Description |
|---|---|
| **Create** | `CreateEventView` form presented as a sheet from the Dashboard FAB |
| **Read** | Real-time Firestore snapshot listener (with local dummy data fallback) |
| **Update** | `EditEventView` for modifying existing events |
| **Delete** | `deleteEvent()` removes the document from Firestore |

> **Note:** Firebase Firestore operations are currently commented out; the app uses local dummy data for development.

### 8. Profile

| Requirement | Description |
|---|---|
| User info | Displays avatar, name, session badge, and email |
| My Activities | View the user's joined/created activities |
| Saved Events | View bookmarked/saved events |
| Edit Interests | Modify the user's selected interest categories |
| Settings | App settings and preferences |
| Log Out | Destructive action to sign out (highlighted in red) |

---

## Data Model

### `Event`

```swift
struct Event: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var location: String
    var date: String
    var time: String
    var cost: Int                        // Total cost in IDR
    var organizerName: String
    var organizerSession: String         // e.g. "Afternoon Session"
    var category: String                 // Board Game, Sport, Share Meal, etc.
    var timeframe: String                // This Week, Next Week, Completed
    var maxCapacity: Int
    var joinedParticipants: Int
    var imageURL: String?
    var isSaved: Bool
}
```

**Computed Properties:**

| Property | Logic |
|---|---|
| `mainSlotsFilled` | `min(joinedParticipants, maxCapacity)` |
| `queueCount` | `max(0, joinedParticipants - maxCapacity)` — overflow/mingling count |
| `iconName` | Maps category string → SF Symbol name |
| `currentIndividualPrice` | `cost / max(1, mainSlotsFilled)` |
| `nextIndividualPrice` | Price if one more person joins |
| `formatPrice(_:)` | Formats `50000` → `"50k"` |

---

## Project Structure

```
KongkyApp/
├── KongkyApp.swift              # App entry point, routing (Splash → Auth → Onboarding)
├── GoogleService-Info.plist     # Firebase configuration
├── Assets.xcassets/             # Asset catalog
│
├── Models/
│   └── Event.swift              # Data model with cost-splitting logic
│
├── ViewModels/
│   └── HomeViewModel.swift      # CRUD operations, dummy data, Firestore listener
│
├── Services/                    # (Reserved for service layer)
│
└── Views/
    ├── Splash/
    │   └── SplashView.swift
    ├── Auth/
    │   ├── LoginView.swift
    │   └── RegisterView.swift
    ├── Onboarding/
    │   └── OnboardingInterestsView.swift
    ├── MainTabView.swift        # Tab bar (Events · Home · Profile)
    ├── Dashboard/
    │   ├── DashboardView.swift
    │   ├── CreateEventView.swift
    │   ├── EditEventView.swift
    │   └── __Components/
    │       └── DashboardEventCardView.swift
    ├── Event/
    │   └── EventView.swift
    ├── Detail/
    │   ├── ActivityDetailView.swift
    │   └── ParticipantListView.swift
    ├── Profile/
    │   ├── ProfileView.swift
    │   ├── MyActivitiesView.swift
    │   ├── SavedEventsView.swift
    │   ├── EditInterestsView.swift
    │   └── SettingsView.swift
    └── Components/
        ├── EventRowView.swift
        ├── LoadingView.swift
        └── SkeletonView.swift
```

---

## Getting Started

### Prerequisites

- **Xcode 15+** (Swift 5.9+)
- **iOS 26+** deployment target
- A **Firebase project** with Firestore enabled

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/KongkyApp.git
   cd KongkyApp
   ```

2. **Open in Xcode**
   ```bash
   open KongkyApp.xcodeproj
   ```

3. **Configure Firebase**
   - Replace `GoogleService-Info.plist` with your own Firebase config file
   - Uncomment the Firestore imports and CRUD code in `HomeViewModel.swift` and `Event.swift` to connect to your backend

4. **Run**
   - Select a simulator or device and hit **⌘R**

---

<p align="center">
  Made with ❤️ using SwiftUI
</p>
