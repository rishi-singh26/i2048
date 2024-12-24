//
//  NetworkImageView.swift
//  i2048
//
//  Created by Rishi Singh on 21/12/24.
//

import SwiftUI
import Kingfisher

struct NetworkImageView<Content: View>: View {
    var card: CarouselCard
    var cardSize: CGSize
    let content: Content
    var radius: Double

    init(
        card: CarouselCard,
        cardSize: CGSize,
        radius: Double = 15,
        @ViewBuilder content: () -> Content = { EmptyView()}
    ) {
        self.content = content()
        self.card = card
        self.cardSize = cardSize
        self.radius = radius
    }
    
    var body: some View {
        KFImage(URL(string: card.image))
            .cacheOriginalImage() // Cache original image
//            .onSuccess { result in
//                print("✅ Image loaded successfully: \(result.cacheType)")
//            }
//            .onFailure { error in
//                print("❌ Failed to load image: \(error)")
//            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: cardSize.width, height: cardSize.height)
            .overlay {
                content
            }
            .clipShape(.rect(cornerRadius: radius))
            .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
}
