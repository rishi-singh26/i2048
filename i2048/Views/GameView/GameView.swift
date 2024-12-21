//
//  GameVIew.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    private let gameController: GameController = GameController()
    var selectedGame: Game
    @Binding var animationValues: [[Double]]
        
    var body: some View {
        ZStack {
            GameBackgroundImageView()
            VStack {
                if selectedGame.hasWon {
                    Text("You Won!")
                        .font(.title)
                        .fontWeight(.bold)
                }
                if gameController.isGameOver(on: selectedGame) {
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
                .cornerRadius(10)
                
                GameGridView(animationValues: $animationValues, selectedGame: selectedGame)
#if os(macOS)
                macOSGameControlls
#endif
            }
        }
        .onAppear {
            initializeAnimationValues()
            if selectedGame.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                gameController.addInitialTiles(on: selectedGame, $animationValues)
            }
        }
        .onChange(of: selectedGame, { oldValue, newValue in
            initializeAnimationValues()
            if newValue.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                gameController.addInitialTiles(on: selectedGame, $animationValues)
            }
        })
    }
    
    // MARK: - MacOS game controlls
    private var macOSGameControlls: some View {
        HStack {
            KeyboardKeyButton(keyLabel: ["command", "arrow.right"]) {
                gameController.moveRight(on: selectedGame, $animationValues)
                updateScore()
            }
            KeyboardKeyButton(keyLabel: ["command", "arrow.left"]) {
                gameController.moveLeft(on: selectedGame, $animationValues)
                updateScore()
            }
            KeyboardKeyButton(keyLabel: ["command", "arrow.down"]) {
                gameController.moveDown(on: selectedGame, $animationValues)
                updateScore()
            }
            KeyboardKeyButton(keyLabel: ["command", "arrow.up"]) {
                gameController.moveUp(on: selectedGame, $animationValues)
                updateScore()
            }
        }
    }
    
    private func updateScore() {
        if selectedGame.score > userDefaultsManager.highScore {
            userDefaultsManager.highScore = selectedGame.score
        }
    }
    
    private func initializeAnimationValues() {
        animationValues = Array(repeating: Array(repeating: 1.0, count: selectedGame.gridSize), count: selectedGame.gridSize);
    }
}


#Preview {
    ContentView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
