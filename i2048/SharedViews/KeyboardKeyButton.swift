//
//  KeyboardKeyButton.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI

struct KeyboardKeyButton: View {
    var keyLabel: [String]
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 2) { // Adjust spacing as needed
                ForEach(keyLabel, id: \.self) {lable in
                    Image(systemName: lable)
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(.thinMaterial)
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    KeyboardKeyButton(keyLabel: ["command", "arrow.left"]) {
        print("Hello")
    }
}

//SF Symbols Keyboard Icons: SF Symbols includes icons such as:
//command for ⌘
//option for ⌥
//control for ⌃
//shift for ⇧
//capslock for ⇪
//delete.left for ⌫
//return for ⏎
