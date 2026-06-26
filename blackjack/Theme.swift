//
//  File.swift
//  blackjack
//
//  Created by Alp Rüzgar on 12.06.2026.
//

import Foundation
import SwiftUI

enum ThemeBackground: Equatable {
    case color(Color)
    case image(Image)
}

extension ThemeBackground: View {
    var body: some View {
        switch self {
        case .color(let color):
            color.ignoresSafeArea()
        case .image(let image):
            GeometryReader { geometry in
                    image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
        }
    }

    @ViewBuilder
    var preview: some View {
        switch self {
        case .color(let color):
            color
        case .image(let image):
            image
                .resizable()
                .frame(width: 170, height: 200)
        }
    }
}

struct ThemeColors: Equatable {
    let primary: Color
    let secondary: Color
    let alert: Color
    let extra: Color
    let text: Color
}

@Observable
class Theme: Identifiable {
    var isUnlocked: Bool
    let price: Int
    let id: String
    let background: ThemeBackground
    let colors: ThemeColors
    let cardTint: Color?
    
    init(isUnlocked: Bool, price: Int, id: String, background: ThemeBackground, colors: ThemeColors, cardTint: Color? = nil) {
        self.isUnlocked = UserDefaults.standard.bool(forKey: "theme_Unlocked-\(id)")
        self.price = price
        self.id = id
        self.background = background
        self.colors = colors
        self.cardTint = cardTint
    }
    
    func unlock() {
        isUnlocked = true
        UserDefaults.standard.set(true, forKey: "theme_Unlocked-\(id)")
    }
    
    func lock(){
        isUnlocked = false
        UserDefaults.standard.set(false, forKey: "theme_locked-\(id)")
    }
}
