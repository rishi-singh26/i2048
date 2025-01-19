//
//  AddGameView.swift
//  i2048
//
//  Created by Rishi Singh on 29/12/24.
//

import SwiftUI
import SwiftData

@MainActor struct AddGameView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var gameLogic: GameLogic
    
    @Query() private var games: [Game]
    
    @State private var gameName: String = ""
    @State private var gridSize: Int = 4
    @State private var allowUndo: Bool = false
    @State private var showGameNameError: Bool = false
    @State private var newBlockNum: Int = 0
    @State private var targetScore: Int = 2048
    @State private var editingGame: Game? = nil
    var gameId: UUID? = nil
    
    var body: some View {
#if os(iOS)
        IosNewGameFormBuilder()
            .onAppear {
                fetchGame()
            }
#elseif os(macOS)
        MacOSNewGameFormBuilder()
            .onAppear {
                fetchGame()
            }
            .frame(width: 400, height: 400)
#endif
    }

#if os(macOS)
    private func MacOSNewGameFormBuilder() -> some View {
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
            
            MacCustomSection(footer: "3x3 grid is a lot more difficult than 4x4 grid") {
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
            
//            MacCustomSection(footer: "If on, player will be allowd to undo one move at a time") {
//                HStack(alignment: .center) {
//                    Text("Allow Undo")
//                        .frame(width: 100, alignment: .leading)
//                    Spacer()
//                    Toggle("", isOn: $allowUndo)
//                        .toggleStyle(.switch)
//                        .disabled(editingGame != nil)
//                }
//            }
            
            MacCustomSection(footer: "Number on new blocks in the game") {
                HStack(alignment: .center) {
                    Text("New Block")
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
            
            MacCustomSection(footer: "Choose Target Score") {
                HStack(alignment: .center) {
                    Text("Game Target Score")
                        .frame(width: 100, alignment: .leading)
                    Spacer()
                    Picker("", selection: $targetScore) {
                        Text("128")
                            .tag(128)
                        Text("256")
                            .tag(256)
                        Text("512")
                            .tag(512)
                        Text("1024")
                            .tag(1024)
                        Text("2048")
                            .tag(2048)
                        Text("4096")
                            .tag(4096)
                        Text("8192")
                            .tag(8192)
                        Text("16384")
                            .tag(16384)
                    }
                    .disabled(editingGame != nil)
                }
            }
            
        }
        .padding(.vertical, 10)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    if editingGame != nil {
                        editGame()
                    } else {
                        addGame()
                    }
                } label: {
                    Text(editingGame != nil ? "Edit" : "Add")
                }
            }
        }
    }
#endif
    
#if os(iOS)
    private func IosNewGameFormBuilder() -> some View {
        NavigationView {
            Form {
                Section {
                    TextField("Game Name", text: $gameName)
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
                    Text("3x3 grid is a lot more difficult than 4x4 grid")
                }
                
//                Section(footer: Text("If on, you will be allowd to undo one move at a time")) {
//                    Toggle("Allow Undo", isOn: $allowUndo)
//                        .disabled(editingGame != nil)
//                }
                
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
                
                Section {
                    Picker("Game Target Score", systemImage: "target", selection: $targetScore) {
                        Text("128")
                            .tag(128)
                        Text("256")
                            .tag(256)
                        Text("512")
                            .tag(512)
                        Text("1024")
                            .tag(1024)
                        Text("2048")
                            .tag(2048)
                        Text("4096")
                            .tag(4096)
                        Text("8192")
                            .tag(8192)
                        Text("16384")
                            .tag(16384)
                    }
                    .pickerStyle(.navigationLink)
                    .disabled(editingGame != nil)
                } footer: {
                    Text("Choose Target Score")
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
    
    private func fetchGame() {
        // Fetch the item by ID
        if let gameId = gameId, let fetchedItem = games.first(where: { $0.id == gameId }) {
            editingGame = fetchedItem
            gameName = fetchedItem.name
            targetScore = fetchedItem.targetScore
            gridSize = fetchedItem.gridSize
            newBlockNum = fetchedItem.newBlockNumber
            allowUndo = fetchedItem.allowUndo
        }
    }
    
    private func addGame() {
        if gameName == "" {
            showGameNameError = true
            return
        }
        showGameNameError = false
        let game = Game(
            name: gameName,
            gridSize: gridSize,
            allowUndo: allowUndo,
            newBlockNumber: newBlockNum,
            targetScore: targetScore
        )
        modelContext.insert(game)
        gameLogic.selectedGame = game
        dismiss()
    }
    
    private func editGame() {
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
