//
//  TrainingMode.swift
//  hauler
//

import Foundation

/// The four training modes the user picks during onboarding.
/// Determines workout frequency and the AI's attitude/tone.
enum TrainingMode: String, CaseIterable, Codable, Sendable {

    case chillCoach     = "chill_coach"
    case smartTrainer   = "smart_trainer"
    case ruthlessCoach  = "ruthless_coach"
    case obsessionMode  = "obsession_mode"

    // ── Display ──────────────────────────────────────────────────────────────

    var emoji: String {
        switch self {
        case .chillCoach:    return "😴"
        case .smartTrainer:  return "💪"
        case .ruthlessCoach: return "🔥"
        case .obsessionMode: return "🏆"
        }
    }

    /// Short label shown on the mode card.
    var title: String {
        switch self {
        case .chillCoach:    return "Just want to move"
        case .smartTrainer:  return "Need structure"
        case .ruthlessCoach: return "Serious results"
        case .obsessionMode: return "Full transformation"
        }
    }

    /// Days per week + tone label shown below the title.
    var subtitle: String {
        switch self {
        case .chillCoach:    return "3 days · Chill mode"
        case .smartTrainer:  return "4–5 days · Smart mode"
        case .ruthlessCoach: return "5–6 days · Ruthless"
        case .obsessionMode: return "6 days · Obsession"
        }
    }

    // ── Plan Config ───────────────────────────────────────────────────────────

    /// Human-readable name used in plan generation prompts.
    var modeName: String {
        switch self {
        case .chillCoach:    return "Chill Coach"
        case .smartTrainer:  return "Smart Trainer"
        case .ruthlessCoach: return "Ruthless Coach"
        case .obsessionMode: return "Obsession Mode"
        }
    }

    /// Target weekly workout days for plan generation.
    var targetDaysPerWeek: Int {
        switch self {
        case .chillCoach:    return 3
        case .smartTrainer:  return 4
        case .ruthlessCoach: return 5
        case .obsessionMode: return 6
        }
    }
}
