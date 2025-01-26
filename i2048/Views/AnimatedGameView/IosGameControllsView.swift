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
            Button {
                userDefaultsManager.hapticsEnabled.toggle()
            } label: {
                if (userDefaultsManager.hapticsEnabled) {
                    Label("disable.haptics", systemImage: "hand.tap.fill")
                } else {
                    Label("Enable Haptics", systemImage: "hand.tap")
                }
            }
            Divider()
            Picker("game.screen.theme", selection: Binding(
                get: { selectedGame.gameColorMode },
                set: { newVal in
                    selectedGame.gameColorMode = newVal
                }
            )) {
                Label("light", systemImage: "warninglight.fill")
                    .tag(true)
                Label("dark", systemImage: "warninglight")
                    .tag(false)
            }
            .pickerStyle(.menu)
            Button {
                showBackgroundImageSheet.toggle()
            } label: {
                Label("background.image", systemImage: "photo")
            }
            Divider()
            if selectedGame.canUndo && selectedGame.score > 0 {
                Menu("undo.step") {
                    Button {
                        gameLogic.undoStep()
                    } label: {
                        Label("undo.step", systemImage: "arrow.uturn.backward.circle")
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
