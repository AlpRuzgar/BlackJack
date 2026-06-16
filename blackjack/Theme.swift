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
            color
        case .image(let image):
            image.resizable().scaledToFill()
        }
    }
}

struct ThemeColors: Equatable {
    let primary: Color
    let secondary: Color
    let alert: Color
    let extra: Color
}

struct Theme: Identifiable, Equatable {
    var isUnlocked: Bool
    let price: Int
    let id: String
    let background: ThemeBackground
    let colors: ThemeColors
    let chipImages: [Image]
}
