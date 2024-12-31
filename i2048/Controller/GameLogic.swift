//
//  GameLogic.swift
//  SwiftUI2048
//
//  Created by Hongyu on 6/5/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class GameLogic : ObservableObject {
    
    enum Direction {
        case left
        case right
        case up
        case down
    }
    
    typealias BlockMatrixType = BlockMatrix<IdentifiedBlock>
    
    let objectWillChange = PassthroughSubject<GameLogic, Never>()
    
    fileprivate var _blockMatrix: BlockMatrixType!
    var blockMatrix: BlockMatrixType {
        return _blockMatrix
    }
    private(set) var selectedGame: Game?
    private(set) var gridSize: Int = 4
    
    @Published fileprivate(set) var lastGestureDirection: Direction = .up
    
    fileprivate var _globalID = 0
    fileprivate var newGlobalID: Int {
        _globalID += 1
        return _globalID
    }
    
    init() {
        newGame()
    }
    
    func newGame() {
        _blockMatrix = BlockMatrixType()
        resetLastGestureDirection()
        generateNewBlocks()
        
        objectWillChange.send(self)
    }
    
    func updateSelectedGame(selectedGame: Game) {
        self.selectedGame = selectedGame
        self.gridSize = selectedGame.gridSize
        _blockMatrix = BlockMatrixType(grid: transformToIdentifiedBlocks(matrix: selectedGame.grid))
        resetLastGestureDirection()
        
        if selectedGame.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
            generateNewBlocks()
        }
        
        DispatchQueue.main.async {
            self.objectWillChange.send(self)
        }
    }
        
    private func transformToIdentifiedBlocks(matrix: [[Int]]) -> [[IdentifiedBlock?]] {
        var idCounter = 0
        
        return matrix.map { row in
            row.map { number in
                defer { idCounter += 1 }
                if number == 0 {
                    return nil
                }
                return IdentifiedBlock(id: idCounter, number: number)
            }
        }
    }

    private func updateGame() {
        selectedGame?.grid = self.blockMatrix.toIntMatrix()
    }

    
    func resetLastGestureDirection() {
        lastGestureDirection = .up
    }
    
    func move(_ direction: Direction) {
        defer {
            objectWillChange.send(self)
        }
        
        lastGestureDirection = direction
        
        var moved = false
        
        let axis = direction == .left || direction == .right
        for row in 0..<gridSize {
            var rowSnapshot = [IdentifiedBlock?]()
            var compactRow = [IdentifiedBlock]()
            for col in 0..<gridSize {
                // Transpose if necessary.
                if let block = _blockMatrix[axis ? (col, row) : (row, col)] {
                    rowSnapshot.append(block)
                    compactRow.append(block)
                }
                rowSnapshot.append(nil)
            }
            
            merge(blocks: &compactRow, reverse: direction == .down || direction == .right)
            
            var newRow = [IdentifiedBlock?]()
            compactRow.forEach { newRow.append($0) }
            if compactRow.count < gridSize {
                for _ in 0..<(gridSize - compactRow.count) {
                    if direction == .left || direction == .up {
                        newRow.append(nil)
                    } else {
                        newRow.insert(nil, at: 0)
                    }
                }
            }
            
            newRow.enumerated().forEach {
                if rowSnapshot[$0]?.number != $1?.number {
                    moved = true
                }
                _blockMatrix.place($1, to: axis ? ($0, row) : (row, $0))
            }
        }
        
        updateGame()
        
        if moved {
            generateNewBlocks()
        }
    }
    
    fileprivate func merge(blocks: inout [IdentifiedBlock], reverse: Bool) {
        if reverse {
            blocks = blocks.reversed()
        }
        
        blocks = blocks
            .map { (false, $0) }
            .reduce([(Bool, IdentifiedBlock)]()) { acc, item in
                if acc.last?.0 == false && acc.last?.1.number == item.1.number {
                    var accPrefix = Array(acc.dropLast())
                    var mergedBlock = item.1
                    mergedBlock.number *= 2
                    accPrefix.append((true, mergedBlock))
                    return accPrefix
                } else {
                    var accTmp = acc
                    accTmp.append((false, item.1))
                    return accTmp
                }
            }
            .map { $0.1 }
        
        if reverse {
            blocks = blocks.reversed()
        }
    }
    
    @discardableResult fileprivate func generateNewBlocks() -> Bool {
        var blankLocations = [BlockMatrixType.Index]()
        for rowIndex in 0..<gridSize {
            for colIndex in 0..<gridSize {
                let index = (colIndex, rowIndex)
                if _blockMatrix[index] == nil {
                    blankLocations.append(index)
                }
            }
        }
        
        guard blankLocations.count >= 1 else {
            return false
        }
        
        // Don't forget to sync data.
        DispatchQueue.main.async {
            self.objectWillChange.send(self)
        }
        
        // Place the first block.
        let placeLocIndex = Int.random(in: 0..<blankLocations.count)
        _blockMatrix.place(IdentifiedBlock(id: newGlobalID, number: Bool.random() ? 2 : 4), to: blankLocations[placeLocIndex])
        
        // Place the second block.
//        guard let lastLoc = blankLocations.last else {
//            return false
//        }
//        blankLocations[placeLocIndex] = lastLoc
//        placeLocIndex = Int.random(in: 0..<(blankLocations.count - 1))
//        _blockMatrix.place(IdentifiedBlock(id: newGlobalID, number: 2), to: blankLocations[placeLocIndex])
        
        updateGame()
        
        return true
    }
}
