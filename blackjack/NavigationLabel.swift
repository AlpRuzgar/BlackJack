//
//  NavigationLabel.swift
//  blackjack
//
//  Created by Alp Rüzgar on 12.07.2026.
//

import SwiftUI

struct NavigationLabel: View {
    let icon: String?
    let text: String?
    let foregroundColor: Color
    let backgroundColor:Color
    var body: some View {
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
            }
            if let text {
                Text(text)
                    .font(.system(size:20, weight: .bold))
                    .tracking(1.5)
            }
        }
        .foregroundStyle(foregroundColor)
        .frame(height: 62)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(backgroundColor)
        )
        .overlay(content: {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(LinearGradient(colors: [.white.opacity(0),.white.opacity(0.25)], startPoint: .leading, endPoint: .trailing))
        })
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: backgroundColor, radius: 15)


    }
}
