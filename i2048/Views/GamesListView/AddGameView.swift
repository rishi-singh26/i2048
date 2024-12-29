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
    
    @State private var gameName: String = ""
    @State private var gridSize: Int = 4
    @State private var allowUndo: Bool = false
    @State private var showGameNameError: Bool = false
    @Binding var selectedGame: Game?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Game name", text: $gameName)
                        .textInputAutocapitalization(.words)
                } footer: {
                    Text("Game name appears on the games list screen.")
                        .foregroundStyle(showGameNameError ? .red : .secondary)
                }
                
                Section(footer: Text("3x3 grid is a lot more difficult then 4x4 grid.")) {
                    VStack(alignment: .leading) {
                        Text("Difficulty Level")
                            .font(.headline)
                        Picker("Difficulty Level", selection: $gridSize) {
                            Text("3 x 3 grid")
                                .tag(3)
                            Text("4 x 4 grid")
                                .tag(4)
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                Section(footer: Text("Ones on, you will be allowd to undo one move at a time")) {
                    Toggle("Allow Undo", isOn: $allowUndo)
                }
            }
            .navigationTitle("Add Game")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addGame()
                    } label: {
                        Text("Done")
                            .font(.headline)
                    }

                }
            }
        }
    }
    
    func addGame() {
        if gameName == "" {
            showGameNameError = true
            return
        }
        showGameNameError = false
        let game = Game(name: gameName, gridSize: gridSize)
        modelContext.insert(game)
        selectedGame = game
        dismiss()
    }
}

//#Preview {
//    AddGameView()
//}
