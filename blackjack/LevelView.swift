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
    
    var body: some View {
        Group {
            if !level.isCompleted && !isOutofChips {
                if !betsPlaced {
                    BetSelectorView(viewModel: viewModel, betsPlaced: $betsPlaced)
                }
                else {
                    GameView(viewModel: viewModel) {
                        betsPlaced = false
                        if viewModel.checkLevelPass() {
                            level.markCompleted()
                        }
                        isOutofChips = viewModel.checkOutOfChips()
                    }
                }
            }
            else if isOutofChips {
                LevelOutcomeOverlay(isWon: false)
            }
            else if level.isCompleted {
                LevelOutcomeOverlay(isWon: true)
            }
        }
        .onDisappear {
            viewModel.resetGame()
        }
        
    }
}

#Preview {
    LevelView(level: Level(id: 1, name: "1", startingChips: 100, requiredChips: 120, minimumBet: 10))
}
