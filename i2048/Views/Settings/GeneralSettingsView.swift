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
    
    var body: some View {
        ScrollView {
            
            MacCustomSection(header: "Choose which sections to show at app launch", footer: "Selected sections will be expanded at app launch") {
                HStack {
                    Label("Active Games", systemImage: userDefaultsManager.activeGamesSectionEnabled ? "gamecontroller.fill" : "gamecontroller")
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.activeGamesSectionEnabled.animation())
                        .toggleStyle(.switch)
                }
                Divider()
                HStack {
                    Label("Games Won", systemImage: userDefaultsManager.gamesWonSectionEnabled ? "trophy.fill" : "trophy")
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.gamesWonSectionEnabled.animation())
                        .toggleStyle(.switch)
                }
                Divider()
                HStack {
                    Label("Games Lost", systemImage: userDefaultsManager.gamesLostSectionEnabled ? "exclamationmark.warninglight.fill" : "exclamationmark.warninglight")
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.gamesLostSectionEnabled.animation())
                        .toggleStyle(.switch)
                }
            }
            
//            MacCustomSection(header: "Game Geedback", footer: "Enable game feedback with Sound") {
//                HStack {
//                    Label("Enable Sound", systemImage: userDefaultsManager.soundEnabled ? "speaker.wave.3.fill" : "speaker.wave.3")
//                    Spacer()
//                    Toggle("", isOn: $userDefaultsManager.soundEnabled.animation())
//                        .toggleStyle(.switch)
//                }
//            }
            
            MacCustomSection(header: "Quick Game Defaults", footer: "Select default values for quick game") {
                HStack {
                    Text("Game name prefix")
                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    TextField("", text: $userDefaultsManager.quickGameNamePrefix)
                        .textFieldStyle(.roundedBorder)
                }
                Divider()
//                HStack(alignment: .center) {
//                    Text("Allow Undo")
//                        .frame(width: 150, alignment: .leading)
//                    Spacer()
//                    Toggle("", isOn: $userDefaultsManager.quickGameAllowUndo)
//                        .toggleStyle(.switch)
//                }
//                Divider()
                HStack(alignment: .center) {
                    Text("New Block")
                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    Picker("", selection: $userDefaultsManager.quickGameNewBlocNum) {
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
                CustomLabel(leadingImageName: "bolt.shield", trailingImageName: "chevron.right", title: "Privacy Policy")
                Divider()
                    .padding(.vertical, 2)
                CustomLabel(leadingImageName: "list.bullet.rectangle.portrait", trailingImageName: "chevron.right", title: "Terms of Use")
                Divider()
                    .padding(.vertical, 2)
                CustomLabel(leadingImageName: "checkmark.seal", trailingImageName: "chevron.right", title: "Usage License")
                Divider()
                    .padding(.top, 2)
                Link(destination: URL(string: "https://github.com/rishi-singh26/i2048")!) {
                    CustomLabel(leadingImageName: "lock.open.display", trailingImageName: "arrow.up.right", title: "Open Source Code")
                }
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
#endif
