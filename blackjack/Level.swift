//
//  Level.swift
//  blackjack
//
//  Created by Alp Rüzgar on 24.05.2026.
//

import Foundation
import Combine

class Level: Identifiable, ObservableObject {
    let id: Int
    let name: String
    let startingChips: Int
    @Published var chipsOwned: Int
    let requiredChips: Int
    let minimumBet: Int
    @Published private(set) var isCompleted: Bool

    init(id: Int, name: String, startingChips: Int, requiredChips: Int, minimumBet: Int, isUnlocked: Bool = false) {
        self.id = id
        self.name = name
        self.startingChips = startingChips
        self.chipsOwned = startingChips
        self.requiredChips = requiredChips
        self.minimumBet = minimumBet
        self.isCompleted = UserDefaults.standard.bool(forKey: Self.completionDefaultsKey(for: id))
    }

    func markCompleted() {
        isCompleted = true
        UserDefaults.standard.set(true, forKey: Self.completionDefaultsKey(for: id))
    }

    func resetCompletion() {
        isCompleted = false
        UserDefaults.standard.removeObject(forKey: Self.completionDefaultsKey(for: id))
    }

    func resetChips() {
        chipsOwned = startingChips
    }

    func reset() {
        chipsOwned = startingChips
        resetCompletion()
    }

    private static func completionDefaultsKey(for id: Int) -> String {
        "level_\(id)_completed"
    }
}
