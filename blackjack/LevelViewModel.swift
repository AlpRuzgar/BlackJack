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
    var currentHand: Hand {
        hands[targetHandIndex]
    }
    var nextHand: Hand {
        hands[targetHandIndex+1]
    }
    @Published var startingBet: Int
    @Published var currentBet: Int
    
    var canDoubleDown: Bool {
        level.chipsOwned > startingBet * 2 && playersHand.cards.count == 2
    }
    
    var canSplit: Bool {
        playersHand.cards.count == 2 && playersHand.cards.first?.value == playersHand.cards.last?.value && level.chipsOwned > startingBet
    }
    
    init(level: Level) {
        self.level = level
        self.startingBet = level.minimumBet
        self.currentBet = level.minimumBet
        super.init(gameType: .level)
    }
    
    func placeBet() {
        level.chipsOwned -= currentBet
    }
    
    func chipGain() {
        level.chipsOwned += currentBet * 2
    }
    
    func chipPush() {
        level.chipsOwned += currentBet
    }
    
    func checkLevelPass() -> Bool {
        return level.chipsOwned >= level.requiredChips
    }
    
    func checkOutOfChips() -> Bool {
        return level.chipsOwned < level.minimumBet
    }
    
    func doubleDown() {
        level.chipsOwned -= startingBet
        currentBet = startingBet * 2
        hit()
        if playersHandValue > 21 {
            playerBust()
        } else {
            stand()
        }
        
    }
    
    override func stand() {
        if targetHandIndex + 1 < hands.count {
            targetHandIndex += 1
        } else {
            super.stand()
        }
    }
    
    override func playerBust() {
        hands[targetHandIndex].result = .playerBust
        if targetHandIndex + 1 < hands.count {
            targetHandIndex += 1
        } else {
            // If any prior hand stood (result is nil), dealer must still play to evaluate those hands.
            let hasStoodHands = hands[0..<targetHandIndex].contains { $0.result == nil }
            if hasStoodHands {
                super.stand()
            } else {
                isGameOver = true
                isRoundComplete = true
            }
        }
    }
    
    override func evaluateRoundResult() {
        super.evaluateRoundResult()
        for hand in hands {
            switch hand.result {
            case .playerWin, .dealerBust:
                level.chipsOwned += currentBet * 2
            case .push:
                level.chipsOwned += currentBet
            default:
                break
            }
        }
    }
    
    func split() {
        guard currentHand.splitable else { return }
        let newHand = Hand()
        let splitCard = currentHand.cards.removeLast()
        newHand.cards.append(splitCard)
        hands.insert(newHand, at: targetHandIndex + 1)
        level.chipsOwned -= startingBet
        currentBet += startingBet
        calculateHand(currentHand)
        calculateHand(newHand)
    }
}
//FIXME: 10s and face cards can't be splitted
///Maybe add a animation to split, like a slide
