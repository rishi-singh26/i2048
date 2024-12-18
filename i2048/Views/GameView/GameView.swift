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
    @Environment(\.modelContext) var modelContext
    
    @Binding var gameController: GameController
    @Binding var animationValues: [[Double]]
        
    var body: some View {
        ZStack {
            Image(userDefaultsManager.imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                if gameController.game.hasWon {
                    Text("You Won!")
                        .font(.title)
                        .fontWeight(.bold)
                }
                if gameController.isGameOver() {
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
                        Text("\(gameController.game.score)")
                            .font(.title)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(minWidth: 300, maxWidth: 350)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                
                GameGridView(gameController: .constant(gameController), animationValues: $animationValues)
#if os(macOS)
                macOSGameControlls
#endif
            }
        }
        .onAppear {
            initializeAnimationValues()
            if gameController.game.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                gameController.addInitialTiles($animationValues)
            }
        }
        .onChange(of: gameController.game, { oldValue, newValue in
            initializeAnimationValues()
            if newValue.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                gameController.addInitialTiles($animationValues)
            }
        })
    }
    
    // MARK: - MacOS game controlls
    private var macOSGameControlls: some View {
        HStack {
            KeyboardKeyButton(keyLabel: ["command", "arrow.right"]) {
                gameController.moveRight($animationValues)
            }
            KeyboardKeyButton(keyLabel: ["command", "arrow.left"]) {
                gameController.moveLeft($animationValues)
            }
            KeyboardKeyButton(keyLabel: ["command", "arrow.down"]) {
                gameController.moveDown($animationValues)
            }
            KeyboardKeyButton(keyLabel: ["command", "arrow.up"]) {
                gameController.moveUp($animationValues)
            }
        }
    }
    
    private func updateScore() {
        if gameController.game.score > userDefaultsManager.highScore {
            userDefaultsManager.highScore = gameController.game.score
        }
    }
    
    private func updateModifiedAt() {
        gameController.game.modifiedAt = .now
    }
    
    private func initializeAnimationValues() {
        animationValues = Array(repeating: Array(repeating: 1.0, count: gameController.game.gridSize), count: gameController.game.gridSize);
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Game.self, configurations: config)
        let example = Game(name: "Preview Game", gridSize: 4)
        
        @State var gameController = GameController(game: example, userDefaultsManager: UserDefaultsManager.shared)
        @State var animationValues: [[Double]] = Array(repeating: Array(repeating: 1.0, count: 4), count: 4);
        return GameView(gameController: $gameController, animationValues: $animationValues)
            .modelContainer(container)
            .environmentObject(UserDefaultsManager.shared)
    } catch {
        fatalError("Failed to created model container")
    }
}
