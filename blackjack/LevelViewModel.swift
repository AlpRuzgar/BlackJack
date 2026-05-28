//
//  LevelViewModel.swift
//  blackjack
//
//  Created by Alp Rüzgar on 24.05.2026.
//

import Foundation
import Combine

class LevelViewModel: GameViewModel {
    let level: Level
    @Published var currentBet: Int
    
    init(level: Level) {
        self.level = level
        self.currentBet = level.minimumBet
        super.init(gameType: .level)
    }
    func placeBet() {
        level.chipsOwned -= currentBet
    }

    func chipGain() {
        level.chipsOwned += currentBet*2
    }

    func chipPush() {
        level.chipsOwned += currentBet
    }

    override func dealerBust() {
        super.dealerBust()
        chipGain()
    }
    override func playerWin() {
        super.playerWin()
        chipGain()
    }
    
    func checkLevelPass() -> Bool {
        return level.chipsOwned >= level.requiredChips
    }
    func checkOutOfChips() -> Bool {
        return level.chipsOwned < level.minimumBet
    }
    
    func doubleDown() {
        if level.chipsOwned > currentBet*2 && playersHandArray.count == 2 {
            level.chipsOwned -= currentBet
            currentBet *= 2
            hit()
            if playersHandValue > 21 {
                playerBust()
            }
            else { stand() }
        }
        else { return }
    }
}
