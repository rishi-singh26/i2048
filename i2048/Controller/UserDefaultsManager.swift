//
//  UserDefaultsManager.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import Foundation
import SwiftUI

class UserDefaultsManager: ObservableObject {
    /// Singleton instance for centralized management if needed
    static let shared = UserDefaultsManager()
    
    /// The colorSchme of the game view
    /// When themeMode is false then the color scheme of game view is based on this proepery
    /// true -> light; false -> dark
    @Published var colorScheme: Bool {
        didSet {
            UserDefaults.standard.set(colorScheme, forKey: "colorScheme")
        }
    }
    
    /// Game hight score. This will not be synced with each device
    @Published var highScore: Int {
        didSet {
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
    }
    
    /// Haptic feedback control
    @Published var hapticsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(hapticsEnabled, forKey: "hapticsEnabled")
        }
    }
    
    /// Game sound control
    @Published var soundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        }
    }
    
    // MARK: - Light mode properties
    @Published var isNetworkImageSelected: Bool {
        didSet {
            UserDefaults.standard.set(isNetworkImageSelected, forKey: "isNetworkImageSelected")
        }
    }
    @Published var imageName: String {
        didSet {
            UserDefaults.standard.set(imageName, forKey: "imageName")
        }
    }
    @Published var imageUrl: String {
        didSet {
            UserDefaults.standard.set(imageUrl, forKey: "imageUrl")
        }
    }
    @Published var imagePreviewUrl: String {
        didSet {
            UserDefaults.standard.set(imagePreviewUrl, forKey: "imagePreviewUrl")
        }
    }
    @Published var imageDribbleUrl: String {
        didSet {
            UserDefaults.standard.set(imageDribbleUrl, forKey: "imageDribbleUrl")
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
    
    // MARK: - Dark mode properties
    @Published var isDarkNetworkImageSelected: Bool {
        didSet {
            UserDefaults.standard.set(isDarkNetworkImageSelected, forKey: "isDarkNetworkImageSelected")
        }
    }
    @Published var darkImageName: String {
            didSet {
                UserDefaults.standard.set(darkImageName, forKey: "darkImageName")
            }
        }
    @Published var darkImageUrl: String {
        didSet {
            UserDefaults.standard.set(darkImageUrl, forKey: "darkImageUrl")
        }
    }
    @Published var darkImagePreviewUrl: String {
        didSet {
            UserDefaults.standard.set(darkImagePreviewUrl, forKey: "darkImagePreviewUrl")
        }
    }
    @Published var darkImageDribbleUrl: String {
        didSet {
            UserDefaults.standard.set(darkImageDribbleUrl, forKey: "darkImageDribbleUrl")
        }
    }
    @Published var darkImageMode: Bool {
        didSet {
            UserDefaults.standard.set(darkImageMode, forKey: "darkImageMode")
        }
    }
    @Published var darkForGroundColor: String {
        didSet {
            UserDefaults.standard.set(darkForGroundColor, forKey: "darkForGroundColor")
        }
    }
    @Published var darkGameVictoryColor: String {
        didSet {
            UserDefaults.standard.set(darkGameVictoryColor, forKey: "darkGameVictoryColor")
        }
    }
    @Published var darkGameLossColor: String {
        didSet {
            UserDefaults.standard.set(darkGameLossColor, forKey: "darkGameLossColor")
        }
    }
    @Published var darkBackGroundColor: String {
        didSet {
            UserDefaults.standard.set(darkBackGroundColor, forKey: "darkBackGroundColor")
        }
    }
    @Published var darkColor2: String {
        didSet {
            UserDefaults.standard.set(darkColor2, forKey: "darkColor2")
        }
    }
    @Published var darkColor4: String {
        didSet {
            UserDefaults.standard.set(darkColor4, forKey: "darkColor4")
        }
    }
    @Published var darkColor8: String {
        didSet {
            UserDefaults.standard.set(darkColor8, forKey: "darkColor8")
        }
    }
    @Published var darkColor16: String {
        didSet {
            UserDefaults.standard.set(darkColor16, forKey: "darkColor16")
        }
    }
    @Published var darkColor32: String {
        didSet {
            UserDefaults.standard.set(darkColor32, forKey: "darkColor32")
        }
    }
    @Published var darkColor64: String {
        didSet {
            UserDefaults.standard.set(darkColor64, forKey: "darkColor64")
        }
    }
    @Published var darkColor128: String {
        didSet {
            UserDefaults.standard.set(darkColor128, forKey: "darkColor128")
        }
    }
    @Published var darkColor256: String {
        didSet {
            UserDefaults.standard.set(darkColor256, forKey: "darkColor256")
        }
    }
    @Published var darkColor512: String {
        didSet {
            UserDefaults.standard.set(darkColor512, forKey: "darkColor512")
        }
    }
    @Published var darkColor1024: String {
        didSet {
            UserDefaults.standard.set(darkColor1024, forKey: "darkColor1024")
        }
    }
    @Published var darkColor2048: String {
        didSet {
            UserDefaults.standard.set(darkColor2048, forKey: "darkColor2048")
        }
    }
    @Published var darkColor4096: String {
        didSet {
            UserDefaults.standard.set(darkColor4096, forKey: "darkColor4096")
        }
    }
    @Published var darkColor8192: String {
        didSet {
            UserDefaults.standard.set(darkColor8192, forKey: "darkColor8192")
        }
    }
    @Published var darkColor16384: String {
        didSet {
            UserDefaults.standard.set(darkColor16384, forKey: "darkColor16384")
        }
    }
    
    func selectNetworkImage(_ image: BackgroundArt, _ colorScheme: ColorScheme) {
        if colorScheme == .light {
            self.imageUrl = image.url
            self.imagePreviewUrl = image.previewUrl
            self.imageDribbleUrl = image.dribbleUrl
            self.imageName = image.name
            self.imageMode = image.mode
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
            self.isNetworkImageSelected = true
        } else {
            self.darkImageUrl = image.url
            self.darkImagePreviewUrl = image.previewUrl
            self.darkImageDribbleUrl = image.dribbleUrl
            self.darkImageName = image.name
            self.darkImageMode = image.mode
            self.darkForGroundColor = image.forGroundColor
            self.darkGameVictoryColor = image.gameVictoryColor
            self.darkGameLossColor = image.gameLossColor
            self.darkBackGroundColor = image.backGroundColor
            self.darkColor2 = image.color2
            self.darkColor4 = image.color4
            self.darkColor8 = image.color8
            self.darkColor16 = image.color16
            self.darkColor32 = image.color32
            self.darkColor64 = image.color64
            self.darkColor128 = image.color128
            self.darkColor256 = image.color256
            self.darkColor512 = image.color512
            self.darkColor1024 = image.color1024
            self.darkColor2048 = image.color2048
            self.darkColor4096 = image.color4096
            self.darkColor8192 = image.color8192
            self.darkColor16384 = image.color16384
            self.isDarkNetworkImageSelected = true
        }
    }

    init() {
        self.colorScheme = UserDefaults.standard.bool(forKey: "colorScheme")
        self.highScore = UserDefaults.standard.integer(forKey: "highScore")
        self.hapticsEnabled = UserDefaults.standard.bool(forKey: "hapticsEnabled")
        self.soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        // MARK: - Light mode properties
        self.imageName = UserDefaults.standard.string(forKey: "imageName") ?? "Camping-on-the-beach"
        self.imageUrl = UserDefaults.standard.string(forKey: "imageUrl") ?? "Camping-on-the-beach"
        self.imagePreviewUrl = UserDefaults.standard.string(forKey: "imagePreviewUrl") ?? "Camping-on-the-beach"
        self.imageDribbleUrl = UserDefaults.standard.string(forKey: "imageDribbleUrl") ?? "Camping-on-the-beach"
        self.imageMode = UserDefaults.standard.bool(forKey: "imageMode")
        self.forGroundColor = UserDefaults.standard.string(forKey: "forGroundColor") ?? "#ffffff"
        self.gameVictoryColor = UserDefaults.standard.string(forKey: "gameVictoryColor") ?? "#00F900"
        self.gameLossColor = UserDefaults.standard.string(forKey: "gameLossColor") ?? "#FF2600"
        self.backGroundColor = UserDefaults.standard.string(forKey: "backGroundColor") ?? "#FFFB00"
        self.color2 = UserDefaults.standard.string(forKey: "color2") ?? "#FFCC01"
        self.color4 = UserDefaults.standard.string(forKey: "color4") ?? "#FF9500"
        self.color8 = UserDefaults.standard.string(forKey: "color8") ?? "#FF2C55"
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
        self.isNetworkImageSelected = UserDefaults.standard.bool(forKey: "isNetworkImageSelected")
        // MARK: - Dark mode properties
        self.darkImageName = UserDefaults.standard.string(forKey: "darkImageName") ?? "Camping-on-the-beach"
        self.darkImageUrl = UserDefaults.standard.string(forKey: "darkImageUrl") ?? "Camping-on-the-beach"
        self.darkImagePreviewUrl = UserDefaults.standard.string(forKey: "darkImagePreviewUrl") ?? "Camping-on-the-beach"
        self.darkImageDribbleUrl = UserDefaults.standard.string(forKey: "darkImageDribbleUrl") ?? "Camping-on-the-beach"
        self.darkImageMode = UserDefaults.standard.bool(forKey: "darkImageMode")
        self.darkForGroundColor = UserDefaults.standard.string(forKey: "darkForGroundColor") ?? "#ffffff"
        self.darkGameVictoryColor = UserDefaults.standard.string(forKey: "darkGameVictoryColor") ?? "#00F900"
        self.darkGameLossColor = UserDefaults.standard.string(forKey: "darkGameLossColor") ?? "#FF2600"
        self.darkBackGroundColor = UserDefaults.standard.string(forKey: "darkBackGroundColor") ?? "#FFFB00"
        self.darkColor2 = UserDefaults.standard.string(forKey: "darkColor2") ?? "#FFCC01"
        self.darkColor4 = UserDefaults.standard.string(forKey: "darkColor4") ?? "#FF9500"
        self.darkColor8 = UserDefaults.standard.string(forKey: "darkColor8") ?? "#FF2C55"
        self.darkColor16 = UserDefaults.standard.string(forKey: "darkColor16") ?? "#AF52DE"
        self.darkColor32 = UserDefaults.standard.string(forKey: "darkColor32") ?? "#FF3C2F"
        self.darkColor64 = UserDefaults.standard.string(forKey: "darkColor64") ?? "#FB5C4C"
        self.darkColor128 = UserDefaults.standard.string(forKey: "darkColor128") ?? "#007AFF"
        self.darkColor256 = UserDefaults.standard.string(forKey: "darkColor256") ?? "#2C8EF3"
        self.darkColor512 = UserDefaults.standard.string(forKey: "darkColor512") ?? "#35C759"
        self.darkColor1024 = UserDefaults.standard.string(forKey: "darkColor1024") ?? "#51CA70"
        self.darkColor2048 = UserDefaults.standard.string(forKey: "darkColor2048") ?? "#FED702"
        self.darkColor4096 = UserDefaults.standard.string(forKey: "darkColor4096") ?? "#5856D6"
        self.darkColor8192 = UserDefaults.standard.string(forKey: "darkColor8192") ?? "#BD8BCD"
        self.darkColor16384 = UserDefaults.standard.string(forKey: "darkColor16384") ?? "#B8BAB2"
        self.isDarkNetworkImageSelected = UserDefaults.standard.bool(forKey: "isDarkNetworkImageSelected")
    }
}
