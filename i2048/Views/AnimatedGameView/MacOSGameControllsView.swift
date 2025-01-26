//
//  MacOSGameControllsView.swift
//  i2048
//
//  Created by Rishi Singh on 24/01/25.
//

import SwiftUI
import SwiftData

struct MacOSGameControllsView: View {
    var game: Game
    
    var body: some View {
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
                        }).animation()
                    )
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
        return MacOSGameControllsView(game: example)
            .modelContainer(container)
            .environmentObject(BackgroundArtManager.shared)
            .environmentObject(UserDefaultsManager.shared)
    } catch {
        fatalError("Failed to created model container")
    }
}
