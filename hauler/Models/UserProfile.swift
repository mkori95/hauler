//
//  UserProfile.swift
//  hauler
//
//  Local user record — SwiftData storage only for Phase 1.
//  Supabase sync added in Phase 2.
//

import Foundation
import SwiftData

@Model
final class UserProfile {

    // ── Auth / identity ───────────────────────────────────────────────────────
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var dateOfBirth: Date

    // ── Body stats (filled during profile setup, Phase 1 step 2) ─────────────
    var weightKg: Double
    var heightCm: Double

    // ── Training config ───────────────────────────────────────────────────────
    /// Stored as TrainingMode.rawValue — use the computed var below.
    var modeRaw: String

    // ── Onboarding state ──────────────────────────────────────────────────────
    var onboardingCompleted: Bool

    // ── Meta ──────────────────────────────────────────────────────────────────
    var createdAt: Date

    init(
        id: UUID = UUID(),
        firstName: String = "",
        lastName: String = "",
        email: String = "",
        phone: String = "",
        dateOfBirth: Date = Date(),
        weightKg: Double = 0,
        heightCm: Double = 0,
        modeRaw: String = TrainingMode.smartTrainer.rawValue,
        onboardingCompleted: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.dateOfBirth = dateOfBirth
        self.weightKg = weightKg
        self.heightCm = heightCm
        self.modeRaw = modeRaw
        self.onboardingCompleted = onboardingCompleted
        self.createdAt = createdAt
    }

    // ── Computed ──────────────────────────────────────────────────────────────

    var fullName: String { "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces) }

    var age: Int {
        Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
    }

    var trainingMode: TrainingMode {
        get { TrainingMode(rawValue: modeRaw) ?? .smartTrainer }
        set { modeRaw = newValue.rawValue }
    }
}
