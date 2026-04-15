//
//  ButtonView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 24.02.2026.
//

import Foundation
import SwiftUI

struct ButtonView: View {
    var text: String
    var action: () -> Void
    var backgroundColor: Color
    var textColor: Color
    var isGradient: Bool = false
    
    var body: some View {
        Button{
            action()
        }label: {
            Text(text)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .tracking(1.5)
                .foregroundStyle(textColor)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        // Gradient background
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        backgroundColor,
                                        backgroundColor.opacity(0.7)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        // Glossy overlay effect
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .white.opacity(0.3), location: 0),
                                        .init(color: .clear, location: 0.5)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                )
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    .white.opacity(0.4),
                                    .clear
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: backgroundColor.opacity(0.4), radius: 8, x: 0, y: 4)
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            
        }
        .buttonStyle(PressableButtonStyle())
    }
    init( action: @escaping () -> Void, text: String, backgroundColor: Color, textColor: Color, isGradient: Bool = false) {
        self.text = text
        self.action = action
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.isGradient = isGradient
    }
}

// Custom button style for press animation
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ButtonView(action: {}, text: "Test", backgroundColor: .blue, textColor: .white, isGradient: true)
}
