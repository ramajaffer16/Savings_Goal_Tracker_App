//
//  AddContributionView.swift
//  SavingsApp
//
//  Created by Ramadhan on 09/03/2026.
//

import SwiftUI

// MARK: - AddContributionView
// Deposit and Withdraw screens.
struct AddContributionView: View {
    @EnvironmentObject var vm: GoalsViewModel
    @Environment(\.dismiss) var dismiss
    
    let goal: SavingsGoal
    var isWithdrawal: Bool = false
    
    @State private var amountText   = ""
    @State private var showSuccess  = false
    @State private var channel: Channel = .coop
    @State private var phoneNumber  = ""
    
    var title: String { isWithdrawal ? "Withdraw" : "Deposit" }
    
    enum Channel: String {
        case coop = "Coop Account"
        case mpesa = "M-PESA"
    }
    
    var isValid: Bool {
        (Double(amountText) ?? 0) > 0
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header: title + back + close
                ZStack {
                    Color.darkGreen
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text(title)
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .semibold))
                        Spacer()
                        Button { dismiss() } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 56)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Goal name (read-only, looks like a field)
                        FieldLabel("Goal Name")
                        Text(goal.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 14)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        
                        // Available balance (green, under goal name)
                        HStack(spacing: 4) {
                            Text("Available balance:")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                            Text("\(goal.totalSaved.formatted) KES")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.brightGreen)
                        }
                        
                        // Fund from / Withdraw to
                        FieldLabel(isWithdrawal ? "Withdraw to:" : "Fund from:")
                        HStack(spacing: 16) {
                            RadioButton(isSelected: channel == .coop, label: Channel.coop.rawValue) {
                                channel = .coop
                            }
                            RadioButton(isSelected: channel == .mpesa, label: Channel.mpesa.rawValue) {
                                channel = .mpesa
                            }
                        }
                        
                        // Coop: Credit Account card. M-PESA: Phone Number field.
                        if channel == .coop {
                            FieldLabel("Credit Account")
                            HStack(spacing: 12) {
                                Image(systemName: "building.columns.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Salary Account")
                                        .font(.system(size: 15, weight: .semibold))
                                    Text("011090145246202")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                    Text("Available balance: 87,000.00 KES")
                                        .font(.system(size: 12))
                                        .foregroundColor(.brightGreen)
                                }
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        } else {
                            FieldLabel("Phone Number")
                            TextField("07XXXXXXXX", text: $phoneNumber)
                                .keyboardType(.numberPad)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal, 14)
                                .frame(height: 50)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        }
                        
                        // Amount (deposit vs withdraw)
                        FieldLabel(isWithdrawal ? "Amount to withdraw" : "Amount to deposit")
                        HStack(spacing: 0) {
                            Text("KES")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 50)
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 1, height: 30)
                            TextField("0.00", text: $amountText)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal, 12)
                                .frame(height: 50)
                        }
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        
                        Spacer(minLength: 60)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                .background(Color(UIColor.systemGray6))
                
                // Bottom button: "Deposit" or "Withdraw"
                PrimaryButton(title: title, action: handleAction, disabled: !isValid)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.white)
            }
            
            // Success popup
            if showSuccess {
                let amount = Double(amountText) ?? 0
                SuccessModalView(
                    title: "KES \(amount.formatted)",
                    subtitle: "\(title) Successful",
                    message: "",
                    buttonTitle: "Go to My Goals"
                ) {
                    dismiss()
                }
                .transition(.opacity.combined(with: .scale(scale: 0.92)))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showSuccess)
        .navigationBarHidden(true)
        .background(Color.darkGreen.ignoresSafeArea(edges: .top))
    }
    
    private func handleAction() {
        let amount = Double(amountText) ?? 0
        let finalAmount = isWithdrawal ? -amount : amount
        vm.addContribution(to: goal.id, amount: finalAmount, date: Date())
        showSuccess = true
    }
}
