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
    
    @State private var chipViewOpacity: Double = 0
    @State private var chipViewOffset: CGFloat = -20
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = -15
    @State private var actionButtonsOpacity: Double = 0
    @State private var actionButtonsOffset: CGFloat = 30
    
    var body: some View {
        ZStack {
            Color.casinogreen
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                VStack(spacing: 8) {
                    // Player's chip count display
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundStyle(.gold)
                        Text("\(viewModel.level.chipsOwned)")
                            .font(.libreCaslonBold(18))
                            .foregroundStyle(.gold)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing)
                    .opacity(chipViewOpacity)
                    .offset(y: chipViewOffset)
                    
                    Text("PLACE YOUR BET")
                        .font(.libreCaslonBold(26))
                        .foregroundStyle(.whiteish)
                        .padding(.vertical, 6)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)
                    
                    Text("BET: \(viewModel.startingBet)")
                        .font(.libreCaslon(18))
                        .foregroundStyle(.gold)
                        .shadow(color: .black, radius: 5, x: -5, y: 8)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.black.opacity(0.6))
                    VStack(spacing: 6) { //MARK: DECREASE BUTTONS
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
                        Text("TAP CHIPS HERE TO DECREASE BET")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.casinogreen)
                            .padding(2)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)

                VStack(spacing: 8) {
                    HStack { //MARK: INCREASE BUTTONS
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
                    Text("TAP CHIPS HERE TO INCREASE BET")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.whiteish)
                        .padding(2)
                }
                
                //MARK: action buttons
                VStack {
                    HStack {
                        ButtonView(action: {
                            decreaseBet(by: viewModel.startingBet)
                            calculateBetinChips(bet: viewModel.level.minimumBet)
                            increaseBet(by: viewModel.level.minimumBet)
                        }, text: "MIN BET", backgroundColor: .greenish, textColor: .whiteish)
                        .padding(4)
                        ButtonView(action: {
                            decreaseBet(by: viewModel.startingBet)
                            calculateBetinChips(bet: viewModel.level.chipsOwned)
                            increaseBet(by: viewModel.level.chipsOwned)
                        }, text: "MAX BET", backgroundColor: .crimson, textColor: .whiteish)
                        .padding(4)
                    }
                    ButtonView(action: {
                        viewModel.placeBet()
                        betsPlaced = true
                    }, text: "PLACE BET", backgroundColor: .navy, textColor: .whiteish)
                    .padding(4)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .opacity(actionButtonsOpacity)
                .offset(y: actionButtonsOffset)
            }
            
            Text(errorMessage)
                .font(.libreCaslon(16))
                .foregroundStyle(.whiteish)
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
            withAnimation(.easeOut(duration: 0.4)) {
                chipViewOpacity = 1
                chipViewOffset = 0
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.15)) {
                titleOpacity = 1
                titleOffset = 0
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.3)) {
                actionButtonsOpacity = 1
                actionButtonsOffset = 0
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
            .font(.libreCaslon(16))
            .foregroundStyle(.whiteish)
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
