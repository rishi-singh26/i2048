//
//  UserDefaultsManager.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI

class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()
    
    // Properties directly linked to UserDefaults using @AppStorage
    @AppStorage("highScore") var highScore: Int = 0
    @AppStorage("hapticsEnabled") var hapticsEnabled: Bool = false {
        didSet {
            if hapticsEnabled {
                HapticsManager.shared.prepareHapticEngine()
            } else {
                HapticsManager.shared.stopEngine()
            }
        }
    }
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("titleBarDisabled") var titleBarDisabled: Bool = false
    
    @AppStorage("quick3GameNamePrefix") var quick3GameNamePrefix: String = "New Game"
    @AppStorage("quick4GameNamePrefix") var quick4GameNamePrefix: String = "New Game"
    @AppStorage("quick3GameAllowUndo") var quick3GameAllowUndo: Bool = false
    @AppStorage("quick4GameAllowUndo") var quick4GameAllowUndo: Bool = false
    @AppStorage("quick3GameNewBlocNum") var quick3GameNewBlocNum: Int = 0
    @AppStorage("quick4GameNewBlocNum") var quick4GameNewBlocNum: Int = 0
    @AppStorage("quick3GameTarget") var quick3GameTarget: Int = 256
    @AppStorage("quick4GameTarget") var quick4GameTarget: Int = 2048
    
    @AppStorage("arrowBindingsEnabled") var arrowBindingsEnabled: Bool = true // ⌘ + (↑ → ↓ ←)
    @AppStorage("leftBindingsEnabled") var leftBindingsEnabled: Bool = false // W D S A
    @AppStorage("rightBindingsEnabled") var rightBindingsEnabled: Bool = false // I L K J
    
    /// When user buys premium or restores purchase, set this to true
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
        
    init() {
        if self.hapticsEnabled {
            HapticsManager.shared.prepareHapticEngine()
        }
    }
    
    func unlockPremiumAccess() {
        isPremiumUser = true;
    }
    
    func resetPremiumAccess() {
        isPremiumUser = false;
    }
}
