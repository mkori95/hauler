//
//  RootView.swift
//  hauler
//
//  App-level navigation gate.
//  Flow: AuthView → OnboardingView → ContentView (Home)
//

import SwiftUI

struct RootView: View {

    @AppStorage("isSignedUp") private var isSignedUp = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if !isSignedUp {
            AuthView()
        } else if !hasCompletedOnboarding {
            OnboardingView()
        } else {
            ContentView()
        }
    }
}
