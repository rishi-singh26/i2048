//
//  ContentView.swift
//  i2048
//
//  Created by Rishi Singh on 16/12/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    @Query var games: [Game]
    @State private var path = [Game]()
    
    @State private var selectedGame: Game?
    
    var body: some View {
            NavigationSplitView {
                List(selection: $selectedGame) {
                    ForEach(games) {game in
                        NavigationLink(value: game) {
                            VStack(alignment: .leading) {
                                Text(game.name)
                                    .font(.headline)
                                Text(game.modifiedAt.formatted(date: .long, time: .shortened))
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    editGame(game.id)
                                } label: {
                                    Label("Rename", systemImage: "pencil.circle")
                                }
                                .tint(.yellow)
                            }
                            .contextMenu(menuItems: {
                                Button {
                                    deleteGame(game.id)
                                } label: {
                                    Label("Rename", systemImage: "pencil.circle")
                                }
                                Button(role: .destructive) {
                                    deleteGame(game.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }.keyboardShortcut(.delete)
                            })
                        }
                    }
                    .onDelete(perform: deleteGames)
                }
    #if os(macOS)
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    #endif
                .toolbar {
    #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
    #endif
                    ToolbarItem {
                        Button(action: addGame) {
                            Label("Add Game", systemImage: "plus")
                        }
                        .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
                    }
                }
                .navigationTitle("i2048")
                #if os(iOS)
                        .background(LinearGradient(gradient: Gradient(colors: getGradienColors()), startPoint: UnitPoint(x: 0, y: -0.2), endPoint: UnitPoint(x: 0, y: 0.7)))
                        .scrollContentBackground(.hidden)
                #endif
            } detail: {
                if let selectedGame = selectedGame {
                    GameViewTwo(game: selectedGame, selectedGame: $selectedGame)
                } else {
                    Text("Select a game")
                }
            }
        }
    
    func addGame() {
        let game = Game(name: "Game #\(games.count + 1)", gridSize: 4)
        modelContext.insert(game)
#if os(iOS)
        selectedGame = game
#endif
    }
    
    func editGame(_ gameId: UUID) {
//        if let game = games.first(where: { $0.id == gameId }) {
//            modelContext.delete(game)
//        }
    }
    
    func deleteGames(_ indexSet: IndexSet) {
        for index in indexSet {
            let game = games[index]
            modelContext.delete(game)
            updateSelectionAfterDeletion(for: game)
        }
    }
    
    func deleteGame(_ gameId: UUID) {
        if let game = games.first(where: { $0.id == gameId }) {
            modelContext.delete(game)
            updateSelectionAfterDeletion(for: game)
        }
    }
    
    private func updateSelectionAfterDeletion(for deletedGame: Game) {
        // If the deleted item is the currently selected item, clear the selection
        if deletedGame == selectedGame {
            selectedGame = nil
        }
    }
    
#if os(iOS)
    func getGradienColors() -> [Color] {
        if colorScheme == .dark {
            return [
                Color(red: 0.57, green: 0.21, blue: 0.07, opacity: 1.00),
                .black,
                .black,
            ]
        } else {
            return [
                Color(red: 1.00, green: 0.69, blue: 0.53, opacity: 1.00),
                Color(uiColor: UIColor.secondarySystemBackground),
                Color(uiColor: UIColor.secondarySystemBackground),
            ]
        }
    }
#endif
}

#Preview {
    ContentView()
}
