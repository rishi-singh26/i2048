//
//  AddGameView.swift
//  i2048
//
//  Created by Rishi Singh on 29/12/24.
//

import SwiftUI

struct AddGameView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var gameLogic: GameLogic
    
    @State private var gameName: String = ""
    @State private var gridSize: Int = 4
    @State private var allowUndo: Bool = false
    @State private var showGameNameError: Bool = false
    @State private var newBlockNum: Int = 0
    var editingGame: Game? = nil
    
    init(editingGame: Game? = nil) {
        self.editingGame = editingGame
        if let game = editingGame {
            self._gameName = State(initialValue: game.name)
        }
    }
    
    var body: some View {
#if os(iOS)
        IosNewGameFormBuilder()
#elseif os(macOS)
        MacOSNewGameFormBuilder()
#endif
    }

#if os(macOS)
    private func MacOSNewGameFormBuilder() -> some View {
        VStack(alignment: .leading) {
            Text(editingGame != nil ? "Edit Game" : "Add Game")
                .font(.title.bold())
                .padding([.top, .horizontal])
                .padding(.bottom, 0)
            ScrollView {
                MacCustomSection(footer: "Game name appears on the games list screen.") {
                    HStack {
                        Text("Game Name")
                            .frame(width: 100, alignment: .leading)
                        Spacer()
                        TextField("", text: $gameName)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                MacCustomSection(footer: "3x3 grid is a lot more difficult then 4x4 grid") {
                    HStack {
                        Text("Grid Size")
                            .frame(width: 100, alignment: .leading)
                        Spacer()
                        Picker("", selection: $gridSize) {
                            Text("3 x 3 grid")
                                .tag(3)
                            Text("4 x 4 grid")
                                .tag(4)
                        }
                        .pickerStyle(.segmented)
                        .disabled(editingGame != nil)
                    }
                }
                
                MacCustomSection(footer: "If on, player will be allowd to undo one move at a time") {
                    HStack(alignment: .center) {
                        Text("Allow Undo")
                            .frame(width: 100, alignment: .leading)
                        Spacer()
                        Toggle("", isOn: $allowUndo)
                            .toggleStyle(.switch)
                            .disabled(editingGame != nil)
                    }
                }
                
                MacCustomSection(footer: "Number on new blocks in the game") {
                    HStack(alignment: .center) {
                        Text("Allow Undo")
                            .frame(width: 100, alignment: .leading)
                        Spacer()
                        Picker("", selection: $newBlockNum) {
                            Text("2")
                                .tag(2)
                            Text("4")
                                .tag(4)
                            Text("2 or 4 (Random)")
                                .tag(0)
                        }
                        .disabled(editingGame != nil)
                    }
                }
            }
            .padding(.bottom, 10)
        }
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    if editingGame != nil {
                        editGame()
                    } else {
                        addGame()
                    }
                } label: {
                    Text("Done")
                }
            }
        }
        .frame(width: 500, height: 380, alignment: .leading)
    }
#endif
    
#if os(iOS)
    private func IosNewGameFormBuilder() -> some View {
        NavigationView {
            Form {
                Section {
                    TextField("Game name", text: $gameName)
                        .textInputAutocapitalization(.words)
                } footer: {
                    Text("Game name appears on the games list screen.")
                        .foregroundStyle(showGameNameError ? .red : .secondary)
                }
                
                Section {
                    Picker("Grid Size", selection: $gridSize) {
                        Text("3 x 3 grid")
                            .tag(3)
                        Text("4 x 4 grid")
                            .tag(4)
                    }
                    .pickerStyle(.segmented)
                    .disabled(editingGame != nil)
                } header: {
                    Text("Select grid size")
                } footer: {
                    Text("3x3 grid is a lot more difficult then 4x4 grid")
                }
                
                Section(footer: Text("If on, you will be allowd to undo one move at a time")) {
                    Toggle("Allow Undo", isOn: $allowUndo)
                        .disabled(editingGame != nil)
                }
                
                Section {
                    Picker(selection: $newBlockNum.animation()) {
                        Text("2")
                            .tag(2)
                        Text("4")
                            .tag(4)
                        Text("2 or 4 (Random)")
                            .tag(0)
                    } label: {
                        Label {
                            Text("New Block")
                        } icon: {
                            AnimatedIconsView(symbols: Game.getNewBlockIcon(newBlockNum), animationDuration: 2.0)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .disabled(editingGame != nil)
                    
                } footer: {
                    Text("Number on new blocks in the game")
                }
            }
            .navigationTitle(editingGame != nil ? "Edit Game" : "Add Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if editingGame != nil {
                            editGame()
                        } else {
                            addGame()
                        }
                    } label: {
                        Text("Done")
                            .font(.headline)
                    }
                }
            }
        }
    }
#endif
    
    func addGame() {
        if gameName == "" {
            showGameNameError = true
            return
        }
        showGameNameError = false
        let game = Game(name: gameName, gridSize: gridSize, allowUndo: allowUndo, newBlockNumber: newBlockNum)
        modelContext.insert(game)
        gameLogic.selectedGame = game
        dismiss()
    }
    
    func editGame() {
        if gameName == "" {
            showGameNameError = true
            return
        }
        showGameNameError = false
        editingGame?.name = gameName
        dismiss()
    }
}

#Preview {
    ContentView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
