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
    
    init() {
        self.highScore = UserDefaults.standard.integer(forKey: "highScore")
        self.hapticsEnabled = UserDefaults.standard.bool(forKey: "hapticsEnabled")
        self.soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
    }
}
