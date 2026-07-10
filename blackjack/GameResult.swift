//
//  GameResult.swift
//  blackjack
//
//  Created by Alp Rüzgar on 21.05.2026.
//

import SwiftUI

extension GameResult {
    var title: String {
        switch self {
        case .playerWin: return String(localized: "YOU WIN!")
        case .dealerWin: return String(localized: "DEALER WINS")
        case .push: return String(localized: "PUSH")
        case .playerBust: return String(localized: "BUST!")
        case .dealerBust: return String(localized: "DEALER BUST!")
        }
    }

    var message: String {
        switch self {
        case .playerWin: return String(localized: "Your hand beats the dealer!")
        case .dealerWin: return String(localized: "Dealer's hand is closer to 21")
        case .push: return String(localized: "It's a tie!")
        case .playerBust: return String(localized: "You went over 21")
        case .dealerBust: return String(localized: "Dealer went over 21. You win!")
        }
    }

    var color: Color {
        switch self {
        case .playerWin, .dealerBust: return .green
        case .dealerWin, .playerBust: return .red
        case .push: return .orange
        }
    }

    var iconName: String {
        switch self {
        case .playerWin, .dealerBust: return "crown.fill"
        case .dealerWin, .playerBust: return "xmark.circle.fill"
        case .push: return "equal.circle.fill"
        }
    }

    var shortLabel: String {
        switch self {
        case .playerWin, .dealerBust: return String(localized: "WIN")
        case .dealerWin: return String(localized: "LOSE")
        case .push: return String(localized: "PUSH")
        case .playerBust: return String(localized: "BUST")
        }
    }
}
