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
    
    @Bindable var game: Game
    @Bindable var userPreference: UserPreferences
    
    @Binding var gameController: GameController
    
    var body: some View {
        ZStack {
            Image("Camping-on-the-beach")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                if game.hasWon {
                    Text("You Won!")
                        .font(.title)
                        .fontWeight(.bold)
                }
                if isGameOver() {
                    Text("Game Over")
                        .foregroundColor(.red)
                        .font(.title)
                        .fontWeight(.bold)
                }
                HStack {
                    Text("High Score: \(userPreference.highScore)")
                        .font(.headline)
                    Divider().frame(height: 20)
                    Text("Score: \(game.score)")
                        .font(.headline)
                }
                .padding()
                .frame(minWidth: 300)
                .background(.thinMaterial)
                .cornerRadius(10)
                
                gridView
#if os(macOS)
                macOSGameControlls
#endif
            }
        }
        .onAppear {
            if game.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                gameController.addInitialTiles()
            }
        }
#if os(macOS)
        .onChange(of: game, { oldValue, newValue in
            print(newValue.name)
            if newValue.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                gameController.addInitialTiles()
            }
        })
#endif
    }
    
    // MARK: - MacOS game controlls
    private var macOSGameControlls: some View {
        HStack {
            Button(action: gameController.moveLeft) {
                Image(systemName: "arrow.left")
            }
            
            Button(action: gameController.moveRight) {
                Image(systemName: "arrow.right")
            }
            
            Button(action: gameController.moveDown) {
                Image(systemName: "arrow.down")
            }
            
            Button(action: gameController.moveUp) {
                Image(systemName: "arrow.up")
            }
        }
        .padding()
    }
    
    private var gridView: some View {
        VStack(spacing: 10) {
            ForEach(0..<game.gridSize, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<game.gridSize, id: \.self) { col in
                        let value = game.grid[row][col]
                        TileView(userPreference: userPreference, value: value, scale: 1.0)
                    }
                }
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(10)
        .gesture(
            DragGesture()
                .onEnded { value in
                    gameController.handleSwipe(translation: value.translation)
                }
        )
    }
    
    private func updateScore() {
        if game.score > userPreference.highScore {
            userPreference.highScore = game.score
        }
    }
    
    private func updateModifiedAt() {
        game.modifiedAt = .now
    }
    
    private func isGameOver() -> Bool {
        // Check if no moves are possible
        for row in 0..<game.gridSize {
            for col in 0..<game.gridSize {
                if game.grid[row][col] == 0 {
                    return false
                }
                
                // Check adjacent cells for possible merges
                let currentValue = game.grid[row][col]
                
                // Right
                if col < game.gridSize - 1 && game.grid[row][col + 1] == currentValue {
                    return false
                }
                
                // Down
                if row < game.gridSize - 1 && game.grid[row + 1][col] == currentValue {
                    return false
                }
            }
        }
        
        return true
    }
}


struct TileView: View {
    @Bindable var userPreference: UserPreferences
    let value: Int
    var scale: Double = 1.0
    
    var body: some View {
        Text(value == 0 ? "" : "\(value)")
            .frame(width: 70, height: 70)
            .background(colorForValue(value))
            .foregroundColor(.white)
            .font(.title.bold())
            .cornerRadius(10)
            .scaleEffect(value > 0 ? 1.0 : 0.8)
//            .scaleEffect(scale)
            .opacity(value > 0 ? 1 : 0.5)
    }

    private func colorForValue(_ value: Int) -> Color {
//        switch value {
//        case 2:
//            return Color(hex: userPreference.color2)
//        case 4:
//            return Color(hex: userPreference.color4)
//        case 8:
//            return Color(hex: userPreference.color8)
//        case 16:
//            return Color(hex: userPreference.color16)
//        case 32:
//            return Color(hex: userPreference.color32)
//        case 64:
//            return Color(hex: userPreference.color64)
//        case 128:
//            return Color(hex: userPreference.color128)
//        case 256:
//            return Color(hex: userPreference.color256)
//        case 512:
//            return Color(hex: userPreference.color512)
//        case 1024:
//            return Color(hex: userPreference.color1024)
//        case 2048:
//            return Color(hex: userPreference.color2048)
//            // Color(red: 1.0, green: 0.84, blue: 0.0) // RGB for gold
//        case 4096:
//            return Color(hex: userPreference.color4096)
//        case 8192:
//            return Color(hex: userPreference.color8192)
//        default:
//            return Color(hex: userPreference.color16384)
//        }
        switch value {
        case 2:
            return .yellow
        case 4:
            return Color.orange
        case 8:
            return Color.pink
        case 16:
            return Color.purple
        case 32:
            return Color.red
        case 64:
            return Color.red.opacity(0.8)
        case 128:
            return Color.blue
        case 256:
            return Color.blue.opacity(0.8)
        case 512:
            return Color.green
        case 1024:
            return Color.green.opacity(0.8)
        case 2048:
            return Color(red: 1.0, green: 0.84, blue: 0.0) // RGB for gold
        case 4096:
            return Color.indigo
        case 8192:
            return Color.purple.opacity(0.5)
        default:
            return Color.gray.opacity(0.3)
        }
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
        return GameView(game: example, userPreference: userPreferenceExample, gameController: $gameController)
            .modelContainer(container)
            .modelContainer(userPreferenceContainer)
    } catch {
        fatalError("Failed to created model container")
    }
}
