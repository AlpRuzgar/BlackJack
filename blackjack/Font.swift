//
//  Font.swift
//  blackjack
//
//  Created by Alp Rüzgar on 7.06.2026.
//

import Foundation
import SwiftUI

extension Font {
    static func playfairdisplay(_ size: CGFloat) -> Font {
        .custom("PlayfairDisplay-Regular", size: size)
    }
    
    static func playfairdisplayBold(_ size: CGFloat) -> Font {
        .custom("PlayfairDisplay-Bold", size: size)
    }
}
