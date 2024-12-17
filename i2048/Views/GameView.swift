//
//  GameVIew.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @Bindable var game: Game
    @Binding var selectedGame: Game?
    @State private var animationValues: [[Double]] = []
    @Environment(\.modelContext) var modelContext
    
//    @FocusState private var isGameViewFocused: Bool // Focus state to capture keyboard input

    var body: some View {
        VStack {
            Text("Score: \(game.score)")
                .font(.title)
            
            gridView
            
            HStack {
                Button("Reset") {
                    resetGame()
                }
                .buttonStyle(.bordered)
                
                if game.hasWon {
                    Text("You Won!")
                        .foregroundColor(.green)
                }
                
                if isGameOver() {
                    Text("Game Over")
                        .foregroundColor(.red)
                }
            }
            .padding()
            
#if os(macOS)
            HStack {
                Button(action: moveLeft) {
                    Image(systemName: "arrow.left")
                }
                .buttonStyle(.bordered)
//                .keyboardShortcut(.leftArrow)
                
                Button(action: moveRight) {
                    Image(systemName: "arrow.right")
                }
                .buttonStyle(.bordered)
//                .keyboardShortcut(.rightArrow)
                
                Button(action: moveDown) {
                    Image(systemName: "arrow.down")
                }
                .buttonStyle(.bordered)
//                .keyboardShortcut(.downArrow)
                
                Button(action: moveUp) {
                    Image(systemName: "arrow.up")
                }
                .buttonStyle(.bordered)
//                .keyboardShortcut(.upArrow)
                
//                game.hasWon
            }
            .padding()
#endif
        }
        .onAppear {
            initializeAnimationValues()
            if game.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                addInitialTiles()
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    handleSwipe(translation: value.translation)
                }
        )
        .onKeyPress(action: { KeyPress in
            switch KeyPress.key {
            case KeyEquivalent("s"):
                moveDown()
                return .handled
            case KeyEquivalent("w"):
                moveUp()
                return .handled
            case KeyEquivalent("d"):
                moveRight()
                return .handled
            case KeyEquivalent("a"):
                moveLeft()
                return .handled
            default:
                return .ignored
            }
        })
