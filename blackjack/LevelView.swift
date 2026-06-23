//
//  LevelView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 21.05.2026.
//

import SwiftUI

struct LevelView: View {
    @ObservedObject var level: Level
    @State var betsPlaced = false
    @State var showOutcomeOverlay = false
    @State var levelWon = false
    @StateObject var viewModel: LevelViewModel
    @Environment(ThemeManager.self) var themeManager
    @Environment(User.self) var user

    init(level: Level) {
        self.level = level
        self._viewModel = StateObject(wrappedValue: LevelViewModel(level: level))
    }
    
    
    var body: some View {
        ZStack {
            if !betsPlaced {
                BetSelectionView(viewModel: viewModel, betsPlaced: $betsPlaced)
            } else {
                GameView(viewModel: viewModel) {
                    betsPlaced = false
                    if viewModel.checkLevelPass() {
                        level.markCompleted()
                        levelWon = true
                        showOutcomeOverlay = true
                        user.increaseCoins(by: level.requiredChips/10)
                    } else if viewModel.checkOutOfChips() {
                        levelWon = false
                        showOutcomeOverlay = true
                    }
                }
            }

            if showOutcomeOverlay {
                LevelOutcomeOverlay(isWon: levelWon) {
                    level.resetChips()
                    viewModel.resetGame()
                    showOutcomeOverlay = false
                    betsPlaced = false
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showOutcomeOverlay)
        .onDisappear {
            viewModel.resetGame()
        }
    }
}

#Preview {
    NavigationStack {
        LevelView(level: Level(id: 4, name: "1", startingChips: 1000, requiredChips: 10000, minimumBet: 30))
    }
    .environment(ThemeManager())
}
