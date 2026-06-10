//
//  StartView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 24.02.2026.
//

import Foundation
import SwiftUI

struct StartView: View {
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = -30
    @State private var button1Opacity: Double = 0
    @State private var button1Offset: CGFloat = 40
    @State private var button2Opacity: Double = 0
    @State private var button2Offset: CGFloat = 40

    var body: some View {
        NavigationStack {
            ZStack {
                Color.casinogreen
                    .ignoresSafeArea()

                VStack {
                    Text("Double on 17")
                        .font(.libreCaslonBold(50))
                        .foregroundStyle(.whiteish)
                        .padding()
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)

                    VStack(spacing: 20) {
                        NavigationLink(destination: LevelMenuView()) {
                            StartViewButton(text: "TABLES", textColor: .whiteish, backgroundColor: .crimson)
                        }
                        .opacity(button1Opacity)
                        .offset(y: button1Offset)

                        NavigationLink(destination: GameView(viewModel: GameViewModel(gameType: .endless))) {
                            StartViewButton(text: "ENDLESS MODE", textColor: .whiteish, backgroundColor: .gold)
                        }
                        .opacity(button2Opacity)
                        .offset(y: button2Offset)
                    }
                    .padding()
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    titleOpacity = 1
                    titleOffset = 0
                }
                withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                    button1Opacity = 1
                    button1Offset = 0
                }
                withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                    button2Opacity = 1
                    button2Offset = 0
                }
            }
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
            .shadow(color: .black, radius: 2, x: -5, y: 5)
    }
}

#Preview {
    StartView()
}
