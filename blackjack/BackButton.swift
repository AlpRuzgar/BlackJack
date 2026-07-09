//
//  BackButton.swift
//  blackjack
//
//  Created by Alp Rüzgar on 6.07.2026.
//

import Foundation
import SwiftUI

// MARK: - BackButton

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ThemeManager.self) var themeManager

    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text("Back")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(themeManager.current.colors.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(themeManager.current.colors.secondary.opacity(0.45), lineWidth: 1.5)
            )
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// MARK: - InfoButton

struct InfoButton: View {
    @Environment(ThemeManager.self) var themeManager
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "info")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(themeManager.current.colors.secondary)
                .frame(width: 36, height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(themeManager.current.colors.secondary.opacity(0.45), lineWidth: 1.5)
                )
        }
        .buttonStyle(PressableButtonStyle())
    }
}
