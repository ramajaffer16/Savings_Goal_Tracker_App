//
//  GoalListView.swift
//  SavingsApp
//
//  Created by Ramadhan on 09/03/2026.
//

import SwiftUI

// MARK: - GoalsListView
// Main screen — shows all goals as cards + transaction history below
struct GoalsListView: View {
    @EnvironmentObject var vm: GoalsViewModel
    @State private var showCreateGoal = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            AppHeader()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: Section Header
                    HStack {
                        Text("My Goals")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        Button {
                            showCreateGoal = true
                        } label: {
                            Label("Add a Goal", systemImage: "plus")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.brightGreen)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // MARK: Goals — empty state or cards
                    if vm.goals.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "target")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No goals yet. Tap 'Add a Goal' to start!")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        
                    } else {
                        // Horizontally scrollable goal cards
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(vm.goals) { goal in
                                    GoalCardView(goal: goal)
                                        .frame(width: UIScreen.main.bounds.width - 40)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    // MARK: Transaction History
                    TransactionHistoryView()
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showCreateGoal) {
            CreateGoalView()
        }
        // MARK: Goal Completion Alert
        // show congratulatory message when goal is reached
        .alert(
            "🎉 Goal Completed!",
            isPresented: Binding(
                get: { vm.justCompletedGoal != nil },
                set: { if !$0 { vm.justCompletedGoal = nil } }
            )
        ) {
            Button("Awesome!") { vm.justCompletedGoal = nil }
        } message: {
            if let goal = vm.justCompletedGoal {
                Text("Congratulations! You reached your '\(goal.name)' goal of KES \(goal.targetAmount.formatted)!")
            }
        }
    }
}
