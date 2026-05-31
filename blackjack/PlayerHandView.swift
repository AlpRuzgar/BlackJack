//
//  PlayerHandView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 28.05.2026.
//

import SwiftUI

struct PlayerHandView: View {
    let cards: [Card]
    let handValue: Int
    let label: String
    @Binding var dealtCardIDs: Set<UUID>

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: -30) {
                ForEach(cards) { card in
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
            .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)

            ZStack {
                Capsule()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 80, height: 36)
                Text("\(handValue)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(handValue > 21 ? .red : .white)
            }
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)

            Text(label)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .tracking(2)
        }
    }
}
