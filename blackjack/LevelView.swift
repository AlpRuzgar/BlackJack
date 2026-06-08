//
//  LevelView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 21.05.2026.
//

import SwiftUI

struct LevelView: View {
    @ObservedObject var level: Level
    let startingChips: Int
    @State var betsPlaced = false
    @State var isOutofChips: Bool = false
    @StateObject var viewModel: LevelViewModel

    init(level: Level) {
        self.level = level
        self.startingChips = level.chipsOwned
        _viewModel = StateObject(wrappedValue: LevelViewModel(level: level))
    }

    var showOutcomeOverlay: Bool {
        isOutofChips || level.isCompleted
    }

    var body: some View {
        ZStack {
            if !betsPlaced {
                NewBetSelectionView(viewModel: viewModel, betsPlaced: $betsPlaced)
            } else {
                GameView(viewModel: viewModel) {
                    betsPlaced = false
                    if viewModel.checkLevelPass() {
                        level.markCompleted()
                    }
                    isOutofChips = viewModel.checkOutOfChips()
                }
            }

            if showOutcomeOverlay {
                LevelOutcomeOverlay(isWon: level.isCompleted)
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
}
