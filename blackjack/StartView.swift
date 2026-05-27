//
//  StartView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 24.02.2026.
//

import Foundation
import SwiftUI

struct StartView: View {
    @State private var isAnimating = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                // Matching gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.0, green: 0.3, blue: 0.2),
                        Color(red: 0.0, green: 0.5, blue: 0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40){
                    Spacer()
                    
                    // Enhanced title section
                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Text("BLACK")
                                .font(.system(size: 56, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, Color(white: 0.7)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                            
                            Text("JACK")
                                .font(.system(size: 56, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(red: 1.0, green: 0.3, blue: 0.3), Color(red: 0.8, green: 0.1, blue: 0.1)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .red.opacity(0.6), radius: 8, x: 0, y: 0)
                                .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                        }
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    }
                    
                    Spacer()
                    
                    // Card symbols decoration
                    HStack(spacing: 30) {
                        ForEach(["♠︎", "♥︎", "♣︎", "♦︎"], id: \.self) { suit in
                            Text(suit)
                                .font(.system(size: 40))
                                .foregroundColor(
                                    suit == "♥︎" || suit == "♦︎" ?
                                    Color(red: 1.0, green: 0.3, blue: 0.3) :
                                            .white
                                )
                                .opacity(0.8)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Enhanced Play button using ButtonView
                    NavigationLink(destination: LevelMenuView()) { StartViewButton(text: "Levels", color: .red)}
                    NavigationLink(destination: GameView(viewModel: GameViewModel(gameType: .endless))) {
                        StartViewButton(text: "Endless Mode", color: .green)
                    }
                    
                    Spacer()
                        .frame(height: 60)
                }
                .padding()
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct StartViewButton: View {
    let text: String
    let color: Color
    var body: some View {
        HStack(spacing: 12) {
            Text(text)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .tracking(2)
        }
        .foregroundStyle(.white)
        .frame(width: 280, height: 65)
        .background(
            ZStack {
                // Gradient background
                Capsule()
                    .fill(
                        color.gradient
                    )
                
                // Glossy overlay effect
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .white.opacity(0.3), location: 0),
                                .init(color: .clear, location: 0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
        )
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.5),
                            .clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: Color(red: 1.0, green: 0.3, blue: 0.2).opacity(0.5), radius: 15, x: 0, y: 5)
        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
    }
    
}

#Preview {
    StartView()
}
