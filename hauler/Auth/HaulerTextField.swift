//
//  HaulerTextField.swift
//  hauler
//
//  Reusable dark-themed text field used across all forms.
//

import SwiftUI

struct HaulerTextField: View {

    let placeholder: String
    @Binding var text: String

    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var icon: String? = nil
    var autocapitalization: TextInputAutocapitalization = .words

    @FocusState private var isFocused: Bool
    @State private var passwordVisible: Bool = false

    var body: some View {
        HStack(spacing: 12) {

            // ── Leading icon ──────────────────────────────────────────────────
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(isFocused ? Color(hex: "#FF4D00") : Color(hex: "#555555"))
                    .frame(width: 18)
                    .animation(.easeInOut(duration: 0.15), value: isFocused)
            }

            // ── Input ─────────────────────────────────────────────────────────
            // Using prompt: to explicitly set placeholder colour — SwiftUI's default
            // placeholder is nearly invisible on dark backgrounds.
            let prompt = Text(placeholder).foregroundColor(Color(hex: "#888888"))

            Group {
                if isSecure && !passwordVisible {
                    SecureField(text: $text, prompt: prompt) { EmptyView() }
                } else {
                    TextField(text: $text, prompt: prompt) { EmptyView() }
                        .keyboardType(isSecure ? .default : keyboardType)
                        .textInputAutocapitalization(isSecure ? .never : autocapitalization)
                }
            }
            .foregroundColor(.white)
            .font(.system(size: 15))
            .tint(Color(hex: "#FF4D00"))
            .autocorrectionDisabled(true)
            .focused($isFocused)

            // ── Password reveal toggle ────────────────────────────────────────
            if isSecure {
                Button {
                    passwordVisible.toggle()
                } label: {
                    Image(systemName: passwordVisible ? "eye.slash" : "eye")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#555555"))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#1A1A1A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            isFocused ? Color(hex: "#FF4D00").opacity(0.5) : Color(hex: "#2A2A2A"),
                            lineWidth: isFocused ? 1.0 : 0.5
                        )
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// ── Preview ───────────────────────────────────────────────────────────────────

#Preview {
    VStack(spacing: 12) {
        HaulerTextField(placeholder: "First name", text: .constant(""), icon: "person")
        HaulerTextField(placeholder: "Email", text: .constant("mani@example.com"), icon: "envelope", autocapitalization: .never)
        HaulerTextField(placeholder: "Password", text: .constant(""), isSecure: true, icon: "lock")
    }
    .padding(20)
    .background(Color(hex: "#111111"))
}
