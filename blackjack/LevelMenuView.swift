//
//  LevelMenuView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 24.05.2026.
//

import SwiftUI

struct LevelMenuView: View {
    @State private var levels: [Level] = [
        Level(id: 1, name: "Garage Game", startingChips: 1000, requiredChips: 2000, minimumBet: 10),
        Level(id: 2, name: "Local Casino", startingChips: 1500, requiredChips: 4000, minimumBet: 25),
        Level(id: 3, name: "The Mainfloor", startingChips: 2500, requiredChips: 8000, minimumBet: 50),
        Level(id: 4, name: "Members Only", startingChips: 4000, requiredChips: 15000, minimumBet: 100),
        Level(id: 5, name: "VIP Lounge", startingChips: 6000, requiredChips: 30000, minimumBet: 250),
        Level(id: 6, name: "Monte Carlo", startingChips: 10000, requiredChips: 60000, minimumBet: 500)
    ]
    
    var body: some View {
        ZStack{
            Color.casinogreen
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Text("Select Level")
                        .font(.libreCaslonBold(40))
                        .foregroundStyle(.whiteish)
                        .tracking(2)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                        .padding(.top, 40)
                        .padding(.bottom, 30)
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 270), spacing: 20)],
                        spacing: 20
                    ) {
                        ForEach(levels.indices, id: \.self) { index in
                            NewLevelButton(tableIndex: index % 6, level: levels[index])
                                .padding()
                        }
                    }
                    Spacer()
                }
            }
        }
        #if DEBUG
        .toolbar {
            ToolbarItem{
                Button("Reset Levels") {
                    for level in levels {
                        level.reset()
                    }
                }
            }
        }
        #endif
    }
    func unlockNextLevel() {
        //TODO
    }
}



#Preview {
    NavigationStack {
        LevelMenuView()
    }
}
