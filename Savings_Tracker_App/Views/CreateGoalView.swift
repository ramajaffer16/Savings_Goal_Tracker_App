//
//  CreateGoalView.swift
//  SavingsApp
//
//  Created by Ramadhan on 09/03/2026.
//

import SwiftUI

// Goal categories shown
private let goalCategories = ["Travelling", "Family", "Education", "Emergency", "Other"]

// MARK: - CreateGoalView
// Form for creating a new savings goal. (category, target amount, optional date.)
struct CreateGoalView: View {
    @EnvironmentObject var vm: GoalsViewModel
    @Environment(\.dismiss) var dismiss
    
    let onFinished: (() -> Void)?
    
    init(onFinished: (() -> Void)? = nil) {
        self.onFinished = onFinished
    }
    
    @State private var name         = ""
    @State private var category     = "Travelling"
    @State private var amountText   = ""
    @State private var targetDate   = Date().addingTimeInterval(60 * 60 * 24 * 90)
    @State private var hasDate      = true
    @State private var showSuccess  = false
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
        && (Double(amountText) ?? 0) > 0
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header: "Create a Goal" title + back navigation
                ZStack {
                    Color.darkGreen
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("Create a Goal")
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
                        Text("Please let's have the following:")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 24)
                        
                        FieldLabel("Goal Name")
                        TextField("e.g. Dubai Trip", text: $name)
                            .fieldStyle()
                        
                        FieldLabel("Goal Category")
                        Menu {
                            ForEach(goalCategories, id: \.self) { cat in
                                Button(cat) { category = cat }
                            }
                        } label: {
                            HStack {
                                Text(category)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 50)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        }
                        
                        FieldLabel("Target Amount")
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
                        
                        Toggle("Set a target date", isOn: $hasDate)
                            .tint(.brightGreen)
                        
                        if hasDate {
                            FieldLabel("Savings Target Date")
                            DatePicker("", selection: $targetDate, in: Date()..., displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .tint(.brightGreen)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 14)
                                .frame(height: 50)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        }
                        
                        Spacer(minLength: 60)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                .background(Color(UIColor.systemGray6))
                
                PrimaryButton(title: "Create a Goal", action: handleCreate, disabled: !isValid)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.white)
            }
            
            // Success popup
            if showSuccess {
                SuccessModalView(
                    title: "\(name) Goal",
                    subtitle: "Created Successfully",
                    message: "You are one step closer to reaching your target",
                    buttonTitle: "Go to My Goals"
                ) {
                    if let onFinished {
                        onFinished()
                    } else {
                        dismiss()
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.92)))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showSuccess)
        .navigationBarHidden(true)
        .background(Color.darkGreen.ignoresSafeArea(edges: .top))
    }
    
    private func handleCreate() {
        let amount = Double(amountText) ?? 0
        vm.createGoal(
            name: name.trimmingCharacters(in: .whitespaces),
            category: category,
            targetAmount: amount,
            targetDate: hasDate ? targetDate : nil
        )
        showSuccess = true
    }
}

// MARK: - Small Helpers (used only in this file)
struct FieldLabel: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text)
            .font(.system(size: 13))
            .foregroundColor(.gray)
    }
}

extension View {
    func fieldStyle() -> some View {
        self
            .font(.system(size: 16, weight: .semibold))
            .padding(.horizontal, 14)
            .frame(height: 50)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
    }
}
