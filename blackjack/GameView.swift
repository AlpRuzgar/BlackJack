//
//  ContentView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 23.02.2026.
//

import SwiftUI


struct GameView: View {
    @StateObject var viewModel: GameViewModel
    var onRestart: (() -> Void)?
    @State private var dealtCardIDs: Set<UUID> = []
    @State private var dealerFlipAngle: Double = 0
    var body: some View {
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
                chipBar
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
                        ForEach(Array(viewModel.dealersHand.cards.enumerated()), id: \.element.id) { index, card in
                            dealerCardView(index: index, card: card)
                        }
                    }
                    .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                
                Spacer()
                
                // Player Section - all hands
                ZStack {
                    ForEach(Array(viewModel.hands.enumerated()), id: \.offset) { index, hand in
                        PlayerHandView(
                            cards: hand.cards,
                            handValue: hand.value,
                            label: viewModel.hands.count > 1 ? "HAND \(index + 1)" : "PLAYER",
                            isActive: index == viewModel.targetHandIndex,
                            handResult: hand.result,
                            dealtCardIDs: $dealtCardIDs
                        )
                        .scaleEffect(index == viewModel.targetHandIndex ? 1.0 : 0.75)
                        .offset(x: CGFloat(index - viewModel.targetHandIndex) * 160)
                        .opacity(index == viewModel.targetHandIndex ? 1.0 : 0.65)
                        .zIndex(index == viewModel.targetHandIndex ? 1 : 0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.targetHandIndex)
                    }
                }
                .padding(.bottom, 20)
                
                // Action Buttons with enhanced styling
                VStack(spacing: 0) {
                    HStack(spacing: 15) {
                        ButtonView(
                            action: {
                                viewModel.hit()
                                if viewModel.playersHandValue > 21 {
                                    if let levelVM = viewModel as? LevelViewModel {
                                        let isLastHand = levelVM.targetHandIndex + 1 >= levelVM.hands.count
                                        let hasStoodPriorHands = levelVM.targetHandIndex > 0 && levelVM.hands[0..<levelVM.targetHandIndex].contains { $0.result == nil }
                                        levelVM.playerBust()
                                        if isLastHand && hasStoodPriorHands {
                                            Task {
                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                    dealerFlipAngle = 180
                                                }
                                            }
                                        }
                                    } else {
                                        viewModel.playerBust()
                                    }
                                }
                            },
                            text: "HIT",
                            backgroundColor: Color(red: 0.9, green: 0.2, blue: 0.2),
                            textColor: .white
                        )
                            ButtonView(
                                action: {
                                    if let levelVM = viewModel as? LevelViewModel {
                                        let isLastHand = levelVM.targetHandIndex + 1 >= levelVM.hands.count
                                        levelVM.stand()
                                        if isLastHand {
                                            Task {
                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                    dealerFlipAngle = 180
                                                }
                                            }
                                        }
                                    } else {
                                        viewModel.stand()
                                        Task {
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                dealerFlipAngle = 180
                                            }
                                        }
                                    }
                                },
                                text: "STAND",
                                backgroundColor: Color(red: 0.2, green: 0.6, blue: 0.3),
                                textColor: .white
                            )
        
                        if let levelVM = viewModel as? LevelViewModel {
                            if levelVM.hands.count == 1 && levelVM.currentHand.cards.count == 2 {
                                ButtonView(action: {
                                    if levelVM.canDoubleDown {
                                        levelVM.doubleDown()
                                        Task {
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                dealerFlipAngle = 180
                                            }
                                        }
                                    }
                                    else { return }
                                },
                                           text: "DOUBLE",
                                           backgroundColor: .purple,
                                           textColor: .white,
                                           isGradient: true)
                            }
                        }
                        if let levelVM = viewModel as? LevelViewModel {
                            if levelVM.canSplit {
                                ButtonView(action: {
                                    levelVM.split()
                                },
                                           text: "SPLIT",
                                           backgroundColor: .yellow,
                                           textColor: .white,
                                           isGradient: true)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 30)
            }
            .onAppear() {
                Task{
                    await viewModel.startGame(for: viewModel.playersHand)
                    viewModel.isGameOver = false
                }
            }
            .onChange(of: viewModel.isRoundComplete) {
                guard viewModel.isRoundComplete else { return }
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    dealtCardIDs.removeAll()
                    dealerFlipAngle = 0
                    if let onRestart {
                        onRestart()
                        viewModel.resetGame()
                    } else {
                        await viewModel.startGame(for: viewModel.playersHand)
                        viewModel.isGameOver = false
                    }
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
    
    @ViewBuilder
    private var chipBar: some View {
        if let levelVM = viewModel as? LevelViewModel {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.yellow)
                    Text("\(levelVM.level.chipsOwned)")
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
                    Text("\(levelVM.currentBet)")
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
    }
}


#Preview {
    GameView(viewModel: GameViewModel(gameType: .endless))
}
