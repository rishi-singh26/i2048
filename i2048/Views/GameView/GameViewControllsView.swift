//
//  GameViewControllsView.swift
//  i2048
//
//  Created by Rishi Singh on 23/12/24.
//

import SwiftUI
import SwiftData

struct GameViewControllsView: View {
    @EnvironmentObject var artManager: BackgroundArtManager
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    var game: Game
    
    @State private var showBackgroundImageSheet: Bool = false
    
    var body: some View {
        #if os(iOS)
        IosViewBuilder()
        #elseif os(macOS)
        MacOSViewBuilder()
        #endif
    }
    
    private func IosViewBuilder() -> some View {
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
                Button {
                    showBackgroundImageSheet.toggle()
                } label: {
                    Label("Background Image", systemImage: "photo")
                }
            } header: {
                Text("App Theme")
            } footer: {
                Text("Footer note")
            }
        }
        .frame(minWidth: 350, minHeight: 350)
        .presentationCompactAdaptation(.popover)
        .sheet(isPresented: $showBackgroundImageSheet) {
            BackgroundArtSettings(cardSize: CGSize(width: 550, height: 400), artistImageSize: 50)
        }
    }
    
    private func MacOSViewBuilder() -> some View {
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
            
            BackgroundArtSettings(cardSize: CGSize(width: 130, height: 80), artistImageSize: 30, simpleCarousel: true)
            .padding(.horizontal)
        }
        .frame(minWidth: 350, idealWidth: 400, maxWidth: 450, minHeight: 400, idealHeight: 450, maxHeight: 500, alignment: .leading)
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Game.self, configurations: config)
        let example = Game(name: "Preview Game", gridSize: 4)
        return GameViewControllsView(game: example)
            .modelContainer(container)
            .environmentObject(BackgroundArtManager.shared)
            .environmentObject(UserDefaultsManager.shared)
    } catch {
        fatalError("Failed to created model container")
    }
}
