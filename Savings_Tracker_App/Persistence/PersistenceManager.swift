//
//  PersistenceManager.swift
//  SavingsApp
//
//  Created by Ramadhan on 09/03/2026.
//
import Foundation

// MARK: - PersistenceManager
// Handles saving and loading goals from UserDefaults.
// Using UserDefaults + Codable — simple, works for this scale.
// Trade-off: no complex querying. CoreData would be better for production.

class PersistenceManager {

    // Singleton — one shared instance used across the app
    static let shared = PersistenceManager()
    private init() {}

    private let key = "saved_goals"

    func save(_ goals: [SavingsGoal]) {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func load() -> [SavingsGoal] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let goals = try? JSONDecoder().decode([SavingsGoal].self, from: data)
        else {
            return [] // First launch — return empty list
        }
        return goals
    }
}
