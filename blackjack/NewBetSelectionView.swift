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
    var betsPlaced: Bool = false
    @State var errorMessage = ""

    @State var chip1BetAmount = 0
    @State var chip5BetAmount = 0
    @State var chip25BetAmount = 0
    @State var chip100BetAmount = 0
    @State var chip500BetAmount = 0

    @State private var buttonPositions: [String: CGPoint] = [:]
    @State private var flyingChips: [ActiveFlyingChip] = []

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.black.opacity(0.6))
                    VStack {
                        HStack {
                            ChipButton(action: {
                                decreaseBet(by: 1)
                                chip1BetAmount -= 1
                            }, image: chip1BetAmount == 0 ? nil : Image(.chip1))
                            .capturePosition(key: "decrease_1")
                            ChipButton(action: {
                                decreaseBet(by: 5)
                                chip5BetAmount -= 1
                            }, image: chip5BetAmount == 0 ? nil : Image(.chip5))
                            .capturePosition(key: "decrease_5")
                        }
                        HStack {
                            ChipButton(action: {
                                decreaseBet(by: 25)
                                chip25BetAmount -= 1
                            }, image: chip25BetAmount == 0 ? nil : Image(.chip25))
                            .capturePosition(key: "decrease_25")
                            ChipButton(action: {
                                decreaseBet(by: 100)
                                chip100BetAmount -= 1
                            }, image: chip100BetAmount == 0 ? nil : Image(.chip100))
                            .capturePosition(key: "decrease_100")
                        }
                        HStack {
                            ChipButton(action: {
                                decreaseBet(by: 500)
                                chip500BetAmount -= 1
                            }, image: chip500BetAmount == 0 ? nil : Image(.chip500))
                            .capturePosition(key: "decrease_500")
                        }
                    }
                }
                .padding()
                VStack {
                    HStack {
                        ChipButton(action: {
                            launchChip(value: 1, image: Image(.chip1))
                            increaseBet(by: 1)
                            chip1BetAmount += 1
                        }, image: Image(.chip1))
                        .capturePosition(key: "increase_1")
                        ChipButton(action: {
                            launchChip(value: 5, image: Image(.chip5))
                            increaseBet(by: 5)
                            chip5BetAmount += 1
                        }, image: Image(.chip5))
                        .capturePosition(key: "increase_5")
                    }
                    HStack {
                        ChipButton(action: {
                            launchChip(value: 25, image: Image(.chip25))
                            increaseBet(by: 25)
                            chip25BetAmount += 1
                        }, image: Image(.chip25))
                        .capturePosition(key: "increase_25")
                        ChipButton(action: {
                            launchChip(value: 100, image: Image(.chip100))
                            increaseBet(by: 100)
                            chip100BetAmount += 1
                        }, image: Image(.chip100))
                        .capturePosition(key: "increase_100")
                    }
                    HStack {
                        ChipButton(action: {
                            launchChip(value: 500, image: Image(.chip500))
                            increaseBet(by: 500)
                            chip500BetAmount += 1
                        }, image: Image(.chip500))
                        .capturePosition(key: "increase_500")
                    }
                }
                .padding()
                HStack {
                    ButtonView(action: {
                        //MAX BET
                    }, text: "MAX BET", backgroundColor: .red, textColor: .white)
                    ButtonView(action: {
                        //Place bet
                    }, text: "Place bet", backgroundColor: .blue, textColor: .white)
                }
                .padding()
            }

            ForEach(flyingChips) { chip in
                FlyingChipView(chip: chip) {
                    flyingChips.removeAll { $0.id == chip.id }
                }
            }
        }
        .coordinateSpace(.named("betView"))
        .onPreferenceChange(ChipPositionPreferenceKey.self) { positions in
            buttonPositions = positions
        }
    }

    func launchChip(value: Int, image: Image) {
        guard let from = buttonPositions["increase_\(value)"],
              let to = buttonPositions["decrease_\(value)"] else { return }
        flyingChips.append(ActiveFlyingChip(image: image, from: from, to: to))
    }

    func increaseBet(by bet: Int) {
        guard viewModel.level.chipsOwned <= viewModel.startingBet else { errorMessage = "You don't have enough chips"; return }
        viewModel.startingBet += bet
    }
    func decreaseBet(by bet: Int) {
        guard viewModel.startingBet <= viewModel.level.minimumBet else { errorMessage = "You can't bet less than \(viewModel.level.minimumBet)"; return }
        viewModel.startingBet -= bet
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
                withAnimation(.easeInOut(duration: 0.45)) {
                    position = chip.to
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
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

#Preview {
    NewBetSelectionView(viewModel: LevelViewModel(level: Level(id: 1, name: "easy", startingChips: 1000, requiredChips: 1000, minimumBet: 20)))
}
