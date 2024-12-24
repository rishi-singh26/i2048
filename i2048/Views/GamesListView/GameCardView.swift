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
        Label {
            HStack {
                VStack(alignment: .leading) {
                    Text(game.name)
                        .font(.title2.bold())
                    Text(game.createdAt.formattedString())
                        .font(.footnote)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text("\(game.score)")
                        .font(.title3.bold())
                }
            }
        } icon: {
            IconViewBuilder(game: game)
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
    
    @ViewBuilder
    func IconViewBuilder(game: Game) -> some View {
        if #available(iOS 18.0, macOS 15.0, *) {
            if game.hasWon {
                Image(systemName: "trophy.fill")
                    .symbolEffect(.wiggle.byLayer, options: .repeat(5))
                    .font(.headline)
                    .foregroundStyle(.yellow)
            } else {
                if GameController.shared.isGameOver(on: game) {
                    Image(systemName: "exclamationmark.warninglight")
                        .symbolEffect(.wiggle.byLayer, options: .repeat(5))
                        .font(.headline)
                        .foregroundStyle(.red)
                } else {
                    Image(systemName: "hourglass")
                        .symbolEffect(.wiggle, options: .repeat(5))
                        .font(.headline)
                        .foregroundStyle(.orange)
                }
            }
        } else {
            if game.hasWon {
                Image(systemName: "trophy.fill")
                    .font(.headline)
                    .foregroundStyle(.yellow)
            } else {
                if GameController.shared.isGameOver(on: game) {
                    Image(systemName: "exclamationmark.warninglight")
                        .font(.headline)
                        .foregroundStyle(.red)
                } else {
                    Image(systemName: "hourglass")
                        .font(.headline)
                        .foregroundStyle(.orange)
                }
            }
        }
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
    ContentView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
