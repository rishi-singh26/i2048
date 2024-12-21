//
//  GameBackgroundImageView.swift
//  i2048
//
//  Created by Rishi Singh on 21/12/24.
//

import SwiftUI

struct GameBackgroundImageView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    var body: some View {
//        if (colorScheme == .light && userDefaultsManager.isNetworkImageSelected) || (colorScheme == .dark && userDefaultsManager.isDarkNetworkImageSelected) {
//            AsyncImage(url: URL(string: colorScheme == .dark ? userDefaultsManager.darkImageUrl : userDefaultsManager.imageUrl)) { phase in
//                switch phase {
//                case .empty:
//                    EmptyView()
//                    //                    ProgressView()
//                    //                        .scaledToFill()
//                    //                        .ignoresSafeArea()
//                case .success(let image):
//                    image
//                        .resizable()
//                        .scaledToFill()
//                        .ignoresSafeArea()
//                case .failure:
//                    Image("Camping-on-the-beach")
//                        .resizable()
//                        .scaledToFit()
//                        .ignoresSafeArea()
//                @unknown default:
//                    EmptyView()
//                }
//            }
//        } else {
            Image("Camping-on-the-beach")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
//        }
    }
}

#Preview {
    GameBackgroundImageView()
        .environmentObject(UserDefaultsManager.shared)
}
