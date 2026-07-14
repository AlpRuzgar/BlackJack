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
    @State private var soundManager = SoundManager()

    var body: some Scene {
        WindowGroup {
            StartView()
                .fontDesign(.serif)
                .environment(themeManager)
                .environment(user)
                .environment(soundManager)
                .onAppear {
                    soundManager.load("cardPlacingSound.mp3")
                    soundManager.load("chipPlacingSound.mp3")
                }
        }
    }
}

//TODO: buttonların farklı ekranlarda tutarlı boyutlanması ve konumlanması -> bitti, test et
//TODO: Daha fazla level
//TODO: game view açılırken bir geçiş animasyonu -> bitti, test et
//TODO: Endless streak -> bitti, test et
//TODO: kovboy teması
