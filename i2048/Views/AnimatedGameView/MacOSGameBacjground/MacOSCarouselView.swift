//
//  MacOsCarouselView.swift
//  i2048
//
//  Created by Rishi Singh on 13/02/25.
//

#if os(macOS)
import SwiftUI

struct MacOsCarouselView: View {
    var cards: [BackgroundArt]
    var size: CGSize
    var game: Game
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            GeometryReader(content: { geometry in
                let gSize = geometry.size
                ScrollView(.horizontal) {
                    BuildHorisontalArea(gSize.height)
                }
                .content.offset(x: -CGFloat(currentIndex) * (size.width + 10))
                .scrollIndicators(.hidden)
            })
            .frame(height: size.height)
            .padding([.leading, .trailing, .top], 30)
            CarouselControlls(cardsCount: cards.count, currentIndex: $currentIndex)
        }
    }
    
    @ViewBuilder
    func BuildHorisontalArea(_ height: CGFloat) -> some View {
        HStack(spacing: 10){
            ForEach(cards) { card in
                BuildPlatfromBackground(imageData: card)
                    .cornerRadius(10)
                    .frame(width: 150, height: 100)
                    .onTapGesture {
                        game.selectNetworkImage(card)
                    }
            }
        }
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
