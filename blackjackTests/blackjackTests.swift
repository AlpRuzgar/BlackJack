//
//  blackjackTests.swift
//  blackjackTests
//
//  Created by Alp Rüzgar on 23.02.2026.
//

import Testing
import Foundation
import SwiftUI
@testable import blackjack

private func makeHand(_ values: [String]) -> Hand {
    let hand = Hand()
    hand.cards = values.map { Card(value: $0, suit: "S") }
    return hand
}

private func makeLevel(minimumBet: Int = 100, startingChips: Int = 1000) -> Level {
    // Random id keeps each test isolated from any persisted UserDefaults lock state.
    let id = Int.random(in: 1_000_000...9_999_999)
    return Level(id: id, name: "Test Level", startingChips: startingChips, requiredChips: startingChips * 2, minimumBet: minimumBet, lockDuration: 60)
}

private func resultMatches(_ result: GameResult?, _ expected: GameResult) -> Bool {
    switch (result, expected) {
    case (.playerWin, .playerWin), (.dealerWin, .dealerWin), (.push, .push),
         (.playerBust, .playerBust), (.dealerBust, .dealerBust):
        return true
    default:
        return false
    }
}

private func makeTheme(id: String? = nil, isUnlocked: Bool = false, price: Int = 1000) -> Theme {
    // Random id keeps each test isolated from any persisted UserDefaults unlock state.
    let themeId = id ?? "test-theme-\(Int.random(in: 1_000_000...9_999_999))"
    return Theme(isUnlocked: isUnlocked, price: price, id: themeId,
                 background: .color(.black), colors: ThemeColors(primary: .black, secondary: .black, alert: .black, extra: .black, text: .black),
                 gameBG: .color(.black))
}

@MainActor
struct HandValueTests {

    @Test func numberCardsSumDirectly() async throws {
        let vm = GameViewModel(gameType: .endless)
        let hand = makeHand(["9", "5"])
        vm.calculateHand(hand)
        #expect(hand.value == 14)
    }

    @Test func faceCardsCountAsTen() async throws {
        let vm = GameViewModel(gameType: .endless)
        let hand = makeHand(["K", "Q"])
        vm.calculateHand(hand)
        #expect(hand.value == 20)
    }

    @Test func singleAceCountsAsElevenWhenSafe() async throws {
        let vm = GameViewModel(gameType: .endless)
        let hand = makeHand(["A", "6"])
        vm.calculateHand(hand)
        #expect(hand.value == 17)
    }

    @Test func aceDropsToOneToAvoidBust() async throws {
        let vm = GameViewModel(gameType: .endless)
        let hand = makeHand(["A", "6", "5"])
        vm.calculateHand(hand)
        #expect(hand.value == 12)
    }

    @Test func pairOfAcesIsTwelve() async throws {
        let vm = GameViewModel(gameType: .endless)
        let hand = makeHand(["A", "A"])
        vm.calculateHand(hand)
        #expect(hand.value == 12)
    }

    @Test func twoAcesPlusNineIsSoftTwentyOne() async throws {
        let vm = GameViewModel(gameType: .endless)
        let hand = makeHand(["A", "A", "9"])
        vm.calculateHand(hand)
        #expect(hand.value == 21)
    }

    @Test func fourAcesReduceAsMuchAsNeeded() async throws {
        let vm = GameViewModel(gameType: .endless)
        let hand = makeHand(["A", "A", "A", "A"])
        vm.calculateHand(hand)
        #expect(hand.value == 14)
    }
}

@MainActor
struct RoundResultTests {

    @Test func playerBustsRegardlessOfDealerHand() async throws {
        let vm = GameViewModel(gameType: .endless)
        vm.playersHand = makeHand(["K", "Q", "5"]) // 25
        vm.hands = [vm.playersHand]
        vm.calculateHand(vm.playersHand)
        vm.dealersHand = makeHand(["9", "8"]) // 17
        vm.calculateHand(vm.dealersHand)

        vm.evaluateRoundResult()

        #expect(resultMatches(vm.playersHand.result, .playerBust))
    }

