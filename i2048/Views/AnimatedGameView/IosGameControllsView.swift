//
//  IosGameControllsView.swift
//  i2048
//
//  Created by Rishi Singh on 24/01/25.
//

import SwiftUI

struct IosGameControllsView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var gameLogic: GameLogic
    
    @Binding var showBackgroundImageSheet: Bool

    var body: some View {
        if let selectedGame = gameLogic.selectedGame {
            if userDefaultsManager.isPremiumUser {
                Button {
                    userDefaultsManager.hapticsEnabled.toggle()
                } label: {
                    if (userDefaultsManager.hapticsEnabled) {
                        Label("Disable Haptics", systemImage: "hand.tap.fill")
                    } else {
                        Label("Enable Haptics", systemImage: "hand.tap")
                    }
                }
            }
            Divider()
            Picker("Game Screen Theme", selection: Binding(
                get: { selectedGame.gameColorMode },
                set: { newVal in
                    selectedGame.gameColorMode = newVal
                }
            )) {
                Label("Light", systemImage: "warninglight.fill")
                    .tag(true)
                Label("Dark", systemImage: "warninglight")
                    .tag(false)
            }
            .pickerStyle(.menu)
            Button {
                showBackgroundImageSheet.toggle()
            } label: {
                Label("Background Colors", systemImage: "paintpalette")
            }
            Divider()
            if selectedGame.canUndo && selectedGame.score > 0 {
                Menu("Undo Step") {
                    Button {
                        gameLogic.undoStep()
                    } label: {
                        Label("Undo Step", systemImage: "arrow.uturn.backward.circle")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    IosGameControllsView(showBackgroundImageSheet: .constant(false))
}
