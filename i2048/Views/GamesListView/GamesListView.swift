//
//  GamesListView.swift
//  i2048
//
//  Created by Rishi Singh on 28/12/24.
//

import SwiftUI
import SwiftData

struct GamesListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Game.createdAt) var games: [Game]
    @Namespace var navigationNamespace

    @Binding var selectedGame: Game?
    @Binding var animationValues: [[Double]]
    var sortBy: SortOrder
    var sortOrder: Bool
    var searchText: String
    var body: some View {
#if os (macOS)
        MacOsGamesListBuilder()
#elseif os(iOS)
        IosGamesListBuilder()
#endif
    }
    
    var filteredGames: [Game] {
        guard !searchText.isEmpty else { return games }
        return games.filter { game in
            game.name.lowercased().contains(searchText.lowercased()) || searchText.lowercased().contains(game.name.lowercased())
        }
    }
    
    @ViewBuilder
    func MacOsGamesListBuilder() -> some View {
        List(selection: $selectedGame.animation()) {
            ForEach(filteredGames) {game in
                NavigationLink(value: game) {
                    GameCardView(game: game, selectedGame: $selectedGame)
                }
            }
        }
    }
    
    @ViewBuilder
    func IosGamesListBuilder() -> some View {
        List(selection: $selectedGame) {
            ForEach(filteredGames) { game in
                if #available(iOS 18.0, *) {
                    NavigationCardBuilder(game: game)
                        .matchedTransitionSource(id: game.id, in: navigationNamespace)
                } else {
                    NavigationCardBuilder(game: game)
                }
            }
            .onDelete(perform: deleteGames)
        }
    }
    
    @ViewBuilder
    func NavigationCardBuilder(game: Game) -> some View {
        NavigationLink {
            if #available(iOS 18.0, *) {
                GameView(
                    selectedGame: game,
                    animationValues: $animationValues
                )
                    .navigationTransition(.zoom(sourceID: game.id, in: navigationNamespace))
            } else {
                GameView(
                    selectedGame: game,
                    animationValues: $animationValues
                )
            }
        } label: {
            GameCardView(game: game, selectedGame: $selectedGame)
        }
    }
    
    func deleteGames(_ indexSet: IndexSet) {
        for index in indexSet {
            let game = games[index]
            modelContext.delete(game)
            if game == selectedGame {
                selectedGame = nil
            }
        }
    }
}

//#Preview {
//    GamesListView()
//}
