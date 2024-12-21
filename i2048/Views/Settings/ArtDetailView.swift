//
//  ArtDetailView.swift
//  i2048
//
//  Created by Rishi Singh on 20/12/24.
//

import SwiftUI

struct ArtDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var artManager: BackgroundArtManager
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Image("Camping-on-the-beach")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: geometry.size.width)
//                AsyncImage(url: URL(string: "artManager.selectedArt!.url")) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .scaledToFill()
//                            .ignoresSafeArea()
//                            .frame(width: geometry.size.width)
//                    case .failure:
//                        Image(systemName: "Camping-on-the-beach")
//                            .resizable()
//                            .scaledToFit()
//                            .ignoresSafeArea()
//                            .frame(width: geometry.size.width)
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
                VStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Camping on the beach")
                            .font(.title.bold())
                        Text("Krestovskaya Anna")
                        Divider()
                        HStack {
                            Spacer()
                            Button(action: {}, label: {
                                Text("Set as Game Background")
                                    .font(.headline.bold())
                                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            })
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(25)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 50, style: .continuous))
                }
                .padding(5)
                .ignoresSafeArea()
            }
        })
    }
}

#Preview {
//    BackgroundArtSettings()
    ArtDetailView()
            .environmentObject(BackgroundArtManager.shared)
}
