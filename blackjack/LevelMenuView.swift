//
//  LevelMenuView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 24.05.2026.
//

import SwiftUI

struct LevelMenuView: View {
    @State private var levels: [Level] = [
        Level(id: 1, name: "Level 1", startingChips: 100, requiredChips: 120, minimumBet: 10),
        Level(id: 2, name: "Level 2", startingChips: 100, requiredChips: 150, minimumBet: 10),
    ]
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.3, blue: 0.2),
                    Color(red: 0.0, green: 0.5, blue: 0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            ScrollView {
                VStack {
                    Text("Select Level")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .tracking(2)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                        .padding(.top, 40)
                        .padding(.bottom, 30)
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 160), spacing: 20)],
                        spacing: 20
                    ) {
                        ForEach(levels) { level in
                            LevelButton(level: level)
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
            }
        }
        //MARK: DEV SPEC - DELETE BEFORE PUBLISH
        .toolbar {
            ToolbarItem{
                Button("Reset Levels") {
                    for level in levels {
                        level.reset()
                    }
                }
            }
        }
    }
}



#Preview {
    NavigationStack {
        LevelMenuView()
    }
}
