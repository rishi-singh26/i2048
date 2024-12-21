//
//  SettingsView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedTab: String?
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    let screens = ["General", "Background Image", "About"]
    
    var body: some View {
        Group {
#if os(iOS)
            IosViewBuilder()
#else
            MacOSViewBuilder()
#endif
        }
    }
    
#if os(iOS)
    @ViewBuilder
    func IosViewBuilder() -> some View {
        NavigationView {
            List {
                Section {
                    Toggle(isOn: $userDefaultsManager.hapticsEnabled) {
                        Label("Enable Haptics", systemImage: userDefaultsManager.hapticsEnabled ? "hand.tap.fill" : "hand.tap")
                    }
                    .toggleStyle(.switch)
                    Toggle(isOn: $userDefaultsManager.soundEnabled.animation()) {
                        Label("Enable Sound", systemImage: userDefaultsManager.soundEnabled ? "speaker.wave.3.fill" : "speaker.wave.3")
                    }
                    .toggleStyle(.switch)
                } header: {
                    Text("General")
                } footer: {
                    Text("Enaable game feedbacks with haptics")
                }
                
                Section {
                    Toggle(isOn: $userDefaultsManager.colorScheme.animation(), label: {
                        Label("Game Screen Theme", systemImage: userDefaultsManager.colorScheme ? "warninglight.fill" : "warninglight")
                    })
                    NavigationLink(destination: BackgroundArtSettings()) {
                        Label("Background Image", systemImage: "photo")
                        //                        Text("Background Image")
                    }
                } header: {
                    Text("App Theme")
                } footer: {
                    Text("Footer note")
                }
                
                Section {
                    NavigationLink(destination: Text("Destination")) {
                        Label("Privacy Policy", systemImage: "bolt.shield")
                    }
                    NavigationLink(destination: Text("Destination")) {
                        Label("Terms of Use", systemImage: "list.bullet.rectangle.portrait")
                    }
                    NavigationLink(destination: Text("Destination")) {
                        Label("Usage License", systemImage: "licenseplate")
                    }
                    
                    Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                        CustomLabel(leadingImageName: "lock.open.display", trailingImageName: "arrow.up.right", title: "Open Source Code")
                    }
                }
                
                Section {
                    NavigationLink(destination: AboutView()) {
                        Label("About i2048", systemImage: "info.square")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
#endif
    
#if os(macOS)
    @ViewBuilder
    func MacOSViewBuilder() -> some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                NavigationLink(value: screens[2]) {
                    Label(screens[0], systemImage: "gear")
                }
                NavigationLink(value: screens[1]) {
                    Label(screens[1], systemImage: "photo")
                }
                NavigationLink(value: screens[0]) {
                    Label(screens[2], systemImage: "info.square")
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            switch selectedTab {
            case screens[0]:
                GeneralSettingsView()
            case screens[1]:
                BackgroundArtSettings()
            case screens[2]:
                AboutView()
            default:
                GeneralSettingsView()
            }
        }
    }
#endif
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
}
