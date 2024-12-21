//
//  BackgroundArtSettings.swift
//  i2048
//
//  Created by Rishi Singh on 19/12/24.
//

import SwiftUI

struct BackgroundArtSettings: View {
    @EnvironmentObject var artManager: BackgroundArtManager
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                ForEach(Array(artManager.backgroundImages.enumerated()), id: \.offset) {index, artist in
                    ArtistView(artist: artist)
                }
            }
            .padding(15)
        }
#if os(iOS)
        .navigationTitle("Background Image")
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

struct ArtistView: View {
    var artist: BackgroundArtist
    var parallaxCards: [CarouselCard] = []
    
    init(artist: BackgroundArtist) {
        self.artist = artist
        self.parallaxCards = artist.images.map({ image in
            CarouselCard(
                imageId: image.id,
                artistId: artist.id,
                artistName: artist.name,
                title: image.name,
                subTitle: artist.name,
                image: image.previewUrl,
                backGroundColor: image.backGroundColor
            )
        })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            HStack(alignment: .center, spacing: 0) {
                NetworkAvatar(url: artist.profileImage, width: 50, height: 50)
                Text(artist.name)
                    .font(.title.bold())
                    .fontWeight(.black)
                    .padding(.horizontal, 20)
            }
            
#if os(iOS)
            ParallaxCarouselView(cards: parallaxCards, cardHeight: 450)
#else
            MacOsCarouselView(cards: parallaxCards)
#endif
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
