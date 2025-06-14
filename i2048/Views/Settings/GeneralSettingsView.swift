//
//  GeneralSettingsView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

#if os(macOS)
import SwiftUI

struct GeneralSettingsView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var artManager: BackgroundArtManager
    
    @State private var showPrivacyPolicy: Bool = false
    @State private var showTermsOfService: Bool = false
    
    private let privacyPolicyURL = "https://raw.githubusercontent.com/rishi-singh26/i2048/refs/heads/main/Assets/PrivacyPolicy.md"
    private let termsOfuserURL = "https://raw.githubusercontent.com/rishi-singh26/i2048/refs/heads/main/Assets/TermsOfUse.md"
    
    var body: some View {
        ScrollView {
//            MacCustomSection(header: "Game Geedback", footer: "Enable game feedback with Sound") {
//                HStack {
//                    Label("Enable Sound", systemImage: userDefaultsManager.soundEnabled ? "speaker.wave.3.fill" : "speaker.wave.3")
//                    Spacer()
//                    Toggle("", isOn: $userDefaultsManager.soundEnabled.animation())
//                        .toggleStyle(.switch)
//                }
//            }
            
            MacCustomSection(header: "Quick 3x3 Game Defaults", footer: "Select default values for quick game") {
                HStack {
                    Text("Game name prefix")
                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    TextField("", text: $userDefaultsManager.quick3GameNamePrefix)
                        .textFieldStyle(.roundedBorder)
                }
                Divider()
                HStack(alignment: .center) {
                    Text("Allow Undo")
                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.quick4GameAllowUndo)
                        .toggleStyle(.switch)
                }
                Divider()
                HStack(alignment: .center) {
                    Text("New Block")
                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    Picker("", selection: $userDefaultsManager.quick3GameNewBlocNum) {
                        Text("2")
                            .tag(2)
                        Text("4")
                            .tag(4)
                        Text("2 or 4 (Random)")
                            .tag(0)
                    }
                }
                Divider()
                HStack(alignment: .center) {
                    Text("3x3 Game Target Score")
                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    Picker("", selection: $userDefaultsManager.quick3GameTarget) {
                        Text("128")
                            .tag(128)
                        Text("256")
                            .tag(256)
                        Text("512")
                            .tag(512)
                        Text("1024")
                            .tag(1024)
                        Text("2048")
                            .tag(2048)
                        Text("4096")
                            .tag(4096)
                        Text("8192")
                            .tag(8192)
                        Text("16384")
                            .tag(16384)
                    }
                }
            }
            
            MacCustomSection(header: "Quick 4x4 Game Defaults", footer: "Select default values for quick game") {
                HStack {
                    Text("Game name prefix")
                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    TextField("", text: $userDefaultsManager.quick4GameNamePrefix)
                        .textFieldStyle(.roundedBorder)
                }
                Divider()
                HStack(alignment: .center) {
                    Text("Allow Undo")
                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.quick4GameAllowUndo)
                        .toggleStyle(.switch)
                }
                Divider()
                HStack(alignment: .center) {
                    Text("New Block")
                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    Picker("", selection: $userDefaultsManager.quick4GameNewBlocNum) {
                        Text("2")
                            .tag(2)
                        Text("4")
                            .tag(4)
                        Text("2 or 4 (Random)")
                            .tag(0)
                    }
                }
                Divider()
                HStack(alignment: .center) {
                    Text("4x4 Game Target Score")
                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    Picker("", selection: $userDefaultsManager.quick4GameTarget) {
                        Text("128")
                            .tag(128)
                        Text("256")
                            .tag(256)
                        Text("512")
                            .tag(512)
                        Text("1024")
                            .tag(1024)
                        Text("2048")
                            .tag(2048)
                        Text("4096")
                            .tag(4096)
                        Text("8192")
                            .tag(8192)
                        Text("16384")
                            .tag(16384)
                    }
                }
            }
            
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
            
            MacCustomSection(header: "") {
                Link(destination: URL(string: "https://letterbird.co/i2048-brain-tiles")!) {
                    CustomLabel(leadingImageName: "text.bubble", trailingImageName: "arrow.up.right", title: "Help & Support")
                }
                Divider()
                    .padding(.top, 2)
                Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                    CustomLabel(leadingImageName: "lock.open.display", trailingImageName: "arrow.up.right", title: "Open Source Code")
                }
            }
            .padding(.bottom)
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            BuildSheetView(url: URL(string: privacyPolicyURL), navigationTitle: "Privacy Policy")
        }
        .sheet(isPresented: $showTermsOfService) {
            BuildSheetView(url: URL(string: termsOfuserURL), navigationTitle: "Terms of Use")
        }
    }
    
    @ViewBuilder
    private func BuildSheetView(url: URL?, navigationTitle: String) -> some View {
        MarkdownWebView(url: url!)
//            .toolbar {
//                Button("Done")
//            }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
#endif
