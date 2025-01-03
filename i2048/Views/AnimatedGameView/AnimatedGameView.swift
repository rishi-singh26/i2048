//
//  GameView.swift
//  SwiftUI2048
//
//  Created by Hongyu on 6/5/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

import SwiftUI
import ConfettiSwiftUI

extension Edge {
    
    static func from(_ from: GameLogic.Direction) -> Self {
        switch from {
        case .down:
            return .top
        case .up:
            return .bottom
        case .left:
            return .trailing
        case .right:
            return .leading
        }
    }
    
}

struct AnimatedGameView : View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var gameLogic: GameLogic

    @State var ignoreGesture = false
    @State private var showOptionsPopover = false

    fileprivate struct LayoutTraits {
        let bannerOffset: CGSize
        let showsBanner: Bool
        let containerAlignment: Alignment
    }
    
    var gesture: some Gesture {
        let threshold: CGFloat = 44
        let drag = DragGesture()
            .onChanged { v in
                guard !ignoreGesture else { return }
                
                guard abs(v.translation.width) > threshold ||
                    abs(v.translation.height) > threshold else {
                    return
                }
                
                withTransaction(Transaction(animation: .spring())) {
                    self.ignoreGesture = true
                    
                    if v.translation.width > threshold {
                        // Move right
                        gameLogic.move(.right)
                    } else if v.translation.width < -threshold {
                        // Move left
                        gameLogic.move(.left)
                    } else if v.translation.height > threshold {
                        // Move down
                        gameLogic.move(.down)
                    } else if v.translation.height < -threshold {
                        // Move up
                        gameLogic.move(.up)
                    }
                }
            }
            .onEnded { _ in
                self.ignoreGesture = false
            }
        return drag
    }
    
    // MARK: - MacOS game controlls
    @ViewBuilder
    private func MacOSGameControlls() -> some View {
        HStack {
            if let game = gameLogic.selectedGame, game.canUndo {
                KeyboardKeyButton(keyLabel: ["command", "z.square"]) {
                    withTransaction(Transaction(animation: .spring())) {
                        gameLogic.undoStep()
                    }
                }
                Divider()
                    .foregroundStyle(.gray)
                    .frame(maxHeight: 20)
            }
            KeyboardKeyButton(keyLabel: ["command", "arrow.right"]) {
                withTransaction(Transaction(animation: .spring())) {
                    gameLogic.move(.right)
                }
            }
            KeyboardKeyButton(keyLabel: ["command", "arrow.left"]) {
                withTransaction(Transaction(animation: .spring())) {
                    gameLogic.move(.left)
                }
            }
            KeyboardKeyButton(keyLabel: ["command", "arrow.down"]) {
                withTransaction(Transaction(animation: .spring())) {
                    gameLogic.move(.down)
                }
            }
            KeyboardKeyButton(keyLabel: ["command", "arrow.up"]) {
                withTransaction(Transaction(animation: .spring())) {
                    gameLogic.move(.up)
                }
            }
        }
    }
    
    @ViewBuilder
    func GameViewBuilder(selectedGame: Game, proxy: GeometryProxy) -> some View {
        ZStack(alignment: .center) {
            GameBackgroundImageView(game: gameLogic.selectedGame)
            VStack {
                if selectedGame.hasWon {
                    Text("You Won!")
                        .font(.title)
                        .fontWeight(.bold)
                }
                if selectedGame.isGameOver {
                    Text("Game Over")
                        .foregroundColor(.red)
                        .font(.title)
                        .fontWeight(.bold)
                }
                HStack {
                    VStack {
                        Text("High Score")
                        Text("\(userDefaultsManager.highScore)")
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity)
                    Divider().frame(height: 60)
                    VStack {
                        Text("Score")
                        Text("\(selectedGame.score)")
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(minWidth: 300, maxWidth: 350)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .environment(\.colorScheme, selectedGame.gameColorMode ? .light : .dark)
                .cornerRadius(10)
                
                BlockGridView(
                    matrix: gameLogic.blockMatrix,
                    blockEnterEdge: .from(gameLogic.lastGestureDirection)
                )
                .gesture(gesture, including: .all)
                .confettiCannon(
                    counter: $gameLogic.confettiCounter,
                    num: 50,
                    confettiSize: 15,
                    openingAngle: Angle(degrees: 0),
                    closingAngle: Angle(degrees: 360),
                    radius: 200,
                    repetitions: 1
                )
#if os(macOS)
                MacOSGameControlls()
#endif
            }
        }
        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        .toolbar {
            ToolbarItem(placement: .automatic) {
#if os(macOS)
                Button(action: {
                    showOptionsPopover = true
                }, label: {
                    Image(systemName: "switch.2")
                })
                .popover(isPresented: $showOptionsPopover) {
                    GameViewControllsView(game: selectedGame)
                }
#elseif os(iOS)
                HStack {
                    if let game = gameLogic.selectedGame, game.canUndo {
                        KeyboardKeyButton(keyLabel: ["arrow.uturn.backward.circle"]) {
                            withTransaction(Transaction(animation: .spring())) {
                                gameLogic.undoStep()
                            }
                        }
                    }
                    KeyboardKeyButton(keyLabel: ["switch.2"]) {
                        showOptionsPopover = true
                    }
                }
                .popover(isPresented: $showOptionsPopover) {
                    GameViewControllsView(game: selectedGame)
                }
#endif
            }
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            if let selectedGame = gameLogic.selectedGame {
                GameViewBuilder(selectedGame: selectedGame, proxy: proxy)
            } else {
                GameBackgroundImageView(game: gameLogic.selectedGame)
            }
        }
    }
    
    func doNothing(val: Int) {}
}

#Preview {
    AnimatedGameView()
        .environmentObject(GameLogic())
}
