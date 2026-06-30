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
    @Environment(ThemeManager.self) var themeManager
    @State private var dealtCardIDs: Set<UUID> = []
    @State private var dealerFlipAngle: Double = 0
    @Namespace private var splitNamespace
    @State private var chipBarOpacity: Double = 0
    @State private var chipBarOffset: CGFloat = -50
    @State private var buttonsOpacity: Double = 0
    @State private var buttonsOffset: CGFloat = 50
    
    @State private var isHowToShowing = false
    let isBackButtonHidden: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.current.background
                VStack(spacing: 20) {
                    // Chip & Bet status bar
                    chipBar
                        .opacity(chipBarOpacity)
                        .offset(y: chipBarOffset)
                    // Dealer Section
                    VStack  (spacing: 12){
                        VStack(spacing: 12) {
                            Text("DEALER")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(themeManager.current.colors.text.opacity(0.8))
                                .tracking(2)
                            
                            // Dealer hand value display
                            ZStack {
                                Capsule()
                                    .fill(Color.black.opacity(0.3))
                                    .frame(width: 80, height: 36)
                                
                                Text(dealerFlipAngle >= 180 ? "\(viewModel.dealersHandValue)" : "?")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.current.colors.text)
                            }
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                            
                            HStack(spacing: -35) {
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
                                    dealtCardIDs: $dealtCardIDs,
                                    splitNamespace: splitNamespace
                                )
                                .scaleEffect(index == viewModel.targetHandIndex ? 1.0 : 0.75)
                                .offset(x: CGFloat(index - viewModel.targetHandIndex) * 160)
                                .opacity(index == viewModel.targetHandIndex ? 1.0 : 0.65)
                                .zIndex(index == viewModel.targetHandIndex ? 1 : 0)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.targetHandIndex)
                            }
                        }
                        .padding(.bottom, 120)
                    }
                    
                }
                
                // Action Buttons (overlay - floats above content without affecting layout)
                VStack {
                    Spacer()
                    if !viewModel.isGameOver {
                        HStack(spacing: 20) {
                            gameButton(systemName: "plus", color: themeManager.current.colors.alert) {
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
                            }
                            gameButton(systemName: "hand.raised.fill", color: themeManager.current.colors.primary) {
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
                            }
                            
                            if let levelVM = viewModel as? LevelViewModel,
                               levelVM.hands.count == 1 && levelVM.currentHand.cards.count == 2 {
                                gameButton(systemName: "chevron.up.2", color: themeManager.current.colors.extra) {
                                    if levelVM.canDoubleDown {
                                        levelVM.doubleDown()
                                        Task {
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                dealerFlipAngle = 180
                                            }
                                        }
                                    }
                                }
                            }
                            if let levelVM = viewModel as? LevelViewModel, levelVM.canSplit() {
                                gameButton(systemName: "arrow.left.and.right", color: themeManager.current.colors.secondary) {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        levelVM.split()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                        .opacity(buttonsOpacity)
                        .offset(y: buttonsOffset)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .disabled(isHowToShowing)
                    }
                }
                .animation(.easeInOut(duration: 0.4), value: viewModel.isGameOver)
                
                if isHowToShowing {
                    InfoOverlay(isPresented: $isHowToShowing, title: "How to Play?", overlayBody: {
                        VStack(spacing: 4) {
                            InfoRow(icon: "plus", color: themeManager.current.colors.alert, text: "Hit: draw a card.")
                            InfoRow(icon: "hand.raised.fill", color: themeManager.current.colors.primary, text: "Stand: end your turn.")
                            InfoRow(icon: "chevron.up.2", color: themeManager.current.colors.extra, text: "Double: double your bet, draw one card.")
                            InfoRow(icon: "arrow.left.and.right", color: themeManager.current.colors.secondary, text: "Split: split a matching pair into two hands.")
                        }
                        .foregroundStyle(themeManager.current.colors.text)
                        .font(.system(size: 20, weight: .medium))
                    })
                        .padding(10)
                    
                }
            }
            .toolbar {
                Button("", systemImage: "info"){
                    isHowToShowing = true
                }
            }
        }
        .navigationBarBackButtonHidden(isBackButtonHidden)
        .onAppear() {
            viewModel.themeManager = themeManager
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
            isHowToShowing = false
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
        }        .toolbarBackground(.hidden, for: .navigationBar)
        
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
                    .frame(width: 110, height: 165)
                    .colorMultiply(themeManager.current.cardTint ?? .white)
                    .scaleEffect(x: -1, y: 1)
                    .opacity(dealerFlipAngle > 90 ? 1 : 0)
                
                // Back of card
                Image(card.backImage)
                    .resizable()
                    .interpolation(.high)
                    .antialiased(true)
                    .scaledToFit()
                    .frame(width: 110, height: 165)
                    .opacity(dealerFlipAngle <= 90 ? 1 : 0)
            }
            .cornerRadius(10)
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
            .frame(width: 110, height: 165)
        //            .colorMultiply(themeManager.current.cardTint ?? .white)
            .cornerRadius(10)
            .offset(y: dealtCardIDs.contains(card.id) ? 0 : -1000)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    _ = dealtCardIDs.insert(card.id)
                }
            }
    }
    
    private func gameButton(systemName: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.ivory)
                .frame(width: 70, height: 70)
                .background(color, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: color.opacity(0.6), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PressableButtonStyle())
    }
    
    @ViewBuilder
    private var chipBar: some View {
        if let levelVM = viewModel as? LevelViewModel {
            HStack {
                HStack(spacing: 6) {
                    Text("BET")
                        .font(.system(size: 12,weight: .bold))
                        .foregroundStyle(themeManager.current.colors.secondary.opacity(0.7))
                        .tracking(1.5)
                    Text("\(levelVM.currentBet)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(themeManager.current.colors.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundStyle(themeManager.current.colors.secondary)
                    Text("\(levelVM.level.chipsOwned)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(themeManager.current.colors.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))
                
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            
            
        } else {
            // For endless mode, show exit button
            HStack {
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
}


private struct InfoRow: View {
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(color)
                .frame(width: 28)
            Text(text)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

#Preview {
    let tm = ThemeManager()
    GameView(viewModel: GameViewModel(gameType: .endless), isBackButtonHidden: false)
        .environment(tm)
        .environment(User())
}
