//
//  ArtistView.swift
//  i2048
//
//  Created by Rishi Singh on 24/12/24.
//

import SwiftUI
import SwiftData

struct ArtistView: View {
    var artist: BackgroundArtist
    var cardSize: CGSize
    var artistImageSize: Double
    var simpleCarousel: Bool
    var artistNameFont: Font
    var game: Game
    private var parallaxCards: [CarouselCard] = []
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var artManager: BackgroundArtManager
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    init(
        artist: BackgroundArtist,
        cardSize: CGSize,
        artistImageSize: Double,
        game: Game,
        simpleCarousel: Bool = false,
        artistNameFont: Font = .title.bold()
    ) {
        self.artist = artist
        self.cardSize = cardSize
        self.artistImageSize = artistImageSize
        self.game = game
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
        self.simpleCarousel = simpleCarousel
        self.artistNameFont = artistNameFont
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            HStack(alignment: .center, spacing: 0) {
                NetworkAvatar(url: artist.profileImage, width: artistImageSize, height: artistImageSize)
                Text(artist.name)
                    .font(artistNameFont)
                    .fontWeight(.black)
                    .padding(.horizontal, 20)
            }
            
            if simpleCarousel {
                ScrollView(.horizontal) {
                    HStack(spacing: 10){
                        ForEach(parallaxCards) { card in
                            VStack(alignment: .center) {
                                NetworkImageView(card: card, cardSize: cardSize, radius: 8)
                                    .onTapGesture {
                                        selectImage(card: card)
                                    }
                                Text(card.title)
                                    .padding(.bottom, 10)
                            }
                        }
                    }
                }
            } else {
                
#if os(iOS)
                ParallaxCarouselView(cards: parallaxCards, cardHeight: 450, game: game)
#else
                MacOsCarouselView(cards: parallaxCards, size: cardSize, game: game)
#endif
            }
        }
    }
    
    func selectImage(card: CarouselCard) {
        if let image = artManager.getImageById(imageId: card.imageId, artistId: card.artistId) {
            game.selectNetworkImage(image)
        }
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
