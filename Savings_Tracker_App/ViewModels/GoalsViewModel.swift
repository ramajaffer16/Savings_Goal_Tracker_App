//
//  GoalsViewModel.swift
//  SavingsApp
//
//  Created by Ramadhan on 09/03/2026.
//
import Foundation

// MARK: - GoalsViewModel
// ObservableObject = SwiftUI can subscribe to changes
// All business logic lives here — views just call these functions


class GoalsViewModel: ObservableObject {

    // @Published = any view watching this will auto-refresh when it changes
    @Published var goals: [SavingsGoal] = []

    // When this is set, the UI shows a congratulations alert
    @Published var justCompletedGoal: SavingsGoal? = nil

    private let persistence = PersistenceManager.shared

    // Load saved data the moment this ViewModel is created
    init() {
        goals = persistence.load()
    }

    // MARK: - Create Goal
    func createGoal(name: String, category: String?, targetAmount: Double, targetDate: Date?) {
        let goal = SavingsGoal(
            name: name,
            category: category,
            targetAmount: targetAmount,
            targetDate: targetDate
        )
        goals.append(goal)
        save()
    }

    // MARK: - Add Contribution
    //Requires contributions to have an amount AND a date
    func addContribution(to goalID: UUID, amount: Double, date: Date) {
        // Find the index of the goal we want to update
        guard let index = goals.firstIndex(where: { $0.id == goalID }) else { return }

        let contribution = Contribution(amount: amount, date: date)
        goals[index].contributions.append(contribution)

        // Check if this contribution completed the goal
        // Only fire the alert if it JUST became complete (not already was)
        if goals[index].isCompleted {
            justCompletedGoal = goals[index]
        }

        save()
    }

    // MARK: - Delete Goal
    func deleteGoal(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
        save()
    }

    // MARK: - Private Helpers
    private func save() {
        persistence.save(goals)
    }
}
