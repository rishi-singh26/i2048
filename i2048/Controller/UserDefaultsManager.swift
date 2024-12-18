//
//  UserDefaultsManager.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import Foundation
import SwiftUI

enum AppThemeMode: String {
    case automatic // based on system
    case imageBased // based on selected background image
    case dark // forced dark mode
    case light // forced light mode
}

class UserDefaultsManager: ObservableObject {
    // Singleton instance for centralized management if needed
    static let shared = UserDefaultsManager()

    @Published var appThemeMode: AppThemeMode {
        didSet {
            UserDefaults.standard.set(appThemeMode.rawValue, forKey: "appThemeMode")
        }
    }
    @Published var themeMode: String {
        didSet {
            UserDefaults.standard.set(themeMode, forKey: "themeMode")
        }
    }
    @Published var colorScheme: Bool {
        didSet {
            UserDefaults.standard.set(colorScheme, forKey: "colorScheme")
        }
    }
    @Published var highScore: Int {
        didSet {
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
    }
    @Published var hapticsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(hapticsEnabled, forKey: "hapticsEnabled")
        }
    }
    @Published var soundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        }
    }
    @Published var imageName: String {
        didSet {
            UserDefaults.standard.set(imageName, forKey: "imageName")
        }
    }
    @Published var imageMode: Bool {
        didSet {
            UserDefaults.standard.set(imageMode, forKey: "imageMode")
        }
    }
    @Published var forGroundColor: String {
        didSet {
            UserDefaults.standard.set(forGroundColor, forKey: "forGroundColor")
        }
    }
    @Published var gameVictoryColor: String {
        didSet {
            UserDefaults.standard.set(gameVictoryColor, forKey: "gameVictoryColor")
        }
    }
    @Published var gameLossColor: String {
        didSet {
            UserDefaults.standard.set(gameLossColor, forKey: "gameLossColor")
        }
    }
    @Published var backGroundColor: String {
        didSet {
            UserDefaults.standard.set(backGroundColor, forKey: "backGroundColor")
        }
    }
    @Published var color2: String {
        didSet {
            UserDefaults.standard.set(color2, forKey: "color2")
        }
    }
    @Published var color4: String {
        didSet {
            UserDefaults.standard.set(color4, forKey: "color4")
        }
    }
    @Published var color8: String {
        didSet {
            UserDefaults.standard.set(color8, forKey: "color8")
        }
    }
    @Published var color16: String {
        didSet {
            UserDefaults.standard.set(color16, forKey: "color16")
        }
    }
    @Published var color32: String {
        didSet {
            UserDefaults.standard.set(color32, forKey: "color32")
        }
    }
    @Published var color64: String {
        didSet {
            UserDefaults.standard.set(color64, forKey: "color64")
        }
    }
    @Published var color128: String {
        didSet {
            UserDefaults.standard.set(color128, forKey: "color128")
        }
    }
    @Published var color256: String {
        didSet {
            UserDefaults.standard.set(color256, forKey: "color256")
        }
    }
    @Published var color512: String {
        didSet {
            UserDefaults.standard.set(color512, forKey: "color512")
        }
    }
    @Published var color1024: String {
        didSet {
            UserDefaults.standard.set(color1024, forKey: "color1024")
        }
    }
    @Published var color2048: String {
        didSet {
            UserDefaults.standard.set(color2048, forKey: "color2048")
        }
    }
    @Published var color4096: String {
        didSet {
            UserDefaults.standard.set(color4096, forKey: "color4096")
        }
    }
    @Published var color8192: String {
        didSet {
            UserDefaults.standard.set(color8192, forKey: "color8192")
        }
    }
    @Published var color16384: String {
        didSet {
            UserDefaults.standard.set(color16384, forKey: "color16384")
        }
    }

    init() {
        self.appThemeMode = AppThemeMode(rawValue: UserDefaults.standard.string(forKey: "appThemeMode") ?? "automatic") ?? .automatic
        self.themeMode = UserDefaults.standard.string(forKey: "themeMode") ?? "automatic"
        self.colorScheme = UserDefaults.standard.bool(forKey: "colorScheme")
        self.highScore = UserDefaults.standard.integer(forKey: "highScore")
        self.hapticsEnabled = UserDefaults.standard.bool(forKey: "hapticsEnabled")
        self.soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        self.imageName = UserDefaults.standard.string(forKey: "imageName") ?? "Camping-on-the-beach"
        self.imageMode = UserDefaults.standard.bool(forKey: "imageMode")
        self.forGroundColor = UserDefaults.standard.string(forKey: "forGroundColor") ?? "#ffffff"
        self.gameVictoryColor = UserDefaults.standard.string(forKey: "gameVictoryColor") ?? "#00F900"
        self.gameLossColor = UserDefaults.standard.string(forKey: "gameLossColor") ?? "#FF2600"
        self.backGroundColor = UserDefaults.standard.string(forKey: "backGroundColor") ?? "#FFFB00"
        self.color2 = UserDefaults.standard.string(forKey: "color2") ?? "#FFCC01"
        self.color4 = UserDefaults.standard.string(forKey: "color4") ?? "#FF9500"
        self.color8 = UserDefaults.standard.string(forKey: "color8") ?? "##FF2C55"
        self.color16 = UserDefaults.standard.string(forKey: "color16") ?? "#AF52DE"
        self.color32 = UserDefaults.standard.string(forKey: "color32") ?? "#FF3C2F"
        self.color64 = UserDefaults.standard.string(forKey: "color64") ?? "#FB5C4C"
        self.color128 = UserDefaults.standard.string(forKey: "color128") ?? "#007AFF"
        self.color256 = UserDefaults.standard.string(forKey: "color256") ?? "#2C8EF3"
        self.color512 = UserDefaults.standard.string(forKey: "color512") ?? "#35C759"
        self.color1024 = UserDefaults.standard.string(forKey: "color1024") ?? "#51CA70"
        self.color2048 = UserDefaults.standard.string(forKey: "color2048") ?? "#FED702"
        self.color4096 = UserDefaults.standard.string(forKey: "color4096") ?? "#5856D6"
        self.color8192 = UserDefaults.standard.string(forKey: "color8192") ?? "#BD8BCD"
        self.color16384 = UserDefaults.standard.string(forKey: "color16384") ?? "#B8BAB2"
    }
}
