//
//  GameBackgroundImageView.swift
//  i2048
//
//  Created by Rishi Singh on 21/12/24.
//

import SwiftUI
import Kingfisher

struct GameBackgroundImageView: View {
    var game: Game?

    var body: some View {
        GeometryReader { geometry in
            if (game != nil && game!.imageUrl != "") {
                KFImage(URL(string: game!.imageUrl))
                    .cacheOriginalImage() // Cache original image
                // .onSuccess { result in
                //     print("✅ Image loaded successfully: \(result.cacheType)")
                // }
                // .onFailure { error in
                //     print("❌ Failed to load image: \(error)")
                // }
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: geometry.size.width)
            } else {
                Image("Camping-on-the-beach")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: geometry.size.width)
            }
        }
    }
}

//#Preview {
//    GameBackgroundImageView()
//}
