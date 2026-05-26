//
//  haulerApp.swift
//  hauler
//

import SwiftUI
import SwiftData

@main
struct haulerApp: App {

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        // SwiftData handles store creation, migration, and recovery automatically.
        // Supabase sync added in Phase 2.
        .modelContainer(for: UserProfile.self)
    }
}
