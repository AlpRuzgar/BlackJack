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
    init() {
        registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            StartView()
        }
    }

    private func registerFonts() {
        let fontFileNames = [
            "PlayfairDisplay-Black",
            "PlayfairDisplay-BlackItalic",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-ExtraBoldItalic",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-SemiBoldItalic"
        ]
        for name in fontFileNames {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
