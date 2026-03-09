//
//  SupportingsView.swift
//  SavingsApp
//
//  Created by Ramadhan on 09/03/2026.
//

import SwiftUI

// MARK: - SuccessModalView
// Simple success popup used for: Goal Created, Deposit, Withdraw
struct SuccessModalView: View {
    let title: String
    let subtitle: String
    let message: String
    let buttonTitle: String
    let onAction: () -> Void

    var body: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.45).ignoresSafeArea()

            // White card
            VStack(spacing: 16) {

                // Simple green circle with checkmark
                Circle()
                    .fill(Color.brightGreen)
                    .frame(width: 72, height: 72)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                    )

                VStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.brightGreen)
                        .multilineTextAlignment(.center)

                    Text(subtitle)
                        .font(.system(size: 16))
                        .foregroundColor(.black.opacity(0.7))

                    if !message.isEmpty {
                        Text(message)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)
                    }
                }

                PrimaryButton(title: buttonTitle, action: onAction)
                    .padding(.horizontal, 4)
                    .padding(.top, 4)
            }
            .padding(28)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 32)
        }
    }
}

// MARK: - RadioButton
// Simple button used on Deposit / Withdraw screens
struct RadioButton: View {
    let isSelected: Bool
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.brightGreen : Color.gray.opacity(0.4), lineWidth: 2)
                        .frame(width: 18, height: 18)
                    if isSelected {
                        Circle()
                            .fill(Color.brightGreen)
                            .frame(width: 10, height: 10)
                    }
                }
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(.black)
            }
        }
    }
}

// MARK: - TransactionHistoryView
// Shows all contributions across all goals, sorted by date
// Supports filtering: All / Deposits / Withdrawals
struct TransactionHistoryView: View {
    @EnvironmentObject var vm: GoalsViewModel
    @State private var filter: Filter = .all

    enum Filter: String, CaseIterable {
        case all = "All"
        case deposits = "Deposits"
        case withdrawals = "Withdrawals"
    }

    // Flatten all contributions from all goals into one list
    var allContributions: [(goal: SavingsGoal, contribution: Contribution)] {
        vm.goals.flatMap { goal in
            goal.contributions.map { (goal: goal, contribution: $0) }
        }
        .sorted { $0.contribution.date > $1.contribution.date }
    }

    var filtered: [(goal: SavingsGoal, contribution: Contribution)] {
        switch filter {
        case .all:
            return allContributions
        case .deposits:
            return allContributions.filter { $0.contribution.amount > 0 }
        case .withdrawals:
            return allContributions.filter { $0.contribution.amount < 0 }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Transaction History")
                    .font(.system(size: 17, weight: .bold))
                Spacer()
                Button("View all") {}
                    .font(.system(size: 13))
                    .foregroundColor(.brightGreen)
            }

            // Filter tabs
            HStack(spacing: 8) {
                ForEach(Filter.allCases, id: \.self) { f in
                    Button(f.rawValue) { filter = f }
                        .font(.system(size: 13, weight: filter == f ? .semibold : .regular))
                        .foregroundColor(filter == f ? .brightGreen : .black)
                        .padding(.horizontal, 14).padding(.vertical, 7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(filter == f ? Color.brightGreen : Color.gray.opacity(0.3))
                        )
                        .background(filter == f ? Color.brightGreen.opacity(0.1) : Color.clear)
                        .cornerRadius(20)
                }
                Spacer()
            }

            if filtered.isEmpty {
                Text("No transactions yet")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else {
                VStack(spacing: 0) {
                    ForEach(filtered, id: \.contribution.id) { item in
                        TransactionRow(
                            goalName: item.goal.name,
                            contribution: item.contribution
                        )
                        Divider().padding(.horizontal, 16)
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.15)))
            }
        }
    }
}

// MARK: - TransactionRow
struct TransactionRow: View {
    let goalName: String
    let contribution: Contribution

    var isDeposit: Bool { contribution.amount > 0 }

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Circle()
                .fill(isDeposit ? Color.brightGreen.opacity(0.15) : Color.red.opacity(0.12))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: isDeposit ? "plus.circle.fill" : "minus.circle.fill")
                        .foregroundColor(isDeposit ? .brightGreen : .red)
                        .font(.system(size: 20))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(isDeposit ? "Deposit" : "Withdrawal")
                    .font(.system(size: 15, weight: .semibold))
                Text(goalName)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("KES \(abs(contribution.amount).formatted)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isDeposit ? .black : .red)
                Text(contribution.date.displayString)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