//        .focusable(true)
//        .focused($isGameViewFocused) // Connect the focus state
//        .onAppear {
//            isGameViewFocused = true // Focus the game view on load
//        }
//        .onDisappear {
//            isGameViewFocused = false // Remove focus when view disappears
//        }
    }
    
    private var gridView: some View {
        VStack(spacing: 10) {
            ForEach(0..<game.gridSize, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<game.gridSize, id: \.self) { col in
                        let value = game.grid[row][col]
                        TileView(value: value,
                                 scale: animationValues.isEmpty ? 1.0 : animationValues[row][col])
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    private func initializeAnimationValues() {
        animationValues = Array(repeating:
            Array(repeating: 1.0, count: game.gridSize),
            count: game.gridSize)
    }
    
    private func addInitialTiles() {
        addRandomTile()
        addRandomTile()
        updateModifiedAt()
    }
    
    private func addRandomTile() {
        var emptyCells = [(Int, Int)]()
        for row in 0..<game.gridSize {
            for col in 0..<game.gridSize {
                if game.grid[row][col] == 0 {
                    emptyCells.append((row, col))
                }
            }
        }
        
        guard !emptyCells.isEmpty else { return }
        
        let (row, col) = emptyCells.randomElement()!
        let initialValue = Bool.random() ? 2 : 4
        
        game.grid[row][col] = initialValue
        animationValues[row][col] = 0.5 // Add pop animation
        
        withAnimation(.spring()) {
            animationValues[row][col] = 1.0
        }
    }
    
    private func handleSwipe(translation: CGSize) {
        let horizontalDirection = abs(translation.width) > abs(translation.height)
        
        if horizontalDirection {
            if translation.width > 50 {
                moveRight()
            } else if translation.width < -50 {
                moveLeft()
            }
        } else {
            if translation.height > 50 {
                moveDown()
            } else if translation.height < -50 {
                moveUp()
            }
        }
    }
    
    private func moveLeft() {
        print("🔍 moveLeft() called")
        var moved = false
        var newGrid = game.grid
        
        for row in 0..<game.gridSize {
            let rowItem = game.grid[row]
            let (newRow, rowMoved) = compressRow(row: rowItem)
            newGrid[row] = newRow
            moved = moved || (rowItem != newRow)
        }
        
        if moved {
            game.grid = newGrid
            addRandomTile()
            updateScore()
            updateModifiedAt()
        } else {
            print("❌ No movement occurred")
        }
    }
    
    private func moveRight() {
        print("🔍 moveRight() called")
        var moved = false
        var newGrid = game.grid
        
        for row in 0..<game.gridSize {
            let rowItem = game.grid[row]
            let reversedRow = rowItem.reversed()
            let (compressedRow, rowMoved) = compressRow(row: Array(reversedRow))
            newGrid[row] = Array(compressedRow.reversed())
            moved = moved || (rowItem != compressedRow)
        }
        
        if moved {
            game.grid = newGrid
            addRandomTile()
            updateScore()
            updateModifiedAt()
        } else {
            print("❌ No movement occurred")
        }
    }
    
    private func moveUp() {
        print("🔍 moveUp() called")
        var moved = false
        var newGrid = game.grid
        
        for col in 0..<game.gridSize {
            let column = (0..<game.gridSize).map { game.grid[$0][col] }
            let (newColumn, colMoved) = compressRow(row: column)
            
            for row in 0..<game.gridSize {
                newGrid[row][col] = newColumn[row]
            }
            moved = moved || (column != newColumn)
        }
        
        if moved {
            game.grid = newGrid
            addRandomTile()
            updateScore()
            updateModifiedAt()
        } else {
            print("❌ No movement occurred")
        }
    }
    
    private func moveDown() {
        print("🔍 moveDown() called")
        
        var moved = false
        var newGrid = game.grid
        
        for col in 0..<game.gridSize {
            let column = (0..<game.gridSize).map { game.grid[$0][col] }
            let (compressedColumn, colMoved) = compressRow(row: Array(column.reversed()))
            let finalColumn = Array(compressedColumn.reversed())
            let columnChanged = column != finalColumn
            // Update the grid
            for row in 0..<game.gridSize {
                newGrid[row][col] = finalColumn[row]
            }
            // Update moved flag
            moved = moved || colMoved || columnChanged
        }
        
        if moved {
            game.grid = newGrid
            addRandomTile()
            updateScore()
            updateModifiedAt()
        } else {
            print("❌ No movement occurred")
        }
    }
    
    private func compressRow(row: [Int]) -> ([Int], Bool) {
        // Remove zeros
        var newRow = row.filter { $0 != 0 }
        var moved = newRow.count != row.filter { $0 != 0 }.count
        
        var i = 0
        while i < newRow.count - 1 {
            // Check if adjacent elements are the same
            if newRow[i] == newRow[i + 1] {
                newRow[i] *= 2
                game.score += newRow[i]
                newRow.remove(at: i + 1)
                moved = true
                
                // Check for win condition
                if newRow[i] == 2048 {
                    game.hasWon = true
                }
            }
            i += 1
        }
        
        // Pad with zeros to maintain grid size
        while newRow.count < game.gridSize {
            newRow.append(0)
        }
        
        return (newRow, moved)
    }
    
    private func updateScore() {
        // Additional score tracking logic if needed
    }
    
    private func updateModifiedAt() {
        game.modifiedAt = .now
    }
    
    private func resetGame() {
        game.grid = Array(repeating: Array(repeating: 0, count: game.gridSize), count: game.gridSize)
        game.score = 0
        game.hasWon = false
        addInitialTiles()
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
    let value: Int
    var scale: Double = 1.0
    
    var body: some View {
        Text(value == 0 ? "" : "\(value)")
            .frame(width: 70, height: 70)
            .background(colorForValue(value))
            .foregroundColor(.white)
            .font(.title.bold())
            .cornerRadius(10)
//            .scaleEffect(number > 0 ? 1.0 : 0.8)
            .scaleEffect(scale)
            .opacity(value > 0 ? 1 : 0.5)
    }

    private func colorForValue(_ value: Int) -> Color {
        switch value {
        case 2:
            return Color.yellow
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
            return Color.gold
        case 4096:
            return Color.indigo
        case 8192:
            return Color.purple.opacity(0.5)
        default:
            return Color.gray.opacity(0.3)
        }
    }
}

//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Game.self, configurations: config)
//        let example = Game(name: "Preview Game", gridSize: 4)
//        return GameView(game: example)
//            .modelContainer(container)
//    } catch {
//        fatalError("Failed to created model container")
//    }
//}
