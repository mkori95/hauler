//
//  OnboardingView.swift
//  hauler
//
//  Step 2 of the onboarding flow: pick your training mode.
//  The UserProfile is already created by AuthView.
//  This screen finds that record and stamps the selected mode onto it.
//

import SwiftUI
import SwiftData
import UIKit

struct OnboardingView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("selectedTrainingMode") private var selectedModeRaw: String = ""

    @State private var selectedMode: TrainingMode? = nil
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color(hex: "#111111").ignoresSafeArea()

            RadialGradient(
                colors: [Color(hex: "#FF4D00").opacity(0.07), .clear],
                center: .topLeading,
                startRadius: 0,
                endRadius: 380
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // ── Brand ─────────────────────────────────────────────────
                    HStack(spacing: 0) {
                        Text("Haul").foregroundColor(.white)
                        Text("er").foregroundColor(Color(hex: "#FF4D00"))
                    }
                    .font(.system(size: 42, weight: .regular, design: .serif))
                    .padding(.top, 24)

                    Text("You haul the weight. We haul you there.")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(hex: "#444444"))
                        .padding(.top, 5)
                        .padding(.bottom, 36)

                    // ── Prompt ────────────────────────────────────────────────
                    Text("Be honest with yourself.")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.bottom, 18)

                    // ── Mode cards ────────────────────────────────────────────
                    VStack(spacing: 10) {
                        ForEach(TrainingMode.allCases, id: \.self) { mode in
                            ModeCardView(mode: mode, isSelected: selectedMode == mode)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedMode = mode
                                    }
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                }
                        }
                    }
                    .padding(.bottom, 32)

                    // ── Continue ──────────────────────────────────────────────
                    Button(action: handleContinue) {
                        HStack(spacing: 8) {
                            Spacer()
                            Text("Continue")
                                .font(.system(size: 17, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 15, weight: .semibold))
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 17)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    selectedMode != nil
                                        ? Color(hex: "#FF4D00")
                                        : Color(hex: "#222222")
                                )
                        )
                    }
                    .disabled(selectedMode == nil)
                    .animation(.easeInOut(duration: 0.2), value: selectedMode)

                    Spacer(minLength: 48)
                }
                .padding(.horizontal, 22)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 14)
                .animation(.easeOut(duration: 0.45), value: appeared)
            }
        }
        .onAppear { appeared = true }
    }

    // ── Action ────────────────────────────────────────────────────────────────

    private func handleContinue() {
        guard let mode = selectedMode else { return }

        selectedModeRaw = mode.rawValue

        // Stamp the mode onto the profile created during sign up.
        if let profile = profiles.first {
            profile.modeRaw = mode.rawValue
            profile.onboardingCompleted = true
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            hasCompletedOnboarding = true
        }
    }
}

// ── Preview ───────────────────────────────────────────────────────────────────

#Preview {
    OnboardingView()
        .modelContainer(for: UserProfile.self, inMemory: true)
}
