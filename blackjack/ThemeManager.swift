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
    var themes: [Theme] = [
        Theme(isUnlocked: true, price: 0, id: "default",
              background: .color(.casinogreen),
              colors: ThemeColors(primary: .greenish, secondary: .gold, alert: .crimson, extra: .plum, text: .ivory)),
                
        Theme(isUnlocked: false, price: 1000, id: "greece",
              background: .image(Image("background-greece")),
              colors: ThemeColors(primary: .greekAegean, secondary: .greekGold, alert: .greekOlive, extra: .greekSky, text: .greekMarble)),

        Theme(isUnlocked: false, price: 2000, id: "egypt",
              background: .image(Image("background-egypt")),
              colors: ThemeColors(primary: .egyptLapis, secondary: .egyptGold, alert: .egyptCarnelian, extra: .egyptTurquoise, text: .egyptSandstone),
              cardTint: .white),
        
        Theme(isUnlocked: false, price: 3000, id: "norse",
              background: .image(Image("background-norse")),
              colors: ThemeColors(primary: .norseSteel, secondary: .norseBronze, alert: .norseBlood, extra: .norseIce, text: .norseFrost),
              cardTint: .white),
        Theme(isUnlocked: false, price: 3000, id: "norse",
              background: .image(Image("background-norse")),
              colors: ThemeColors(primary: .norseSteel, secondary: .norseBronze, alert: .norseBlood, extra: .norseIce, text: .norseFrost),
              cardTint: .white),
        Theme(isUnlocked: false, price: 3000, id: "norse",
              background: .image(Image("background-norse")),
              colors: ThemeColors(primary: .norseSteel, secondary: .norseBronze, alert: .norseBlood, extra: .norseIce, text: .norseFrost),
              cardTint: .white),
        Theme(isUnlocked: false, price: 3000, id: "norse",
              background: .image(Image("background-norse")),
              colors: ThemeColors(primary: .norseSteel, secondary: .norseBronze, alert: .norseBlood, extra: .norseIce, text: .norseFrost),
              cardTint: .white),

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
        self.selectedThemeId = UserDefaults.standard.string(forKey: "selectedTheme") ?? "default"
    }
    
    func select(_ theme: Theme) {
        selectedThemeId = theme.id
    }
    
    func reset() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        for theme in themes where theme.id != "default" {
            theme.isUnlocked = false
        }
        selectedThemeId = "default"
    }
}
