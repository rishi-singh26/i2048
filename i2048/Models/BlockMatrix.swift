//
//  BlockMatrix.swift
//  SwiftUI2048
//
//  Created by Hongyu on 6/5/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

import Foundation

protocol Block: Equatable {
    
    associatedtype Value: Equatable
    
    var number: Value { get set }
    
}

struct IndexedBlock<T> where T: Block {
    
    typealias Index = BlockMatrix<T>.Index
    
    let index: Self.Index
    let item: T

}

struct BlockMatrix<T> : Equatable, CustomDebugStringConvertible where T: Block {
    
    typealias Index = (Int, Int)
    
    private var matrix: [[T?]]
    
    private var gridSize: Int = 4
    
    init() {
        matrix = [[T?]]()
        for _ in 0..<gridSize {
            var row = [T?]()
            for _ in 0..<gridSize {
                row.append(nil)
            }
            matrix.append(row)
        }
    }
    
    init(grid: [[T?]]) {
        matrix = [[T?]]()
        self.gridSize = grid.count
        for rowInd in 0..<gridSize {
            var row = [T?]()
            for colInd in 0..<gridSize {
                row.append(grid[rowInd][colInd])
            }
            matrix.append(row)
        }
    }
    
    var debugDescription: String {
        matrix.map { row -> String in
            row.map {
                if $0 == nil {
                    return " "
                } else {
                    return String(describing: $0!.number)
                }
            }.joined(separator: "\t")
        }.joined(separator: "\n")
    }
    
    var flatten: [IndexedBlock<T>] {
        return self.matrix.enumerated().flatMap { (y: Int, element: [T?]) in
            element.enumerated().compactMap { (x: Int, element: T?) in
                guard let element = element else {
                    return nil
                }
                return IndexedBlock(index: (x, y), item: element)
            }
        }
    }
    
    subscript(index: Self.Index) -> T? {
        guard isIndexValid(index) else {
            return nil
        }
        
        return matrix[index.1][index.0]
    }
    
    /// Move the block to specific location and leave the original location blank.
    /// - Parameter from: Source location
    /// - Parameter to: Destination location
    mutating func move(from: Self.Index, to: Self.Index) {
        guard isIndexValid(from) && isIndexValid(to) else {
            // TODO: Throw an error?
            return
        }
        
        guard let source = self[from] else {
            return
        }
        
        matrix[to.1][to.0] = source
        matrix[from.1][from.0] = nil
    }
    
    /// Move the block to specific location, change its value and leave the original location blank.
    /// - Parameter from: Source location
    /// - Parameter to: Destination location
    /// - Parameter newValue: The new value
    mutating func move(from: Self.Index, to: Self.Index, with newValue: T.Value) {
        guard isIndexValid(from) && isIndexValid(to) else {
            // TODO: Throw an error?
            return
        }
        
        guard var source = self[from] else {
            return
        }
        
        source.number = newValue
        
        matrix[to.1][to.0] = source
        matrix[from.1][from.0] = nil
    }
    
    /// Place a block to specific location.
    /// - Parameter block: The block to place
    /// - Parameter to: Destination location
    mutating func place(_ block: T?, to: Self.Index) {
        matrix[to.1][to.0] = block
    }
    
    fileprivate func isIndexValid(_ index: Self.Index) -> Bool {
        guard index.0 >= 0 && index.0 < gridSize else {
            return false
        }
        
        guard index.1 >= 0 && index.1 < gridSize else {
            return false
        }
        
        return true
    }
    
    static func == (lhs: BlockMatrix<T>, rhs: BlockMatrix<T>) -> Bool {
            guard lhs.matrix.count == rhs.matrix.count else {
                return false
            }
            
            for (row1, row2) in zip(lhs.matrix, rhs.matrix) {
                guard row1.count == row2.count else {
                    return false
                }
                
                for (block1, block2) in zip(row1, row2) {
                    if block1?.number != block2?.number {
                        return false
                    }
                }
            }
            
            return true
        }
    
}

extension BlockMatrix where T == IdentifiedBlock {
    func toIntMatrix() -> [[Int]] {
        return matrix.map { row in
            row.map { block in
                block?.number ?? 0
            }
        }
    }
}
