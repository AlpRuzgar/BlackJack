//
//  User.swift
//  blackjack
//
//  Created by Alp Rüzgar on 19.06.2026.
//

import Foundation

@Observable
class User {
    var coins: Int {
        didSet {
            UserDefaults.standard.set(coins, forKey: "userCoins")
        }
    }

    init() {
        self.coins = UserDefaults.standard.integer(forKey: "userCoins")
    }

    func increaseCoins(by amount: Int) {
        coins += amount
    }

    func decreaseCoins(by amount: Int) {
        coins -= amount
    }
}
