# Savings Goal Tracker
A simple iOS app that lets users create savings goals and track progress with deposits and withdrawals. Built with SwiftUI.

## How to Run the App
 Open 'Savings_Goal_Tracker_App.xcodeproj' in Xcode.
 Select an iOS Simulator (e.g., iPhone 16) or a connected device.
 Press **Run**.

## Architecture Overview
 **SwiftUI**
 **MVVM**:
 **Persistence**: `PersistenceManager` saves/loads `[SavingsGoal]` as JSON in UserDefaults.

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
- **Time limitation**: If I had more time I will hide the toggle visiblity so that users can hide and unhide amount when they want.

