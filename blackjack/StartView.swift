//
//  StartView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 24.02.2026.
//

import Foundation
import SwiftUI

struct StartView: View {
    @Environment(ThemeManager.self) var themeManager
    
    @State private var titleVisible = false
    @State private var buttonsVisible = false
    @State private var storeVisible = false
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.current.background
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Title + gold divider
                    VStack(spacing: 14) {
                        Text("Double on 17")
                            .font(.libreCaslonBold(52))
                            .foregroundStyle(themeManager.current.colors.text)
                            .tracking(1)
                            .shadow(color: .black.opacity(0.6), radius: 6, x: 2, y: 3)
                        
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
                        .padding(.horizontal, 40)
                    }
                    .opacity(titleVisible ? 1 : 0)
                    .offset(y: titleVisible ? 0 : -30)
                    .animation(.easeOut(duration: 0.6), value: titleVisible)
                    
                    Spacer()
                    
                    // Main navigation buttons
                    VStack(spacing: 16) {
                        NavigationLink(destination: LevelMenuView()) {
                            StartViewButton(
                                text: "TABLES",
                                icon: "rectangle.stack.fill",
                                backgroundColor: themeManager.current.colors.primary
                            )
                        }
                        .buttonStyle(PressableButtonStyle())
                        NavigationLink(destination: GameView(viewModel: GameViewModel(gameType: .endless))) {
                            StartViewButton(
                                text: "ENDLESS MODE",
                                icon: "infinity",
                                backgroundColor: themeManager.current.colors.alert
                            )
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                    .padding(.horizontal, 24)
                    .opacity(buttonsVisible ? 1 : 0)
                    .offset(y: buttonsVisible ? 0 : 40)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: buttonsVisible)
                    
                    Spacer()
                    
                    // Theme store link
                    NavigationLink(destination: ThemeStoreView()) {
                        HStack(spacing: 10) {
                            Image(systemName: "paintpalette.fill")
                                .font(.system(size: 17, weight: .bold))
                            Text("THEMES")
                                .font(.libreCaslonBold(16))
                                .tracking(2)
                        }
                        .foregroundStyle(themeManager.current.colors.text)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(themeManager.current.colors.secondary)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(themeManager.current.colors.secondary.opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: themeManager.current.colors.secondary.opacity(0.6), radius: 8)
                    }
                    .buttonStyle(PressableButtonStyle())
                    .opacity(storeVisible ? 1 : 0)
                    .offset(y: storeVisible ? 0 : 20)
                    .animation(.easeOut(duration: 0.4).delay(0.55), value: storeVisible)
                    .padding(.bottom, 48)
                    
                }
            }
            .onAppear {
                titleVisible = true
                buttonsVisible = true
                storeVisible = true
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showResetAlert = true
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .alert("Reset All Data", isPresented: $showResetAlert) {
                Button("Reset", role: .destructive) {
                    themeManager.reset()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will wipe all progress, chips, and unlocked themes.")
            }
        }
    }
}

struct StartViewButton: View {
    @Environment(ThemeManager.self) var themeManager
    let text: String
    let icon: String
    let backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
            Text(text)
                .font(.libreCaslonBold(20))
                .tracking(1.5)
        }
        .foregroundStyle(themeManager.current.colors.text)
        .frame(height: 62)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(backgroundColor)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: backgroundColor.opacity(0.7), radius: 8)
    }
}

#Preview {
    StartView()
        .environment(ThemeManager())
}
