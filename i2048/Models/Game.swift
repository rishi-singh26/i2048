//
//  Game.swift
//  i2048
//
//  Created by Rishi Singh on 16/12/24.
//

import Foundation
import SwiftData

enum GameSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [Game.self]
    }

    @Model
    class Game {
        var id: UUID = UUID()
        var name: String = "New Game"
        var gridSize: Int = 4
        var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 4),count: 4)
        var score: Int = 0
        var hasWon: Bool = false
        var createdAt: Date = Date.now
        var modifiedAt: Date = Date.now
        
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
}

typealias Game = GameSchemaV1.Game
