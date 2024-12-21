//
//  NetworkImageView.swift
//  i2048
//
//  Created by Rishi Singh on 21/12/24.
//

import SwiftUI

struct NetworkImageView<Content: View>: View {
    var card: CarouselCard
    var cardSize: CGSize
    let content: Content

    init(card: CarouselCard, cardSize: CGSize, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.card = card
        self.cardSize = cardSize
    }
    
    var body: some View {
        AsyncImage(url: URL(string: card.image)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: cardSize.width, height: cardSize.height)
                //                        .background(Color(hex: card.backGroundColor))
                    .background(.orange.opacity(0.6))
                    .overlay {
                        content
                    }
                    .clipShape(.rect(cornerRadius: 15))
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cardSize.width, height: cardSize.height)
                    .overlay {
                        content
                    }
                    .clipShape(.rect(cornerRadius: 15))
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
            case .failure:
                Image("Camping-on-the-beach")
                    .resizable()
                    .scaledToFit()
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
}
