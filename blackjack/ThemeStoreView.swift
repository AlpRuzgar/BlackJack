//
//  ThemeStore.swift
//  blackjack
//
//  Created by Alp Rüzgar on 12.06.2026.
//

import SwiftUI

struct ThemeStoreView: View {
    @Environment(User.self) var user
    @Environment(ThemeManager.self) var themeManager
    @State private var selectedTheme: Theme?
    @State private var titleVisible = false
    @State private var cardsVisible = false
    @State private var errorMessage = ""
    @State private var errorVisible = false
    @State private var isInfoShowing = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Coin display — fixed top-right
                    HStack{
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundStyle(themeManager.current.colors.secondary)
                            Text("\(user.coins)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(themeManager.current.colors.secondary)
                        }
                        
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))
                        .padding(.trailing)
                    }
                    VStack(spacing: 10) {
                        Text("Themes")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(themeManager.current.colors.text)
                            .tracking(2)
                            .shadow(color: .black.opacity(0.5), radius: 4, x: 2, y: 2)
                        
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(themeManager.current.colors.secondary.gradient)
                            Image(systemName: "square.fill")
                                .font(.system(size: 7))
                                .foregroundStyle(themeManager.current.colors.secondary.gradient)
                                .rotationEffect(.degrees(45))
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(themeManager.current.colors.secondary.gradient)
                        }
                        .padding(.horizontal, 50)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 28)
                    .opacity(titleVisible ? 1 : 0)
                    .offset(y: titleVisible ? 0 : -25)
                    .animation(.easeOut(duration: 0.5), value: titleVisible)
                    
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                        spacing: 16
                    ) {
                        ForEach(Array(themeManager.themes.enumerated()), id: \.element.id) { index, theme in
                            ThemeButton(theme: theme, textColor: .ivory, selectedTheme: $selectedTheme, showError: showError)
                                .opacity(cardsVisible ? 1 : 0)
                                .offset(y: cardsVisible ? 0 : 40)
                                .animation(.easeOut(duration: 0.45).delay(0.1 + Double(index) * 0.1), value: cardsVisible)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                    
                }
            }
            .background(themeManager.current.background)
            .toolbar {
                Button("", systemImage: "info") {
                    isInfoShowing = true
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                titleVisible = true
                cardsVisible = true
            }
            
            if isInfoShowing {
                InfoOverlay(isPresented: $isInfoShowing, title: "Theme Store") {
                    VStack(spacing: 4) {
                        ThemeInfoRow(icon: "dollarsign.circle.fill", color: themeManager.current.colors.secondary, text: "Buy locked themes with coins.")
                        ThemeInfoRow(icon: "trophy.fill", color: themeManager.current.colors.secondary, text: "Earn coins by completing levels.")
                    }
                    .foregroundStyle(themeManager.current.colors.text)
                    .font(.system(size: 16, weight: .medium))
                }
            }

            // Error toast — overlay outside ScrollView so it's always visible
            Text(errorMessage)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(themeManager.current.colors.text)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(red: 0.7, green: 0.05, blue: 0.05), in: RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.red.opacity(0.4), lineWidth: 1))
                .opacity(errorVisible ? 1 : 0)
                .animation(.easeOut(duration: 0.6), value: errorVisible)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 20)
                .allowsHitTesting(false)
        }
    }

    func showError(_ message: String) {
        errorMessage = message
        errorVisible = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            errorVisible = false
        }
    }
}

struct ThemeButton: View {
    @Environment(ThemeManager.self) var themeManager
    @Environment(User.self) var user
    
    var theme: Theme
    let textColor: Color
    @Binding var selectedTheme: Theme?
    var showError: (String) -> Void
    
    var isSelected: Bool { selectedTheme?.id == theme.id }
    var isActive: Bool { themeManager.selectedThemeId == theme.id }
    
    var borderColor: Color {
        if isActive { .green }
        else if isSelected { .blue }
        else { .black }
    }
    
    var body: some View {
        Button {
            selectedTheme = theme
        } label: {
            VStack(spacing: 0) {
                ZStack {
                    theme.background.preview
                    // Theme background preview with sample card
                    Image("AS-\(theme.id)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 85)
                        .colorMultiply(theme.cardTint ?? .white)
                        .shadow(color: .black.opacity(0.5), radius: 6, x: 2, y: 3)
                        .background(theme.background)
                }
                .frame(height: 200)
                
                // Name + status strip
                VStack(spacing: 3) {
                    Text(theme.id.uppercased())
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(themeManager.current.colors.text)
                        .tracking(1.5)
                    
                    if isActive {
                        Text("ACTIVE")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.green)
                    } else if !theme.isUnlocked {
                        Text("\(theme.price) coins")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(themeManager.current.colors.secondary)
                    } else {
                        Text("UNLOCKED")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(themeManager.current.colors.text.opacity(0.55))
                    }
                }
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(.black.opacity(0.45))
                
                // Action row — only visible when expanded
                if isSelected {
                    Group {
                        if isActive {
                            Text("Currently Active")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.green)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(.black.opacity(0.5))
                        } else if theme.isUnlocked {
                            Button {
                                themeManager.select(theme)
                            } label: {
                                Text("SELECT")
                                    .font(.system(size: 15, weight: .bold))
                                    .tracking(1.5)
                                    .foregroundStyle(themeManager.current.colors.text)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(themeManager.current.colors.secondary)
                            }
                        } else {
                            Button {
                                if user.coins >= selectedTheme!.price {
                                    print("Bought \(theme.id)")
                                    selectedTheme?.unlock()
                                    user.coins -= selectedTheme!.price
                                }
                                else {
                                    showError("Not enough coins")
                                }
                            } label: {
                                Text("BUY — \(theme.price)")
                                    .font(.system(size: 15, weight: .bold))
                                    .tracking(1.5)
                                    .foregroundStyle(themeManager.current.colors.text)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(themeManager.current.colors.primary)
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: 4)
        )
        .shadow(
            color: borderColor.opacity(isSelected || isActive ? 0.7 : 0.3),
            radius: isSelected || isActive ? 10 : 4
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

private struct ThemeInfoRow: View {
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
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

#Preview {
    NavigationStack {
        ThemeStoreView()
            .environment(ThemeManager())
            .environment(User())
    }
}
