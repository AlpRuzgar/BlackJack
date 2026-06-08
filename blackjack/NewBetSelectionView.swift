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

struct NewBetSelectionView: View {
    @ObservedObject var viewModel: LevelViewModel
    @Binding var betsPlaced: Bool
    @State var errorMessage = ""
    @State private var errorVisible = false

    @State var chip1BetAmount = 0
    @State var chip5BetAmount = 0
    @State var chip25BetAmount = 0
    @State var chip100BetAmount = 0
    @State var chip500BetAmount = 0

    @State private var buttonPositions: [String: CGPoint] = [:]
    @State private var flyingChips: [ActiveFlyingChip] = []

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.3, blue: 0.2),
                    Color(red: 0.0, green: 0.5, blue: 0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                VStack {
                    Text("Place your bet")
                        .font(.playfairdisplay(30))
                        .foregroundStyle(.white)
                        .padding()

                    Text("Bet: \(viewModel.startingBet)")
                        .font(.playfairdisplay(20))
                        .foregroundStyle(.gold)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.black.opacity(0.6))
                        VStack { //DECREASE BUTTONS
                            HStack {
                                ChipButton(action: {
                                    doDecrease(chipAmount: &chip1BetAmount, value: 1)
                                }, image: Image(.chip1))
                                .capturePosition(key: "decrease_1")
                                .opacity(chip1BetAmount > 0 ? 1 : 0)
                                .allowsHitTesting(chip1BetAmount > 0)
                                chipAmountDisplay(chip1BetAmount)

                                ChipButton(action: {
                                    doDecrease(chipAmount: &chip5BetAmount, value: 5)
                                }, image: Image(.chip5))
                                .capturePosition(key: "decrease_5")
                                .opacity(chip5BetAmount > 0 ? 1 : 0)
                                .allowsHitTesting(chip5BetAmount > 0)
                                chipAmountDisplay(chip5BetAmount)
                                ChipButton(action: {
                                    doDecrease(chipAmount: &chip25BetAmount, value: 25)
                                }, image: Image(.chip25))
                                .capturePosition(key: "decrease_25")
                                .opacity(chip25BetAmount > 0 ? 1 : 0)
                                .allowsHitTesting(chip25BetAmount > 0)
                                chipAmountDisplay(chip25BetAmount)
                            }
                            HStack {
                                ChipButton(action: {
                                    doDecrease(chipAmount: &chip100BetAmount, value: 100)
                                }, image: Image(.chip100))
                                .capturePosition(key: "decrease_100")
                                .opacity(chip100BetAmount > 0 ? 1 : 0)
                                .allowsHitTesting(chip100BetAmount > 0)
                                chipAmountDisplay(chip100BetAmount)
                                ChipButton(action: {
                                    doDecrease(chipAmount: &chip500BetAmount, value: 500)
                                }, image: Image(.chip500))
                                .capturePosition(key: "decrease_500")
                                .opacity(chip500BetAmount > 0 ? 1 : 0)
                                .allowsHitTesting(chip500BetAmount > 0)
                                chipAmountDisplay(chip500BetAmount)

                            }
                        }
                        .padding()
                    }
                }
                .padding()

                VStack {
                    HStack { //INCREASE BUTTONS
                        ChipButton(action: {
                            if doIncrease(value: 1) { launchChip(value: 1, image: Image(.chip1)) { chip1BetAmount += 1 } }
                        }, image: Image(.chip1))
                        .capturePosition(key: "increase_1")
                        ChipButton(action: {
                            if doIncrease(value: 5) { launchChip(value: 5, image: Image(.chip5)) { chip5BetAmount += 1 } }
                        }, image: Image(.chip5))
                        .capturePosition(key: "increase_5")
                        ChipButton(action: {
                            if doIncrease(value: 25) { launchChip(value: 25, image: Image(.chip25)) { chip25BetAmount += 1 } }
                        }, image: Image(.chip25))
                        .capturePosition(key: "increase_25")

                    }
                    HStack {
                        ChipButton(action: {
                            if doIncrease(value: 100) { launchChip(value: 100, image: Image(.chip100)) { chip100BetAmount += 1 } }
                        }, image: Image(.chip100))
                        .capturePosition(key: "increase_100")
                        ChipButton(action: {
                            if doIncrease(value: 500) { launchChip(value: 500, image: Image(.chip500)) { chip500BetAmount += 1 } }
                        }, image: Image(.chip500))
                        .capturePosition(key: "increase_500")
                    }
                }
                .padding()
                HStack {
                    ButtonView(action: {
                        decreaseBet(by: viewModel.startingBet)
                        calculateBetinChips(bet: viewModel.level.chipsOwned)
                        increaseBet(by: viewModel.level.chipsOwned)
                    }, text: "MAX BET", backgroundColor: .red, textColor: .white)
                    ButtonView(action: {
                        viewModel.placeBet()
                        betsPlaced = true
                    }, text: "Place bet", backgroundColor: .blue, textColor: .white)
                }
                .padding()
            }
            .safeAreaPadding(.top)

            Text(errorMessage)
                .font(.playfairdisplay(16))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color(red: 0.7, green: 0.05, blue: 0.05), in: RoundedRectangle(cornerRadius: 10))
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
        .coordinateSpace(.named("betView"))
        .onPreferenceChange(ChipPositionPreferenceKey.self) { positions in
            buttonPositions = positions
        }
        .onAppear {
            viewModel.startingBet = viewModel.level.minimumBet
            calculateBetinChips(bet: viewModel.level.minimumBet)
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
        viewModel.startingBet += bet
    }
    func decreaseBet(by bet: Int) {
        viewModel.startingBet -= bet
    }
    
    @discardableResult
    func doIncrease(value: Int) -> Bool {
        guard viewModel.level.chipsOwned >= viewModel.startingBet + value else { showError("You don't have enough chips"); return false }
        increaseBet(by: value)
        return true
    }

    func doDecrease(chipAmount: inout Int, value: Int) {
        guard viewModel.startingBet - value >= viewModel.level.minimumBet else { showError("You can't bet less than \(viewModel.level.minimumBet)"); return }
        decreaseBet(by: value)
        chipAmount -= 1
    }
    
    func chipAmountDisplay(_ amount: Int) -> some View {
        Text("\(amount)")
            .font(.playfairdisplay(20))
            .foregroundStyle(.white)
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
            .frame(width: 90, height: 90)
            .shadow(radius: 20)
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
                .shadow(radius: 20)
        }
        .frame(width: 90, height: 90)
    }
}
