//
//  betSelectorView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 25.02.2026.
//

import Foundation
import SwiftUI

struct betSelectorView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var betsPlaced: Bool

    var body: some View {
        if viewModel.isGameOver {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.0, green: 0.3, blue: 0.2),
                        Color(red: 0.0, green: 0.5, blue: 0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Text("CHIPS")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .tracking(2)

                        HStack(spacing: 10) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.system(size: 26))
                                .foregroundColor(.yellow)
                            Text("\(viewModel.chipsOwned)")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color.black.opacity(0.3)))
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.top, 40)

                    Spacer()

                    VStack(spacing: 16) {
                        Text("PLACE YOUR BET")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .tracking(3)

                        ZStack {
                            Capsule()
                                .fill(Color.black.opacity(0.3))
                                .frame(width: 200, height: 80)

                            Text("\(viewModel.currentBet)")
                                .font(.system(size: 48, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }

                    HStack(spacing: 15) {
                        ButtonView(action: {
                            if viewModel.currentBet > viewModel.minimumBet {
                                viewModel.currentBet -= 5
                            }
                        }, text: "−", backgroundColor: Color(red: 0.9, green: 0.2, blue: 0.2), textColor: .white)

                        ButtonView(action: {
                            if viewModel.currentBet < viewModel.chipsOwned {
                                viewModel.currentBet += 5
                            }
                        }, text: "+", backgroundColor: Color(red: 0.2, green: 0.6, blue: 0.3), textColor: .white)
                    }
                    .padding(.horizontal, 30)

                    Spacer()

                    ButtonView(action: {
                        betsPlaced = true
                        viewModel.chipsOwned -= viewModel.currentBet
                    }, text: "PLACE BET", backgroundColor: Color(red: 0.2, green: 0.4, blue: 0.8), textColor: .white)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}
