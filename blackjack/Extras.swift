//
//  Font.swift
//  blackjack
//
//  Created by Alp Rüzgar on 7.06.2026.
//

import Foundation
import SwiftUI

extension Font {
    static func anton(_ size: CGFloat) -> Font {
        .custom("Anton-Regular", size: size)
    }
    
    static func libreCaslon(_ size: CGFloat) -> Font {
        .custom("LibreCaslonText-Regular", size: size)
    }
    
    static func libreCaslonBold(_ size: CGFloat) -> Font {
        .custom("LibreCaslonText-Bold", size: size)
    }
    static func libreCaslonItalic(_ size: CGFloat) -> Font {
        .custom("LibreCaslonText-Italic", size: size)
    }
}

extension Color {
    // Ancient Greek — sunlit marble & Aegean sea
    static let greekAegean   = Color(red: 0.11, green: 0.43, blue: 0.55)
    static let greekSky      = Color(red: 0.44, green: 0.69, blue: 0.77)
    static let greekOlive    = Color(red: 0.54, green: 0.60, blue: 0.36)
    static let greekGold     = Color(red: 0.85, green: 0.71, blue: 0.29)
    static let greekMarble   = Color(red: 0.96, green: 0.94, blue: 0.90)
    
    // Ancient Egyptian — desert gold & lapis
    static let egyptGold      = Color(red: 0.88, green: 0.66, blue: 0.18)
    static let egyptLapis     = Color(red: 0.12, green: 0.23, blue: 0.54)
    static let egyptTurquoise = Color(red: 0.17, green: 0.66, blue: 0.61)
    static let egyptCarnelian = Color(red: 0.71, green: 0.28, blue: 0.18)
    static let egyptSandstone = Color(red: 0.94, green: 0.88, blue: 0.72)
    
    // Norse / Viking — cold steel & ice
    static let norseSteel    = Color(red: 0.29, green: 0.33, blue: 0.38)
    static let norseIce      = Color(red: 0.62, green: 0.72, blue: 0.74)
    static let norseBlood    = Color(red: 0.48, green: 0.18, blue: 0.15)
    static let norseBronze   = Color(red: 0.65, green: 0.49, blue: 0.27)
    static let norseFrost    = Color(red: 0.89, green: 0.92, blue: 0.92)
    
    // Feudal Japan — black lacquer, crimson & gold
    static let japanLacquer  = Color(red: 0.10, green: 0.10, blue: 0.12)
    static let japanCrimson  = Color(red: 0.69, green: 0.12, blue: 0.18)
    static let japanGoldLeaf = Color(red: 0.79, green: 0.66, blue: 0.30)
    static let japanIndigo   = Color(red: 0.20, green: 0.25, blue: 0.36)
    static let japanRice     = Color(red: 0.96, green: 0.94, blue: 0.90)
    
    // Future / Cyberpunk — neon on near-black
    static let neonCyan    = Color(red: 0.13, green: 0.83, blue: 0.93)
    static let neonMagenta = Color(red: 0.91, green: 0.24, blue: 0.55)
    static let neonViolet  = Color(red: 0.49, green: 0.23, blue: 0.93)
    static let neonLime    = Color(red: 0.64, green: 0.90, blue: 0.21)
    static let neonGhost   = Color(red: 0.90, green: 0.95, blue: 0.96)
    
    // Dark & Moody — noir with a single ember
    static let moodyCharcoal = Color(red: 0.12, green: 0.13, blue: 0.14)
    static let moodySlate    = Color(red: 0.23, green: 0.25, blue: 0.28)
    static let moodyEmber    = Color(red: 0.78, green: 0.42, blue: 0.23)
    static let moodyAsh      = Color(red: 0.42, green: 0.44, blue: 0.47)
    static let moodyFog      = Color(red: 0.85, green: 0.85, blue: 0.87)
}

