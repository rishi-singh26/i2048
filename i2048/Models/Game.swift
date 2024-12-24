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

enum GameSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
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
        var imageUrl: String = ""
        var gameColorMode: Bool = true
        var forGroundColor: String = "#ffffff"
        var gameVictoryColor: String = "#00F900"
        var gameLossColor: String = "#FF2600"
        var backGroundColor: String = "#FFFB00"
        var color2: String = "#FFCC01"
        var color4: String = "#FF9500"
        var color8: String = "#FF2C55"
        var color16: String = "#AF52DE"
        var color32: String = "#FF3C2F"
        var color64: String = "#FB5C4C"
        var color128: String = "#007AFF"
        var color256: String = "#2C8EF3"
        var color512: String = "#35C759"
        var color1024: String = "#51CA70"
        var color2048: String = "#FED702"
        var color4096: String = "#5856D6"
        var color8192: String = "#BD8BCD"
        var color16384: String = "#B8BAB2"
        
        /// For creating new game
        init(
            name: String,
            gridSize: Int,
            imageUrl: String = "",
            gameColorMode: Bool = true,
            forGroundColor: String = "#ffffff",
            gameVictoryColor: String = "#00F900",
            gameLossColor: String = "#FF2600",
            backGroundColor: String = "#FFFB00",
            color2: String = "#FFCC01",
            color4: String = "#FF9500",
            color8: String = "#FF2C55",
            color16: String = "#AF52DE",
            color32: String = "#FF3C2F",
            color64: String = "#FB5C4C",
            color128: String = "#007AFF",
            color256: String = "#2C8EF3",
            color512: String = "#35C759",
            color1024: String = "#51CA70",
            color2048: String = "#FED702",
            color4096: String = "#5856D6",
            color8192: String = "#BD8BCD",
            color16384: String = "#B8BAB2"
        ) {
            self.id = UUID()
            self.name = name
            self.gridSize = gridSize
            self.grid = Array(repeating: Array(repeating: 0, count: gridSize),count: gridSize)
            self.score = 0
            self.hasWon = false
            self.createdAt = .now
            self.modifiedAt = .now
            self.imageUrl = imageUrl
            self.gameColorMode = gameColorMode
            self.forGroundColor = forGroundColor
            self.gameVictoryColor = gameVictoryColor
            self.gameLossColor = gameLossColor
            self.backGroundColor = backGroundColor
            self.color2 = color2
            self.color4 = color4
            self.color8 = color8
            self.color16 = color16
            self.color32 = color32
            self.color64 = color64
            self.color128 = color128
            self.color256 = color256
            self.color512 = color512
            self.color1024 = color1024
            self.color2048 = color2048
            self.color4096 = color4096
            self.color8192 = color8192
            self.color16384 = color16384
        }
        
        func selectNetworkImage(_ image: BackgroundArt) {
            self.gameColorMode = !image.mode // for light images use dark background and vice versa
            self.imageUrl = image.url
            self.forGroundColor = image.forGroundColor
            self.gameVictoryColor = image.gameVictoryColor
            self.gameLossColor = image.gameLossColor
            self.backGroundColor = image.backGroundColor
            self.color2 = image.color2
            self.color4 = image.color4
            self.color8 = image.color8
            self.color16 = image.color16
            self.color32 = image.color32
            self.color64 = image.color64
            self.color128 = image.color128
            self.color256 = image.color256
            self.color512 = image.color512
            self.color1024 = image.color1024
            self.color2048 = image.color2048
            self.color4096 = image.color4096
            self.color8192 = image.color8192
            self.color16384 = image.color16384
        }
    }
}

typealias Game = GameSchemaV2.Game
