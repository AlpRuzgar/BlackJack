//
//  GameOverOverlay.swift
//  blackjack
//
//  Created by Alp Rüzgar on 21.05.2026.
//

import SwiftUI

struct LevelOutcomeOverlay: View {
    @Environment(\.dismiss) var dismiss
    let isWon: Bool
    var primaryColor: Color {
        if isWon{
            Color.green
        }
        else {
            Color.red
        }
    }
    var title: String {
        if isWon{
            "You passed the level!"
        }
        else {
            "You are out of chips!"
        }
    }
    
    var body: some View {
        //TODO: update the ui
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.5))
                .shadow(radius: 10)
            VStack {
                Text(title)
                    .font(.title)
                    .foregroundColor(primaryColor)
                Button ("main menu") {
                    dismiss()
                    //TODO: Dissmiss to menu view
                }
            }
        }
    }
}

#Preview {
    LevelOutcomeOverlay(isWon: true)
}
