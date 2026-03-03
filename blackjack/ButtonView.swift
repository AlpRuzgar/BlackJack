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
                .bold()
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    Capsule().fill(isGradient ? AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [backgroundColor, backgroundColor.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)) : AnyShapeStyle(backgroundColor))
                )
                .foregroundStyle(textColor)
                .clipShape(Capsule())
                .padding()
            
        }
    }
    init( action: @escaping () -> Void, text: String, backgroundColor: Color, textColor: Color, isGradient: Bool = false) {
        self.text = text
        self.action = action
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.isGradient = isGradient
    }
}

#Preview {
    ButtonView(action: {}, text: "Test", backgroundColor: .blue, textColor: .white, isGradient: true)
}
