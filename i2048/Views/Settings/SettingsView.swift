//
//  SettingsView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedTab: String?
    
    let screens = ["General", "Appearance", "Privacy"]
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                ForEach(screens, id: \.self) {screen in
                    NavigationLink(value: screen) {
                        Label(screen, systemImage: "gear")
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            switch selectedTab {
            case screens[0]:
                GeneralSettingsView()
            case screens[1]:
                AppearanceSettingsView()
            case screens[2]:
                PrivacySettingsView()
            default:
                GeneralSettingsView()
            }
        }
    }
}

#Preview {
    SettingsView()
}
