//
//  Hand.swift
//  blackjack
//
//  Created by Alp Rüzgar on 28.05.2026.
//

import Foundation
import Combine

class Hand {
    var cards: [Card] = []
    var value: Int = 0
    var result: GameResult? = nil
    var splitable: Bool {
        cards.count == 2 && cards[1].value == cards[0].value &&
        !["10", "J", "Q", "K"].contains(cards.first?.value)
    }

}
