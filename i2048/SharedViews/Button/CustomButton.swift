//
//  CustomButton.swift
//  i2048
//
//  Created by Rishi Singh on 20/12/24.
//

import SwiftUI

struct CustomButton: View {
    var keyLabel: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(keyLabel)
            .padding(10)
            .background(.thinMaterial)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.25), radius: 8, x: 2, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CustomButton(keyLabel: "Hello") {
        print("Hello")
    }
}
