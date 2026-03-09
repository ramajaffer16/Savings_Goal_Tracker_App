//
//  SavingsGoal.swift
//  SavingsApp
//
//  Created by Ramadhan on 09/03/2026.
//


import Foundation

// MARK: - Contribution
struct Contribution: Identifiable, Codable {
    var id = UUID()
    var amount: Double
    var date: Date

    init(amount: Double, date: Date = Date()) {
        self.amount = amount
        self.date = date
    }
}

// MARK: - SavingsGoal
struct SavingsGoal: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: String?
    var targetAmount: Double
    var targetDate: Date?
    var contributions: [Contribution] = []
    var createdAt: Date = Date()

    // MARK: Computed Properties
    // total saved, remaining, and percentage progress

    var totalSaved: Double {
        contributions.reduce(0) { $0 + $1.amount }
    }

    var remaining: Double {
        // Never go below zero — can't owe a savings goal
        max(0, targetAmount - totalSaved)
    }

    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        // Cap at 1.0 so progress bar never overflows
        return min(totalSaved / targetAmount, 1.0)
    }

    var progressPercentage: String {
        String(format: "%.0f%%", progress * 100)
    }

    var isCompleted: Bool {
        totalSaved >= targetAmount
    }
}
