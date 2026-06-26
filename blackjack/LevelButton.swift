//
//  NewLevelButton.swift
//  blackjack
//
//  Created by Alp Rüzgar on 7.06.2026.
//

import SwiftUI

struct LevelButton: View {
    @ObservedObject var level: Level
    @Environment(ThemeManager.self) var themeManager
    
    var body: some View {
        NavigationLink(destination: LevelView(level: level)) {
            ZStack {
                if level.isCompleted {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.green)
                                .shadow(color: .black.opacity(0.4), radius: 3)
                                .padding(12)
                        }
                        Spacer()
                    }
                }
                
                VStack(spacing: -5) {
                    Text(level.name)
                        .font(.system(size: 35, weight: .bold))
                        .foregroundStyle(themeManager.current.colors.text)
                        .shadow(color: .black.opacity(0.5), radius: 3, x: 1, y: 1)
                        .padding(.top, 18)
                    
                    // Diamond divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(themeManager.current.colors.secondary)
                        Image(systemName: "square.fill")
                            .font(.system(size: 7))
                            .foregroundStyle(themeManager.current.colors.secondary)
                            .rotationEffect(.degrees(45))
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(themeManager.current.colors.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    
                    // Level stats
                    HStack(spacing: -20) {
                        VStack(spacing: 2) {
                            Text("START")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(themeManager.current.colors.secondary)
                                .tracking(1)
                            Text("\(level.startingChips)")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(themeManager.current.colors.text)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .frame(width: 1, height: 40)
                            .foregroundStyle(themeManager.current.colors.secondary.opacity(0.6))
                        
                        VStack(spacing: 2) {
                            Text("TARGET")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(themeManager.current.colors.secondary)
                                .tracking(1)
                            Text("\(level.requiredChips)")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(themeManager.current.colors.text)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Rectangle()
                            .frame(width: 1, height: 40)
                            .foregroundStyle(themeManager.current.colors.secondary.opacity(0.6))
                        
                        VStack(spacing: 2) {
                            Text("MIN BET")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(themeManager.current.colors.secondary)
                                .tracking(1)
                            Text("\(level.minimumBet)")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(themeManager.current.colors.text)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 8)
                    
                }.background(
                    Image("table-\(themeManager.current.id)")
                        .resizable()
                        .scaledToFill()
                )
            }
        }
        .buttonStyle(PressableButtonStyle())
        .frame(width: 360, height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(level.isCompleted ? Color.green.opacity(0.6) : themeManager.current.colors.secondary.opacity(0.25), lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    LevelButton(level: Level(id: 99, name: "Level 1", startingChips: 1000, requiredChips: 10000, minimumBet: 500))
        .environment(ThemeManager())
}
