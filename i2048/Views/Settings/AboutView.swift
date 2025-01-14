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
            MacCustomSection(header: "") {
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
            }
            
            MacCustomSection(header: "Special Thanks") {
                VStack(alignment: .leading) {
                    ForEach(Array(artManager.backgroundImages.enumerated()), id: \.offset) { index, artist in
                        Text(artist.name)
                        if index < (artManager.backgroundImages.count - 1) {
                            Divider()
                        }
                    }
                }
            }
            
            MacCustomSection(header: "Acknowledgements") {
                VStack(alignment: .leading) {
                    Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                        CustomLabel(trailingImageName: "arrow.up.right", title: "Markdown Viewer")
                    }
                    Divider()
                    Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                        CustomLabel(trailingImageName: "arrow.up.right", title: "Kingfisher")
                    }
                }
            }
            
            MacCustomSection(header: "Copyright © 2025 Rishi Singh. All Rights Reserved.") {
                VStack(alignment: .leading) {
                    Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                        CustomLabel(trailingImageName: "arrow.up.right", title: "i2048.rishisingh.in")
                    }
                }
            }
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
            
            Section("Copyright © 2025 Rishi Singh. All Rights Reserved.") {
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
