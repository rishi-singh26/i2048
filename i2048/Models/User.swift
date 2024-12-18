//
//  User.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

import Foundation
import SwiftData

enum UserPreferencesSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [UserPreferences.self]
    }
    
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
        
        //    Color Pallet based on Camping-on-the-beach image
        //    init() {
        //        self.highScore = 0
        //        self.hapticsEnabled = false
        //        self.soundEnabled = false
        //        self.imageName = "Camping-on-the-beach"
        //        self.forGroundColor = "#ffffff"
        //        self.backGroundColor = "#FFFB00"
        //        self.gameVictoryColor = "#00F900"
        //        self.gameLossColor = "#FF2600"
        //        self.color2 = "#bac895"
        //        self.color4 = "#b9c795"
        //        self.color8 = "#b9c794"
        //        self.color16 = "#f4ef96"
        //        self.color32 = "#b9c796"
        //        self.color64 = "#f4ee93"
        //        self.color128 = "#b9c894"
        //        self.color256 = "#bac896"
        //        self.color512 = "#b8c695"
        //        self.color1024 = "#f7c883"
        //        self.color2048 = "#ebbe44"
        //        self.color4096 = "#b9c793"
        //        self.color8192 = "#f4ed91"
        //        self.color16384 = "#b9c895"
        //    }
        
        init() {
            self.highScore = 0
            self.hapticsEnabled = false
            self.soundEnabled = false
            self.imageName = "Camping-on-the-beach"
            self.forGroundColor = "#ffffff"
            self.backGroundColor = "#FFFB00"
            self.gameVictoryColor = "#00F900"
            self.gameLossColor = "#FF2600"
            self.color2 = "#FFCC01" // yellow
            self.color4 = "#FF9500" // orange
            self.color8 = "##FF2C55" // pink
            self.color16 = "#AF52DE" // purple
            self.color32 = "#FF3C2F" // red
            self.color64 = "#FB5C4C" // red.opacity(0.8)
            self.color128 = "#007AFF" // blue
            self.color256 = "#2C8EF3" // blue.opacity(0.8)
            self.color512 = "#35C759" // green
            self.color1024 = "#51CA70" // green.opacity(0.8)
            self.color2048 = "#FED702" // gold
            self.color4096 = "#5856D6" // indogo
            self.color8192 = "#BD8BCD" // purple.opacity(0.5)
            self.color16384 = "#B8BAB2" // gray.opacity(0.3)
        }
        
    }
}

enum UserPreferencesSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 1, 0)
    
    static var models: [any PersistentModel.Type] {
        [UserPreferences.self]
    }
    
    @Model
    class UserPreferences {
        var highScore: Int
        var hapticsEnabled: Bool
        var soundEnabled: Bool
        /// Name of the image as in Assets.xcassets
        var imageName: String
        
        /// Image mode has the data aboud weather the image is a dark or light image.
        ///
        /// true => light image; false => dark image
        var imageMode: Bool
        
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
            self.color2 = "#FFCC01" // yellow
            self.color4 = "#FF9500" // orange
            self.color8 = "##FF2C55" // pink
            self.color16 = "#AF52DE" // purple
            self.color32 = "#FF3C2F" // red
            self.color64 = "#FB5C4C" // red.opacity(0.8)
            self.color128 = "#007AFF" // blue
            self.color256 = "#2C8EF3" // blue.opacity(0.8)
            self.color512 = "#35C759" // green
            self.color1024 = "#51CA70" // green.opacity(0.8)
            self.color2048 = "#FED702" // gold
            self.color4096 = "#5856D6" // indogo
            self.color8192 = "#BD8BCD" // purple.opacity(0.5)
            self.color16384 = "#B8BAB2" // gray.opacity(0.3)
            self.imageMode = true // light image
        }
        
    }
}

typealias UserPreferences = UserPreferencesSchemaV2.UserPreferences

enum UserPreferencesMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [UserPreferencesSchemaV1.self, UserPreferencesSchemaV2.self]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: UserPreferencesSchemaV1.self,
        toVersion: UserPreferencesSchemaV2.self
    )
    
//    static let migrateV1toV2 = MigrationStage.custom(
//        fromVersion: UserPreferencesSchemaV1.self,
//        toVersion: UserPreferencesSchemaV2.self,
//        willMigrate: { context in
//            let preferences = try context.fetch(FetchDescriptor<UserPreferencesSchemaV1.UserPreferences>())
//
//            var usedNames = Set<String>()
//
//            for preference in preferences {
//                if usedNames.contains(user.name) {
//                    context.delete(user)
//                }
//
//                usedNames.insert(user.name)
//            }
//
//            try context.save()
//        }, didMigrate: nil
//    )
    
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
}
