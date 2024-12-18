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
        ScrollView {
            GroupBox {
                VStack {
                    HStack {
                        Text("Enable Haptics")
                        Spacer()
                        Toggle("", isOn: $userDefaultsManager.hapticsEnabled)
                            .toggleStyle(.switch)
                    }
                    Divider()
                    HStack {
                        Text("Enable Soubd")
                        Spacer()
                        Toggle("", isOn: $userDefaultsManager.soundEnabled)
                            .toggleStyle(.switch)
                    }
                    Divider()
                    HStack {
                        Text("App theme")
                        Spacer()
                        Picker(selection: $userDefaultsManager.appThemeMode, label: Text("")) {
                            Text("Automatic").tag(AppThemeMode.automatic)
                            Text("Image Based").tag(AppThemeMode.imageBased)
                            Text("Dark").tag(AppThemeMode.dark)
                            Text("Light").tag(AppThemeMode.light)
                        }
                        .scaledToFit()
                    }
                }
                .padding(4)
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
}

#Preview {
    GeneralSettingsView()
        .environmentObject(UserDefaultsManager.shared)
}
