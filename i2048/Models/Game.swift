//
//  Game.swift
//  i2048
//
//  Created by Rishi Singh on 16/12/24.
//

import Foundation
import SwiftData

@Model
class Game {
    var id: UUID
    var name: String
    var gridSize: Int
    var grid: [[Int]]
    var score: Int
    var hasWon: Bool
    var createdAt: Date
    var modifiedAt: Date
    
    /// For loading existing game
    init(
        id: UUID = UUID(),
        name: String,
        grid: [[Int]],
        score: Int,
        hasWon: Bool,
        createdAt: Date,
        modifiedAt: Date
    ) {
        self.id = id
        self.name = name
        self.gridSize = grid.count
        self.grid = grid
        self.score = score
        self.hasWon = hasWon
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
    
    /// For creating new game
    init(
        name: String,
        gridSize: Int
    ) {
        self.id = UUID()
        self.name = name
        self.gridSize = gridSize
        self.grid = Array(repeating: Array(repeating: 0, count: gridSize),count: gridSize)
        self.score = 0
        self.hasWon = false
        self.createdAt = .now
        self.modifiedAt = .now
    }
    
    
    /// This is an example of how to add documnetation in swift.
    /// Produce a greeting string for the given `subject`.
    ///
    /// ```
    /// print(hello("world")) // "Hello, world!"
    /// ```
    ///
    /// > Warning: The returned greeting is not localized. To
    /// > produce a localized string, use ``localizedHello(_:)``
    /// > instead.
    ///
    /// - Parameters:
    ///     - subject: The subject to be welcomed.
    ///
    /// - Returns: A greeting for the given `subject`.
    func hello(_ subject: String) -> String {
        return "Hello, \(subject)!"
    }
}
