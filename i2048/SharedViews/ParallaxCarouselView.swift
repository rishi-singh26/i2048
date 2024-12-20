//
//  ParallaxCarouselView.swift
//  i2048
//
//  Created by Rishi Singh on 19/12/24.
//

import SwiftUI

struct ParallaxCard: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}

struct ParallaxCarouselView: View {
    var cards: [ParallaxCard] = []
    var cardHeight: CGFloat = 500
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            ScrollView(.horizontal) {
                /// Try to change it back to 10
                HStack(spacing: 5) {
                    ForEach(cards) { card in
                        /// In order to move the card in Reverse Direction
                        /// (Parallax Effect)
                        GeometryReader(content: { proxy in
                            let cardSize = proxy.size
                            /// Simple parallax effect (1)
                             let minX = proxy.frame(in: .scrollView).minX - 30
//                                    let minX = min((proxy.frame(in: .scrollView).minX - 30) * 1.4, size.width * 1.4)≥
                            
                            AsyncImage(url: URL(string: card.image)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: cardSize.width, height: cardSize.height)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .offset(x: -minX)
                                        .frame(width: proxy.size.width * 1.4)
        //                                        .frame(width: proxy.size.width * 2.5)
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .overlay {
                                            OverlayView(card)
                                        }
                                        .clipShape(.rect(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                case .failure:
                                    Image(systemName: "Camping-on-the-beach")
                                        .resizable()
                                        .scaledToFit()
                                @unknown default:
                                    EmptyView()
                                }
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
    
    @ViewBuilder
    func OverlayView(_ card: ParallaxCard) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.5),
                .black
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(card.title)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                
                Text(card.subTitle)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
            })
            .padding(20)
        })
    }
}

#Preview {
    ParallaxCarouselView()
}
