//
//  GameCardView.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

import SwiftUI
import SwiftData

struct GameCardView: View {
    @Environment(\.modelContext) var modelContext
        
    @Bindable var game: Game
    @Binding var selectedGame: Game?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name)
                .font(.headline)
            Text(game.modifiedAt.formatted(date: .long, time: .shortened))
                .font(.footnote)
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
    
    func editGame(_ gameId: UUID) {
    //        if let game = games.first(where: { $0.id == gameId }) {
    //            modelContext.delete(game)
    //        }
    }
    
    func deleteGame(_ gameId: UUID) {
        modelContext.delete(game)
        if game == selectedGame {
            selectedGame = nil
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Game.self, configurations: config)
        let example = Game(name: "Preview Game", gridSize: 4)
        
        @State var selectedGame: Game?
        return GameCardView(game: example, selectedGame: $selectedGame)
            .modelContainer(container)
    } catch {
        fatalError("Failed to created model container")
    }
}
