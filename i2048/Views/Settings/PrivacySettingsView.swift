//
//  PrivacySettingsView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI

struct PrivacySettingsView: View {
    var body: some View {
        VStack {
            Text("Privacy Settings")
                .font(.largeTitle)
                .padding()
            Text("Manage privacy preferences here.")
            Spacer()
        }
        .padding()
    }
}

#Preview {
    PrivacySettingsView()
}
