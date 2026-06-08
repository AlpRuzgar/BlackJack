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
