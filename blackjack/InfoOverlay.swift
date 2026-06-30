//
//  InfoOverlay.swift
//  blackjack
//
//  Created by Alp Rüzgar on 29.06.2026.
//

import SwiftUI

struct InfoOverlay<Content: View>: View {
    @Binding var isPresented: Bool
    var title: String
    @ViewBuilder var overlayBody: () -> Content
    @Environment(ThemeManager.self) var themeManager
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            VStack(spacing: 22) {
                // Title
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .tracking(1.5)
                    .foregroundStyle(themeManager.current.colors.text)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 1, y: 2)

                // Decorative divider
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
                .padding(.horizontal, 8)

                // Body content
                overlayBody()

                // Dismiss button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPresented = false
                    }
                }) {
                    Text("OK")
                        .font(.system(size: 18, weight: .bold))
                        .tracking(1.5)
                        .foregroundStyle(themeManager.current.colors.text)
                        .frame(height: 54)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(themeManager.current.colors.primary)
                        )
                        .shadow(color: themeManager.current.colors.primary.opacity(0.6), radius: 8)
                }
                .buttonStyle(PressableButtonStyle())
                .padding(.top, 4)
            }
            .padding(28)
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
