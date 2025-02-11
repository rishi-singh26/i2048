//
//  IosGameBackgroundSelectionView.swift
//  i2048
//
//  Created by Rishi Singh on 04/02/25.
//

import SwiftUI

struct IosGameBackgroundSelectionView: View {
    @EnvironmentObject var backgrounArtManager: BackgroundArtManager
    @EnvironmentObject var gameLogic: GameLogic
    @Environment(\.dismiss) var dismiss
    @State private var imagesData: [BackgroundArt]
    
    init(imagesData: [BackgroundArt]) {
        self.imagesData = imagesData
    }
    
    var data: Binding<[BackgroundArt]> {
        return Binding(get: {
            imagesData
        }, set: { value, transaction in
            imagesData = value
        })
    }
    
    var body: some View {
        NavigationView {
            IosGameBackgroundView(
                data: data,
                content: { $item in
                    BuildPlatfromBackground(imageData: item)
                        .cornerRadius(20)
                        .frame(height: 500)
                        .onTapGesture {
                            if let selectedGame = gameLogic.selectedGame {
                                selectedGame.selectNetworkImage(item)
                            }
                        }
                },
                titleContent: { $item in
                    Text("")
                    //                Text(item.name)
                    //                    .font(.title3.bold())
                    //                    .padding(.bottom, 35)
                    //                    .frame(height: 100)
                }
                //            activeId: imagesData.last?.id ?? nil
            )
            /// Use safe area padding to avoid clipping of ScrollVIew
            .safeAreaPadding([.horizontal, .top], 35)
            .navigationTitle("Select Colors")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Label("Dismiss", systemImage: "xmark.circle.fill")
                    }

                }
            })
        }
    }
    
    @ViewBuilder
    func BuildPlatfromBackground(imageData: BackgroundArt) -> some View {
        if #available(iOS 18.0, macOS 15.0, *) {
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

#Preview {
    IosGameBackgroundSelectionView(imagesData: BackgroundArtManager.shared.getAllImages())
        .environmentObject(BackgroundArtManager.shared)
}
