//
//  GeneralSettingsView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

#if os(macOS)
import SwiftUI

struct GeneralSettingsView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var artManager: BackgroundArtManager
    
    var body: some View {
        ScrollView {
            
            MacCustomSection(header: "Choose which sections to show at app launch", footer: "Selected sections will be expanded at app launch") {
                HStack {
                    Label("Active Games", systemImage: userDefaultsManager.activeGamesSectionEnabled ? "gamecontroller.fill" : "gamecontroller")
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.activeGamesSectionEnabled.animation())
                        .toggleStyle(.switch)
                }
                Divider()
                HStack {
                    Label("Games Won", systemImage: userDefaultsManager.gamesWonSectionEnabled ? "trophy.fill" : "trophy")
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.gamesWonSectionEnabled.animation())
                        .toggleStyle(.switch)
                }
                Divider()
                HStack {
                    Label("Games Lost", systemImage: userDefaultsManager.gamesLostSectionEnabled ? "exclamationmark.warninglight.fill" : "exclamationmark.warninglight")
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.gamesLostSectionEnabled.animation())
                        .toggleStyle(.switch)
                }
            }
            
            MacCustomSection(header: "Game Geedback", footer: "Enable game feedback with Sound") {
                HStack {
                    Label("Enable Sound", systemImage: userDefaultsManager.soundEnabled ? "speaker.wave.3.fill" : "speaker.wave.3")
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.soundEnabled.animation())
                        .toggleStyle(.switch)
                }
            }
            
            MacCustomSection(header: "") {
                CustomLabel(leadingImageName: "bolt.shield", trailingImageName: "chevron.right", title: "Privacy Policy")
                Divider()
                    .padding(.vertical, 2)
                CustomLabel(leadingImageName: "list.bullet.rectangle.portrait", trailingImageName: "chevron.right", title: "Terms of Use")
                Divider()
                    .padding(.vertical, 2)
                CustomLabel(leadingImageName: "checkmark.seal", trailingImageName: "chevron.right", title: "Usage License")
                Divider()
                    .padding(.top, 2)
                Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                    CustomLabel(leadingImageName: "lock.open.display", trailingImageName: "arrow.up.right", title: "Open Source Code")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
#endif
