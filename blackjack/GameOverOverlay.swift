//
//  GameOverOverlay.swift
//  blackjack
//
//  Created by Alp Rüzgar on 21.05.2026.
//

import SwiftUI

struct GameOverOverlay: View {
    let result: GameResult
    let onRestart: () -> Void
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // Background layer (not animated with scale)
            Color.black.opacity(0.7 * opacity)
                .ignoresSafeArea()
                .onTapGesture { }
            
            // Content layer (animated with scale)
            VStack(spacing: 25) {
                // Animated icon
                ZStack {
                    Circle()
                        .fill(result.color.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .stroke(result.color, lineWidth: 4)
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: result.iconName)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(result.color)
                }
                
                VStack(spacing: 12) {
                    Text(result.title)
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.whiteish)
                    
                    Text(result.message)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.whiteish.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                
                Button(action: onRestart) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("PLAY AGAIN")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.whiteish)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(result.color)
                    )
                }
                .shadow(color: result.color.opacity(0.5), radius: 10, x: 0, y: 5)
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
