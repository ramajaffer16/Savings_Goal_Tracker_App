# Savings Goal Tracker

A simple iOS app that lets users create savings goals and track progress with deposits and withdrawals. Built with SwiftUI.

## How to Run the App

 Open 'Savings_Goal_Tracker_App.xcodeproj' in Xcode.
 Select an iOS Simulator (e.g., iPhone 16) or a connected device.
 Press **Run**.

## Architecture Overview
**SwiftUI** for all UI.
 **MVVM**: Views talk to a single `GoalsViewModel`; the view model talks to models and persistence.
 **Single source of truth**: `GoalsViewModel` holds `goals: [SavingsGoal]` and loads/saves via `PersistenceManager`.
 **Flow**:
  - **Home** → tap “Goal Savings” card → **Create a Goal** (full-screen) → success popup → “Go to My Goals” → **My Goals**.
  - **My Goals** → “Add a Goal” → **Create a Goal** (sheet) → success → back to My Goals with new goal.
  - On a goal card → **Deposit** or **Withdraw** → form (Coop Account / M-PESA, amount) → success → back to My Goals.
- **Persistence**: `PersistenceManager` saves/loads `[SavingsGoal]` as JSON in UserDefaults.

## Assumptions Made

- **Currency**: KES (Kenyan Shillings) for display; no real payments (Coop/M-PESA are UI only).
- **Deposit/Withdraw**: No date picker on these screens; contribution date is set to “now” when the user taps the button.
- **Goal category**: Optional; stored for display and to match the design (e.g. Travelling, Family).
- **One view model**: One 'GoalsViewModel' for the whole app, created at launch and passed via environmentObject.

## Trade-offs and Limitations

- **UserDefaults**: Simple and fine for a small list of goals; for large data or complex queries, something like Core Data would be better.
- **No sign-in**: All data is local to the device; no sync or backup.
- **Coop / M-PESA**: UI only; no real integration. Phone number and “Credit Account” are not used when saving.
- **Delete goal**: Exists in the view model but is not wired to a visible button in the UI (could be added later).
- **iOS only**: Built for iOS with SwiftUI; not adapted for macOS or other platforms.

