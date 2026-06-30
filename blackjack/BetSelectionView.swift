//
//  NewBetSelectionView.swift
//  blackjack
//
//  Created by Alp Rüzgar on 7.06.2026.
//

import SwiftUI

struct ActiveFlyingChip: Identifiable {
    let id = UUID()
    let image: Image
    let from: CGPoint
    let to: CGPoint
    var onLand: () -> Void
}

struct ChipPositionPreferenceKey: PreferenceKey {
    static var defaultValue: [String: CGPoint] = [:]
    static func reduce(value: inout [String: CGPoint], nextValue: () -> [String: CGPoint]) {
        value.merge(nextValue()) { $1 }
    }
}

extension View {
    func capturePosition(key: String) -> some View {
        background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: ChipPositionPreferenceKey.self,
                    value: [key: CGPoint(
                        x: geo.frame(in: .named("betView")).midX,
                        y: geo.frame(in: .named("betView")).midY
                    )]
                )
            }
        )
    }
}

struct BetSelectionView: View {
    @ObservedObject var vm: LevelViewModel
    @Binding var betsPlaced: Bool
    @Environment(ThemeManager.self) var themeManager
    @Environment(\.dismiss) private var dismiss
    @State var errorMessage = ""
    @State private var errorVisible = false

    @State var chip1BetAmount = 0
    @State var chip5BetAmount = 0
    @State var chip25BetAmount = 0
    @State var chip100BetAmount = 0
    @State var chip500BetAmount = 0

    @State private var buttonPositions: [String: CGPoint] = [:]
    @State private var flyingChips: [ActiveFlyingChip] = []

    @State private var headerVisible = false
    @State private var chipsVisible = false
    @State private var actionsVisible = false

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                // Header — balance, title, divider, bet amount
                VStack(spacing: 6) {
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundStyle(themeManager.current.colors.secondary)
                            Text("\(vm.level.chipsOwned)")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(themeManager.current.colors.secondary)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal, 16)

