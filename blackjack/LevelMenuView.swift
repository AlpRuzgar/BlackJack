//
//  LevelMenuView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 24.05.2026.
//

import SwiftUI

struct LevelMenuView: View {
    @Environment(ThemeManager.self) var themeManager
    @State private var levels: [Level] = [
        Level(id: 1, name: "Garage Game", startingChips: 1000, requiredChips: 2000, minimumBet: 10,
              lockDuration: 5*60),
        Level(id: 2, name: "Local Casino", startingChips: 1500, requiredChips: 4000, minimumBet: 25,
              lockDuration: 10*60),
        Level(id: 3, name: "The Mainfloor", startingChips: 2500, requiredChips: 8000, minimumBet: 50,
              lockDuration: 20*60),
        Level(id: 4, name: "Members Only", startingChips: 4000, requiredChips: 15000, minimumBet: 100,
              lockDuration: 40*60),
        Level(id: 5, name: "VIP Lounge", startingChips: 6000, requiredChips: 30000, minimumBet: 250,
              lockDuration: 60*60),
        Level(id: 6, name: "Monte Carlo", startingChips: 10000, requiredChips: 60000, minimumBet: 500,
              lockDuration: 120*60)
    ]

    @State private var titleVisible = false
    @State private var levelsVisible = false
    @State private var isInfoPresented = false

    var body: some View {
        ZStack {
            themeManager.current.background
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    // Title + gold divider
                    VStack(spacing: 10) {
                        Text("Select Level")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(themeManager.current.colors.text)
                            .tracking(2)
                            .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)

                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(themeManager.current.colors.secondary.gradient)
                            Image(systemName: "square.fill")
                                .font(.system(size: 7))
                                .foregroundStyle(themeManager.current.colors.secondary.gradient)
                                .rotationEffect(.degrees(45))
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(themeManager.current.colors.secondary.gradient)
                        }
                        .padding(.horizontal, 50)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 28)
                    .opacity(titleVisible ? 1 : 0)
                    .offset(y: titleVisible ? 0 : -25)
                    .animation(.easeOut(duration: 0.5), value: titleVisible)

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 270), spacing: 20)],
                        spacing: 20
                    ) {
                        ForEach(levels.indices, id: \.self) { index in
                            LevelButton(level: levels[index])
                                .padding(.horizontal, 8)
                                .opacity(levelsVisible ? 1 : 0)
                                .offset(y: levelsVisible ? 0 : 40)
                                .animation(.easeOut(duration: 0.45).delay(0.15 + Double(index) * 0.09), value: levelsVisible)
                        }
                    }
                    .padding(.bottom, 30)

                    Spacer()
                }
            }
            if isInfoPresented {
                InfoOverlay(isPresented: $isInfoPresented, title: "Levels") {
                    VStack(spacing: 4) {
                        LevelInfoRow(icon: "trophy.fill",
                                     color: themeManager.current.colors.secondary,
                                     text: "Reach the target chips to complete a level and earn coins.")
                        LevelInfoRow(icon: "lock.fill",
                                     color: .green,
                                     text: "Completed levels lock for a cooldown period. They unlock automatically when the timer expires.")
                    }
                    .foregroundStyle(themeManager.current.colors.text)
                    .font(.system(size: 16, weight: .medium))
                }
            }

        }
        .onAppear {
            titleVisible = true
            levelsVisible = true
        }
        #if DEBUG
        .toolbar {
            ToolbarItem {
                Button("Reset Levels") {
                    for level in levels {
                        level.reset()
                    }
                }
            }
        }
        #endif
        .toolbar {
            ToolbarItem{
                Button{
                    isInfoPresented.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
    }

    func unlockNextLevel() {
        //TODO
    }
}

private struct LevelInfoRow: View {
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
    NavigationStack {
        LevelMenuView()
    }
    .environment(ThemeManager())
}
