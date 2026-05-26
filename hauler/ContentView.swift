//
//  ContentView.swift
//  hauler
//
//  Placeholder home screen — full Home UI is built in the next session.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(hex: "#111111").ignoresSafeArea()

            VStack(spacing: 12) {
                // Brand mark
                HStack(spacing: 0) {
                    Text("Haul")
                        .foregroundColor(.white)
                    Text("er")
                        .foregroundColor(Color(hex: "#FF4D00"))
                }
                .font(.system(size: 42, weight: .regular, design: .serif))

                Text("Home screen — coming next.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#555555"))
            }
        }
    }
}

#Preview {
    ContentView()
}
