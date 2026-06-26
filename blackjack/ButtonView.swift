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
    @Environment(ThemeManager.self) var themeManager
    
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
                .buttonStyle(PressableButtonStyle())
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(backgroundColor)
                )            
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .shadow(color: backgroundColor, radius: 5)
    }
    init( action: @escaping () -> Void, text: String, backgroundColor: Color, textColor: Color) {
        self.text = text
        self.action = action
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(
                configuration.isPressed
                    ? .easeIn(duration: 0.08)
                    : .spring(response: 0.35, dampingFraction: 0.45),
                value: configuration.isPressed
            )
    }
}

#Preview {
    ButtonView(action: {}, text: "Test", backgroundColor: .blue, textColor: .ivory)
        .padding(20)
        .environment(ThemeManager())
}

//TODO: needs rework, looks like shit
