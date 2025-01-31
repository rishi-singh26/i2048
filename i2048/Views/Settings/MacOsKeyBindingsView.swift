//
//  MacOsKeyBindingsView.swift
//  i2048
//
//  Created by Rishi Singh on 30/01/25.
//

#if os(macOS)
import SwiftUI

struct MacOsKeyBindingsView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var artManager: BackgroundArtManager
    
    var body: some View {
        ScrollView {
            MacCustomSection(header: "Choose Key bindings", footer: "You can choose to enable all three key binding groups at ones") {
                HStack(alignment: .center) {
                    Text("Arrow Bindongs - ⌘ + (↑ → ↓ ←)")
//                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.arrowBindingsEnabled)
                        .toggleStyle(.switch)
                }
                Divider()
                HStack(alignment: .center) {
                    Text("Left Hand Binding - W D S A")
//                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.leftBindingsEnabled)
                        .toggleStyle(.switch)
                }
                Divider()
                HStack(alignment: .center) {
                    Text("Right Hand Binding - I L K J")
//                        .frame(width: 150, alignment: .leading)
                    Spacer()
                    Toggle("", isOn: $userDefaultsManager.rightBindingsEnabled)
                        .toggleStyle(.switch)
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
