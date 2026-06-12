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
    @Namespace private var splitNamespace
    @State private var chipBarOpacity: Double = 0
    @State private var chipBarOffset: CGFloat = -50
    @State private var buttonsOpacity: Double = 0
    @State private var buttonsOffset: CGFloat = 50
    @State private var showAllHands: Bool = false

    private var allHandsScale: CGFloat {
        switch viewModel.hands.count {
        case 1:  return 1.0
        case 2:  return 0.85
        case 3:  return 0.65
        default: return 0.50
        }
    }
    private var allHandsSpacing: CGFloat { 170 * allHandsScale + 8 }

    var body: some View {
        ZStack {
            // Enhanced gradient background
            Color.casinogreen
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Chip & Bet status bar
                chipBar
                    .opacity(chipBarOpacity)
                    .offset(y: chipBarOffset)
                // Dealer Section
                VStack(spacing: 12) {
                    Text("DEALER")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.whiteish.opacity(0.8))
                        .tracking(2)
                    
                    // Dealer hand value display
                    ZStack {
                        Capsule()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 80, height: 36)
                        
                        Text(dealerFlipAngle >= 180 ? "\(viewModel.dealersHandValue)" : "?")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.whiteish)
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
                        let handCount = viewModel.hands.count
                        let isActive = index == viewModel.targetHandIndex
                        let spacing = allHandsSpacing
                        PlayerHandView(
                            cards: hand.cards,
                            handValue: hand.value,
                            label: handCount > 1 ? "HAND \(index + 1)" : "PLAYER",
                            isActive: !showAllHands && isActive,
                            handResult: hand.result,
                            dealtCardIDs: $dealtCardIDs,
                            splitNamespace: splitNamespace
                        )
                        .scaleEffect(showAllHands ? allHandsScale : (isActive ? 1.0 : 0.75))
                        .offset(x: showAllHands
                            ? CGFloat(index) * spacing - CGFloat(handCount - 1) * spacing / 2
                            : CGFloat(index - viewModel.targetHandIndex) * 160
                        )
                        .opacity(showAllHands ? 1.0 : (isActive ? 1.0 : 0.65))
                        .zIndex(isActive ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.75), value: showAllHands)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.targetHandIndex)
                    }
                }
                .padding(.bottom, 20)
                
                // Action Buttons with enhanced styling
                VStack(spacing: 12) {
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
                                            showAllHands = true
                                            Task {
                                                try? await Task.sleep(for: .milliseconds(400))
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
                            backgroundColor: .crimson,
                            textColor: .whiteish
                        )
                        ButtonView(
                            action: {
                                if let levelVM = viewModel as? LevelViewModel {
                                    let isLastHand = levelVM.targetHandIndex + 1 >= levelVM.hands.count
                                    levelVM.stand()
                                    if isLastHand {
                                        if levelVM.hands.count > 1 { showAllHands = true }
                                        Task {
                                            if levelVM.hands.count > 1 {
                                                try? await Task.sleep(for: .milliseconds(400))
                                            }
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
                            backgroundColor: .greenish,
                            textColor: .whiteish
                        )
                    }
                    .padding(.horizontal, 30)

                    HStack(spacing: 15) {
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
                                           backgroundColor: .plum,
                                           textColor: .whiteish,
                                           isGradient: true)
                            }
                        }
                        if let levelVM = viewModel as? LevelViewModel {
                            if levelVM.canSplit() {
                                ButtonView(action: {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        levelVM.split()
                                    }
                                },
                                           text: "SPLIT",
                                           backgroundColor: .amber,
                                           textColor: .whiteish,
                                           isGradient: true)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 30)
                .opacity(buttonsOpacity)
                .offset(y: buttonsOffset)
            }
            .onAppear() {
                Task{
                    await viewModel.startGame(for: viewModel.playersHand)
                    viewModel.isGameOver = false
                }
                withAnimation(.easeOut(duration: 0.5)) {
                    chipBarOpacity = 1
                    chipBarOffset = 0
                }
                withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                    buttonsOpacity = 1
                    buttonsOffset = 0
                }
            }
            .onChange(of: viewModel.isRoundComplete) {
                guard viewModel.isRoundComplete else { return }
                // Ensure all hands are visible when results appear (covers the all-bust case)
                if viewModel.hands.count > 1 { showAllHands = true }
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    dealtCardIDs.removeAll()
                    dealerFlipAngle = 0
                    showAllHands = false
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
        if index == 1 {
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
                    Text("BET")
                        .font(.libreCaslon(12))
                        .foregroundStyle(.gold.opacity(0.7))
                        .tracking(1.5)
                    Text("\(levelVM.currentBet)")
                        .font(.libreCaslonBold(18))
                        .foregroundStyle(.gold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundStyle(.gold)
                    Text("\(levelVM.level.chipsOwned)")
                        .font(.libreCaslonBold(18))
                        .foregroundStyle(.gold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))

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
