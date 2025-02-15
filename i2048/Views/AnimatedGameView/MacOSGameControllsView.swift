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
            
            MacOsCarouselView(cards: data, size: CGSize(width: 150, height: 90), game: game)
        }
        .frame(minWidth: 350, idealWidth: 400, maxWidth: 450, minHeight: 200, idealHeight: 250, alignment: .leading)
    }
    
    @ViewBuilder
    func BuildPlatfromBackground(imageData: BackgroundArt) -> some View {
        if #available(macOS 15.0, *) {
            MeshGradient(
                width: 3,
                height: 4,
                points: [
                    [0, 0], [0.5, 0], [1.0, 0],
                    [0, 0.4], [0.5, 0.4], [1.0, 0.4],
                    [0, 0.7], [0.5, 0.7], [1.0, 0.7],
                    [0, 1.0], [0.5, 1.0], [1.0, 1.0]
                ],
                colors: [
                    Color(hex: imageData.color4096), Color(hex: imageData.color2048), Color(hex: imageData.color1024),
                    Color(hex: imageData.color512), Color(hex: imageData.color256), Color(hex: imageData.color128),
                    Color(hex: imageData.color64), Color(hex: imageData.color32), Color(hex: imageData.color16),
                    Color(hex: imageData.color8), Color(hex: imageData.color4), Color(hex: imageData.color2)
                ]
            )
        } else {
            LinearGradient(
                colors: [
                    Color(hex: imageData.color4096), Color(hex: imageData.color2048), Color(hex: imageData.color1024),
                    Color(hex: imageData.color512), Color(hex: imageData.color256), Color(hex: imageData.color128),
                    Color(hex: imageData.color64), Color(hex: imageData.color32), Color(hex: imageData.color16),
                    Color(hex: imageData.color8), Color(hex: imageData.color4), Color(hex: imageData.color2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .hueRotation(.degrees(45))
        }
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
