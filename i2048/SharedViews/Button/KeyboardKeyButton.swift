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
            HStack(spacing: 3) {
                ForEach(keyLabel, id: \.self) {lable in
                    Image(systemName: lable)
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(.thinMaterial)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.25), radius: 8, x: 2, y: 2)
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
