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
    var playersHand2: Hand = Hand()
    var playersHand3: Hand = Hand()
    var playersHand4: Hand = Hand()
    var currentHand: Hand {
        hands[targetHandIndex]
    }
    var nextHand: Hand {
        hands[targetHandIndex+1]
    }
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
        level.chipsOwned += currentBet * 2
    }

    func chipPush() {
        level.chipsOwned += currentBet
    }

    override func resetGame() {
        super.resetGame()
        playersHand2.cards.removeAll()
        playersHand3.cards.removeAll()
        playersHand4.cards.removeAll()
    }

    func checkLevelPass() -> Bool {
        return level.chipsOwned >= level.requiredChips
    }

    func checkOutOfChips() -> Bool {
        return level.chipsOwned < level.minimumBet
    }

    func doubleDown() {
        if level.chipsOwned > currentBet * 2 && playersHand.cards.count == 2 {
            level.chipsOwned -= currentBet
            currentBet *= 2
            hit()
            if playersHandValue > 21 {
                playerBust()
            } else {
                stand()
            }
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
            isGameOver = true
            withAnimation(.spring()) {
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
        giveCard(to: currentHand)
        giveCard(to: newHand)
    }
}
