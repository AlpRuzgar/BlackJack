//
//  LevelButton.swift
//  blackjack
//
//  Created by Alp Rüzgar on 27.05.2026.
//

import SwiftUI

struct LevelButton: View {
    @ObservedObject var level: Level

    private var gradientTop: Color {
        level.isCompleted
            ? Color(red: 0.2, green: 0.7, blue: 0.3)
            : Color(red: 1.0, green: 0.3, blue: 0.2)
    }

    private var gradientBottom: Color {
        level.isCompleted
            ? Color(red: 0.1, green: 0.5, blue: 0.2)
            : Color(red: 0.8, green: 0.1, blue: 0.1)
    }

    var body: some View {
        NavigationLink(destination: LevelView(level: level)) {
            VStack(spacing: 14) {
                Text(level.name)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(1.5)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)

                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Text("START:")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .tracking(1.5)
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.yellow)
                        Text("\(level.chipsOwned)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.black.opacity(0.3)))

                    HStack(spacing: 6) {
                        Text("GOAL:")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .tracking(1.5)
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.yellow)
                        Text("\(level.requiredChips)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.black.opacity(0.3)))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    gradientTop,
                                    gradientBottom
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    RoundedRectangle(cornerRadius: 20)
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
                RoundedRectangle(cornerRadius: 20)
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
            .shadow(color: gradientTop.opacity(0.5), radius: 15, x: 0, y: 5)
            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    LevelButton(level: Level(id: 1, name: "Level 1", startingChips: 10, requiredChips: 20, minimumBet: 2))
}
