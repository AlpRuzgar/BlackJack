//
//  ContentView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 23.02.2026.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
//    @State var isBettingButtonsEnabled: Bool = true
//    @State var isPlayingButtonEnabled: Bool = false
    
    @State private var showAlert = false
    
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.ignoresSafeArea()
                    .brightness(-0.2)
                
                VStack {
                    VStack{
                        HStack(spacing: -30) {
                            ForEach(Array(viewModel.dealersHandArray.enumerated()), id: \.element.id) { index, card in
                                let showBack = (index == 0) && (viewModel.isGameOver == false)
                                Image(showBack ? card.backImage : card.frontImage)
                                    .resizable()
                                    .interpolation(.high)
                                    .antialiased(true)
                                    .scaledToFit()
                                    .frame(width: 90, height: 135)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: -30) {
                            ForEach(viewModel.playersHandArray) { card in
                                Image(card.frontImage)
                                    .resizable()
                                    .interpolation(.high)
                                    .antialiased(true)
                                    .scaledToFit()
                                    .frame(width: 90, height: 135)
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        ButtonView(action: {
                            guard viewModel.isGameOver == false else { return }
                            viewModel.giveCard(reciever: "player")
                            viewModel.calculatePlayersHand()
                            if viewModel.playersHandValue > 21 {
                                alertMessage = "You busted!"
                                showAlert.toggle()
                            }
                        }, text: "Hit     ", backgroundColor: .red, textColor: .white)
                        
                        .alert(alertMessage, isPresented: $showAlert) {
                            Button("Restart", role: .confirm) {
                                viewModel.resetGame()
                                Task{
                                    await viewModel.startGame()
                                }
                            }
                            
                        } message: {
                            Text(viewModel.gameOverMessage)
                        }
                        
                        
                        
                        ButtonView(action: {
                            Task {
                                viewModel.isGameOver = true
                                try? await Task.sleep(for: .milliseconds(500))
                                while viewModel.dealersHandValue < 17 {
                                    viewModel.giveCard(reciever: "dealer")
                                    viewModel.calculateDealersHand()
                                    try? await Task.sleep(for: .milliseconds(500))
                                }
                                if viewModel.dealersHandValue > 21 {
                                    alertMessage = "Dealer Bust!"
                                    viewModel.gameOverMessage = "Dealer Busted! You win!"
                                    showAlert.toggle()
                                }
                                else if viewModel.playersHandValue > viewModel.dealersHandValue {
                                    alertMessage = "Player Wins!"
                                    viewModel.gameOverMessage = "Your hand is closer to 21 than the dealer's. You win!"
                                    showAlert.toggle()
                                }
                                else if viewModel.playersHandValue < viewModel.dealersHandValue {
                                    alertMessage = "Dealer Wins!"
                                    viewModel.gameOverMessage = "The dealer's hand is closer to 21 than yours. You lose."
                                    showAlert.toggle()
                                }
                                else if viewModel.playersHandValue == viewModel.dealersHandValue {
                                    alertMessage = "Push!"
                                    viewModel.gameOverMessage = "It's a push! No one wins or loses."
                                    showAlert.toggle()
                                }
                            }
                            
                        }, text: "Stand", backgroundColor: .green, textColor: .white)
                        
                        .alert(alertMessage, isPresented: $showAlert) {
                            Button("Restart", role: .confirm) {
                                viewModel.resetGame()
                                Task{
                                    await viewModel.startGame()
                                }
                            }
                            
                        } message: {
                            Text(viewModel.gameOverMessage)
                        }
                    }
                }
                .padding()
                .onAppear() {
                    viewModel.isGameOver = false
                    Task{
                        await viewModel.startGame()
                    }
                }
            }
        }
    }
}
#Preview {
    ContentView()
}

