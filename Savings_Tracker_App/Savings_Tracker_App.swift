//
//  SavingsGoalTrackerApp.swift
//  Savings_Tracker_App
//
//  Created by Ramadhan on 09/03/2026.
//

import SwiftUI

// MARK: - App Entry Point
// Created the view model once and shared it across the app.
@main
struct SavingsGoalTrackerApp: App {
    @StateObject private var vm = GoalsViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(vm)
        }
    }
}

// MARK: - HomeView
// First screen: intro banner + "Goal Savings" card.
struct HomeView: View {
    @EnvironmentObject var vm: GoalsViewModel
    @State private var showCreateGoalFromHome = false
    @State private var navigateToGoals = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                AppHeader()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        Text("Start Saving Towards Your Goals")
                            .font(.system(size: 22, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 20)
                            .padding(.top, 24)

                        // Main "Goal Savings" card
                        Button {
                            showCreateGoalFromHome = true
                        } label: {
                            PromoCard(
                                title: "Goal Savings",
                                subtitle: "Turn your goals into savings!",
                                gradient: [Color(hex: "#2D7A3A"), Color(hex: "#1A4D2E")],
                                icon: "banknote.fill"
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)

                        // Extra info cards (static content)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                PromoCard(
                                    title: "Learn about Savings",
                                    subtitle: "Discover the world with our new savings, one step towards your goal",
                                    gradient: [Color.darkGreen, Color.darkGreen.opacity(0.8)],
                                    icon: "leaf.fill",
                                    height: 120,
                                    width: 260
                                )
                                PromoCard(
                                    title: "What's  Your Investing Style?",
                                    subtitle: "Answer a few questions to determine your risk profile and find suitable investments",
                                    gradient: [Color.tealAccent, Color.tealAccent.opacity(0.8)],
                                    icon: "chart.bar.fill",
                                    height: 120,
                                    width: 260
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(true)
            .background(
                NavigationLink(
                    destination: GoalsListView().environmentObject(vm),
                    isActive: $navigateToGoals
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
        // Full‑screen Create Goal flow triggered from Home card
        .fullScreenCover(isPresented: $showCreateGoalFromHome) {
            CreateGoalView {
                // After success, dismiss then navigate to "My Goals"
                showCreateGoalFromHome = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    navigateToGoals = true
                }
            }
            .environmentObject(vm)
        }
    }
}

// MARK: - PromoCard
// Reusable promo/marketing style card.
struct PromoCard: View {
    let title: String
    let subtitle: String
    let gradient: [Color]
    let icon: String
    var height: CGFloat = 200
    var width: CGFloat? = nil

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: height > 150 ? 22 : 16, weight: .bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: height > 150 ? 14 : 12))
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(3)
                }
                .padding(.leading, 16)
                .padding(.bottom, 20)

                Spacer()

                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: height > 150 ? 70 : 45)
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
            }
        }
        .frame(maxWidth: width != nil ? width : .infinity)
        .frame(height: height)
        .cornerRadius(14)
    }
}
