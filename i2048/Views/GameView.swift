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
    
    @State private var animationValues: [[Double]] = []

    var body: some View {
        ZStack {
            Image("Camping-on-the-beach")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
//                Spacer()
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
                
                // MARK: - MacOS game controlls
#if os(macOS)
                HStack {
                    Button(action: moveLeft) {
                        Image(systemName: "arrow.left")
                    }
                    .keyboardShortcut(.leftArrow, modifiers: .command)
                    
                    Button(action: moveRight) {
                        Image(systemName: "arrow.right")
                    }
                    .keyboardShortcut(.rightArrow, modifiers: .command)
                    
                    Button(action: moveDown) {
                        Image(systemName: "arrow.down")
                    }
                    .keyboardShortcut(.downArrow, modifiers: .command)
                    
                    Button(action: moveUp) {
                        Image(systemName: "arrow.up")
                    }
                    .keyboardShortcut(.upArrow, modifiers: .command)
                }
                .padding()
#endif
            }
        }
        .onAppear {
            initializeAnimationValues()
            if game.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                addInitialTiles()
            }
        }
#if os(macOS)
        .onChange(of: game, { oldValue, newValue in
            print(newValue.name)
            initializeAnimationValues()
            if newValue.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                addInitialTiles()
            }
        })
#endif
    }
    
    private var gridView: some View {
        VStack(spacing: 10) {
            ForEach(0..<game.gridSize, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<game.gridSize, id: \.self) { col in
                        let value = game.grid[row][col]
                        TileView(userPreference: userPreference, value: value,
                                 scale: animationValues.isEmpty ? 1.0 : animationValues[row][col])
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
                    handleSwipe(translation: value.translation)
                }
        )
    }
    
    private func initializeAnimationValues() {
        animationValues = Array(repeating: Array(repeating: 1.0, count: game.gridSize), count: game.gridSize)
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
            moved = moved || rowMoved || (rowItem != newRow)
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
            let compressionResult = Array(compressedRow.reversed())
            newGrid[row] = compressionResult
            moved = moved || rowMoved || (rowItem != compressionResult)
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
            moved = moved || colMoved || (column != newColumn)
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
            // Update the grid
            for row in 0..<game.gridSize {
                newGrid[row][col] = finalColumn[row]
            }
            // Update moved flag
            moved = moved || colMoved || column != finalColumn
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
//            .scaleEffect(number > 0 ? 1.0 : 0.8)
            .scaleEffect(scale)
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
        return GameView(game: example, userPreference: userPreferenceExample)
            .modelContainer(container)
            .modelContainer(userPreferenceContainer)
    } catch {
        fatalError("Failed to created model container")
    }
}