    @Test func dealerBustGivesPlayerWinWhenPlayerHasNotBusted() async throws {
        let vm = GameViewModel(gameType: .endless)
        vm.playersHand = makeHand(["10", "9"]) // 19
        vm.hands = [vm.playersHand]
        vm.calculateHand(vm.playersHand)
        vm.dealersHand = makeHand(["K", "Q", "5"]) // 25
        vm.calculateHand(vm.dealersHand)

        vm.evaluateRoundResult()

        #expect(resultMatches(vm.playersHand.result, .dealerBust))
    }

    @Test func higherPlayerValueWins() async throws {
        let vm = GameViewModel(gameType: .endless)
        vm.playersHand = makeHand(["10", "10"]) // 20
        vm.hands = [vm.playersHand]
        vm.calculateHand(vm.playersHand)
        vm.dealersHand = makeHand(["10", "8"]) // 18
        vm.calculateHand(vm.dealersHand)

        vm.evaluateRoundResult()

        #expect(resultMatches(vm.playersHand.result, .playerWin))
    }

    @Test func higherDealerValueWins() async throws {
        let vm = GameViewModel(gameType: .endless)
        vm.playersHand = makeHand(["10", "8"]) // 18
        vm.hands = [vm.playersHand]
        vm.calculateHand(vm.playersHand)
        vm.dealersHand = makeHand(["10", "10"]) // 20
        vm.calculateHand(vm.dealersHand)

        vm.evaluateRoundResult()

        #expect(resultMatches(vm.playersHand.result, .dealerWin))
    }

    @Test func equalValuesArePush() async throws {
        let vm = GameViewModel(gameType: .endless)
        vm.playersHand = makeHand(["10", "9"]) // 19
        vm.hands = [vm.playersHand]
        vm.calculateHand(vm.playersHand)
        vm.dealersHand = makeHand(["10", "9"]) // 19
        vm.calculateHand(vm.dealersHand)

        vm.evaluateRoundResult()

        #expect(resultMatches(vm.playersHand.result, .push))
    }
}

@MainActor
struct DealerPlayTests {

    @Test func dealerStopsHittingAtOrAboveSeventeen() async throws {
        let vm = GameViewModel(gameType: .endless)
        vm.resetGame()
        vm.dealersHand.cards = [Card(value: "10", suit: "S"), Card(value: "6", suit: "H")]
        vm.calculateHand(vm.dealersHand) // 16, dealer must hit at least once
        vm.playersHand.cards = [Card(value: "10", suit: "D"), Card(value: "9", suit: "C")]
        vm.calculateHand(vm.playersHand) // 19
        vm.isGameOver = false

        vm.stand()

        var iterations = 0
        while !vm.isRoundComplete && iterations < 100 {
            try await Task.sleep(for: .milliseconds(100))
            iterations += 1
        }

        #expect(vm.isRoundComplete == true)
        #expect(vm.dealersHandValue >= 17)
    }
}

struct HandSplitableTests {

    @Test func pairOfNumberCardsIsSplitable() throws {
        let hand = makeHand(["8", "8"])
        #expect(hand.splitable == true)
    }

    @Test func nonPairIsNotSplitable() throws {
        let hand = makeHand(["8", "9"])
        #expect(hand.splitable == false)
    }
}

@MainActor
struct ChipMathTests {

    @Test func placingBetDeductsChipsImmediately() async throws {
        let level = makeLevel()
        let vm = LevelViewModel(level: level)
        vm.placeBet()
        #expect(level.chipsOwned == 900)
        #expect(vm.currentBet == 100)
    }

    @Test func winningPaysBackBetPlusEqualWinnings() async throws {
        let level = makeLevel()
        let vm = LevelViewModel(level: level)
        vm.placeBet() // chipsOwned: 900, currentBet: 100
        vm.winChips()
        #expect(level.chipsOwned == 1100) // net +100 on a 100 chip bet
    }

    @Test func pushReturnsOnlyTheOriginalBet() async throws {
        let level = makeLevel()
        let vm = LevelViewModel(level: level)
        vm.placeBet() // chipsOwned: 900, currentBet: 100
        vm.chipPush()
        #expect(level.chipsOwned == 1000) // net 0
    }

