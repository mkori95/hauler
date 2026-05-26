# Hauler — Claude Code Project Context

## What Is Hauler
Hauler is an iOS + watchOS gym companion app built for inconsistent gym-goers who want to be consistent. The app hauls you off the couch, tracks your workouts, roasts you when you skip, and gets smarter the longer you use it.

Tagline: *"You haul the weight. We haul you there."*

## Core Personality
The app has attitude. It evolves its tone based on user consistency:
- Week 1–2: Encouraging hype-man
- Week 3–4: Light banter
- Month 2: Calling out patterns
- Month 3+: Full roast mode
- 5+ day absence: Drops jokes, genuinely checks in (empathy mode)

## Tech Stack
- iOS: Swift + SwiftUI
- watchOS: SwiftUI + WatchConnectivity
- Local Storage: SwiftData
- Backend: Supabase (PostgreSQL + Auth)
- AI: Claude API (anthropic) — plan generation + roast messages
- Exercise Data: ExerciseDB API (GIFs + metadata)
- Health Data: HealthKit (steps, sleep, heart rate)
- Music: MusicKit (Apple Music)
- Notifications: APNs

## Project Structure
- /Hauler — main iOS app
- /Hauler Watch — watchOS app target
- /Hauler Tests — unit tests

## Architecture Rules — Always Follow
- Offline-first: all workout logging works without internet
- SwiftData for local storage — sync to Supabase when online
- WatchConnectivity for iPhone ↔ Watch sync (Phase 1–2)
- Never add features outside current phase scope
- Always write clean, well-commented Swift code
- Follow Apple HIG for all UI decisions
- Every Watch feature must account for WatchConnectivity sync

## Current Phase: Phase 1
Build only these features. Nothing else.

### Phase 1 Features (in build order)
1. Onboarding — honesty-based mode selector (4 modes)
2. Basic profile setup (name, weight, height, age, equipment)
3. Exercise library — 100 exercises via ExerciseDB API
4. AI training plan generation — weekly split via Claude API
5. Workout session screen — set/rep/weight logger
6. Rest timer — auto-starts between sets
7. PR detection — flags when user beats personal best
8. Basic XP + streak system
9. Skip notifications with attitude (APNs)
10. Apple Watch — mirror session, rest timer, PR haptic

## Onboarding Modes
| Selection | Mode Name | Days/Week | Tone |
|---|---|---|---|
| 😴 Just want to move | Chill Coach | 3 | Full savage roast |
| 💪 Need structure | Smart Trainer | 4–5 | Moderate |
| 🔥 Serious | Ruthless Coach | 5–6 | Minimal humor |
| 🏆 Transform | Obsession Mode | 6 | Pure execution |

## Data Models (Core)
- User: id, name, age, weight, height, mode, equipment, preferredDays
- Exercise: id, name, muscleGroup, equipment, gifURL, difficulty
- WorkoutPlan: id, userId, weekStartDate, days[WorkoutDay]
- WorkoutDay: id, dayOfWeek, exercises[PlannedExercise]
- WorkoutSession: id, date, exercises[LoggedExercise], totalVolume, duration, xpEarned
- LoggedExercise: id, exerciseId, sets[LoggedSet]
- LoggedSet: id, weight, reps, isPR, completedAt
- UserStats: streak, totalXP, level, lastWorkoutDate

## Current Focus
UI Reference: Dark theme, #111111 background, #FF4D00 orange accent, 
DM Serif Display for headings, DM Sans for body, bottom nav with 
Home / Workout / Progress / Settings

Currently building: Basic profile setup (weight, height, equipment) — Phase 1 step 3

## Completed
- [x] Xcode project setup (iOS + watchOS targets)
- [x] GitHub repo created
- [x] Auth screen — sign up / sign in with animated tab toggle, form validation
- [x] Sign up collects: first name, last name, email, phone, date of birth, password
- [x] Onboarding screen — mode selector (4 modes, animated cards, haptics)
- [x] TrainingMode enum + UserProfile SwiftData model
- [x] Color+Hex extension, HaulerTextField reusable component (with focus state, password reveal)
- [x] App flow: AuthView → OnboardingView → ContentView (Home placeholder)
- [x] RootView gates flow via @AppStorage flags (isSignedUp, hasCompletedOnboarding)

## Do Not Touch
- Do not modify project structure without asking
- Do not add third party packages without confirming first
- Do not build Phase 2 features until Phase 1 is complete

## Supabase
- Not connected yet — use SwiftData locally for Phase 1
- Supabase integration comes in Phase 2

## API Keys
- Store all keys in a Config.swift file (gitignored)
- Never hardcode API keys in source files
- Config.swift template will be provided separately

## Notes for Claude
- Do NOT explain code unless explicitly asked
- Do NOT add summaries or walkthroughs after building
- Keep code clean and well commented
- One feature at a time
- Ask before making structural changes
- Just build — no teaching, no narration
