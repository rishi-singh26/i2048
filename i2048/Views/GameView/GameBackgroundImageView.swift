//
//  GameBackgroundImageView.swift
//  i2048
//
//  Created by Rishi Singh on 21/12/24.
//

import SwiftUI
import Kingfisher

struct GameBackgroundImageView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    var body: some View {
        if (colorScheme == .light && userDefaultsManager.isNetworkImageSelected) || (colorScheme == .dark && userDefaultsManager.isDarkNetworkImageSelected) {
            KFImage(URL(string: colorScheme == .dark ? userDefaultsManager.darkImageUrl : userDefaultsManager.imageUrl))
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
        } else {
            Image("Camping-on-the-beach")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    GameBackgroundImageView()
        .environmentObject(UserDefaultsManager.shared)
}
