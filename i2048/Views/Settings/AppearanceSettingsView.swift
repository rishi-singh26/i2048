//
//  AppearanceSettingsView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI

struct AppearanceSettingsView: View {
    @State private var restartNeeded = true
    @State private var enable = true
    @State private var display = 0
    @State private var launchAtLogin = false
    
    var body: some View {
            ScrollView {
                if restartNeeded {
                    GroupBox {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text("Restart to take effect")
                            Spacer()
                            Button("Restart") {
                                Swift.print("Restart")
                            }
                        }
                        .padding(4)
                        .foregroundColor(.yellow)
                    }
                    .padding(.horizontal)
                }
                GroupBox {
                    VStack {
                        HStack {
                            Text("Enable")
                            Spacer()
                            Toggle("", isOn: $enable)
                                .toggleStyle(.switch)
                        }
                        Divider()
                        HStack {
                            Text("Display in")
                            Spacer()
                            Picker(selection: $display, label: Text("")) {
                                Text("Both MenuBar and Dock").tag(0)
                                Text("MenuBar").tag(1)
                                Text("Dock").tag(2)
                            }
                            .scaledToFit()
                        }
                        Divider()
                        HStack {
                            Text("Launch at Login")
                            Spacer()
                            Toggle("", isOn: $launchAtLogin)
                                .toggleStyle(.switch)
                        }
                    }
                    .padding(4)
                }
                .padding(.horizontal)
                GroupBox {
                    HStack {
                        Text("Reset All Settings")
                        Spacer()
                        Button("Reset and Restart") {
                            Swift.print("Reset and Restart")
                        }
                    }
                    .padding(4)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.top)
        }
}

#Preview {
    AppearanceSettingsView()
}
