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
                .font(.system(size: 22, weight: .bold, design: .default))
                .tracking(1.5)
                .foregroundStyle(textColor)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(backgroundColor)
                )            
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .shadow(color: .black,radius: 2, x: -5, y:5)
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
    ButtonView(action: {}, text: "Test", backgroundColor: .blue, textColor: .whiteish, isGradient: true)
        .padding(20)
}

//TODO: needs rework, looks like shit
