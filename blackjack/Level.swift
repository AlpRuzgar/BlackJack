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
    let lockDuration: Int

    @Published private(set) var isCompleted: Bool
    @Published var lockTimeLeft: Int

    private var unlockDate: Date?

    init(id: Int, name: String, startingChips: Int, requiredChips: Int, minimumBet: Int, lockDuration: Int) {
        self.id = id
        self.name = name
        self.startingChips = startingChips
        self.chipsOwned = startingChips
        self.requiredChips = requiredChips
        self.minimumBet = minimumBet
        self.lockDuration = lockDuration

        let savedTimestamp = UserDefaults.standard.double(forKey: Self.unlockDateKey(for: id))
        if savedTimestamp > 0 {
            let date = Date(timeIntervalSince1970: savedTimestamp)
            let remaining = Int(date.timeIntervalSinceNow)
            if remaining > 0 {
                self.unlockDate = date
                self.isCompleted = true
                self.lockTimeLeft = remaining
            } else {
                // Lock period already expired while app was closed
                self.unlockDate = nil
                self.isCompleted = false
                self.lockTimeLeft = 0
                UserDefaults.standard.removeObject(forKey: Self.unlockDateKey(for: id))
                UserDefaults.standard.removeObject(forKey: Self.completionDefaultsKey(for: id))
            }
        } else {
            // No unlock timestamp — either never completed, or stale data from before
            // the timestamp system was introduced. Either way, clear any leftover
            // completion flag so the level isn't permanently locked.
            self.isCompleted = false
            self.lockTimeLeft = 0
            UserDefaults.standard.removeObject(forKey: Self.completionDefaultsKey(for: id))
        }
    }

    func markCompleted() {
        let date = Date().addingTimeInterval(TimeInterval(lockDuration))
        unlockDate = date
        isCompleted = true
        lockTimeLeft = lockDuration
        UserDefaults.standard.set(date.timeIntervalSince1970, forKey: Self.unlockDateKey(for: id))
        UserDefaults.standard.set(true, forKey: Self.completionDefaultsKey(for: id))
    }

    func tickLock() {
        guard let date = unlockDate else { return }
        let remaining = Int(date.timeIntervalSinceNow)
        if remaining <= 0 {
            resetCompletion()
        } else {
            lockTimeLeft = remaining
        }
    }

    func resetCompletion() {
        isCompleted = false
        lockTimeLeft = 0
        unlockDate = nil
        UserDefaults.standard.removeObject(forKey: Self.completionDefaultsKey(for: id))
        UserDefaults.standard.removeObject(forKey: Self.unlockDateKey(for: id))
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

    private static func unlockDateKey(for id: Int) -> String {
        "level_\(id)_unlockDate"
    }
}
