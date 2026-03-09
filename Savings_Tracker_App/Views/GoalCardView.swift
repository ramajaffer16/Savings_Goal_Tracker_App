//
//  GoalCardView.swift
//  SavingsApp
//
//  Created by Ramadhan on 09/03/2026.
//

import SwiftUI

// MARK: - GoalCardView
// Simple card showing balance, progress, target and actions.
struct GoalCardView: View {
    @EnvironmentObject var vm: GoalsViewModel
    let goal: SavingsGoal
    
    @State private var showDeposit = false
    @State private var showWithdraw = false
    @State private var isAmountVisible = true
    @State private var isTargetVisible = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Text(goal.name)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.85))
                
                Spacer()
                
                Button {
                    // Menu action placeholder
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14))
                        .foregroundColor(.cardGreen)
                        .frame(width: 32, height: 32)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            
            HStack(alignment: .bottom, spacing: 6) {
                if isAmountVisible {
                    Text(goal.totalSaved.formatted)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    Text("KES")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 4)
                } else {
                    Text("••••••")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    Text("KES")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 4)
                }
                
                Button {
                    isAmountVisible.toggle()
                } label: {
                    Image(systemName: isAmountVisible ? "eye" : "eye.slash")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 4)
                }
                
                Spacer()
                
                if goal.isCompleted {
                    Label("Completed", systemImage: "checkmark.seal.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.brightGreen)
                        .cornerRadius(8)
                }
            }
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(goal.progressPercentage)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(goal.isCompleted ? Color.brightGreen : Color.white)
                            .frame(width: geo.size.width * goal.progress, height: 6)
                    }
                }
                .frame(height: 6)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    if isTargetVisible {
                        Text("Target: KES \(goal.targetAmount.formatted)")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.75))
                        Text("Remaining: KES \(goal.remaining.formatted)")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.75))
                    } else {
                        Text("Target: KES ••••••")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.75))
                        Text("Remaining: KES ••••••")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.75))
                    }
                }
                
                Button {
                    isTargetVisible.toggle()
                } label: {
                    Image(systemName: isTargetVisible ? "eye" : "eye.slash")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                if let date = goal.targetDate {
                    Text(date.displayString)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            HStack(spacing: 10) {
                Button {
                    showDeposit = true
                } label: {
                    Label("Deposit", systemImage: "arrow.up")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.brightGreen)
                        .cornerRadius(8)
                }
                
                Button {
                    showWithdraw = true
                } label: {
                    Label("Withdraw", systemImage: "arrow.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 1.5)
                        )
                }
            }
        }
        .padding(16)
        .background(Color.cardGreen)
        .cornerRadius(12)
        .sheet(isPresented: $showDeposit) {
            AddContributionView(goal: goal)
        }
        .sheet(isPresented: $showWithdraw) {
            // Withdraw uses same form for this exercise
            // In production this would be a separate flow
            AddContributionView(goal: goal, isWithdrawal: true)
        }
    }
}
