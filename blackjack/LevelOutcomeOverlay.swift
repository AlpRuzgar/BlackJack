//
//  GameOverOverlay.swift
//  blackjack
//
//  Created by Alp Rüzgar on 21.05.2026.
//

import SwiftUI

struct LevelOutcomeOverlay: View {
    @Environment(\.dismiss) var dismiss
    let isWon: Bool
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var accentColor: Color { isWon ? .green : .red }
    var iconName: String { isWon ? "trophy.fill" : "xmark.circle.fill" }
    var title: String { isWon ? "Level Complete!" : "Out of Chips!" }
    var subtitle: String { isWon ? "You reached the goal!" : "Better luck next time." }

    var body: some View {
        ZStack {
            Color.black.opacity(0.7 * opacity)
                .ignoresSafeArea()
                .onTapGesture { }

            VStack(spacing: 25) {
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.2))
                        .frame(width: 120, height: 120)
                    Circle()
                        .stroke(accentColor, lineWidth: 4)
                        .frame(width: 120, height: 120)
                    Image(systemName: iconName)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(accentColor)
                }

                VStack(spacing: 12) {
                    Text(title)
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }

                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "house.fill")
                        Text("MAIN MENU")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(Capsule().fill(accentColor))
                }
                .shadow(color: accentColor.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
            )
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

#Preview {
    NavigationStack {
        ZStack {
            Color(red: 0.0, green: 0.4, blue: 0.25).ignoresSafeArea()
            LevelOutcomeOverlay(isWon: true)
        }
    }
}
