//
//  SettingsView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
        
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
                    NavigationLink(destination: BackgroundArtSettings(
                        cardSize: CGSize(width: 10, height: 10),
                        artistImageSize: 50,
                        simpleCarousel: false
                    )) {
                        Label("Background Image", systemImage: "photo")
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
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "wrench")
                }
                .tag(1)
            
            BackgroundArtSettings(cardSize: CGSize(width: 550, height: 400), artistImageSize: 50)
                .tabItem {
                    Label("Background", systemImage: "photo")
                }
                .tag(2)
            
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.square")
                }
                .tag(3)
        }
//        .scenePadding()
        .frame(maxWidth: 640, minHeight: 600)
    }
#endif
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
