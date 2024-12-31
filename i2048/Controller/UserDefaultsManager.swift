//
//  UserDefaultsManager.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI
import CoreHaptics

class UserDefaultsManager: ObservableObject {
    /// Singleton instance for centralized management if needed
    static let shared = UserDefaultsManager()
    
    private var hapticEngine: CHHapticEngine?
        
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
            if hapticsEnabled {
                prepareHapticEngine()
            } else {
                stopEngine()
            }
        }
    }
    
    /// Game sound control
    @Published var soundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        }
    }
    
    /// TitleBar enabled
    @Published var titleBarDisabled: Bool {
        didSet {
            UserDefaults.standard.set(titleBarDisabled, forKey: "titleBarDisabled")
        }
    }
    
    @Published var activeGamesSectionEnabled: Bool {
        didSet {
            UserDefaults.standard.set(activeGamesSectionEnabled, forKey: "activeGamesSectionEnabled")
        }
    }
    
    @Published var gamesWonSectionEnabled: Bool {
        didSet {
            UserDefaults.standard.set(gamesWonSectionEnabled, forKey: "gamesWonSectionEnabled")
        }
    }
    
    @Published var gamesLostSectionEnabled: Bool {
        didSet {
            UserDefaults.standard.set(gamesLostSectionEnabled, forKey: "gamesLostSectionEnabled")
        }
    }
    
    @Published var isWonSectionExpanded = false
    @Published var isRunningSectionExpanded = true
    @Published var isLostSectionExpanded = false
    
    init() {
        self.highScore = UserDefaults.standard.integer(forKey: "highScore")
        self.hapticsEnabled = UserDefaults.standard.bool(forKey: "hapticsEnabled")
        self.soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        self.titleBarDisabled = UserDefaults.standard.bool(forKey: "titleBarDisabled")
        self.activeGamesSectionEnabled = UserDefaults.standard.bool(forKey: "activeGamesSectionEnabled")
        self.gamesWonSectionEnabled = UserDefaults.standard.bool(forKey: "gamesWonSectionEnabled")
        self.gamesLostSectionEnabled = UserDefaults.standard.bool(forKey: "gamesLostSectionEnabled")
        
        self.isWonSectionExpanded = self.gamesWonSectionEnabled
        self.isRunningSectionExpanded = self.activeGamesSectionEnabled
        self.isLostSectionExpanded = self.gamesLostSectionEnabled
        
        if self.hapticsEnabled {
            prepareHapticEngine()
        }
    }
    
    private func prepareHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Failed to start haptic engine: \(error.localizedDescription)")
        }
    }
    
    func triggerSimpleHaptic() {
        guard hapticsEnabled, CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let hapticEvent = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            ],
            relativeTime: 0
        )
        
        do {
            let pattern = try CHHapticPattern(events: [hapticEvent], parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }
    
    func triggerCustomPattern() {
        guard hapticsEnabled, CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            
            let event1 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.0)
            let event2 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.2)
            
            let pattern = try CHHapticPattern(events: [event1, event2], parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play custom pattern: \(error.localizedDescription)")
        }
    }
    
    func stopEngine() {
        hapticEngine?.stop()
    }
}
