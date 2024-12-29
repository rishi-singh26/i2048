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
#if os(iOS)
        IosNewGameFormBuilder()
#elseif os(macOS)
        MacOSNewGameFormBuilder()
#endif
    }

#if os(macOS)
    private func MacOSNewGameFormBuilder() -> some View {
        ScrollView {
            GroupBox {
                HStack {
                    Text("Game Name")
                        .font(.headline)
                        .frame(width: 100, alignment: .leading)
                    Spacer()
                    TextField("", text: $gameName)
                }
                .padding(6)
            }
            .padding([.horizontal, .top])
            
            GroupBox {
                HStack {
                    Text("Difficulty Level")
                        .font(.headline)
                        .frame(width: 100, alignment: .leading)
                    Spacer()
                    Picker("", selection: $gridSize) {
                        Text("3 x 3 grid")
                            .tag(3)
                        Text("4 x 4 grid")
                            .tag(4)
                    }
                    .pickerStyle(.segmented)
                }
                .padding([.leading, .top, .bottom], 6)
                .padding(.trailing, 12)
            }
            .padding(.horizontal)
            
            GroupBox {
                HStack(alignment: .center) {
                    Text("Allow Undo")
                        .font(.headline)
                        .frame(width: 100, alignment: .leading)
                    Spacer()
                    Toggle("", isOn: $allowUndo)
                        .toggleStyle(.switch)
                }
                .padding([.leading, .top, .bottom], 6)
                .padding(.trailing, 12)
            }
            .padding([.horizontal, .bottom])
        }
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    addGame()
                } label: {
                    Text("Done")
                        .font(.headline)
                }
            }
        }
        .frame(width: 500, height: 200, alignment: .leading)
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
#endif
    
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
