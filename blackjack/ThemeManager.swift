//
//  ThemeManager.swift
//  blackjack
//
//  Created by Alp Rüzgar on 12.06.2026.
//

import Foundation
import SwiftUI

@Observable
class ThemeManager {
    var themes: [Theme] = [ ///colors function by order: 1- alert, 2- primary, 3- secondary, 4- third
        Theme(isUnlocked: true, price: 0, id: "default", background: .color(.casinogreen),
              colors: ThemeColors(primary: .greenish, secondary: .gold, alert: .crimson, extra: .plum),
              chipImages: []),
        Theme(isUnlocked: true, price: 1000, id: "future", background: .color(.black),
              colors: ThemeColors(primary: .futureGreen, secondary: .futureYellow, alert: .futurePink, extra: .futureBlue),
              chipImages: []),
    Theme(isUnlocked: true, price: 1500, id: "medieval", background: .color(.cyan),
              colors: ThemeColors(primary: .gold, secondary: .crimson, alert: .plum, extra: .greenish),
              chipImages: [])
    ]
    
    var selectedThemeId: String {
        didSet {
            UserDefaults.standard.set(selectedThemeId, forKey: "selectedTheme")
        }
    }
    
    var current: Theme {
        themes.first { $0.id == selectedThemeId } ?? themes[0]
    }
    
    init() {
        self.selectedThemeId = UserDefaults.standard.string(forKey: "selectedTheme") ?? "classic"
    }
    
    func select(_ theme: Theme) {
        selectedThemeId = theme.id
    }
}
