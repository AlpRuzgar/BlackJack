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
    @State private var navigateToLevels = false
    @State private var navigateToEndless = false
    @State private var navigateToThemes = false
    
    @State private var isInfoPresented  = false

    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.current.background
                VStack(spacing: 0) {
                    HStack{
                        Spacer()
                        InfoButton {
                            isInfoPresented = true
                        }
                        .padding()
                    }

                    Spacer()

                    // Title + gold divider
                    VStack(spacing: 14) {
                        Text("Double on 17")
                            .font(.system(size: 52, weight: .bold))
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
                        ActionButton(
                            text: "TABLES",
                            icon: "rectangle.stack.fill",
                            backgroundColor: themeManager.current.colors.primary,
                            foregroundColor: themeManager.current.colors.text,
                            action: { navigateToLevels = true },
                            doesPlaySound: true
                        )
                        ActionButton(
                            text: "ENDLESS MODE",
                            icon: "infinity",
                            backgroundColor: themeManager.current.colors.alert,
                            foregroundColor: themeManager.current.colors.text,
                            action: { navigateToEndless = true },
                            doesPlaySound: true
                        )
                    }
                    .padding(.horizontal, 24)
                    .opacity(buttonsVisible ? 1 : 0)
                    .offset(y: buttonsVisible ? 0 : 40)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: buttonsVisible)

                    Spacer()

                    // Theme store link
                    ActionButton(
                        text: "THEMES",
                        icon: "paintpalette.fill",
                        backgroundColor: themeManager.current.colors.secondary,
                        foregroundColor: themeManager.current.colors.text,
                        action: { navigateToThemes = true },
                        doesPlaySound: true
                    )
                    .padding(.horizontal, 24)
                    .opacity(storeVisible ? 1 : 0)
                    .offset(y: storeVisible ? 0 : 20)
                    .animation(.easeOut(duration: 0.4).delay(0.55), value: storeVisible)
                    .padding(.bottom, 48)
                }
                if isInfoPresented {
                    InfoOverlay(isPresented: $isInfoPresented, title: "How to Play") {
                        VStack(spacing: 2) {
                            StartInfoRow(icon: "target", color: themeManager.current.colors.primary,
                                         text: "Get closer to 21 than the dealer without going over.")
                            StartInfoRow(icon: "a.square.fill", color: themeManager.current.colors.secondary,
                                         text: "Aces count as 1 or 11. Face cards (J, Q, K) are worth 10.")
                            StartInfoRow(icon: "xmark.circle.fill", color: themeManager.current.colors.alert,
                                         text: "Go over 21 and you bust. If the dealer busts, you win.")
                            StartInfoRow(icon: "person.fill", color: themeManager.current.colors.extra,
                                         text: "Dealer draws until reaching 17, then must stand.")
                            StartInfoRow(icon: "equal.circle.fill", color: themeManager.current.colors.text.opacity(0.6),
                                         text: "Equal scores are a push — your bet is returned.")
                        }
                        .foregroundStyle(themeManager.current.colors.text)
                        .font(.system(size: 15, weight: .medium))
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToLevels) {
                LevelMenuView()
            }
            .navigationDestination(isPresented: $navigateToEndless) {
                GameView(viewModel: GameViewModel(gameType: .endless), isBackButtonHidden: false)
            }
            .navigationDestination(isPresented: $navigateToThemes) {
                ThemeStoreView()
            }
            .onAppear {
                titleVisible = true
                buttonsVisible = true
                storeVisible = true
            }
            .toolbar {
                #if DEBUG
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showResetAlert = true
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.red)
                    }
                }
                #endif
            }
            #if DEBUG
            .alert("Reset All Data", isPresented: $showResetAlert) {
                Button("Reset", role: .destructive) {
                    themeManager.reset()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will wipe all progress, chips, and unlocked themes.")
            }
            #endif
        }
    }
}

private struct StartInfoRow: View {
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(color)
                .frame(width: 28)
            Text(text)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 4)
    }
}

#Preview {
    StartView()
        .environment(ThemeManager())
}
