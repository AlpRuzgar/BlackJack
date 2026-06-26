//
//  blackjackApp.swift
//  blackjack
//
//  Created by Alp Rüzgar on 23.02.2026.
//

import SwiftUI
import CoreText

@main
struct blackjackApp: App {
    @State private var themeManager = ThemeManager()
    @State private var user = User()

    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(themeManager)
                .environment(user)
        }
    }
}
