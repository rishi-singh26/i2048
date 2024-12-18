//
//  GeneralSettingsView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI

struct GeneralSettingsView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    var body: some View {
        Form {
            
            Text("High Score: \(userDefaultsManager.highScore)")
                .font(.largeTitle)
            Toggle("Do you want vibration feedback while playing?", isOn: $userDefaultsManager.hapticsEnabled)

            Toggle("Enable Haptics", isOn: $userDefaultsManager.hapticsEnabled)

            Toggle("Do you want audio playback while playing?", isOn: $userDefaultsManager.soundEnabled)

            Picker("Theme Mode", selection: $userDefaultsManager.appThemeMode) {
                Text("Automatic").tag(AppThemeMode.automatic)
                Text("Image Based").tag(AppThemeMode.imageBased)
                Text("Dark").tag(AppThemeMode.dark)
                Text("Light").tag(AppThemeMode.light)
            }
        }
    }
}

#Preview {
    GeneralSettingsView()
        .environmentObject(UserDefaultsManager.shared)
}
