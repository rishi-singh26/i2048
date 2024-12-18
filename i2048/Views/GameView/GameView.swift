//
//  GameVIew.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var gameController: GameController
        
    var body: some View {
        ZStack {
            Image(gameController.userPreference.imageName)
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
                        Text("\(gameController.userPreference.highScore)")
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
                
                GameGridView(gameController: .constant(gameController))
#if os(macOS)
                macOSGameControlls
#endif
            }
        }
        .onAppear {
            if gameController.game.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                gameController.addInitialTiles()
            }
        }
        .onChange(of: gameController.game, { oldValue, newValue in
            if newValue.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                gameController.addInitialTiles()
            }
        })
    }
    
    // MARK: - MacOS game controlls
    private var macOSGameControlls: some View {
        HStack {
            KeyboardKeyButton(keyLabel: ["command", "arrow.right"], action: gameController.moveRight)
            KeyboardKeyButton(keyLabel: ["command", "arrow.left"], action: gameController.moveLeft)
            KeyboardKeyButton(keyLabel: ["command", "arrow.down"], action: gameController.moveDown)
            KeyboardKeyButton(keyLabel: ["command", "arrow.up"], action: gameController.moveUp)
        }
//        .padding()
//        .frame(width: 300)
//        .background(.thinMaterial)
//        .cornerRadius(10)
    }
    
    private func updateScore() {
        if gameController.game.score > gameController.userPreference.highScore {
            gameController.userPreference.highScore = gameController.game.score
        }
    }
    
    private func updateModifiedAt() {
        gameController.game.modifiedAt = .now
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Game.self, configurations: config)
        let example = Game(name: "Preview Game", gridSize: 4)
        
        let userPreferenceContainer = try ModelContainer(for: UserPreferences.self, configurations: config)
        let userPreferenceExample = UserPreferences()
        
        @State var gameController = GameController(game: example, userPreference: userPreferenceExample)
        return GameView(gameController: $gameController)
            .modelContainer(container)
            .modelContainer(userPreferenceContainer)
    } catch {
        fatalError("Failed to created model container")
    }
}
