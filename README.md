# Hauler

> *You haul the weight. We haul you there.*

A gym companion app for inconsistent gym-goers who want to be consistent. Hauler tracks your workouts, roasts you when you skip, and gets meaner the longer you use it.

---

## Status

**Phase 1 — In Progress**

| Feature | Status |
|---|---|
| Auth screen (sign up / sign in) | ✅ Done |
| Onboarding — mode selector | ✅ Done |
| Basic profile setup | 🔄 Next |
| Exercise library (ExerciseDB) | ⏳ Pending |
| AI training plan (Claude API) | ⏳ Pending |
| Workout session screen | ⏳ Pending |
| Rest timer | ⏳ Pending |
| PR detection | ⏳ Pending |
| XP + streak system | ⏳ Pending |
| Skip notifications (APNs) | ⏳ Pending |
| Apple Watch app | ⏳ Pending |

---

## Tech Stack

| Layer | Tech |
|---|---|
| iOS UI | Swift + SwiftUI |
| watchOS UI | SwiftUI + WatchConnectivity |
| Local storage | SwiftData |
| Backend | Supabase (Phase 2) |
| AI | Claude API — plan generation + roasts |
| Exercise data | ExerciseDB API |
| Health | HealthKit |
| Music | MusicKit |
| Notifications | APNs |

---

## App Flow

```
AuthView (Sign Up / Sign In)
    ↓ sign up
OnboardingView (pick training mode)
    ↓ continue
ProfileSetupView (weight, height, equipment) ← next to build
    ↓ done
HomeView (dashboard + today's workout)
```

---

## Training Modes

| Mode | Days/Week | AI Tone |
|---|---|---|
| 😴 Chill Coach | 3 | Full savage roast |
| 💪 Smart Trainer | 4–5 | Moderate |
| 🔥 Ruthless Coach | 5–6 | Minimal humor |
| 🏆 Obsession Mode | 6 | Pure execution |

---

## Project Structure

```
hauler/
├── Auth/
│   ├── AuthView.swift          # Sign up / sign in screen
│   └── HaulerTextField.swift   # Reusable styled text field
├── Onboarding/
│   ├── OnboardingView.swift    # Mode selector
│   └── ModeCardView.swift      # Selectable mode card
├── Models/
│   ├── UserProfile.swift       # SwiftData user model
│   └── TrainingMode.swift      # Training mode enum
├── Extensions/
│   └── Color+Hex.swift         # Hex color init
├── RootView.swift              # App-level navigation gate
├── ContentView.swift           # Home screen (placeholder)
└── haulerApp.swift             # App entry point
```

---

## Design System

| Token | Value |
|---|---|
| Background | `#111111` |
| Orange accent | `#FF4D00` |
| Card background | `#1A1A1A` |
| Card border | `#2A2A2A` |
| Heading font | System serif (DM Serif Display — add to project) |
| Body font | System sans (DM Sans — add to project) |

---

## Architecture Rules

- **Offline-first** — all workout logging works without internet
- **SwiftData** for local storage — Supabase sync in Phase 2
- **Never hardcode API keys** — use `Config.swift` (gitignored)
- **One feature at a time** — stay in Phase 1 scope
- **Ask before structural changes** or adding packages

---

## API Keys

All keys live in `Config.swift` (gitignored). Template to be provided separately.

Required keys:
- `ANTHROPIC_API_KEY` — Claude API
- `EXERCISEDB_API_KEY` — ExerciseDB
- `SUPABASE_URL` + `SUPABASE_ANON_KEY` — Phase 2

---

## Local Setup

1. Clone the repo
2. Open `Hauler.xcodeproj` in Xcode
3. Select an iPhone simulator
4. **Cmd+R** to build and run
5. Create `hauler/Config.swift` with API keys (see template)

> Requires Xcode 16+ and iOS 26 SDK.
