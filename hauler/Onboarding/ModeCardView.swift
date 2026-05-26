//
//  ModeCardView.swift
//  hauler
//

import SwiftUI

/// Single selectable mode card shown on the onboarding screen.
/// Animates between selected and deselected states via spring.
struct ModeCardView: View {

    let mode: TrainingMode
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 14) {

            // ── Emoji icon ────────────────────────────────────────────────────
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color(hex: "#2A1500") : Color(hex: "#222222"))
                    .frame(width: 46, height: 46)
                Text(mode.emoji)
                    .font(.system(size: 22))
            }

            // ── Labels ────────────────────────────────────────────────────────
            VStack(alignment: .leading, spacing: 3) {
                Text(mode.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(mode.subtitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(
                        isSelected ? Color(hex: "#FF7030") : Color(hex: "#555555")
                    )
            }

            Spacer()

            // ── Radio button ──────────────────────────────────────────────────
            ZStack {
                // Outer ring
                Circle()
                    .strokeBorder(
                        isSelected ? Color(hex: "#FF4D00") : Color(hex: "#333333"),
                        lineWidth: 1.5
                    )
                    .frame(width: 22, height: 22)

                // Inner fill — visible only when selected
                if isSelected {
                    Circle()
                        .fill(Color(hex: "#FF4D00"))
                        .frame(width: 11, height: 11)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: isSelected)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color(hex: "#1C0F00") : Color(hex: "#1A1A1A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(
                            isSelected ? Color(hex: "#FF4D00") : Color(hex: "#2A2A2A"),
                            lineWidth: isSelected ? 1.0 : 0.5
                        )
                )
        )
        // Subtle scale-up when selected
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// ── Preview ───────────────────────────────────────────────────────────────────

#Preview {
    VStack(spacing: 10) {
        ModeCardView(mode: .chillCoach, isSelected: false)
        ModeCardView(mode: .smartTrainer, isSelected: true)
        ModeCardView(mode: .ruthlessCoach, isSelected: false)
        ModeCardView(mode: .obsessionMode, isSelected: false)
    }
    .padding(20)
    .background(Color(hex: "#111111"))
}
