//
//  UserDefaultsManager.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI
import CoreHaptics

class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()

    private var hapticEngine: CHHapticEngine?
    
    // Properties directly linked to UserDefaults using @AppStorage
    @AppStorage("highScore") var highScore: Int = 0
    @AppStorage("hapticsEnabled") var hapticsEnabled: Bool = false {
        didSet {
            if hapticsEnabled {
                prepareHapticEngine()
            } else {
                stopEngine()
            }
        }
    }
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("titleBarDisabled") var titleBarDisabled: Bool = false
    
    @AppStorage("quickGameNamePrefix") var quickGameNamePrefix: String = "Game Name"
    @AppStorage("quickGameAllowUndo") var quickGameAllowUndo: Bool = false
    @AppStorage("quickGameNewBlocNum") var quickGameNewBlocNum: Int = 0
    @AppStorage("quick3GameTarget") var quick3GameTarget: Int = 256
    @AppStorage("quick4GameTarget") var quick4GameTarget: Int = 2048
    
    @AppStorage("activeGamesSectionEnabled") var activeGamesSectionEnabled: Bool = true
    @AppStorage("gamesWonSectionEnabled") var gamesWonSectionEnabled: Bool = true
    @AppStorage("gamesLostSectionEnabled") var gamesLostSectionEnabled: Bool = true

    // State properties for section expansion
    @Published var isWonSectionExpanded = false
    @Published var isRunningSectionExpanded = true
    @Published var isLostSectionExpanded = false
        
    init() {
        // Initialize expansion states based on the enabled settings
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
