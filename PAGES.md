# KongkyApp — Pages & Data Reference

A quick reference of every screen in the app and the data displayed on each. Use this as a design prompting resource.

---

## 1. Splash Screen
- App logo ("K" in a circle)
- App name "Kongky" (letter-by-letter animation)

---

## 2. Login
- Logo + "Welcome Back" heading
- Subtitle: "Sign in to discover your next activity."
- **Fields:** Email, Password
- "Log In" button
- Divider: "or continue with"
- Social buttons: Apple, Google
- Link: "Don't have an account? **Sign Up**"

---

## 3. Register
- "Create Account" heading
- Subtitle: "Join Kongky to meet people and join activities around you."
- **Fields:** Full Name, Email, Password
- "Sign Up" button

---

## 4. Onboarding — Interest Selection
- "What are you into?" heading
- Subtitle: "Pick your favorite activities so we can recommend the best events for you."
- 2-column grid of categories:
  - `Board Game` · `Tea Time` · `Sport` · `Watch Party` · `Share Meal` · `Music`
- Selected chips turn **blue** with a spring bounce
- "Continue" button (disabled until ≥ 1 selected)

---

## 5. Dashboard (Home Tab)
- Welcome header: "Welcome," + **user name**
- Search bar (filters by title & location)
- Horizontal category pills: `Recommended` · `Movie` · `Sports` · `Board Game`
- Vertical list of **Event Cards**, each showing:
  - Category icon
  - Event title
  - Location
  - Date & time
  - Participant count vs. capacity
  - Individual price (formatted, e.g. "10k IDR / pax")
- Empty state: magnifying glass icon + "No activities found."
- **FAB** (floating + button) → opens Create Event

---

## 6. Event List (Events Tab)
- Title: "All Events"
- Grouped sections:
  - **This Week** / **Next Week** / **Completed** (50% opacity)
- Each row:
  - Date badge (gray box with white text, e.g. "Jun 16")
  - Category icon
  - Event title
  - Location + time (e.g. "Thamrin Nine Pantry / 19:00 - 21:00")

---

## 7. Activity Detail
- **Image** placeholder (250pt)
- **Info card:** category icon + title + description
- **Organizer card:** avatar circle, "Event by", organizer name, session label (e.g. "Afternoon Session")
- **Participants card** (tappable → Participant List):
  - Overlapping avatar circles (max 4 visible + "+X" overflow)
  - Text: "X more seats available, book now!" or "Fully booked!"
- **Details card:**
  - Individual Price — e.g. "10k IDR / pax"
  - Hint: "Invite more to become 7k / pax ↘"
  - Total Price — e.g. "50k IDR"
  - Date — e.g. "Jun 16"
  - Location — e.g. "Thamrin Nine Pantry"
- **Sticky bottom:** "Join Activity" button (green gradient, glassmorphism)
- **Toolbar:** heart icon (save/unsave toggle)

---

## 8. Participant List
- Nav title: "Participants"
- **Main Slots** section header: "(filled/capacity)"
  - Rows: avatar icon (blue) + "Participant 1, 2, 3…"
- **Mingling / Queue** section (only if overflow):
  - Rows: avatar icon (gray) + "Queue Member 1, 2…"

---

## 9. Create Event (Sheet)
- Nav title: "New Activity"
- **Event Thumbnail** — photo picker (shows preview or "Select a photo")
- **Basic Info** — Title, Category (picker: Board Game / Tea Time / Sport / Watch Party / Share Meal), Description
- **Details** — Location, Date, Time
- **Capacity & Cost** — Max Capacity (number pad), Cost in IDR (number pad)
- Toolbar: Cancel (red) · Save (blue)

---

## 10. Edit Event (Sheet)
- Nav title: "Edit Activity"
- Same form as Create Event, pre-filled with existing event data
- Toolbar: Cancel (red) · Update (blue)

---

## 11. Profile (Profile Tab)
- Avatar (large, system icon)
- **User name** (e.g. "Alex")
- Session badge (e.g. "Morning Session", blue)
- Email (e.g. "alex@example.com")
- Menu rows:
  - 🎫 My Activities → `MyActivitiesView`
  - ❤️ Saved Events → `SavedEventsView`
  - ⚙️ Settings → `SettingsView`
  - 🚪 Log Out (red, destructive)

---

## 12. My Activities
- Nav title: "My Activities"
- **Segmented control:** `Joined` | `Created`
- List of event rows (reusable `EventRowView`)
- Swipe actions:
  - **Created tab:** Edit (blue) + Delete (red)
  - **Joined tab:** Leave (red)

---

## 13. Saved Events
- Nav title: "Saved Events"
- List of saved event cards (reuses `DashboardEventCard`)
- Empty state: broken-heart icon + "No saved events yet." + hint text

---

## 14. Settings
- **Profile picture** — photo picker (circular, editable)
- **Profile Information:**
  - Name (text field)
  - Session (picker: Morning / Afternoon)
  - Email (disabled, gray)
  - My Interests → links to Edit Interests
- **Security:**
  - Current Password + New Password
  - "Update Password" button (disabled until both filled)
- **Danger Zone:**
  - "Delete Account" (red)

---

## 15. Edit Interests
- Nav title: "My Interests"
- Subtitle: "Update your favorite activities to refresh your recommended feed."
- 2-column grid (same as onboarding):
  - `Board Game` · `Tea Time` · `Sport` · `Watch Party` · `Share Meal` · `Music`
- Pre-selected with user's current interests
- Sticky "Save Changes" button (disabled if none selected)
