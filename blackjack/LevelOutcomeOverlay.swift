//
//  GameOverOverlay.swift
//  blackjack
//
//  Created by Alp Rüzgar on 21.05.2026.
//

import SwiftUI

struct LevelOutcomeOverlay: View {
    @Environment(\.dismiss) var dismiss
    @Environment(ThemeManager.self) var themeManager
    let isWon: Bool
    let onPlayAgain: () -> Void
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var accentColor: Color { isWon ? themeManager.current.colors.primary : themeManager.current.colors.alert }
    var iconName: String { isWon ? "trophy.fill" : "xmark.circle.fill" }
    var title: String { isWon ? "LEVEL COMPLETE" : "OUT OF CHIPS" }
    var subtitle: String { isWon ? "You reached the goal!" : "Better luck next time." }

    var body: some View {
        ZStack {
            Color.black.opacity(0.75 * opacity)
                .ignoresSafeArea()
                .onTapGesture { }

            VStack(spacing: 22) {
                // Icon
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.15))
                        .frame(width: 96, height: 96)
                    Circle()
                        .stroke(accentColor, lineWidth: 2)
                        .frame(width: 96, height: 96)
                    Image(systemName: iconName)
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(accentColor)
                }

                // Title + gold divider + subtitle
                VStack(spacing: 10) {
                    Text(title)
                        .font(.libreCaslonBold(30))
                        .tracking(1.5)
                        .foregroundStyle(themeManager.current.colors.text)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 1, y: 2)

                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(themeManager.current.colors.secondary.gradient)
                        Image(systemName: "square.fill")
                            .font(.system(size: 7))
                            .foregroundStyle(themeManager.current.colors.secondary.gradient)
                            .rotationEffect(.degrees(45))
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(themeManager.current.colors.secondary.gradient)
                    }
                    .padding(.horizontal, 16)

                    Text(subtitle)
                        .font(.libreCaslonItalic(17))
                        .foregroundStyle(themeManager.current.colors.text.opacity(0.75))
                        .multilineTextAlignment(.center)
                }

                // Buttons
                VStack(spacing: 10) {
                    OutcomeButton(
                        text: "PLAY AGAIN",
                        icon: "arrow.counterclockwise",
                        backgroundColor: accentColor,
                        textColor: themeManager.current.colors.text,
                        action: onPlayAgain
                    )
                    OutcomeButton(
                        text: "MAIN MENU",
                        icon: "house.fill",
                        backgroundColor: themeManager.current.colors.secondary,
                        textColor: themeManager.current.colors.text,
                        action: { dismiss() }
                    )
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.black.opacity(0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(themeManager.current.colors.secondary.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, 32)
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

private struct OutcomeButton: View {
    let text: String
    let icon: String
    let backgroundColor: Color
    let textColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                Text(text)
                    .font(.libreCaslonBold(18))
                    .tracking(1.5)
            }
            .foregroundStyle(textColor)
            .frame(height: 54)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(backgroundColor)
            )
            .shadow(color: backgroundColor.opacity(0.6), radius: 8)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    NavigationStack {
        ZStack {
            Color(red: 0.0, green: 0.4, blue: 0.25).ignoresSafeArea()
            LevelOutcomeOverlay(isWon: true, onPlayAgain: {})
        }
    }
    .environment(ThemeManager())
}
