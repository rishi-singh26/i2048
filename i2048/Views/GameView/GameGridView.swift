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
    @Binding var animationValues: [[Double]]
    private let gameController = GameController()
    var selectedGame: Game

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                ForEach(0..<selectedGame.gridSize, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<selectedGame.gridSize, id: \.self) { col in
                            let value = selectedGame.grid[row][col]
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
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .environment(\.colorScheme, selectedGame.gameColorMode ? .light : .dark)
            .cornerRadius(10)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        gameController.handleSwipe(translation: value.translation, on: selectedGame, $animationValues)
                        if selectedGame.score > userDefaultsManager.highScore {
                            userDefaultsManager.highScore = selectedGame.score
                        }
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
            return Color(hex: selectedGame.color2)
        case 4:
            return Color(hex: selectedGame.color4)
        case 8:
            return Color(hex: selectedGame.color8)
        case 16:
            return Color(hex: selectedGame.color16)
        case 32:
            return Color(hex: selectedGame.color32)
        case 64:
            return Color(hex: selectedGame.color64)
        case 128:
            return Color(hex: selectedGame.color128)
        case 256:
            return Color(hex: selectedGame.color256)
        case 512:
            return Color(hex: selectedGame.color512)
        case 1024:
            return Color(hex: selectedGame.color1024)
        case 2048:
            return Color(hex: selectedGame.color2048)
            // Color(red: 1.0, green: 0.84, blue: 0.0) // RGB for gold
        case 4096:
            return Color(hex: selectedGame.color4096)
        case 8192:
            return Color(hex: selectedGame.color8192)
        default:
            return Color(hex: selectedGame.color16384)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
