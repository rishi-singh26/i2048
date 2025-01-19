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
    
#if os(iOS)
    private func IosViewBuilder() -> some View {
        List {
            Section {
                Toggle(isOn: $userDefaultsManager.hapticsEnabled.animation()) {
                    Label("Enable Haptics", systemImage: userDefaultsManager.hapticsEnabled ? "hand.tap.fill" : "hand.tap")
                }
                .toggleStyle(.switch)
//                Toggle(isOn: $userDefaultsManager.soundEnabled.animation()) {
//                    Label("Enable Sound", systemImage: userDefaultsManager.soundEnabled ? "speaker.wave.3.fill" : "speaker.wave.3")
//                }
//                .toggleStyle(.switch)
            } footer: {
                Text("Enable game feedback with Haptics")
            }
            
            Section {
                Toggle(isOn: Binding(
                    get: { game.gameColorMode },
                    set: { newValue in
                        withAnimation {
                            game.gameColorMode = newValue
                        }
                    }
                ).animation(), label: {
                    Label("Game Screen Theme", systemImage: game.gameColorMode ? "warninglight.fill" : "warninglight")
                })
                Button {
                    showBackgroundImageSheet.toggle()
                } label: {
                    Label("Background Image", systemImage: "photo")
                }
            } header: {
                Text("Game Theme")
            } footer: {
                Text("Customize game interface with Background Image and Colors")
            }
        }
        .frame(minWidth: 350, minHeight: 350)
        .presentationCompactAdaptation(.popover)
        .sheet(isPresented: $showBackgroundImageSheet) {
            BackgroundArtSettings(cardSize: CGSize(width: 550, height: 400), artistImageSize: 50, game: game)
        }
    }
#endif
    
    private func MacOSViewBuilder() -> some View {
        ScrollView {

            MacCustomSection(header: "") {
//                HStack {
//                    Label("Enable Sound", systemImage: userDefaultsManager.soundEnabled ? "speaker.wave.3.fill" : "speaker.wave.3")
//                    Spacer()
//                    Toggle("", isOn: $userDefaultsManager.soundEnabled.animation())
//                        .toggleStyle(.switch)
//                }
//                Divider()
                HStack {
                    Label("Game Screen Theme", systemImage: game.gameColorMode ? "warninglight.fill" : "warninglight")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { game.gameColorMode },
                        set: { newValue in
                            withAnimation {
                                game.gameColorMode = newValue
                            }
                    }).animation())
                        .toggleStyle(.switch)
                }
            }
            
            BackgroundArtSettings(cardSize: CGSize(width: 130, height: 80), artistImageSize: 30, game: game, simpleCarousel: true)
            .padding(.horizontal)
        }
        .frame(minWidth: 350, idealWidth: 400, maxWidth: 450, minHeight: 400, idealHeight: 450, alignment: .leading)
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
