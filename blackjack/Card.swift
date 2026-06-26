//
//  Card.swift
//  blackjack
//
//  Created by Alp Rüzgar on 23.02.2026.
//

import Foundation

class Card: Identifiable {
    let id = UUID()
    let value: String
    let suit: String
    var frontImage: String = ""
    var backImage: String = ""
    var isClosed: Bool = false

    init(value: String, suit: String) {
        self.value = value
        self.suit = suit
    }
    func toString() -> String {
        "\(value)\(suit)"
    }
}
