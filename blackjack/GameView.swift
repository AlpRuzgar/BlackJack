//
//  ContentView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 23.02.2026.
//

import SwiftUI


struct GameView: View {
    @StateObject var viewModel: GameViewModel
    
    @State private var dealtCardIDs: Set<UUID> = []
    @State private var dealerFlipAngle: Double = 0
    var onPlayAgain: (() -> Void)? = nil
    var isEndless: Bool {
        viewModel.gameType == .endless
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.0, green: 0.3, blue: 0.2),
                        Color(red: 0.0, green: 0.5, blue: 0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Chip & Bet status bar
                    if !isEndless {
                        HStack {
                            HStack(spacing: 6) {
                                Image(systemName: "dollarsign.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.yellow)
                                Text("\(viewModel.chipsOwned)")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(Color.black.opacity(0.3)))
                            
                            Spacer()
                            
                            HStack(spacing: 6) {
                                Text("BET")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                                    .tracking(1.5)
                                Text("\(viewModel.currentBet)")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(Color.black.opacity(0.3)))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    // Dealer Section
                    VStack(spacing: 12) {
                        Text("DEALER")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .tracking(2)
                        
                        // Dealer hand value display
                        ZStack {
                            Capsule()
                                .fill(Color.black.opacity(0.3))
                                .frame(width: 80, height: 36)
                            
                            Text(dealerFlipAngle >= 180 ? "\(viewModel.dealersHandValue)" : "?")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        
                        HStack(spacing: -30) {
                            ForEach(Array(viewModel.dealersHandArray.enumerated()), id: \.element.id) { index, card in
                                dealerCardView(index: index, card: card)
                            }
                        }
                        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    
                    Spacer()
                    
                    // Player Section
                    VStack(spacing: 12) {
                        HStack(spacing: -30) {
                            ForEach(viewModel.playersHandArray) { card in
                                cardImageView(card: card)
                            }
                        }
                        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                        
                        // Player hand value display
                        ZStack {
                            Capsule()
                                .fill(Color.black.opacity(0.3))
                                .frame(width: 80, height: 36)
                            
                            Text("\(viewModel.playersHandValue)")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(viewModel.playersHandValue > 21 ? .red : .white)
                        }
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        
                        Text("PLAYER")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .tracking(2)
                    }
                    .padding(.bottom, 20)
                    
                    // Action Buttons with enhanced styling
                    VStack(spacing: 0) {
                        HStack(spacing: 15) {
                            ButtonView(
                                action: {
                                    guard viewModel.isGameOver == false else { return }
                                    viewModel.giveCard(reciever: "player")
                                    viewModel.calculatePlayersHand()
                                    if viewModel.playersHandValue > 21 {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            dealerFlipAngle = 180
                                        }
                                        viewModel.playerBust()
                                    }
                                },
                                text: "HIT",
                                backgroundColor: Color(red: 0.9, green: 0.2, blue: 0.2),
                                textColor: .white
                            )
                            
                            ButtonView(
                                action: {
                                    Task {
                                        viewModel.isGameOver = true
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            dealerFlipAngle = 180
                                        }
                                        try? await Task.sleep(for: .milliseconds(500))
                                        while viewModel.dealersHandValue < 17 {
                                            viewModel.giveCard(reciever: "dealer")
                                            viewModel.calculateDealersHand()
                                            try? await Task.sleep(for: .milliseconds(500))
                                        }
                                        
                                        viewModel.evaluateRoundResult()
                                    }
                                },
                                text: "STAND",
                                backgroundColor: Color(red: 0.2, green: 0.6, blue: 0.3),
                                textColor: .white
                            )
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.bottom, 30)
                }
                .onAppear() {
                    Task {
                        await viewModel.startGame()
                        viewModel.isGameOver = false
                    }
                }

                // Game Over Overlay
                if let result = viewModel.gameResult {
                    GameOverOverlay(result: result) {
                        dealtCardIDs.removeAll()
                        dealerFlipAngle = 0
                        viewModel.resetGame()
                        if let onPlayAgain {
                            onPlayAgain()
                        } else {
                            Task {
                                await viewModel.startGame()
                                viewModel.isGameOver = false
                            }
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
        }
    }
    
    
    @ViewBuilder
    private func dealerCardView(index: Int, card: Card) -> some View {
        if index == 0 {
            ZStack {
                // Front of card
                Image(card.frontImage)
                    .resizable()
                    .interpolation(.high)
                    .antialiased(true)
                    .scaledToFit()
                    .frame(width: 90, height: 135)
                    .scaleEffect(x: -1, y: 1)
                    .opacity(dealerFlipAngle > 90 ? 1 : 0)
                
                // Back of card
                Image(card.backImage)
                    .resizable()
                    .interpolation(.high)
                    .antialiased(true)
                    .scaledToFit()
                    .frame(width: 90, height: 135)
                    .opacity(dealerFlipAngle <= 90 ? 1 : 0)
            }
            .cornerRadius(8)
            .rotation3DEffect(
                .degrees(dealerFlipAngle),
                axis: (x: 0, y: 1, z: 0)
            )
            .offset(y: dealtCardIDs.contains(card.id) ? 0 : -1000)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    _ = dealtCardIDs.insert(card.id)
                }
            }
        } else {
            cardImageView(card: card)
        }
    }
    
    private func cardImageView(card: Card) -> some View {
        Image(card.frontImage)
            .resizable()
            .interpolation(.high)
            .antialiased(true)
            .scaledToFit()
            .frame(width: 90, height: 135)
            .cornerRadius(8)
            .offset(y: dealtCardIDs.contains(card.id) ? 0 : -1000)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    _ = dealtCardIDs.insert(card.id)
                }
            }
    }
}


#Preview {
    GameView(viewModel: GameViewModel(chipsOwned: 0, requiredChips: 0, minimumBet: 5, gameType: .endless))
}

