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
        case .playerWin: return "YOU WIN!"
        case .dealerWin: return "DEALER WINS"
        case .push: return "PUSH"
        case .playerBust: return "BUST!"
        case .dealerBust: return "DEALER BUST!"
        }
    }

    var message: String {
        switch self {
        case .playerWin: return "Your hand beats the dealer!"
        case .dealerWin: return "Dealer's hand is closer to 21"
        case .push: return "It's a tie!"
        case .playerBust: return "You went over 21"
        case .dealerBust: return "Dealer went over 21. You win!"
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
        case .playerWin, .dealerBust: return "WIN"
        case .dealerWin: return "LOSE"
        case .push: return "PUSH"
        case .playerBust: return "BUST"
        }
    }
}
