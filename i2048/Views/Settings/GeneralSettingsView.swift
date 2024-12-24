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
            GroupBox {
                VStack {
                    HStack {
                        Label("Enable Sound", systemImage: userDefaultsManager.soundEnabled ? "speaker.wave.3.fill" : "speaker.wave.3")
                        Spacer()
                        Toggle("", isOn: $userDefaultsManager.soundEnabled.animation())
                            .toggleStyle(.switch)
                    }
                    Divider()
                    HStack {
                        Label("Game Screen Theme", systemImage: userDefaultsManager.colorScheme ? "warninglight.fill" : "warninglight")
                        Spacer()
                        Toggle("", isOn: $userDefaultsManager.colorScheme.animation())
                            .toggleStyle(.switch)
                    }
                }
                .padding(6)
            }
            .padding(.top)
            .padding(.horizontal)
            
            GroupBox {
                VStack {
                    CustomLabel(leadingImageName: "bolt.shield", trailingImageName: "chevron.right", title: "Privacy Policy")
                    Divider()
                        .padding(.vertical, 2)
                    CustomLabel(leadingImageName: "list.bullet.rectangle.portrait", trailingImageName: "chevron.right", title: "Terms of Use")
                    Divider()
                        .padding(.vertical, 2)
                    CustomLabel(leadingImageName: "licenseplate", trailingImageName: "chevron.right", title: "Usage License")
                    Divider()
                        .padding(.top, 2)
                    Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                        CustomLabel(leadingImageName: "lock.open.display", trailingImageName: "arrow.up.right", title: "Open Source Code")
                    }
                }
                .padding([.leading, .top, .bottom], 6)
                .padding(.trailing, 12)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
}
#endif
