//
//  LevelLostView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 21.05.2026.
//

import SwiftUI

struct LevelLostView:View {
    var body: some View {
        VStack {
            Text("Level Lost")
                .font(.headline)
            Text("You lost all your chips!")
                .font(.title)
            ButtonView(action: {
                //TODO: go back to main menu
            }, text: "Main Menu", backgroundColor: .red, textColor: .white)
        }
    }
}
