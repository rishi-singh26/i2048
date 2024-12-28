//
//  GameController.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

import Foundation
import SwiftUI

class GameController: ObservableObject {
    static let shared = GameController();
    
    func handleSwipe(translation: CGSize, on game: Game, _ animationValues: Binding<[[Double]]>, _ userDefaults: UserDefaultsManager) {
        let horizontalDirection = abs(translation.width) > abs(translation.height)
        
        if horizontalDirection {
            if translation.width > 50 {
                moveRight(on: game, animationValues, userDefaults)
            } else if translation.width < -50 {
                moveLeft(on: game, animationValues, userDefaults)
            }
        } else {
            if translation.height > 50 {
                moveDown(on: game, animationValues, userDefaults)
            } else if translation.height < -50 {
                moveUp(on: game, animationValues, userDefaults)
            }
        }
    }
    
    func moveLeft(on game: Game, _ animationValues: Binding<[[Double]]>, _ userDefaults: UserDefaultsManager? = nil) {
//        print("🔍 moveLeft() called")
        var moved = false
        var newGrid = game.grid
        
        for row in 0..<game.gridSize {
            let rowItem = game.grid[row]
            let (newRow, rowMoved) = compressRow(on: game,row: rowItem)
            newGrid[row] = newRow
            moved = moved || rowMoved || (rowItem != newRow)
        }
        
        if moved {
            game.grid = newGrid
            addRandomTile(on: game, animationValues)
            updateModifiedAt(on: game)
            triggerFeedback(as: true, userDefaults)
        } else {
            triggerFeedback(as: false, userDefaults)
//            print("❌ No movement occurred")
        }
    }
    
    func moveRight(on game: Game, _ animationValues: Binding<[[Double]]>, _ userDefaults: UserDefaultsManager? = nil) {
//        print("🔍 moveRight() called")
        var moved = false
        var newGrid = game.grid
        
        for row in 0..<game.gridSize {
            let rowItem = game.grid[row]
            let reversedRow = rowItem.reversed()
            let (compressedRow, rowMoved) = compressRow(on: game, row: Array(reversedRow))
            let compressionResult = Array(compressedRow.reversed())
            newGrid[row] = compressionResult
            moved = moved || rowMoved || (rowItem != compressionResult)
        }
        
        if moved {
            game.grid = newGrid
            addRandomTile(on: game, animationValues)
            updateModifiedAt(on: game)
            triggerFeedback(as: true, userDefaults)
        } else {
            triggerFeedback(as: false, userDefaults)
//            print("❌ No movement occurred")
        }
    }
    
    func moveUp(on game: Game, _ animationValues: Binding<[[Double]]>, _ userDefaults: UserDefaultsManager? = nil) {
//        print("🔍 moveUp() called")
        var moved = false
        var newGrid = game.grid
        
        for col in 0..<game.gridSize {
            let column = (0..<game.gridSize).map { game.grid[$0][col] }
            let (newColumn, colMoved) = compressRow(on: game, row: column)
            
            for row in 0..<game.gridSize {
                newGrid[row][col] = newColumn[row]
            }
            moved = moved || colMoved || (column != newColumn)
        }
        
        if moved {
            game.grid = newGrid
            addRandomTile(on: game, animationValues)
            updateModifiedAt(on: game)
            triggerFeedback(as: true, userDefaults)
        } else {
            triggerFeedback(as: false, userDefaults)
//            print("❌ No movement occurred")
        }
    }
    
    func moveDown(on game: Game, _ animationValues: Binding<[[Double]]>, _ userDefaults: UserDefaultsManager? = nil) {
//        print("🔍 moveDown() called")
        
        var moved = false
        var newGrid = game.grid
        
        for col in 0..<game.gridSize {
            let column = (0..<game.gridSize).map { game.grid[$0][col] }
            let (compressedColumn, colMoved) = compressRow(on: game, row: Array(column.reversed()))
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
            addRandomTile(on: game, animationValues)
            updateModifiedAt(on: game)
            triggerFeedback(as: true, userDefaults)
        } else {
            triggerFeedback(as: false, userDefaults)
//            print("❌ No movement occurred")
        }
    }
    
    func compressRow(on game: Game, row: [Int]) -> ([Int], Bool) {
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
    
    func addRandomTile(on game: Game, _ animationValues: Binding<[[Double]]>) {
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
        animationValues.wrappedValue[row][col] = 0.5 // Add pop animation
        
        withAnimation(.spring()) {
            animationValues.wrappedValue[row][col] = 1.0
        }
    }
    
    func triggerFeedback(as success: Bool, _ userDefaults: UserDefaultsManager?) {
        if let userDefaults = userDefaults {
            if success {
                userDefaults.triggerSimpleHaptic()
            } else {
                userDefaults.triggerCustomPattern()
            }
        }
    }
    
    func updateModifiedAt(on game: Game) {
        game.modifiedAt = .now
    }
    
    func addInitialTiles(on game: Game, _ animationValues: Binding<[[Double]]>) {
        addRandomTile(on: game, animationValues)
        addRandomTile(on: game, animationValues)
        updateModifiedAt(on: game)
    }
}
