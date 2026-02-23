//
//  contentViewModel.swift
//  blackjack
//
//  Created by Alp Rüzgar on 23.02.2026.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    
    var cardValueArray = ["2","3","4","5","6","7","8","9","10","J","Q","K","A"]
    var suitsArray = [String("S"),String("H"),String("C"),String("D")]
    @Published var cardsArray: [Card] = []
    
    @Published var dealersHandArray: [Card] = []
    @Published var playersHandArray: [Card] = []
    @Published var dealersHandValue: Int = 0
    @Published var playersHandValue: Int = 0
    
    @Published var chipAmount: Int = 100
    @Published var betAmount: Int = 0
    
    @Published var isGameOver: Bool = false
    @Published var gameOverMessage: String = ""
    
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
        guard !cardsArray.isEmpty else { print("No cards left"); return }
        let randomIndex = Int.random(in: 0..<cardsArray.count)
        let selectedCard = cardsArray.remove(at: randomIndex)
        print(selectedCard.toString())
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
        print("dealers hand: \(dealersHandValue)")
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
        print("players hand: \(playersHandValue)")
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
        print("Game started")
        // Ensure fresh state
        resetGame()
        isGameOver = false
        // Deal sequence with delays: dealer closed card first
        giveCard(reciever: "dealer")
        try? await Task.sleep(for: .milliseconds(500))
        giveCard(reciever: "player")
        try? await Task.sleep(for: .milliseconds(500))
        giveCard(reciever: "dealer")
        try? await Task.sleep(for: .milliseconds(500))
        giveCard(reciever: "player")
    }
    /*
    func increaseBet() {
        guard betAmount<chipAmount else { return }
        betAmount += 5
    }
     */
    
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
        isGameOver = false
        gameOverMessage = ""
        createDeck()
    }
}

