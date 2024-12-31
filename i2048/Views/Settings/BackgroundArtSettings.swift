//
//  BackgroundArtSettings.swift
//  i2048
//
//  Created by Rishi Singh on 19/12/24.
//

import SwiftUI

struct BackgroundArtSettings: View {
    @EnvironmentObject private var artManager: BackgroundArtManager
    var cardSize: CGSize
    var artistImageSize: Double
    var game: Game
    var simpleCarousel: Bool = false
    
    
    
    var body: some View {
#if os(iOS)
        NavigationView {
            ArtListBuilder()
            .navigationTitle("Background Image")
            .navigationBarTitleDisplayMode(.inline)
        }
#elseif os(macOS)
        ArtListBuilder()
#endif
    }
    
    private func ArtListBuilder() -> some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                ForEach(Array(artManager.backgroundImages.enumerated()), id: \.offset) {index, artist in
                    ArtistView(
                        artist: artist,
                        cardSize: cardSize,
                        artistImageSize: artistImageSize,
                        game: game,
                        simpleCarousel: simpleCarousel,
                        artistNameFont: simpleCarousel ? .title2.bold() : .title.bold()
                    )
                }
            }
            .padding(15)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
