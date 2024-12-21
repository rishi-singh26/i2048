//
//  ParallaxCarouselView.swift
//  i2048
//
//  Created by Rishi Singh on 19/12/24.
//
#if os(iOS)
import SwiftUI

struct ParallaxCarouselView: View {
    var cards: [CarouselCard]
    var cardHeight: CGFloat = 500
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            ScrollView(.horizontal) {
                HStack(spacing: 10){
                    ForEach(cards) { card in
                        GeometryReader(content: { proxy in
                            let cardSize = proxy.size
                            NetworkImageView(card: card, cardSize: cardSize) {
                                OverlayView(card: card)
                            }
                        })
                        .frame(width: size.width - 60, height: size.height - 50)
                        /// Scroll Animation
                        .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                            view
                                .scaleEffect(phase.isIdentity ? 1 : 0.95)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .scrollTargetLayout()
                .frame(height: size.height, alignment: .top)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        })
        .frame(height: cardHeight)
        .padding(.horizontal, -15)
        .padding(.top, 10)
    }
}

struct OverlayView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var artManager: BackgroundArtManager
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    var card: CarouselCard
    
    var body: some View {
        VStack(content: {
            Spacer()
            VStack {
                Text(card.title)
                    .font(.title2.bold())
                Button(action: {
                    if let image = artManager.getImageById(imageId: card.imageId, artistId: card.artistId) {
                        userDefaultsManager.selectNetworkImage(image, colorScheme)
                    }
                }, label: {
                    Text("Set as Game Background")
                        .font(.headline.bold())
                        .foregroundStyle(colorScheme == .dark ? .black : .white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20, style: .continuous))
                })
            }
            .frame(maxWidth: .infinity)
            .padding(15)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .mask(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                    )
                    .blur(radius: 30)
            )
        })
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
#endif
