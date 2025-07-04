//
//  MacOSGameControllsView.swift
//  i2048
//
//  Created by Rishi Singh on 24/01/25.
//

#if os(macOS)
import SwiftUI
import SwiftData

struct MacOSGameControllsView: View {
    @Environment(\.openWindow) private var openWindow
    var game: Game
    var data: [BackgroundArt]
    
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
                    Picker("", selection: Binding(
                        get: { game.gameColorMode },
                        set: { newValue in
                            withAnimation {
                                game.gameColorMode = newValue
                            }
                        }).animation()) {
                            Text("Light")
                                .tag(true)
                            Text("Dark")
                                .tag(false)
                        }
                        .pickerStyle(.segmented)
                }
                Divider()
                    .padding(.vertical, 3)
                HStack {
                    Label("Share Game", systemImage: "square.and.arrow.up")
                    Spacer()
                    Button("Share   ⇧⌘S") {
                        openWindow(id: "shareGame")
                    }
                }
            }
            
            MacOsCarouselView(cards: data, size: CGSize(width: 150, height: 90), game: game)
        }
        .frame(minWidth: 350, idealWidth: 400, maxWidth: 450, minHeight: 250, idealHeight: 300, alignment: .leading)
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Game.self, configurations: config)
        let example = Game(name: "Preview Game", gridSize: 4)
        return MacOSGameControllsView(game: example, data: [])
            .modelContainer(container)
            .environmentObject(BackgroundArtManager.shared)
            .environmentObject(UserDefaultsManager.shared)
    } catch {
        fatalError("Failed to created model container")
    }
}
#endif
