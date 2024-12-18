//
//  GameGridView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI
import SwiftData

struct GameGridView: View {
    @Binding var gameController: GameController

    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<gameController.game.gridSize, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<gameController.game.gridSize, id: \.self) { col in
                        let value = gameController.game.grid[row][col]
                        GridTileView(value: value, color: colorForValue(value), scale: 1.0)
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .gesture(
            DragGesture()
                .onEnded { value in
                    gameController.handleSwipe(translation: value.translation)
                }
        )
    }
    
    private func colorForValue(_ value: Int) -> Color {
        switch value {
        case 2:
            return Color(hex: gameController.userPreference.color2)
        case 4:
            return Color(hex: gameController.userPreference.color4)
        case 8:
            return Color(hex: gameController.userPreference.color8)
        case 16:
            return Color(hex: gameController.userPreference.color16)
        case 32:
            return Color(hex: gameController.userPreference.color32)
        case 64:
            return Color(hex: gameController.userPreference.color64)
        case 128:
            return Color(hex: gameController.userPreference.color128)
        case 256:
            return Color(hex: gameController.userPreference.color256)
        case 512:
            return Color(hex: gameController.userPreference.color512)
        case 1024:
            return Color(hex: gameController.userPreference.color1024)
        case 2048:
            return Color(hex: gameController.userPreference.color2048)
            // Color(red: 1.0, green: 0.84, blue: 0.0) // RGB for gold
        case 4096:
            return Color(hex: gameController.userPreference.color4096)
        case 8192:
            return Color(hex: gameController.userPreference.color8192)
        default:
            return Color(hex: gameController.userPreference.color16384)
        }
//        switch value {
//        case 2:
//            return .yellow
//        case 4:
//            return Color.orange
//        case 8:
//            return Color.pink
//        case 16:
//            return Color.purple
//        case 32:
//            return Color.red
//        case 64:
//            return Color.red.opacity(0.8)
//        case 128:
//            return Color.blue
//        case 256:
//            return Color.blue.opacity(0.8)
//        case 512:
//            return Color.green
//        case 1024:
//            return Color.green.opacity(0.8)
//        case 2048:
//            return Color(red: 1.0, green: 0.84, blue: 0.0) // RGB for gold
//        case 4096:
//            return Color.indigo
//        case 8192:
//            return Color.purple.opacity(0.5)
//        default:
//            return Color.gray.opacity(0.3)
//        }
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
        return GameGridView(gameController: $gameController)
            .modelContainer(container)
            .modelContainer(userPreferenceContainer)
    } catch {
        fatalError("Failed to created model container")
    }
}
