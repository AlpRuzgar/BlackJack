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
                Color.casinogreen
                    .ignoresSafeArea()
                
                VStack{
                    Text("Double on 17")
                        .font(.libreCaslonBold(40))
                        .foregroundStyle(.whiteish)
                        .padding()
                    VStack(spacing: 20){
                        // Enhanced Play button using ButtonView
                        NavigationLink(destination: LevelMenuView()) {
                            StartViewButton(text: "LEVELS", textColor: .whiteish, backgroundColor: .crimson)
                        }
                        NavigationLink(destination: GameView(viewModel: GameViewModel(gameType: .endless))) {
                            StartViewButton(text: "ENDLESS MODE", textColor: .whiteish, backgroundColor: .gold)
                        }
                        
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct StartViewButton: View {
    let text: String
    let textColor: Color
    let backgroundColor: Color
    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .bold, design: .default))
            .tracking(1.5)
            .foregroundStyle(textColor)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(backgroundColor)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    StartView()
}

//TODO: needs rework, looks like shit
