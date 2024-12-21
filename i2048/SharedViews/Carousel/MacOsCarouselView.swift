//
//  MacOsCarouselView.swift
//  i2048
//
//  Created by Rishi Singh on 21/12/24.
//

#if os(macOS)
import SwiftUI

struct MacOsCarouselView: View {
    var cards: [CarouselCard]
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            GeometryReader(content: { geometry in
                let size = geometry.size
                ScrollView(.horizontal) {
                    HStack(spacing: 10){
                        ForEach(cards) { card in
                            NetworkImageView(card: card, cardSize: CGSize(width: 550, height: size.height)) {
                                MacOsOverlayView(card: card)
                            }
                        }
                    }
                }
                .content.offset(x: -CGFloat(currentIndex) * 560)
                .scrollIndicators(.hidden)
            })
            .frame(height: 400)
            .padding([.leading, .trailing, .top], 30)
            CarouselControlls(cardsCount: cards.count, currentIndex: $currentIndex)
        }
    }
}

struct MacOsOverlayView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var artManager: BackgroundArtManager
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    var card: CarouselCard
    
    var body: some View {
        VStack(content: {
            Spacer()
            HStack {
                Text(card.title)
                    .font(.title2.bold())
                Spacer()
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
                .buttonStyle(PlainButtonStyle())
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

struct CarouselControlls: View {
    var cardsCount: Int
    @Binding var currentIndex: Int
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    currentIndex = max(currentIndex - 1, 0)
                }
            }) {
                Image(systemName: "chevron.compact.left")
                    .font(.largeTitle.bold())
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentIndex == 0) // Disable if at the beginning
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    currentIndex = min(currentIndex + 1, cardsCount - 1)
                }
            }) {
                Image(systemName: "chevron.compact.right")
                    .font(.largeTitle.bold())
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentIndex == cardsCount - 1) // Disable if at the end
        }
    }
}


#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
#endif
