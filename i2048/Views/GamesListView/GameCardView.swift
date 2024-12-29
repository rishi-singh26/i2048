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
    @State private var showDeleteConfirmation: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            IconViewBuilder(game: game)
            HStack {
                VStack(alignment: .leading) {
                    Text(game.name)
                        .font(.title3.bold())
                    Text(game.createdAt.formattedString())
                        .font(.footnote)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text("\(game.score)")
                        .font(.headline.bold())
                }
            }
        }
        #if os(macOS)
        .padding(.vertical, 5)
        #endif
        .swipeActions(edge: .leading) {
            Button {
                editGame(game.id)
            } label: {
                Label("Rename", systemImage: "pencil.circle")
            }
            .tint(.yellow)
        }
        .swipeActions(edge: .trailing) {
            Button {
                showDeleteConfirmation = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
        .contextMenu(menuItems: {
            Button {
                deleteGame(game.id)
            } label: {
                Label("Rename", systemImage: "pencil.circle")
            }
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Label("Delete", systemImage: "trash")
            }.keyboardShortcut(.delete)
        })
        .confirmationDialog(
            "Are you sure you want to delete this game?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deleteGame(game.id)
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    @ViewBuilder
    func IconViewBuilder(game: Game) -> some View {
        if #available(iOS 18.0, macOS 15.0, *) {
            if game.hasWon {
                Image(systemName: "trophy.fill")
                    .symbolEffect(.wiggle.byLayer, options: .repeat(5))
                    .font(.title2)
                    .foregroundStyle(.yellow)
                    .frame(width: 35)
            } else {
                if game.isGameOver {
                    Image(systemName: "exclamationmark.warninglight")
                        .symbolEffect(.wiggle.byLayer, options: .repeat(5))
                        .font(.title2)
                        .foregroundStyle(.red)
                        .frame(width: 35)
                } else {
                    Image(systemName: "gamecontroller.fill")
                        .symbolEffect(.wiggle, options: .repeat(5))
                        .font(.title2)
                        .foregroundStyle(.orange)
                        .frame(width: 35)
                }
            }
        } else {
            if game.hasWon {
                Image(systemName: "trophy.fill")
                    .font(.title2)
                    .foregroundStyle(.yellow)
                    .frame(width: 35)
            } else {
                if game.isGameOver {
                    Image(systemName: "exclamationmark.warninglight")
                        .font(.title2)
                        .foregroundStyle(.red)
                        .frame(width: 35)
                } else {
                    Image(systemName: "gamecontroller.fill")
                        .font(.title2)
                        .foregroundStyle(.orange)
                        .frame(width: 35)
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
