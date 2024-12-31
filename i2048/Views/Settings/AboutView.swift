//
//  AboutView.swift
//  i2048
//
//  Created by Rishi Singh on 19/12/24.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var artManager: BackgroundArtManager
    
    var body: some View {
        #if os(macOS)
        MacOSAboutViewBuilder()
        #else
        IosAboutViewBuilder()
        #endif
    }
    
    @ViewBuilder
    func MacOSAboutViewBuilder() -> some View {
        ScrollView {
            GroupBox {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 70, height: 70)
                        .padding(.trailing, 15)
                    VStack(alignment: .leading) {
                        Text("i2048")
                            .font(.largeTitle.bold())
                        Text("Version 1.0.0")
                            .font(.callout)
                    }
                    Spacer()
                }
                .padding(6)
            }
            .padding(.top)
            .padding(.horizontal)
            
            HStack {
                Text("Special Thanks")
                    .padding(.top)
                Spacer()
            }
            .padding(.horizontal)
            GroupBox {
                VStack(alignment: .leading) {
                    ForEach(Array(artManager.backgroundImages.enumerated()), id: \.offset) { index, artist in
                        Text(artist.name)
                        if index < (artManager.backgroundImages.count - 1) {
                            Divider()
                        }
                    }
                }
                .padding(6)
            }
            .padding(.horizontal)
            
            HStack {
                Text("Acknowledgements")
                    .padding(.top)
                Spacer()
            }
            .padding(.horizontal)
            GroupBox {
                VStack(alignment: .leading) {
                    Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                        CustomLabel(trailingImageName: "arrow.up.right", title: "Markdown Viewer")
                    }
                    Divider()
                    Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                        CustomLabel(trailingImageName: "arrow.up.right", title: "Kingfisher")
                    }
                }
                .padding(6)
            }
            .padding(.horizontal)
            
            HStack {
                Text("Copyright © 2024 Rishi Singh. All Rights Reserved.")
                    .padding(.top)
                Spacer()
            }
            .padding(.horizontal)
            GroupBox {
                VStack(alignment: .leading) {
                    Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                        CustomLabel(trailingImageName: "arrow.up.right", title: "i2048.rishisingh.in")
                    }
                }
                .padding(6)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    @ViewBuilder
    func IosAboutViewBuilder() -> some View {
        List {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 70, height: 70)
                    .padding(.trailing, 15)
                VStack(alignment: .leading) {
                    Text("i2048")
                        .font(.largeTitle.bold())
                    Text("Version 1.0.0")
                        .font(.callout)
                }
            }
            
            Section("Special Thanks") {
                ForEach(artManager.backgroundImages) { artist in
                    Text(artist.name)
                }
            }
            
            Section("Acknowledgements") {
                Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                    CustomLabel(trailingImageName: "arrow.up.right", title: "Markdown Viewer")
                }
                Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                    CustomLabel(trailingImageName: "arrow.up.right", title: "Kingfisher")
                }
            }
            
            Section("Copyright © 2024 Rishi Singh. All Rights Reserved.") {
                Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                    CustomLabel(trailingImageName: "arrow.up.right", title: "i2048.rishisingh.in")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
