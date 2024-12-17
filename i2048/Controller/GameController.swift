//
//  GameController.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

import Foundation
import SwiftUI

class GameController {
    @Bindable var game: Game
    @Bindable var userPreference: UserPreferences
    var animationValues: [[Double]]
    
    init(game: Game, userPreference: UserPreferences) {
        self.game = game
        self.userPreference = userPreference
        self.animationValues = Array(repeating: Array(repeating: 1.0, count: game.gridSize), count: game.gridSize)
    }
    
    func handleSwipe(translation: CGSize) {
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
    
    func moveLeft() {
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
    
    func moveRight() {
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
    
    func moveUp() {
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
    
    func moveDown() {
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
    
    func compressRow(row: [Int]) -> ([Int], Bool) {
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
    
    func addRandomTile() {
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
    
    func updateScore() {
        if game.score > userPreference.highScore {
            userPreference.highScore = game.score
        }
    }
    
    func updateModifiedAt() {
        game.modifiedAt = .now
    }
    
    func addInitialTiles() {
        addRandomTile()
        addRandomTile()
        updateModifiedAt()
    }
    
    func isGameOver() -> Bool {
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