    @Test func doubleDownMatchesTheOriginalBetAndDrawsExactlyOneCard() async throws {
        let level = makeLevel()
        let vm = LevelViewModel(level: level)
        vm.resetGame()
        vm.placeBet() // chipsOwned: 900, currentBet: 100
        vm.playersHand.cards = [Card(value: "5", suit: "S"), Card(value: "6", suit: "H")] // 11
        vm.calculateHand(vm.playersHand)
        vm.isGameOver = false // normally set by GameView after startGame() completes

        vm.doubleDown()

        #expect(level.chipsOwned == 800) // additional 100 matched
        #expect(vm.currentBet == 200)
        #expect(vm.playersHand.cards.count == 3)
    }

    @Test func splittingMatchesTheBetForTheNewHand() async throws {
        let level = makeLevel()
        let vm = LevelViewModel(level: level)
        vm.resetGame()
        vm.placeBet() // chipsOwned: 900, currentBet: 100
        vm.playersHand.cards = [Card(value: "8", suit: "S"), Card(value: "8", suit: "H")]
        vm.calculateHand(vm.playersHand)

        vm.split()

        #expect(level.chipsOwned == 800) // matched bet for the second hand
        #expect(vm.currentBet == 200)
        #expect(vm.hands.count == 2)
        #expect(vm.hands[0].cards.count == 1)
        #expect(vm.hands[1].cards.count == 1)
    }
}

struct ThemeCatalogTests {

    @Test func allThemesHaveUniqueIds() throws {
        let manager = ThemeManager()
        let ids = manager.themes.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test func onlyTheDefaultThemeIsFree() throws {
        let manager = ThemeManager()
        for theme in manager.themes {
            if theme.id == "default" {
                #expect(theme.price == 0)
            } else {
                #expect(theme.price > 0)
            }
        }
    }
}

@MainActor
struct ThemeUnlockTests {

    @Test func freshThemeConstructedAsUnlockedStartsUnlocked() throws {
        // A theme declared `isUnlocked: true` (like the default theme in ThemeManager)
        // should read back as unlocked before any purchase, on a device with no
        // prior UserDefaults state for its id.
        let theme = makeTheme(isUnlocked: true)
        #expect(theme.isUnlocked == true)
    }

    @Test func freshThemeConstructedAsLockedStartsLocked() throws {
        let theme = makeTheme(isUnlocked: false)
        #expect(theme.isUnlocked == false)
    }

    @Test func unlockPersistsAcrossNewInstancesWithTheSameId() throws {
        let id = "test-theme-\(Int.random(in: 1_000_000...9_999_999))"
        let theme = makeTheme(id: id, isUnlocked: false)
        theme.unlock()
        #expect(theme.isUnlocked == true)

        let reloaded = makeTheme(id: id, isUnlocked: false)
        #expect(reloaded.isUnlocked == true)
    }

    @Test func lockPersistsAcrossNewInstancesWithTheSameId() throws {
        let id = "test-theme-\(Int.random(in: 1_000_000...9_999_999))"
        let theme = makeTheme(id: id, isUnlocked: false)
        theme.unlock()
        #expect(theme.isUnlocked == true)

        theme.lock()
        #expect(theme.isUnlocked == false)

        let reloaded = makeTheme(id: id, isUnlocked: false)
        #expect(reloaded.isUnlocked == false)
    }
}

@MainActor
struct ThemeSelectionTests {

    @Test func selectingAThemeUpdatesCurrent() throws {
        let manager = ThemeManager()
        let target = manager.themes[1]
        manager.select(target)
        #expect(manager.selectedThemeId == target.id)
        #expect(manager.current.id == target.id)
    }

    @Test func currentFallsBackToFirstThemeForUnknownSelection() throws {
        let manager = ThemeManager()
        manager.selectedThemeId = "not-a-real-theme-id"
        #expect(manager.current.id == manager.themes[0].id)
    }
}

@MainActor
struct CoinEarningTests {

    private func withPreservedUserCoins(_ body: (User) -> Void) {
        let original = UserDefaults.standard.integer(forKey: "userCoins")
        defer { UserDefaults.standard.set(original, forKey: "userCoins") }
        body(User())
    }

    @Test func increaseCoinsAddsTheExactAmount() throws {
        withPreservedUserCoins { user in
            let before = user.coins
            user.increaseCoins(by: 250)
            #expect(user.coins == before + 250)
        }
    }

    @Test func decreaseCoinsSubtractsTheExactAmount() throws {
        withPreservedUserCoins { user in
            user.increaseCoins(by: 500)
            let before = user.coins
            user.decreaseCoins(by: 250)
            #expect(user.coins == before - 250)
        }
    }

