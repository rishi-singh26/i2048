//
//  User.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

import Foundation
import SwiftData

@Model
class UserPreferences {
    var highScore: Int
    var hapticsEnabled: Bool
    var soundEnabled: Bool
    /// Name of the image as in Assets.xcassets
    var imageName: String
    
    /// This will be the color of text for this image
    var forGroundColor: String

    /// This color will be used when the user wins a game
    var gameVictoryColor: String
    
    /// This color will be used when the user looses a game
    var gameLossColor: String
    
    /// This color will be used as background for the selected bacjground image
    var backGroundColor: String
    
    /// Colors to be used on the game grid
    var color2: String
    var color4: String
    var color8: String
    var color16: String
    var color32: String
    var color64: String
    var color128: String
    var color256: String
    var color512: String
    var color1024: String
    var color2048: String
    var color4096: String
    var color8192: String
    var color16384: String
    
    init() {
        self.highScore = 0
        self.hapticsEnabled = false
        self.soundEnabled = false
        self.imageName = "Camping-on-the-beach"
        self.forGroundColor = "#ffffff"
        self.backGroundColor = "#FFFB00"
        self.gameVictoryColor = "#00F900"
        self.gameLossColor = "#FF2600"
        self.color2 = "#bac895"
        self.color4 = "#b9c795"
        self.color8 = "#b9c794"
        self.color16 = "#f4ef96"
        self.color32 = "#b9c796"
        self.color64 = "#f4ee93"
        self.color128 = "#b9c894"
        self.color256 = "#bac896"
        self.color512 = "#b8c695"
        self.color1024 = "#f7c883"
        self.color2048 = "#ebbe44"
        self.color4096 = "#b9c793"
        self.color8192 = "#f4ed91"
        self.color16384 = "#b9c895"
    }
    
}
