//
//  LevelView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 21.05.2026.
//

import SwiftUI

struct LevelView: View {
    let chipsOwned: Int
    let requiredChips: Int
    let minimumBet: Int
    var levelPassed: Bool {
        chipsOwned > requiredChips
    }
    var levelOver = false
    @State private var betsPlaced = false
    @StateObject private var viewModel: GameViewModel

    init(chipsOwned: Int, requiredChips: Int, minimumBet: Int) {
        self.chipsOwned = chipsOwned
        self.requiredChips = requiredChips
        self.minimumBet = minimumBet
        _viewModel = StateObject(wrappedValue: GameViewModel(chipsOwned: chipsOwned, requiredChips: requiredChips, minimumBet: minimumBet, gameType: .level))
    }

    var body: some View {
        if !betsPlaced {
            betSelectorView(viewModel: viewModel, betsPlaced: $betsPlaced)
        }
        else {
            GameView(viewModel: viewModel)
        }
    }
}

#Preview {
    LevelView(chipsOwned: 100, requiredChips: 200, minimumBet: 10)
}
