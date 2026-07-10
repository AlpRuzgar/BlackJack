//
//  PlayerHandView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 28.05.2026.
//

import SwiftUI

struct PlayerHandView: View {
    @Environment(ThemeManager.self) var themeManager
    let cards: [Card]
    let handValue: Int
    let label: LocalizedStringKey
    var isActive: Bool = false
    var handResult: GameResult? = nil
    @Binding var dealtCardIDs: Set<UUID>
    var splitNamespace: Namespace.ID

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: -35) {
                ForEach(cards) { card in
                    Image(card.frontImage)
                        .resizable()
                        .interpolation(.high)
                        .antialiased(true)
                        .scaledToFit()
                        .frame(width: 110, height: 165)
                        .cornerRadius(10)
                        .matchedGeometryEffect(id: card.id, in: splitNamespace)
                        .offset(y: dealtCardIDs.contains(card.id) ? 0 : -1000)
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.4)) {
                                _ = dealtCardIDs.insert(card.id)
                            }
                        }
                }
            }
            .shadow(color: isActive ? .black.opacity(0.6) : .black.opacity(0.4), radius: 5, x: 0, y: 5)

            ZStack {
                Capsule()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 80, height: 36)
                Text("\(handValue)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(handValue > 21 ? .red : themeManager.current.colors.text)
            }
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)

            if let result = handResult {
                Text(result.shortLabel)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(themeManager.current.colors.text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(result.color))
            }

            Text(label)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(isActive ? AnyShapeStyle(themeManager.current.colors.secondary.gradient) : AnyShapeStyle(themeManager.current.colors.text.opacity(0.8)))
                .tracking(2)
        }
        .padding(8)
//        .background(isActive ? Color.yellow.opacity(0.08) : Color.clear)
        .cornerRadius(12)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(isActive ? Color.yellow.opacity(0.6) : Color.clear, lineWidth: 2)
//        )
    }
}
