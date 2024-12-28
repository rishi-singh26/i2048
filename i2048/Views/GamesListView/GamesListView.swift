//
//  GamesListView.swift
//  i2048
//
//  Created by Rishi Singh on 28/12/24.
//

import SwiftUI
import SwiftData

struct GamesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Game.createdAt, order: .reverse) private var games: [Game]
    @Namespace private var navigationNamespace

    @Binding var selectedGame: Game?
    @Binding var animationValues: [[Double]]
    var searchText: String

    init(selectedGame: Binding<Game?>, animationValues: Binding<[[Double]]>, sortBy: SortOrder, sortOrder: Bool, searchText: String) {
        self._selectedGame = selectedGame
        self._animationValues = animationValues
        self.searchText = searchText
        
        let sortDescriptors: [SortDescriptor<Game>] = switch sortBy {
        case .name:
            [
                SortDescriptor(\Game.name, order: sortOrder ? .forward : .reverse),
                SortDescriptor(\Game.createdAt, order: sortOrder ? .forward : .reverse)
            ]
        case .createdOn:
            [
                SortDescriptor(\Game.createdAt, order: sortOrder ? .forward : .reverse),
                SortDescriptor(\Game.name, order: sortOrder ? .forward : .reverse)
            ]
        case .lastPlayedOn:
            [
                SortDescriptor(\Game.modifiedAt, order: sortOrder ? .forward : .reverse),
                SortDescriptor(\Game.name, order: sortOrder ? .forward : .reverse)
            ]
        }
        
        let predicate = #Predicate<Game> { game in
            game.name.localizedStandardContains(searchText) ||
            searchText.localizedStandardContains(game.name) ||
            searchText.isEmpty
        }
        _games = Query(filter: predicate, sort: sortDescriptors)
    }
    
    var body: some View {
#if os (macOS)
        MacOsGamesListBuilder()
#elseif os(iOS)
        IosGamesListBuilder()
#endif
    }
    
#if os (macOS)
    @ViewBuilder
    func MacOsGamesListBuilder() -> some View {
        List(selection: $selectedGame.animation()) {
            ForEach(games) {game in
                NavigationLink(value: game) {
                    GameCardView(game: game, selectedGame: $selectedGame)
                }
            }
        }
    }
#endif
    
#if os(iOS)
    @ViewBuilder
    func IosGamesListBuilder() -> some View {
        List(selection: $selectedGame) {
            ForEach(games) { game in
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
#endif
}

//#Preview {
//    GamesListView()
//}
