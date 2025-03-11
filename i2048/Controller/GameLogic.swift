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
    static let shared = GameLogic()
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
    private var _prevBlocMatrix: BlockMatrixType!
    @Published var selectedGame: Game? {
        didSet {
            _onGameSet(selectedGame: selectedGame)
        }
    }
    @Published var confettiCounter: Int = 0
    private(set) var defaultsManager: UserDefaultsManager?
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
        _prevBlocMatrix = _blockMatrix
        resetLastGestureDirection()
        generateNewBlocks(2)
        
        objectWillChange.send(self)
    }
    
    func updateUserDefaults(defaultsManager: UserDefaultsManager) -> GameLogic {
        self.defaultsManager = defaultsManager
        return self
    }
    
    private func _onGameSet(selectedGame: Game?) {
        guard let selectedGame = selectedGame else { return }
        gridSize = selectedGame.gridSize
        _blockMatrix = BlockMatrixType(grid: transformToIdentifiedBlocks(matrix: selectedGame.grid))
        _prevBlocMatrix = _blockMatrix
        resetLastGestureDirection()
        
        if selectedGame.grid.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
            generateNewBlocks(2)
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
                return IdentifiedBlock(id: UUID().hashValue, number: number)
            }
        }
    }

    private func updateGame() {
        if let game = selectedGame {
            if game.allowUndo {
                game.prevState = game.grid
            }
            game.grid = self.blockMatrix.toIntMatrix()
        }
    }
    
    private func updateGameValues(score: Int, hasWon: Bool) {
        guard let selectedGame = selectedGame else { return }
        // Update game score
        selectedGame.score = score
        // Update game status
        if !selectedGame.hasWon && hasWon {
            withAnimation {
                confettiCounter += 1
            }
            selectedGame.hasWon = hasWon
        }
        // Update high score
        if score > defaultsManager?.highScore ?? 0 {
            defaultsManager?.highScore = score
        }
    }

    
    func resetLastGestureDirection() {
        lastGestureDirection = .up
    }
    
    func undoStep() {
        if let selectedGame, selectedGame.canUndo {
            // when running on a device the _prevBlocMatrix will be maintined and used for undo
            // when switching between games, _prevBlocMatrix will be reset and _blocMatrix will generated from game.prevState with new ids for blocks
            // when swithcing from one device to another, the _prevBlocMatrix will not be available and _blocMatrix will generated from game.prevState with new ids for blocks
            
            // storing _prevBlocMatrix is important because it holds the ids for each block, so during undo, blocks animate to their previous location properly.
            // when _prevBlocMatrix is not available and _blocMatrix will generated from game.prevState with new ids for blocks, the game will undo but animation will be as if totally new blocks were generated
            if _blockMatrix == _prevBlocMatrix {
                _blockMatrix = BlockMatrixType(grid: transformToIdentifiedBlocks(matrix: selectedGame.prevState))
            } else {
                _blockMatrix = _prevBlocMatrix
            }
            selectedGame.undoStep()
        }
    }
    
    func move(_ direction: Direction) {
        _prevBlocMatrix = _blockMatrix // store the previous step, will be needed for undo
        DispatchQueue.main.async {
            self.objectWillChange.send(self)
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
                } else {
                    rowSnapshot.append(nil)
                }
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
        
        if moved {
            generateNewBlocks(1)
            defaultsManager?.triggerSimpleHaptic()
        } else {
            defaultsManager?.triggerCustomPattern()
        }
    }
    
    fileprivate func merge(blocks: inout [IdentifiedBlock], reverse: Bool) {
        if reverse {
            blocks = blocks.reversed()
        }
        
        var score: Int = selectedGame?.score ?? 0
        var hasWon: Bool = false
        
        blocks = blocks
            .map { (false, $0) }
            .reduce([(Bool, IdentifiedBlock)]()) { acc, item in
                if acc.last?.0 == false && acc.last?.1.number == item.1.number {
                    var accPrefix = Array(acc.dropLast())
                    var mergedBlock = item.1
                    let mergedNumber = mergedBlock.number * 2
                    score += mergedNumber
                    hasWon = mergedNumber >= selectedGame?.targetScore ?? 2048 // win score is 2048 by default
                    mergedBlock.number = mergedNumber
                    accPrefix.append((true, mergedBlock))
                    return accPrefix
                } else {
                    var accTmp = acc
                    accTmp.append((false, item.1))
                    return accTmp
                }
            }
            .map { $0.1 }
        
        // Update game values
        updateGameValues(score: score, hasWon: hasWon)
        
        if reverse {
            blocks = blocks.reversed()
        }
    }
    
    @discardableResult fileprivate func _generateNewBlock() -> Bool {
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
        
        _blockMatrix.place(IdentifiedBlock(id: newGlobalID, number: selectedGame?.getNewBlockNum() ?? 2), to: blankLocations.randomElement()!)
        
        return true
    }
      
    @discardableResult fileprivate func generateNewBlocks(_ num: Int = 1) -> Bool {
        guard num > 0 else {
            return false
        }
        
        for _ in 0..<num {
            if !_generateNewBlock() {
                return false
            }
        }
        
        updateGame()
        
        return true
    }
}
