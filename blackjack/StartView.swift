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
    
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = -30
    @State private var button1Opacity: Double = 0
    @State private var button1Offset: CGFloat = 40
    @State private var button2Opacity: Double = 0
    @State private var button2Offset: CGFloat = 40
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.current.background
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Text("Double on 17")
                        .font(.libreCaslonBold(50))
                        .foregroundStyle(.ivory)
                        .padding()
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)
                    
                    VStack(spacing: 20) {
                        NavigationLink(destination: LevelMenuView()) {
                            StartViewButton(text: "TABLES", textColor: .ivory, backgroundColor: themeManager.current.colors.primary)
                        }
                        .opacity(button1Opacity)
                        .offset(y: button1Offset)
                        
                        NavigationLink(destination: GameView(viewModel: GameViewModel(gameType: .endless, themeManager: themeManager))) {
                            StartViewButton(text: "ENDLESS MODE", textColor: .ivory, backgroundColor: themeManager.current.colors.alert)
                        }
                        .opacity(button2Opacity)
                        .offset(y: button2Offset)
                    }
                    .padding()
                    
                    Spacer()
                    NavigationLink(destination: ThemeStoreView()) {
                        Image(systemName: "cart")
                            .font(.system(size: 70))
                            .foregroundStyle(.white)
                            .frame(width: 110, height: 110)
                            .background(themeManager.current.colors.secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: themeManager.current.colors.primary, radius: 5)
                    }
                    
                    .padding()
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    titleOpacity = 1
                    titleOffset = 0
                }
                withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                    button1Opacity = 1
                    button1Offset = 0
                }
                withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                    button2Opacity = 1
                    button2Offset = 0
                }
            }
        }
    }
}

struct StartViewButton: View {
    let text: String
    let textColor: Color
    let backgroundColor: Color
    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .bold, design: .default))
            .tracking(1.5)
            .foregroundStyle(textColor)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(backgroundColor)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: backgroundColor, radius: 5)
    }
}

#Preview {
    StartView()
        .environment(ThemeManager())
}
