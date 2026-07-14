//
//  contentViewModel.swift
//  blackjack
//
//  Created by Alp Rüzgar on 23.02.2026.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Enums

enum GameResult {
    case playerWin, dealerWin, push, playerBust, dealerBust
}
enum GameStage {
    case betting
    case playing
    case roundOver
}
enum GameType {
    case level
    case endless
}

// MARK: - GameViewModel

class GameViewModel: ObservableObject {

    // MARK: - Properties

    var themeManager: ThemeManager = ThemeManager()
    var soundManager: SoundManager = SoundManager()
    var cardValueArray = ["2","3","4","5","6","7","8","9","10","J","Q","K","A"]
    var suitsArray = [String("S"),String("H"),String("C"),String("D")]
    @Published var cardsArray: [Card] = []

    @Published var targetHandIndex: Int = 0
    @Published var hands: [Hand] = []

    @Published var dealersHand = Hand()
    @Published var playersHand = Hand()
    @Published var dealersHandValue: Int = 0
    @Published var playersHandValue: Int = 0

    var gameStage: GameStage = .betting
    var gameType: GameType

    @Published var isGameOver: Bool = true
    @Published var gameOverMessage: String = ""
    @Published var isRoundComplete: Bool = false
    
    @Published var record: Int
    @Published var streak: Int = 0


    init(gameType: GameType) {
        self.gameType = gameType
        self.record = UserDefaults.standard.integer(forKey: "record")
        self.hands = [self.playersHand]
    }

    // MARK: - Deck

    func createDeck() -> Void {
        for value in cardValueArray {
            for suit in suitsArray {
                let card = Card(value: value, suit: suit)
                    card.frontImage = "\(value)\(suit)-\(themeManager.current.id)"
                card.backImage = "Back-\(themeManager.current.id)"
                cardsArray.append(card)
            }
        }
    }

    #if DEBUG
    var debugForcePairs: Bool = false
    #endif

    // MARK: - Card Dealing

    func giveCard(to hand: Hand) {
        guard !cardsArray.isEmpty else { return }
        #if DEBUG
        if debugForcePairs && hands.contains(where: { $0 === hand }) && hand.cards.count == 1,
           let matchIndex = cardsArray.firstIndex(where: { $0.value == hand.cards[0].value }) {
            let selectedCard = cardsArray.remove(at: matchIndex)
            hand.cards.append(selectedCard)
            calculateHand(hand)
            return
        }
        #endif
        let randomIndex = Int.random(in: 0..<cardsArray.count)
        let selectedCard = cardsArray.remove(at: randomIndex)
        hand.cards.append(selectedCard)
        calculateHand(hand)
        soundManager.play("cardPlacingSound.mp3")
    }

    // MARK: - Hand Calculation

    func calculateHand(_ hand: Hand) {
        var base = 0
        var aceCount = 0
        for card in hand.cards {
            switch card.value {
            case "2","3","4","5","6","7","8","9","10":
                base += Int(card.value) ?? 0
            case "J","Q","K":
                base += 10
            case "A":
                aceCount += 1
            default:
                break
            }
        }
        let total = calculateAces(base: base, aceCount: aceCount)
        hand.value = total
        if hand === dealersHand {
            dealersHandValue = total
        } else {
            playersHandValue = total
        }
    }

    func calculateAces(base: Int, aceCount: Int) -> Int {
        // Start with every ace as 11, then downgrade to 1 (subtract 10) one at a
        // time until the hand is no longer bust. This correctly handles hands like
        // A-A-9 (11+11+9=31 → 11+1+9=21) without special-casing.
        var total = base + aceCount * 11
        var remainingAces = aceCount
        while total > 21 && remainingAces > 0 {
            total -= 10
            remainingAces -= 1
        }
        return total
    }

    // MARK: - Game Flow

    func startGame(for hand: Hand) async {
        resetGame()
        giveCard(to: dealersHand)
        try? await Task.sleep(for: .milliseconds(500))
        giveCard(to: playersHand)
        try? await Task.sleep(for: .milliseconds(500))
        giveCard(to: dealersHand)
        try? await Task.sleep(for: .milliseconds(500))
        giveCard(to: playersHand)
    }

    func hit() {
        guard isGameOver == false else { return }
        giveCard(to: hands[targetHandIndex])
    }

    func stand() {
        Task {
            isGameOver = true
            try? await Task.sleep(for: .milliseconds(500))
            while dealersHandValue < 17 {
                giveCard(to: dealersHand)
                try? await Task.sleep(for: .milliseconds(500))
            }
            evaluateRoundResult()
        }
    }

    // MARK: - Round Evaluation

    func evaluateRoundResult() {
        for hand in hands {
            if hand.value > 21 {
                hand.result = .playerBust
                streak = 0
            } else if dealersHandValue > 21 {
                hand.result = .dealerBust
                streak += 1
            } else if hand.value > dealersHandValue {
                hand.result = .playerWin
                streak += 1
            } else if hand.value < dealersHandValue {
                hand.result = .dealerWin
                streak = 0
            } else {
                hand.result = .push
            }
        }
        withAnimation(.spring()) {
            isRoundComplete = true
        }
        setRecord()
    }

    func setRecord() {
        if streak > record {
            record = streak
            UserDefaults.standard.set(streak, forKey: "record")
        }
    }
    
    func playerBust() {
        streak = 0
        hands[targetHandIndex].result = .playerBust
        isGameOver = true
        withAnimation(.spring()) {
            isRoundComplete = true
        }
    }

    private func triggerGameOver(message: String) {
        gameOverMessage = message
        isGameOver = true
    }

    // MARK: - Reset

    func resetGame() {
        cardsArray.removeAll()
        dealersHand.cards.removeAll()
        playersHand.cards.removeAll()
        playersHand.value = 0
        playersHand.result = nil
        dealersHandValue = 0
        playersHandValue = 0
        gameOverMessage = ""
        isRoundComplete = false
        hands = [playersHand]
        targetHandIndex = 0
        createDeck()
    }
}
