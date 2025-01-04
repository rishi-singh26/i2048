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
    @Environment(\.openWindow) var openWindow
    @EnvironmentObject var gameLogic: GameLogic
        
    @Bindable var game: Game
    @State private var showDeleteConfirmation: Bool = false
    @State private var showEditGameSheet: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            IconViewBuilder(game: game)
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(game.name)
                        .font(.headline.bold())
                    Text(game.createdAt.formattedString())
                        .font(.caption)
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
                editGame()
            } label: {
                Label("Rename", systemImage: "pencil.circle")
            }
            .tint(.yellow)
        }
        .swipeActions(edge: .trailing) {
            Button {
                showDeleteConfirmation .toggle()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
        .contextMenu(menuItems: {
            Button {
                editGame()
            } label: {
                Label("Edit", systemImage: "pencil.circle")
            }
            Button(role: .destructive) {
                showDeleteConfirmation.toggle()
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
                deleteGame()
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showEditGameSheet) {
            AddGameView(gameId: game.id)
        }
    }
    
    @ViewBuilder
    func IconViewBuilder(game: Game) -> some View {
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
    
    func editGame() {
#if os(macOS)
        openWindow(value: game.id)
#elseif os(iOS)
        showEditGameSheet.toggle()
#endif
    }
    
    func deleteGame() {
        if game.id == gameLogic.selectedGame?.id {
            gameLogic.selectedGame = nil
        }
        modelContext.delete(game)
    }
}

#Preview {
    ContentView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
