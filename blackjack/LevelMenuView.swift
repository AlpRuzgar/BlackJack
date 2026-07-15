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
        Level(id: 1, name: String(localized: "Kitchen Table"), startingChips: 100, requiredChips: 200, minimumBet: 5,
              lockDuration: 5*60),
        Level(id: 2, name: String(localized: "The Back Room"), startingChips: 150, requiredChips: 350, minimumBet: 10,
              lockDuration: 10*60),
        Level(id: 3, name: String(localized: "Saturday Night"), startingChips: 200, requiredChips: 500, minimumBet: 15,
              lockDuration: 20*60),
        Level(id: 4, name: String(localized: "Main Room"), startingChips: 300, requiredChips: 750, minimumBet: 25,
              lockDuration: 30*60),
        Level(id: 5, name: String(localized: "Center Stage"), startingChips: 500, requiredChips: 1500, minimumBet: 40,
              lockDuration: 40*60),
        Level(id: 6, name: String(localized: "Black Chip Lounge"), startingChips: 800, requiredChips: 3000, minimumBet: 75,
              lockDuration: 50*60),
        Level(id: 7, name: String(localized: "High Limit Room"), startingChips: 1000, requiredChips: 4000, minimumBet: 100, lockDuration: 60*60),
        Level(id: 8, name: String(localized: "The Whale Room"), startingChips: 1500, requiredChips: 7500, minimumBet: 250, lockDuration: 75*60),
        Level(id: 9, name: String(localized: "The Vault"), startingChips: 2000, requiredChips: 12000, minimumBet: 300, lockDuration: 90*60),
        Level(id: 10, name: String(localized: "The Summit"), startingChips: 3000, requiredChips: 21000, minimumBet: 500, lockDuration: 105*60),
        Level(id: 11, name: String(localized: "Legend's Table"), startingChips: 5000, requiredChips: 50000, minimumBet: 1000, lockDuration: 120*60),

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
                    // Top bar
                    HStack {
                        BackButton()
                        Spacer()
                        InfoButton { isInfoPresented.toggle() }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

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
                    .padding(.top, 12)
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
        .toolbar(.hidden, for: .navigationBar)
        #if DEBUG
        .overlay(alignment: .bottom) {
            Button("Reset Levels") {
                for level in levels { level.reset() }
            }
            .padding(.bottom, 8)
        }
        #endif
    }

    func unlockNextLevel() {
        //TODO
    }
}

private struct LevelInfoRow: View {
    let icon: String
    let color: Color
    let text: LocalizedStringKey

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
