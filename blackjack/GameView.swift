//
//  ContentView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 23.02.2026.
//

import SwiftUI


struct GameView: View {

    @StateObject private var viewModel = ContentViewModel()

    @State private var gameResult: GameOverOverlay.GameResult?
    @State private var dealtCardIDs: Set<UUID> = []
    @State private var dealerFlipAngle: Double = 0

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
                    .padding(.top, 40)

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
                                        withAnimation(.spring()) {
                                            gameResult = .playerBust
                                        }
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
                                        
                                        // Determine game result
                                        if viewModel.dealersHandValue > 21 {
                                            withAnimation(.spring()) {
                                                gameResult = .dealerBust
                                            }
                                        }
                                        else if viewModel.playersHandValue > viewModel.dealersHandValue {
                                            withAnimation(.spring()) {
                                                gameResult = .playerWin
                                            }
                                        }
                                        else if viewModel.playersHandValue < viewModel.dealersHandValue {
                                            withAnimation(.spring()) {
                                                gameResult = .dealerWin
                                            }
                                        }
                                        else if viewModel.playersHandValue == viewModel.dealersHandValue {
                                            withAnimation(.spring()) {
                                                gameResult = .push
                                            }
                                        }
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
                    viewModel.isGameOver = false
                    Task{
                        await viewModel.startGame()
                    }
                }
                
                // Game Over Overlay
                if let result = gameResult {
                    GameOverOverlay(result: result) {
                        gameResult = nil
                        dealtCardIDs.removeAll()
                        dealerFlipAngle = 0
                        viewModel.resetGame()
                        Task {
                            await viewModel.startGame()
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

struct GameOverOverlay: View {
    let result: GameResult
    let onRestart: () -> Void
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    enum GameResult {
        case playerWin, dealerWin, push, playerBust, dealerBust
        
        var title: String {
            switch self {
            case .playerWin: return "YOU WIN!"
            case .dealerWin: return "DEALER WINS"
            case .push: return "PUSH"
            case .playerBust: return "BUST!"
            case .dealerBust: return "DEALER BUST!"
            }
        }
        
        var message: String {
            switch self {
            case .playerWin: return "Your hand beats the dealer!"
            case .dealerWin: return "Dealer's hand is closer to 21"
            case .push: return "It's a tie!"
            case .playerBust: return "You went over 21"
            case .dealerBust: return "Dealer went over 21. You win!"
            }
        }
        
        var color: Color {
            switch self {
            case .playerWin, .dealerBust: return .green
            case .dealerWin, .playerBust: return .red
            case .push: return .orange
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background layer (not animated with scale)
            Color.black.opacity(0.7 * opacity)
                .ignoresSafeArea()
                .onTapGesture { }
            
            // Content layer (animated with scale)
            VStack(spacing: 25) {
                // Animated icon
                ZStack {
                    Circle()
                        .fill(result.color.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .stroke(result.color, lineWidth: 4)
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(result.color)
                }
                
                VStack(spacing: 12) {
                    Text(result.title)
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(result.message)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                
                Button(action: onRestart) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("PLAY AGAIN")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(result.color)
                    )
                }
                .shadow(color: result.color.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
            )
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
    
    private var iconName: String {
        switch result {
        case .playerWin, .dealerBust: return "crown.fill"
        case .dealerWin, .playerBust: return "xmark.circle.fill"
        case .push: return "equal.circle.fill"
        }
    }
}

struct GameOverView{
    
}

#Preview {
    GameView()
}

