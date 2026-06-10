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
    @ObservedObject var level: Level
    var body: some View {
        NavigationLink(destination: LevelView(level: level)) {
            ZStack {
                tableImages[tableIndex]
                    .resizable()
                
                VStack {
                    Text(level.name)
                        .font(.libreCaslonBold(25))
                        .foregroundStyle(.whiteish)
                        .offset(y: 15)
                    
                    //Diamond divider
                    HStack {
                        Rectangle()
                            .frame(width: 100, height: 1)
                            .foregroundStyle(.gold.gradient)
                        Image(systemName: "square.fill")
                            .foregroundStyle(.gold.gradient)
                            .rotationEffect(Angle(degrees: 45))
                        Rectangle()
                            .frame(width: 100, height: 1)
                            .foregroundStyle(.gold.gradient)
                    }
                    //level info
                    HStack(spacing: 0) {
                        Text("Start \(level.startingChips)")
                            .font(.libreCaslon(15))
                            .foregroundStyle(.whiteish)
                            .padding(5)
                            .frame(maxWidth: .infinity)
                            .offset(x: 20)
                        Rectangle()
                            .frame(width: 1, height: 50)
                            .foregroundStyle(.gold.gradient)
                            .offset(x: -0.3)
                        Text("Target \(level.requiredChips)")
                            .font(.libreCaslon(15))
                            .foregroundStyle(.whiteish)
                            .padding(5)
                            .frame(maxWidth: .infinity)
                            .offset(x: -10)
                    }
                    Text("Min \(level.minimumBet)")
                        .font(.libreCaslon(15))
                        .offset(y: -5)
                        .foregroundStyle(.whiteish)
                }
                
                if level.isCompleted {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.green)
                                .padding(12)
                        }
                        Spacer()
                    }
                }
            }
        }
        .frame(width: 300, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

}

#Preview {
    NewLevelButton(tableIndex: 0, level: Level(id: 99, name: "Level 1", startingChips: 1000, requiredChips: 10000, minimumBet: 500))
}
