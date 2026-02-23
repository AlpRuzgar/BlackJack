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
    
    var body: some View {
        Button (action: action) {
            Text(text)
        }
        .font(.system(size: 24, weight: .bold, design: .default))
        .padding()
        .foregroundStyle(textColor)
        .background(backgroundColor)
        .clipShape(.capsule)
        
    }
    init( action: @escaping () -> Void, text: String, backgroundColor: Color, textColor: Color) {
        self.text = text
        self.action = action
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
}

#Preview {
    ButtonView( action: {},text: "Test", backgroundColor: .blue, textColor: .white)
}
