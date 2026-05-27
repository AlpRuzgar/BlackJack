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
    
    @Published var dealersHandArray: [Card] = []
    @Published var playersHandArray: [Card] = []
    @Published var dealersHandValue: Int = 0
    @Published var playersHandValue: Int = 0
        
    var gameStage: GameStage = .betting
    var gameType: GameType

    @Published var isGameOver: Bool = true
    @Published var gameOverMessage: String = ""
    @Published var gameResult: GameResult?

    init(gameType: GameType) {
        self.gameType = gameType
    }
    
    func createDeck() -> Void {
        for value in cardValueArray{
            for suit in suitsArray
            {
                let card = Card(value: value, suit: suit)
                card.frontImage = "\(value)\(suit)"
                cardsArray.append(card)
            }
        }
    }
    
    func giveCard(reciever: String)
    {
        guard !cardsArray.isEmpty else { return }
        let randomIndex = Int.random(in: 0..<cardsArray.count)
        let selectedCard = cardsArray.remove(at: randomIndex)
        switch reciever{
        case "dealer":
            dealersHandArray.append(selectedCard)
            calculateDealersHand()
        case "player":
            playersHandArray.append(selectedCard)
            calculatePlayersHand()
            // Check for player bust
        default:
            break
        }
    }
    
    func calculateDealersHand() {
        var base = 0
        var aceCount = 0
        for card in dealersHandArray {
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
        dealersHandValue = calculateAces(base: base, aceCount: aceCount)
        if dealersHandValue > 21 {
            triggerGameOver(message: "Dealer busted! You win.")
        }
    }
    
    func calculatePlayersHand() {
        var base = 0
        var aceCount = 0
        for card in playersHandArray {
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
        playersHandValue = calculateAces(base: base, aceCount: aceCount)
        if playersHandValue > 21 {
            triggerGameOver(message: "You busted! Dealer wins.")
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
    
    func startGame() async {
        resetGame()
        giveCard(reciever: "dealer")
        try? await Task.sleep(for: .milliseconds(500))
        giveCard(reciever: "player")
        try? await Task.sleep(for: .milliseconds(500))
        giveCard(reciever: "dealer")
        try? await Task.sleep(for: .milliseconds(500))
        giveCard(reciever: "player")
    }
    func hit() {
        guard isGameOver == false else { return }
        giveCard(reciever: "player")
        calculatePlayersHand()
    }
    func stand() {
        Task {
            isGameOver = true
            try? await Task.sleep(for: .milliseconds(500))
            while dealersHandValue < 17 {
                giveCard(reciever: "dealer")
                calculateDealersHand()
                try? await Task.sleep(for: .milliseconds(500))
            }
            
            evaluateRoundResult()
        }
    }
    func evaluateRoundResult() {
        if dealersHandValue > 21 {
            dealerBust()
        } else if playersHandValue > dealersHandValue {
            playerWin()
        } else if playersHandValue < dealersHandValue {
            dealerWin()
        } else {
            push()
        }
    }

    func playerWin() {
        withAnimation(.spring()) {
            gameResult = .playerWin
        }
    }

    func dealerWin() {
        withAnimation(.spring()) {
            gameResult = .dealerWin
        }
    }

    func push() {
        withAnimation(.spring()) {
            gameResult = .push
        }
    }

    func playerBust() {
        withAnimation(.spring()) {
            gameResult = .playerBust
        }
    }

    func dealerBust() {
        withAnimation(.spring()) {
            gameResult = .dealerBust
        }
    }

    private func triggerGameOver(message: String) {
        gameOverMessage = message
        isGameOver = true
    }
    
    func resetGame() {
        cardsArray.removeAll()
        dealersHandArray.removeAll()
        playersHandArray.removeAll()
        dealersHandValue = 0
        playersHandValue = 0
        gameOverMessage = ""
        gameResult = nil
        createDeck()
    
    }
}

