//
//  AppearanceSettingsView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI

struct AppearanceSettingsView: View {
    var body: some View {
        VStack {
            Text("Appearance Settings")
                .font(.largeTitle)
                .padding()
            Picker("Theme", selection: .constant("Light")) {
                Text("Light").tag("Light")
                Text("Dark").tag("Dark")
                Text("System Default").tag("System")
            }
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AppearanceSettingsView()
}
