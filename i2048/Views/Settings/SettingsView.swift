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
                    Toggle(isOn: $userDefaultsManager.activeGamesSectionEnabled.animation()) {
                        Label("Active Games", systemImage: userDefaultsManager.activeGamesSectionEnabled ? "gamecontroller.fill" : "gamecontroller")
                    }
                    .toggleStyle(.switch)
                    Toggle(isOn: $userDefaultsManager.gamesWonSectionEnabled.animation()) {
                        Label("Games Won", systemImage: userDefaultsManager.gamesWonSectionEnabled ? "trophy.fill" : "trophy")
                    }
                    .toggleStyle(.switch)
                    Toggle(isOn: $userDefaultsManager.gamesLostSectionEnabled.animation()) {
                        Label("Games Lost", systemImage: userDefaultsManager.gamesLostSectionEnabled ? "exclamationmark.warninglight.fill" : "exclamationmark.warninglight")
                    }
                    .toggleStyle(.switch)
                } footer: {
                    Text("Choose which sections to show at app launch. Selected sections will be expanded at app launch")
                }
                
                Section {
                    Toggle(isOn: $userDefaultsManager.hapticsEnabled.animation()) {
                        Label("Enable Haptics", systemImage: userDefaultsManager.hapticsEnabled ? "hand.tap.fill" : "hand.tap")
                    }
                    .toggleStyle(.switch)
                    Toggle(isOn: $userDefaultsManager.soundEnabled.animation()) {
                        Label("Enable Sound", systemImage: userDefaultsManager.soundEnabled ? "speaker.wave.3.fill" : "speaker.wave.3")
                    }
                    .toggleStyle(.switch)
                } header: {
                    Text("Game Feedback")
                } footer: {
                    Text("Enable game feedbacks with Haptics and Sound")
                }
                
                Section {
                    TextField("Game name prefix", text: $userDefaultsManager.quickGameNamePrefix)
                        .textInputAutocapitalization(.words)
                    Toggle(isOn: $userDefaultsManager.quickGameAllowUndo.animation()) {
                        Label("Allow Undo", systemImage: userDefaultsManager.quickGameAllowUndo ? "arrow.uturn.backward.square.fill" : "arrow.uturn.backward.square")
                    }
                    .toggleStyle(.switch)
                    Picker(selection: $userDefaultsManager.quickGameNewBlocNum.animation()) {
                        Text("2")
                            .tag(2)
                        Text("4")
                            .tag(4)
                        Text("2 or 4 (Random)")
                            .tag(0)
                    } label: {
                        Label {
                            Text("New Block")
                        } icon: {
                            AnimatedIconsView(symbols: Game.getNewBlockIcon(userDefaultsManager.quickGameNewBlocNum), animationDuration: 2.0)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Quick Game Defaults")
                } footer: {
                    Text("Select default values for quick game")
                }
                
                Section {
                    NavigationLink(destination: Text("Destination")) {
                        Label("Privacy Policy", systemImage: "bolt.shield")
                    }
                    NavigationLink(destination: Text("Destination")) {
                        Label("Terms of Use", systemImage: "list.bullet.rectangle.portrait")
                    }
                    NavigationLink(destination: Text("Destination")) {
                        Label("Usage License", systemImage: "checkmark.seal")
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
