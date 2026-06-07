//
//  NewLevelButton.swift
//  blackjack
//
//  Created by Alp Rüzgar on 7.06.2026.
//

import SwiftUI

struct NewLevelButton: View {
    let tableImages: [Image] = [Image(.orangeTable), Image(.greenTable), Image(.blueTable), Image(.redTable), Image(.purpleTable), Image(.goldTable)]
    var tableIndex: Int
    var level: Level
    var body: some View {
        NavigationLink(destination: LevelView(level: level)) {
            ZStack {
                    tableImages[tableIndex]
                        .resizable()
                    
                VStack {
                    Text(level.name)
                            .font(.playfairdisplayBold(30))
                            .foregroundStyle(.white)
                            .offset(y: 20)
                    
                    //Diamond divider
                    HStack {
                        Rectangle()
                            .frame(width: 100, height: 1)
                            .foregroundStyle(.gold)
                        Image(systemName: "square.fill")
                            .foregroundStyle(.gold)
                            .rotationEffect(Angle(degrees: 45))
                        Rectangle()
                            .frame(width: 100, height: 1)
                            .foregroundStyle(.gold)
                    }
                    //level info
                    HStack(spacing: 0) {
                        Text("Start \(level.startingChips)")
                            .font(.playfairdisplay(15))
                            .foregroundStyle(.white)
                            .padding(5)
                            .frame(maxWidth: .infinity)
                            .offset(x: 45)
                        Rectangle()
                            .frame(width: 1, height: 50)
                            .foregroundStyle(.gold)
                        Text("Target \(level.requiredChips)")
                            .font(.playfairdisplay(15))
                            .foregroundStyle(.white)
                            .padding(5)
                            .frame(maxWidth: .infinity)
                            .offset(x: -45)
                    }
                    Text("Min \(level.minimumBet)")
                        .font(.playfairdisplay(15))
                        .offset(y: -5)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(width: 400, height: 290)
    }

}

#Preview {
    NewLevelButton(tableIndex: 0, level: Level(id: 99, name: "Level 1", startingChips: 1000, requiredChips: 10000, minimumBet: 500))
}
