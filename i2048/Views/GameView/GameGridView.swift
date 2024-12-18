//
//  GameGridView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI
import SwiftData

struct GameGridView: View {
//    @StateObject private var motionManager = MotionManager()
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @Binding var gameController: GameController
    @Binding var animationValues: [[Double]]

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                ForEach(0..<gameController.game.gridSize, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<gameController.game.gridSize, id: \.self) { col in
                            let value = gameController.game.grid[row][col]
                            GridTileView(
                                value: value,
                                color: colorForValue(value),
                                scale: animationValues.count > 0 ? animationValues[row][col] : 1.0
                            )
                        }
                    }
                }
            }
            .padding()
//            .background(LinearGradient(
//                gradient: Gradient(colors: [Color.red, Color.orange]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            ).opacity(0.3).blur(radius: 10))
//            .shadow(radius: 10)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        gameController.handleSwipe(translation: value.translation, $animationValues)
                    }
            )
        }
//        .rotation3DEffect(
//            .degrees(motionManager.x * 20), // Tilt on the x-axis
//            axis: (x: 0, y: 1, z: 0)
//        )
//        .rotation3DEffect(
//            .degrees(motionManager.y * 20), // Tilt on the y-axis
//            axis: (x: 1, y: 0, z: 0)
//        )
//        .animation(.easeOut, value: motionManager.x)
//        .animation(.easeOut, value: motionManager.y)
    }
    
    private func colorForValue(_ value: Int) -> Color {
        switch value {
        case 2:
            return Color(hex: userDefaultsManager.color2)
        case 4:
            return Color(hex: userDefaultsManager.color4)
        case 8:
            return Color(hex: userDefaultsManager.color8)
        case 16:
            return Color(hex: userDefaultsManager.color16)
        case 32:
            return Color(hex: userDefaultsManager.color32)
        case 64:
            return Color(hex: userDefaultsManager.color64)
        case 128:
            return Color(hex: userDefaultsManager.color128)
        case 256:
            return Color(hex: userDefaultsManager.color256)
        case 512:
            return Color(hex: userDefaultsManager.color512)
        case 1024:
            return Color(hex: userDefaultsManager.color1024)
        case 2048:
            return Color(hex: userDefaultsManager.color2048)
            // Color(red: 1.0, green: 0.84, blue: 0.0) // RGB for gold
        case 4096:
            return Color(hex: userDefaultsManager.color4096)
        case 8192:
            return Color(hex: userDefaultsManager.color8192)
        default:
            return Color(hex: userDefaultsManager.color16384)
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
        
        @State var gameController = GameController(game: example, userDefaultsManager: UserDefaultsManager.shared)
        @State var animationValues: [[Double]] = []
        return GameGridView(gameController: $gameController, animationValues: $animationValues)
            .modelContainer(container)
            .environmentObject(UserDefaultsManager.shared)
    } catch {
        fatalError("Failed to created model container")
    }
}
