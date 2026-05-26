//
//  AuthView.swift
//  hauler
//
//  Sign up / sign in screen.
//  Phase 1: stores locally in SwiftData. No network calls.
//  Phase 2: wire Supabase Auth in handleSignUp / handleSignIn.
//

import SwiftUI
import SwiftData
import UIKit

struct AuthView: View {

    // ── Tab ───────────────────────────────────────────────────────────────────

    private enum AuthTab { case signUp, signIn }

    // ── Persistence ───────────────────────────────────────────────────────────

    @AppStorage("isSignedUp") private var isSignedUp = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.modelContext) private var modelContext

    // ── UI state ─────────────────────────────────────────────────────────────

    @Namespace private var tabNS
    @State private var tab: AuthTab = .signUp
    @State private var appeared = false
    @State private var errorMessage: String? = nil

    // ── Sign Up fields ────────────────────────────────────────────────────────

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var dateOfBirth: Date = {
        Calendar.current.date(byAdding: .year, value: -20, to: Date()) ?? Date()
    }()
    @State private var password = ""
    @State private var confirmPassword = ""

    // ── Sign In fields ────────────────────────────────────────────────────────

    @State private var signInEmail = ""
    @State private var signInPassword = ""

    // ── Body ──────────────────────────────────────────────────────────────────

    var body: some View {
        ZStack {
            Color(hex: "#111111").ignoresSafeArea()

            // Orange glow — top right (contrast with onboarding's top-left)
            RadialGradient(
                colors: [Color(hex: "#FF4D00").opacity(0.07), .clear],
                center: .topTrailing,
                startRadius: 0,
                endRadius: 380
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    brandHeader
                    headlineText
                    tabSelector
                        .padding(.bottom, 24)

                    // Animated form swap
                    if tab == .signUp {
                        signUpForm
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal:   .move(edge: .trailing).combined(with: .opacity)
                            ))
                    } else {
                        signInForm
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal:   .move(edge: .leading).combined(with: .opacity)
                            ))
                    }

                    // Error message
                    if let error = errorMessage {
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#FF4D00"))
                            .padding(.top, 10)
                            .transition(.opacity)
                    }

                    Spacer().frame(height: 20)

                    ctaButton

                    if tab == .signUp {
                        termsNote
                    }

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

    // ── Subviews ──────────────────────────────────────────────────────────────

    private var brandHeader: some View {
        HStack(spacing: 0) {
            Text("Haul").foregroundColor(.white)
            Text("er").foregroundColor(Color(hex: "#FF4D00"))
        }
        .font(.system(size: 38, weight: .regular, design: .serif))
        .padding(.top, 24)
    }

    private var headlineText: some View {
        Text(tab == .signUp ? "Game on." : "Let's go.")
            .font(.system(size: 28, weight: .semibold))
            .foregroundColor(.white)
            .padding(.top, 16)
            .padding(.bottom, 28)
            .animation(.easeInOut(duration: 0.2), value: tab)
    }

    // ── Tab selector ──────────────────────────────────────────────────────────

    private var tabSelector: some View {
        HStack(spacing: 4) {

            // Create Account tab
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    tab = .signUp
                    errorMessage = nil
                }
            } label: {
                Text("Create Account")
                    .font(.system(size: 14, weight: tab == .signUp ? .semibold : .regular))
                    .foregroundColor(tab == .signUp ? .white : Color(hex: "#555555"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background {
                        if tab == .signUp {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "#2A1500"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color(hex: "#FF4D00").opacity(0.35), lineWidth: 0.5)
                                )
                                .matchedGeometryEffect(id: "tabBG", in: tabNS)
                        }
                    }
            }
            .buttonStyle(.plain)

            // Sign In tab
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    tab = .signIn
                    errorMessage = nil
                }
            } label: {
                Text("Sign In")
                    .font(.system(size: 14, weight: tab == .signIn ? .semibold : .regular))
                    .foregroundColor(tab == .signIn ? .white : Color(hex: "#555555"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background {
                        if tab == .signIn {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "#2A1500"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Color(hex: "#FF4D00").opacity(0.35), lineWidth: 0.5)
                                )
                                .matchedGeometryEffect(id: "tabBG", in: tabNS)
                        }
                    }
            }
            .buttonStyle(.plain)
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "#1A1A1A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color(hex: "#2A2A2A"), lineWidth: 0.5)
                )
        )
    }

    // ── Sign Up form ──────────────────────────────────────────────────────────

    private var signUpForm: some View {
        VStack(spacing: 12) {

            // First + Last name
            HStack(spacing: 10) {
                HaulerTextField(
                    placeholder: "First name",
                    text: $firstName,
                    icon: "person"
                )
                HaulerTextField(
                    placeholder: "Last name",
                    text: $lastName
                )
            }

            HaulerTextField(
                placeholder: "Email",
                text: $email,
                keyboardType: .emailAddress,
                icon: "envelope",
                autocapitalization: .never
            )

            HaulerTextField(
                placeholder: "Phone",
                text: $phone,
                keyboardType: .phonePad,
                icon: "phone",
                autocapitalization: .never
            )

            // Date of birth row
            dobRow

            HaulerTextField(
                placeholder: "Password",
                text: $password,
                isSecure: true,
                icon: "lock"
            )

            HaulerTextField(
                placeholder: "Confirm password",
                text: $confirmPassword,
                isSecure: true,
                icon: "lock"
            )
        }
    }

    /// Styled date-of-birth picker matching the field style.
    private var dobRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#555555"))
                .frame(width: 18)

            Text("Date of birth")
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "#888888"))

            Spacer()

            DatePicker(
                "",
                selection: $dateOfBirth,
                in: dobRange,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .colorScheme(.dark)
            .tint(Color(hex: "#FF4D00"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#1A1A1A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color(hex: "#2A2A2A"), lineWidth: 0.5)
                )
        )
    }

    // ── Sign In form ──────────────────────────────────────────────────────────

    private var signInForm: some View {
        VStack(spacing: 12) {
            HaulerTextField(
                placeholder: "Email",
                text: $signInEmail,
                keyboardType: .emailAddress,
                icon: "envelope",
                autocapitalization: .never
            )

            HaulerTextField(
                placeholder: "Password",
                text: $signInPassword,
                isSecure: true,
                icon: "lock"
            )

            HStack {
                Spacer()
                // Phase 2: trigger Supabase password reset
                Button("Forgot password?") {}
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#555555"))
            }
            .padding(.top, 2)
        }
    }

    // ── CTA button ────────────────────────────────────────────────────────────

    private var ctaButton: some View {
        Button(action: tab == .signUp ? handleSignUp : handleSignIn) {
            HStack(spacing: 8) {
                Spacer()
                Text(tab == .signUp ? "Create Account" : "Sign In")
                    .font(.system(size: 17, weight: .semibold))
                Image(systemName: "arrow.right")
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical, 17)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "#FF4D00"))
            )
        }
    }

    private var termsNote: some View {
        Text("By creating an account you agree to our Terms of Service and Privacy Policy.")
            .font(.system(size: 11))
            .foregroundColor(Color(hex: "#444444"))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.top, 14)
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    /// Selectable date range: must be at least 13 years old, up to 100 years ago.
    private var dobRange: ClosedRange<Date> {
        let cal = Calendar.current
        let min = cal.date(byAdding: .year, value: -100, to: Date()) ?? Date()
        let max = cal.date(byAdding: .year, value: -13, to: Date()) ?? Date()
        return min...max
    }

    // ── Actions ───────────────────────────────────────────────────────────────

    private func handleSignUp() {
        guard validateSignUp() else { return }

        let profile = UserProfile(
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName:  lastName.trimmingCharacters(in: .whitespaces),
            email:     email.lowercased().trimmingCharacters(in: .whitespaces),
            phone:     phone.trimmingCharacters(in: .whitespaces),
            dateOfBirth: dateOfBirth
        )
        modelContext.insert(profile)

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        withAnimation(.easeInOut(duration: 0.3)) {
            isSignedUp = true
        }
    }

    private func handleSignIn() {
        guard !signInEmail.trimmingCharacters(in: .whitespaces).isEmpty,
              !signInPassword.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }
        // Phase 2: validate against Supabase Auth here.
        // For now, accepted as-is and routes to home.
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        withAnimation(.easeInOut(duration: 0.3)) {
            isSignedUp = true
            hasCompletedOnboarding = true
        }
    }

    private func validateSignUp() -> Bool {
        errorMessage = nil

        if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "First name is required."; return false
        }
        if lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Last name is required."; return false
        }
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        if !trimmedEmail.contains("@") || !trimmedEmail.contains(".") {
            errorMessage = "Enter a valid email address."; return false
        }
        let digits = phone.filter { $0.isNumber }
        if digits.count < 10 {
            errorMessage = "Enter a valid phone number (at least 10 digits)."; return false
        }
        if password.count < 8 {
            errorMessage = "Password must be at least 8 characters."; return false
        }
        if password != confirmPassword {
            errorMessage = "Passwords don't match."; return false
        }
        return true
    }
}

// ── Preview ───────────────────────────────────────────────────────────────────

#Preview {
    AuthView()
        .modelContainer(for: UserProfile.self, inMemory: true)
}
