//
//  GameBackgroundImageView.swift
//  i2048
//
//  Created by Rishi Singh on 21/12/24.
//

import SwiftUI

struct GameBackgroundImageView: View {
    var game: Game?
        
    private let startColor: Color = .blue
    private let endColor: Color = .green

    var body: some View {
        if (game != nil && game!.imageUrl != "") {
            if #available(iOS 18.0, *) {
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
                        Color(hex: game!.color2), Color(hex: game!.color4), Color(hex: game!.color8),
                        Color(hex: game!.color16), Color(hex: game!.color32), Color(hex: game!.color64),
                        Color(hex: game!.color128), Color(hex: game!.color256), Color(hex: game!.color512),
                        Color(hex: game!.color1024), Color(hex: game!.color2048), Color(hex: game!.color4096),
                    ]
                )
                .ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [
                        Color(hex: game!.color2), Color(hex: game!.color4), Color(hex: game!.color8),
                        Color(hex: game!.color16), Color(hex: game!.color32), Color(hex: game!.color64),
                        Color(hex: game!.color128), Color(hex: game!.color256), Color(hex: game!.color512),
                        Color(hex: game!.color1024), Color(hex: game!.color2048), Color(hex: game!.color4096),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                    .edgesIgnoringSafeArea(.all)
                    .hueRotation(.degrees(45))
            }
        } else {
            LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .hueRotation(.degrees(45))
        }
    }
}

//#Preview {
//    GameBackgroundImageView()
//}