                    Text("PLACE YOUR BET")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(themeManager.current.colors.text)
                        .tracking(1)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 1, y: 2)

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

                    Text("BET: \(vm.startingBet)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(themeManager.current.colors.secondary)
                        .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
                }
                .opacity(headerVisible ? 1 : 0)
                .offset(y: headerVisible ? 0 : -20)

                // Placed chips panel (decrease area)
                VStack(spacing: 0) {
                    HStack {
                        Text("YOUR BET")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(themeManager.current.colors.secondary)
                            .tracking(2)
                        Spacer()
                        Text("TAP TO REMOVE")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(themeManager.current.colors.text.opacity(0.5))
                            .tracking(1)
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 10)
                    .padding(.bottom, 6)

                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(themeManager.current.colors.secondary.opacity(0.3))
                        .padding(.horizontal, 14)

                    VStack(spacing: 4) {
                        HStack {
                            ChipButton(action: {
                                doDecrease(chipAmount: &chip1BetAmount, value: 1)
                            }, image: Image("1-\(themeManager.current.id)"))
                            .capturePosition(key: "decrease_1")
                            .opacity(chip1BetAmount > 0 ? 1 : 0)
                            .allowsHitTesting(chip1BetAmount > 0)
                            chipAmountDisplay(chip1BetAmount)

                            ChipButton(action: {
                                doDecrease(chipAmount: &chip5BetAmount, value: 5)
                            }, image: Image("5-\(themeManager.current.id)"))
                            .capturePosition(key: "decrease_5")
                            .opacity(chip5BetAmount > 0 ? 1 : 0)
                            .allowsHitTesting(chip5BetAmount > 0)
                            chipAmountDisplay(chip5BetAmount)

                            ChipButton(action: {
                                doDecrease(chipAmount: &chip25BetAmount, value: 25)
                            }, image: Image("25-\(themeManager.current.id)"))
                            .capturePosition(key: "decrease_25")
                            .opacity(chip25BetAmount > 0 ? 1 : 0)
                            .allowsHitTesting(chip25BetAmount > 0)
                            chipAmountDisplay(chip25BetAmount)
                        }
                        HStack {
                            ChipButton(action: {
                                doDecrease(chipAmount: &chip100BetAmount, value: 100)
                            }, image: Image("100-\(themeManager.current.id)"))
                            .capturePosition(key: "decrease_100")
                            .opacity(chip100BetAmount > 0 ? 1 : 0)
                            .allowsHitTesting(chip100BetAmount > 0)
                            chipAmountDisplay(chip100BetAmount)

                            ChipButton(action: {
                                doDecrease(chipAmount: &chip500BetAmount, value: 500)
                            }, image: Image("500-\(themeManager.current.id)"))
                            .capturePosition(key: "decrease_500")
                            .opacity(chip500BetAmount > 0 ? 1 : 0)
                            .allowsHitTesting(chip500BetAmount > 0)
                            chipAmountDisplay(chip500BetAmount)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .background(.black.opacity(0.55), in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(themeManager.current.colors.secondary.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal, 12)
                .opacity(chipsVisible ? 1 : 0)
                .offset(y: chipsVisible ? 0 : 20)

                // Chip tray (increase area)
                VStack(spacing: 0) {
                    HStack {
                        Text("CHIP TRAY")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(themeManager.current.colors.secondary)
                            .tracking(2)
                        Spacer()
                        Text("TAP TO ADD")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.ivory.opacity(0.5))
                            .tracking(1)
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 10)
                    .padding(.bottom, 6)

                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(themeManager.current.colors.secondary.opacity(0.3))
                        .padding(.horizontal, 14)

                    VStack(spacing: 4) {
                        HStack {
                            ChipButton(action: {
                                if doIncrease(value: 1) { launchChip(value: 1, image: Image("1-\(themeManager.current.id)")) { chip1BetAmount += 1 } }
                            }, image: Image("1-\(themeManager.current.id)"))
                            .capturePosition(key: "increase_1")
                            ChipButton(action: {
                                if doIncrease(value: 5) { launchChip(value: 5, image: Image("5-\(themeManager.current.id)")) { chip5BetAmount += 1 } }
                            }, image: Image("5-\(themeManager.current.id)"))
                            .capturePosition(key: "increase_5")
                            ChipButton(action: {
                                if doIncrease(value: 25) { launchChip(value: 25, image: Image("25-\(themeManager.current.id)")) { chip25BetAmount += 1 } }
                            }, image: Image("25-\(themeManager.current.id)"))
                            .capturePosition(key: "increase_25")
                        }
                        HStack {
                            ChipButton(action: {
                                if doIncrease(value: 100) { launchChip(value: 100, image: Image("100-\(themeManager.current.id)")) { chip100BetAmount += 1 } }
                            }, image: Image("100-\(themeManager.current.id)"))
                            .capturePosition(key: "increase_100")
                            ChipButton(action: {
                                if doIncrease(value: 500) { launchChip(value: 500, image: Image("500-\(themeManager.current.id)")) { chip500BetAmount += 1 } }
                            }, image: Image("500-\(themeManager.current.id)"))
                            .capturePosition(key: "increase_500")
                        }
                    }
                    .padding(.vertical, 8)
                }
                .background(.black.opacity(0.35), in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(themeManager.current.colors.secondary.opacity(0.15), lineWidth: 1)
                )
                .padding(.horizontal, 12)
                .opacity(chipsVisible ? 1 : 0)
                .offset(y: chipsVisible ? 0 : 20)

                // Action buttons
                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        Button {
                            decreaseBet(by: vm.startingBet)
                            calculateBetinChips(bet: vm.level.minimumBet)
                            increaseBet(by: vm.level.minimumBet)
                        } label: {
                            StartViewButton(
                                text: "MIN BET",
                                icon: "arrow.down.circle.fill",
                                backgroundColor: themeManager.current.colors.primary
                            )
                        }
                        .buttonStyle(PressableButtonStyle())
                        Button {
                            decreaseBet(by: vm.startingBet)
                            calculateBetinChips(bet: vm.level.chipsOwned)
                            increaseBet(by: vm.level.chipsOwned)
                        } label: {
                            StartViewButton(
                                text: "MAX BET",
                                icon: "arrow.up.circle.fill",
                                backgroundColor: themeManager.current.colors.alert
                            )
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                    Button {
                        vm.placeBet()
                        betsPlaced = true
                        vm.startingBet = vm.currentBet
                    } label: {
                        StartViewButton(
                            text: "PLACE BET",
                            icon: "checkmark.circle.fill",
                            backgroundColor: themeManager.current.colors.secondary
                        )
                    }
                    .buttonStyle(PressableButtonStyle())
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                .opacity(actionsVisible ? 1 : 0)
                .offset(y: actionsVisible ? 0 : 30)
            }
            .padding(5)

            // Error toast
            Text(errorMessage)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(themeManager.current.colors.text)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(red: 0.7, green: 0.05, blue: 0.05), in: RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.red.opacity(0.4), lineWidth: 1)
                )
                .opacity(errorVisible ? 1 : 0)
                .animation(.easeOut(duration: 0.6), value: errorVisible)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 20)
                .allowsHitTesting(false)

            ForEach(flyingChips) { chip in
                FlyingChipView(chip: chip) {
                    chip.onLand()
                    flyingChips.removeAll { $0.id == chip.id }
                }
            }
        }
        .background(themeManager.current.background)
        .coordinateSpace(.named("betView"))
        .onPreferenceChange(ChipPositionPreferenceKey.self) { positions in
            buttonPositions = positions
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
//            viewModel.startingBet = viewModel.level.minimumBet
            if vm.level.chipsOwned >= vm.startingBet {
                vm.startingBet = vm.startingBet
                calculateBetinChips(bet: vm.startingBet)
            }
            else {
                vm.startingBet = vm.level.minimumBet
                calculateBetinChips(bet: vm.level.minimumBet)
            }
            withAnimation(.easeOut(duration: 0.4)) {
                headerVisible = true
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.15)) {
                chipsVisible = true
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.3)) {
                actionsVisible = true
            }
        }
    }

    func launchChip(value: Int, image: Image, onLand: @escaping () -> Void) {
        guard let from = buttonPositions["increase_\(value)"],
              let to = buttonPositions["decrease_\(value)"] else { onLand(); return }
        flyingChips.append(ActiveFlyingChip(image: image, from: from, to: to, onLand: onLand))
    }

    func showError(_ message: String) {
        errorMessage = message
        errorVisible = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            errorVisible = false
        }
    }

    func increaseBet(by bet: Int) {
        vm.startingBet += bet
    }
    func decreaseBet(by bet: Int) {
        vm.startingBet -= bet
    }

    @discardableResult
    func doIncrease(value: Int) -> Bool {
        guard vm.level.chipsOwned >= vm.startingBet + value else { showError("You don't have enough chips"); return false }
        increaseBet(by: value)
        return true
    }

    func doDecrease(chipAmount: inout Int, value: Int) {
        guard vm.startingBet - value >= vm.level.minimumBet else { showError("You can't bet less than \(vm.level.minimumBet)"); return }
        decreaseBet(by: value)
        chipAmount -= 1
    }

    func chipAmountDisplay(_ amount: Int) -> some View {
        Text("\(amount)")
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(themeManager.current.colors.text)
            .frame(width: 20)
            .opacity(amount > 0 ? 1 : 0)
    }

    func calculateBetinChips(bet: Int) {
        var betLeft = bet
        chip500BetAmount = betLeft / 500
        betLeft = betLeft % 500
        chip100BetAmount = betLeft / 100
        betLeft = betLeft % 100
        chip25BetAmount = betLeft / 25
        betLeft = betLeft % 25
        chip5BetAmount = betLeft / 5
        betLeft = betLeft % 5
        chip1BetAmount = betLeft / 1
        betLeft = betLeft % 1
    }
}

struct FlyingChipView: View {
    let chip: ActiveFlyingChip
    let onComplete: () -> Void

    @State private var position: CGPoint

    init(chip: ActiveFlyingChip, onComplete: @escaping () -> Void) {
        self.chip = chip
        self.onComplete = onComplete
        self._position = State(initialValue: chip.from)
    }

    var body: some View {
        chip.image
            .resizable()
            .scaledToFit()
            .frame(width: 70, height: 70)
            .position(position)
            .allowsHitTesting(false)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.3)) {
                    position = chip.to
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onComplete()
                }
            }
    }
}

struct ChipButton: View {
    var action: () -> Void
    let image: Image?
    var body: some View {
        Button {
            action()
        } label: {
            image?
                .resizable()
                .scaledToFit()
                .shadow(color: .black.opacity(0.6), radius: 6, x: 0, y: 4)
                .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 8)
        }
        .frame(width: 70, height: 70)
    }
}

#Preview {
    BetSelectionView(
        vm: LevelViewModel(level: Level(id: 1, name: "Preview", startingChips: 1000, requiredChips: 2000, minimumBet: 10)),
        betsPlaced: .constant(false)
    )
    .environment(ThemeManager())
}