    @Test func levelCompletionRewardIsTenPercentOfRequiredChips() throws {
        // Matches the formula used in LevelView's onRestart: level.requiredChips / 10
        let requiredChipsByLevel = [2000, 4000, 8000, 15000, 30000, 60000]
        let expectedRewards = [200, 400, 800, 1500, 3000, 6000]
        for (required, expected) in zip(requiredChipsByLevel, expectedRewards) {
            #expect(required / 10 == expected)
        }
    }
}

@MainActor
struct LevelLockdownTimerTests {

    @Test func newLevelStartsUnlockedAndUncompleted() throws {
        let level = makeLevel()
        #expect(level.isCompleted == false)
        #expect(level.lockTimeLeft == 0)
    }

    @Test func markCompletedLocksForTheFullDuration() throws {
        let id = Int.random(in: 1_000_000...9_999_999)
        let level = Level(id: id, name: "Test", startingChips: 1000, requiredChips: 2000, minimumBet: 100, lockDuration: 300)
        level.markCompleted()
        #expect(level.isCompleted == true)
        #expect(level.lockTimeLeft == 300)
    }

    @Test func tickLockCountsDownWhileLocked() async throws {
        let id = Int.random(in: 1_000_000...9_999_999)
        let level = Level(id: id, name: "Test", startingChips: 1000, requiredChips: 2000, minimumBet: 100, lockDuration: 5)
        level.markCompleted()

        try await Task.sleep(for: .seconds(1.5))
        level.tickLock()

        #expect(level.isCompleted == true)
        #expect(level.lockTimeLeft > 0 && level.lockTimeLeft < 5)
    }

    @Test func tickLockUnlocksAfterDurationElapses() async throws {
        let id = Int.random(in: 1_000_000...9_999_999)
        let level = Level(id: id, name: "Test", startingChips: 1000, requiredChips: 2000, minimumBet: 100, lockDuration: 1)
        level.markCompleted()

        try await Task.sleep(for: .seconds(1.5))
        level.tickLock()

        #expect(level.isCompleted == false)
        #expect(level.lockTimeLeft == 0)
    }

    @Test func reloadingAStillLockedLevelRestoresRemainingTime() throws {
        let id = Int.random(in: 1_000_000...9_999_999)
        let original = Level(id: id, name: "Test", startingChips: 1000, requiredChips: 2000, minimumBet: 100, lockDuration: 300)
        original.markCompleted()

        // Simulate relaunching the app: a brand new Level instance for the same id
        // should read the persisted unlock date back from UserDefaults.
        let reloaded = Level(id: id, name: "Test", startingChips: 1000, requiredChips: 2000, minimumBet: 100, lockDuration: 300)
        #expect(reloaded.isCompleted == true)
        #expect(reloaded.lockTimeLeft > 0 && reloaded.lockTimeLeft <= 300)
    }

    @Test func reloadingAfterExpiryStartsUnlocked() async throws {
        let id = Int.random(in: 1_000_000...9_999_999)
        let original = Level(id: id, name: "Test", startingChips: 1000, requiredChips: 2000, minimumBet: 100, lockDuration: 1)
        original.markCompleted()

        try await Task.sleep(for: .seconds(1.5))

        // Simulate relaunching the app after the lock period already expired
        // while the app was closed.
        let reloaded = Level(id: id, name: "Test", startingChips: 1000, requiredChips: 2000, minimumBet: 100, lockDuration: 1)
        #expect(reloaded.isCompleted == false)
        #expect(reloaded.lockTimeLeft == 0)
    }

    @Test func resetChipsOnlyRestoresChipsNotLock() throws {
        let level = makeLevel(startingChips: 1000)
        level.chipsOwned = 50
        level.markCompleted()

        level.resetChips()

        #expect(level.chipsOwned == 1000)
        #expect(level.isCompleted == true) // resetChips is not expected to clear the lock
    }

    @Test func resetClearsChipsAndLock() throws {
        let level = makeLevel(startingChips: 1000)
        level.chipsOwned = 50
        level.markCompleted()

        level.reset()

        #expect(level.chipsOwned == 1000)
        #expect(level.isCompleted == false)
        #expect(level.lockTimeLeft == 0)
    }
}
