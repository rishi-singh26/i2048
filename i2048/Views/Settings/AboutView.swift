//
//  AboutView.swift
//  i2048
//
//  Created by Rishi Singh on 19/12/24.
//

import SwiftUI
import StoreKit

struct AboutView: View {
    @EnvironmentObject private var artManager: BackgroundArtManager
    
    private let privacyPolicyURL = "https://raw.githubusercontent.com/rishi-singh26/i2048/refs/heads/main/Assets/PrivacyPolicy.md"
    private let termsOfuserURL = "https://raw.githubusercontent.com/rishi-singh26/i2048/refs/heads/main/Assets/TermsOfUse.md"
    
#if os(macOS)
    @State private var showPrivacyPolicy: Bool = false
    @State private var showTermsOfService: Bool = false
#endif
    
    var body: some View {
        #if os(macOS)
        MacOSAboutViewBuilder()
        #else
        IosAboutViewBuilder()
        #endif
    }
    
#if os(macOS)
    @ViewBuilder
    func MacOSAboutViewBuilder() -> some View {
        List {
            MacCustomSection(header: "") {
                HStack {
                    Image("PremiumScreenIcon")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding(.trailing, 15)
                    VStack(alignment: .leading) {
                        Text("i2048")
                            .font(.largeTitle.bold())
                        Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                            .font(.callout)
                        Text("Developed by [Rishi Singh](https://rishisingh.in)")
                            .font(.callout)
                    }
                    Spacer()
                }
            }
            .listRowSeparator(.hidden)
            
            MacCustomSection(header: "") {
                HStack {
                    Label("Privacy Policy", systemImage: "bolt.shield")
                    Spacer()
                    Button("View") {
                        showPrivacyPolicy = true
                    }
                }
                Divider()
                    .padding(.vertical, 2)
                HStack {
                    Label("Terms of Use", systemImage: "list.bullet.rectangle.portrait")
                    Spacer()
                    Button("View") {
                        showTermsOfService = true
                    }
                }
            }
            .listRowSeparator(.hidden)
            
            MacCustomSection {
                Link(destination: URL(string: "https://letterbird.co/i2048-brain-tiles")!) {
                    CustomLabel(leadingImageName: "text.bubble", trailingImageName: "arrow.up.right", title: "Help & Feedback")
                }
                Divider()
                Button {
                    getRating()
                } label: {
                    CustomLabel(leadingImageName: "star", title: "Rate Us")
                }
                .buttonStyle(.link)
                Divider()
                Link(destination: URL(string: "https://itunes.apple.com/app/id\(6740532127)?action=write-review")!) {
                    CustomLabel(leadingImageName: "quote.bubble", trailingImageName: "arrow.up.right", title: "Write Review on App Store")
                }
                Divider()
                Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                    CustomLabel(leadingImageName: "lock.open.display", trailingImageName: "arrow.up.right", title: "Open Source Code")
                }
            }
            .listRowSeparator(.hidden)
            
            MacCustomSection(header: "Acknowledgements") {
                Link(destination: URL(string: "https://github.com/simibac/ConfettiSwiftUI")!) {
                    CustomLabel(trailingImageName: "arrow.up.right", title: "ConfettiSwiftUI")
                }
                Divider()
                Link(destination: URL(string: "https://github.com/gonzalezreal/NetworkImage")!) {
                    CustomLabel(trailingImageName: "arrow.up.right", title: "NetworkImage")
                }
                Divider()
                Link(destination: URL(string: "https://github.com/gonzalezreal/swift-markdown-ui")!) {
                    CustomLabel(trailingImageName: "arrow.up.right", title: "swift-markdown-ui")
                }
            }
            .listRowSeparator(.hidden)
            
            MacCustomSection(header: "Website") {
                VStack(alignment: .leading) {
                    Link(destination: URL(string: "https://i2048.rishisingh.in")!) {
                        CustomLabel(trailingImageName: "arrow.up.right", title: "i2048.rishisingh.in")
                    }
                }
            }
            .listRowSeparator(.hidden)
            .padding(.bottom)
        }
        .listStyle(.plain)
        .sheet(isPresented: $showPrivacyPolicy) {
            BuildSheetView(url: URL(string: privacyPolicyURL), navigationTitle: "Privacy Policy")
        }
        .sheet(isPresented: $showTermsOfService) {
            BuildSheetView(url: URL(string: termsOfuserURL), navigationTitle: "Terms of Use")
        }
    }
#endif
    
#if os(iOS)
    @ViewBuilder
    func IosAboutViewBuilder() -> some View {
        List {
            HStack {
                Image("PremiumScreenIcon")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(.trailing, 15)
                VStack(alignment: .leading) {
                    Text("i2048")
                        .font(.largeTitle.bold())
                    Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                        .font(.callout)
                }
            }
            
            Section {
                NavigationLink(destination: BuildSheetView(url: URL(string: privacyPolicyURL), navigationTitle: "Privacy Policy")) {
                    Label("Privacy Policy", systemImage: "bolt.shield")
                }
                NavigationLink(destination: BuildSheetView(url: URL(string: privacyPolicyURL), navigationTitle: "Terms of Use")) {
                    Label("Terms of Use", systemImage: "list.bullet.rectangle.portrait")
                }
            }
            
            Section {
                Link(destination: URL(string: "https://letterbird.co/i2048-brain-tiles")!) {
                    CustomLabel(leadingImageName: "text.bubble", trailingImageName: "arrow.up.right", title: "Help & Feedback")
                }
                Button {
                    getRating()
                } label: {
                    Label("Rate Us", systemImage: "star")
                }
                Link(destination: URL(string: "https://itunes.apple.com/app/id\(6740532127)?action=write-review")!) {
                    CustomLabel(leadingImageName: "quote.bubble", trailingImageName: "arrow.up.right", title: "Write Review on App Store")
                }
                Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                    CustomLabel(leadingImageName: "lock.open.display", trailingImageName: "arrow.up.right", title: "Open Source Code")
                }
            }
            
            Section("Acknowledgements") {
                Link(destination: URL(string: "https://github.com/simibac/ConfettiSwiftUI")!) {
                    CustomLabel(trailingImageName: "arrow.up.right", title: "ConfettiSwiftUI")
                }
                Link(destination: URL(string: "https://github.com/gonzalezreal/NetworkImage")!) {
                    CustomLabel(trailingImageName: "arrow.up.right", title: "NetworkImage")
                }
                Link(destination: URL(string: "https://github.com/gonzalezreal/swift-markdown-ui")!) {
                    CustomLabel(trailingImageName: "arrow.up.right", title: "swift-markdown-ui")
                }
            }
            
            Section("Website") {
                Link(destination: URL(string: "https://i2048.rishisingh.in")!) {
                    CustomLabel(trailingImageName: "arrow.up.right", title: "i2048.rishisingh.in")
                }
            }
        }
    }
#endif
    
    @ViewBuilder
    private func BuildSheetView(url: URL?, navigationTitle: String) -> some View {
        MarkdownWebView(url: url!)
            .navigationTitle(navigationTitle)
    }
    
    func getRating() {
#if os(iOS)
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            AppStore.requestReview(in: scene)
        }
#elseif os(macOS)
        SKStoreReviewController.requestReview() // macOS doesn't need a scene
#elseif os(tvOS)
        SKStoreReviewController.requestReview() // tvOS doesn't need a scene
#elseif os(watchOS)
        // watchOS doesn't support SKStoreReviewController
        print("SKStoreReviewController not supported on watchOS")
#endif
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
