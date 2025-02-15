//
//  SettingsView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @State private var showIAPSheet: Bool = false
        
    var body: some View {
#if os(iOS)
        IosViewBuilder()
#else
        MacOSViewBuilder()
#endif
    }
    
#if os(iOS)
    @ViewBuilder
    func IosViewBuilder() -> some View {
        NavigationView {
            List {
                Button {
                    showIAPSheet = true
                } label: {
                    Label("Buy Premium", systemImage: "crown.fill")
                }
                .listItemTint(.yellow)
                .listRowBackground(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.red.opacity(0.6), Color.yellow]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                
                Section {
                    Toggle(isOn: Binding(get: {
                        userDefaultsManager.hapticsEnabled
                    }, set: { newVal in
                        if userDefaultsManager.isPremiumUser {
                            withAnimation {
                                userDefaultsManager.hapticsEnabled = newVal
                            }
                        } else {
                            showIAPSheet = true
                        }
                    })) {
                        Label("Enable Haptics", systemImage: userDefaultsManager.hapticsEnabled ? "hand.tap.fill" : "hand.tap")
                    }
                    .toggleStyle(.switch)
//                    Toggle(isOn: $userDefaultsManager.soundEnabled.animation()) {
//                        Label("Enable Sound", systemImage: userDefaultsManager.soundEnabled ? "speaker.wave.3.fill" : "speaker.wave.3")
//                    }
//                    .toggleStyle(.switch)
                } footer: {
                    Text("Enable game feedback with Haptics")
                }
                
                Section {
                    TextField("Game name prefix", text: $userDefaultsManager.quick3GameNamePrefix)
                        .textInputAutocapitalization(.words)
                    Toggle(isOn: $userDefaultsManager.quick3GameAllowUndo.animation()) {
                        Label("Allow Undo", systemImage: userDefaultsManager.quick3GameAllowUndo ? "arrow.uturn.backward.square.fill" : "arrow.uturn.backward.square")
                    }
                    .toggleStyle(.switch)
                    Picker(selection: $userDefaultsManager.quick3GameNewBlocNum.animation()) {
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
                            AnimatedIconsView(symbols: Game.getNewBlockIcon(userDefaultsManager.quick3GameNewBlocNum), animationDuration: 2.0)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    Picker("Game Target Score", systemImage: "target", selection: $userDefaultsManager.quick3GameTarget) {
                        Text("128")
                            .tag(128)
                        Text("256")
                            .tag(256)
                        Text("512")
                            .tag(512)
                        Text("1024")
                            .tag(1024)
                        Text("2048")
                            .tag(2048)
                        Text("4096")
                            .tag(4096)
                        Text("8192")
                            .tag(8192)
                        Text("16384")
                            .tag(16384)
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Quick 3x3 Game Defaults")
                } footer: {
                    Text("Quick game can be launched by pressing and holding on the Add Game button")
                }
                
                Section {
                    TextField("Game name prefix", text: $userDefaultsManager.quick4GameNamePrefix)
                        .textInputAutocapitalization(.words)
                    Toggle(isOn: $userDefaultsManager.quick4GameAllowUndo.animation()) {
                        Label("Allow Undo", systemImage: userDefaultsManager.quick4GameAllowUndo ? "arrow.uturn.backward.square.fill" : "arrow.uturn.backward.square")
                    }
                    .toggleStyle(.switch)
                    Picker(selection: $userDefaultsManager.quick4GameNewBlocNum.animation()) {
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
                            AnimatedIconsView(symbols: Game.getNewBlockIcon(userDefaultsManager.quick4GameNewBlocNum), animationDuration: 2.0)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    Picker("Game Target Score", systemImage: "target", selection: $userDefaultsManager.quick4GameTarget) {
                        Text("128")
                            .tag(128)
                        Text("256")
                            .tag(256)
                        Text("512")
                            .tag(512)
                        Text("1024")
                            .tag(1024)
                        Text("2048")
                            .tag(2048)
                        Text("4096")
                            .tag(4096)
                        Text("8192")
                            .tag(8192)
                        Text("16384")
                            .tag(16384)
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Quick 4x4 Game Defaults")
                } footer: {
                    Text("Quick game can be launched by pressing and holding on the Add Game button")
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
                .disabled(!userDefaultsManager.isPremiumUser)
                
                Section {
                    NavigationLink(destination: AboutView()) {
                        Label("About i2048", systemImage: "info.square")
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showIAPSheet, content: {
                IAPView()
            })
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
            
            MacOsKeyBindingsView()
                .tabItem {
                    Label("Key Bindings", systemImage: "keyboard")
                }
                .tag(2)
            
            IAPView(isWindow: true)
                .tabItem {
                    Label("Premium", systemImage: "crown.fill")
                }
                .tag(4)
            
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
