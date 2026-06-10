//
//  StartView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 24.02.2026.
//

import Foundation
import SwiftUI

private struct FloatingSymbol: Identifiable {
    let id = UUID()
    let symbol: String
    let xFraction: CGFloat
    let size: CGFloat
    let opacity: Double
    let duration: Double
    let targetRotation: Double
    let initialYFraction: CGFloat

    static func makeAll() -> [FloatingSymbol] {
        let suits = ["♠", "♥", "♦", "♣"]
        return (0..<14).map { i in
            FloatingSymbol(
                symbol: suits[i % 4],
                xFraction: CGFloat.random(in: 0.05...0.95),
                size: CGFloat.random(in: 22...65),
                opacity: Double.random(in: 0.05...0.15),
                duration: Double.random(in: 9...20),
                targetRotation: Double.random(in: -25...25),
                initialYFraction: CGFloat.random(in: 0.0...1.0)
            )
        }
    }
}

private struct FloatingSymbolView: View {
    let symbol: FloatingSymbol
    let containerSize: CGSize

    @State private var yOffset: CGFloat = 0
    @State private var rotation: Double = 0

    var body: some View {
        Text(symbol.symbol)
            .font(.system(size: symbol.size))
            .foregroundStyle(Color.white.opacity(symbol.opacity))
            .rotationEffect(.degrees(rotation))
            .position(
                x: containerSize.width * symbol.xFraction,
                y: containerSize.height * symbol.initialYFraction + yOffset
            )
            .onAppear {
                withAnimation(.linear(duration: symbol.duration).repeatForever(autoreverses: false)) {
                    yOffset = -(containerSize.height * (1.0 + symbol.initialYFraction))
                    rotation = symbol.targetRotation
                }
            }
    }
}

struct StartView: View {
    @State private var symbols: [FloatingSymbol] = FloatingSymbol.makeAll()
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

                GeometryReader { geo in
                    ForEach(symbols) { sym in
                        FloatingSymbolView(symbol: sym, containerSize: geo.size)
                    }
                }
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
