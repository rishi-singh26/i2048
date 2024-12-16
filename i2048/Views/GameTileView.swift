//
//  GameTileView.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

import SwiftUI
import SwiftData

struct GameTileView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var games: [Game]
    @Bindable var game: Game
    
    var body: some View {
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
            }
        })
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
        }
    }
    
    func deleteGame(_ gameId: UUID) {
        if let game = games.first(where: { $0.id == gameId }) {
            modelContext.delete(game)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Game.self, configurations: config)
        let example = Game(name: "Preview Game", gridSize: 4)
        return GameTileView(game: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to created model container")
    }
}
