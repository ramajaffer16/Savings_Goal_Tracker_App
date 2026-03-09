//
//  AppHelpers.swift
//  SavingsApp
//
//  Created by Ramadhan on 09/03/2026.
//

import SwiftUI

// MARK: - App Colors.
extension Color {
    static let darkGreen   = Color(hex: "#0E3320")  // header background
    static let cardGreen   = Color(hex: "#1A4D2E")  // goal card background
    static let brightGreen = Color(hex: "#5DB844")  // buttons, highlights
    static let tealAccent  = Color(hex: "#0D4040")  // header triangle / promo card
    
    // Convenience init from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Primary Button
// Basic green button shared across screens.
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var disabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(disabled ? Color.brightGreen.opacity(0.5) : Color.brightGreen)
                .cornerRadius(10)
        }
        .disabled(disabled)
    }
}

// MARK: - App Header
// Dark green header with greeting centered (matches design).
struct AppHeader: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.darkGreen
            
            // Teal triangle in the top‑right corner
            GeometryReader { geo in
                Path { path in
                    let w = geo.size.width
                    path.move(to: CGPoint(x: w - 90, y: 0))
                    path.addLine(to: CGPoint(x: w, y: 0))
                    path.addLine(to: CGPoint(x: w, y: 80))
                    path.closeSubpath()
                }
                .fill(Color.tealAccent)
            }
            
            // Centered: avatar + "Hello There!" / "It's a good day to save"
            HStack(spacing: 12) {
                Spacer(minLength: 0)
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    )
                
                VStack(alignment: .center, spacing: 2) {
                    Text("Hello There!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    Text("It's a good day to save")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 56)
            .padding(.bottom, 16)
        }
        .frame(height: 130)
    }
}

// MARK: - Date / Number Helpers
extension Date {
    var displayString: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: self)
    }
}

extension Double {
    // Formats 10000 → "10,000.00"
    var formatted: String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
