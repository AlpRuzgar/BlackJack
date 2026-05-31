//
//  contentViewModel.swift
//  blackjack
//
//  Created by Alp Rüzgar on 23.02.2026.
//

import Foundation
import Combine
import SwiftUI

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

class GameViewModel: ObservableObject {
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

    init(gameType: GameType) {
        self.gameType = gameType
        self.hands = [playersHand]
    }

    func createDeck() -> Void {
        for value in cardValueArray {
            for suit in suitsArray {
                let card = Card(value: value, suit: suit)
                card.frontImage = "\(value)\(suit)"
                cardsArray.append(card)
            }
        }
    }

    #if DEBUG
    var debugForcePairs: Bool = true
    #endif

    func giveCard(to hand: Hand) {
        guard !cardsArray.isEmpty else { return }
        #if DEBUG
        if debugForcePairs && hand === playersHand && hand.cards.count == 1,
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
    }

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
        var total = base + aceCount * 11
        var remainingAces = aceCount
        while total > 21 && remainingAces > 0 {
            total -= 10
            remainingAces -= 1
        }
        return total
    }

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

    func evaluateRoundResult() {
        for hand in hands {
            if hand.value > 21 {
                hand.result = .playerBust
            } else if dealersHandValue > 21 {
                hand.result = .dealerBust
            } else if hand.value > dealersHandValue {
                hand.result = .playerWin
            } else if hand.value < dealersHandValue {
                hand.result = .dealerWin
            } else {
                hand.result = .push
            }
        }
        withAnimation(.spring()) {
            isRoundComplete = true
        }
    }

    func playerBust() {
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
