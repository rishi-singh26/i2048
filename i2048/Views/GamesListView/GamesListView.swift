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
    var navigationNamespace: Namespace.ID
    // State for collapsible sections
    @State private var isWonSectionExpanded = false
    @State private var isRunningSectionExpanded = true
    @State private var isLostSectionExpanded = false
    
    @Binding var selectedGame: Game?
    var searchText: String
    
    init(selectedGame: Binding<Game?>, sortBy: SortOrder, sortOrder: Bool, searchText: String, nameSpace: Namespace.ID) {
        self._selectedGame = selectedGame
        self.searchText = searchText
        self.navigationNamespace = nameSpace
        
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
            searchText.isEmpty
        }
        _games = Query(filter: predicate, sort: sortDescriptors)
    }
    
    // Filter games into sections based on runtime status
    private var wonGames: [Game] {
        games.filter { $0.status == .won }
    }
    
    private var runningGames: [Game] {
        games.filter { $0.status == .running }
    }
    
    private var lostGames: [Game] {
        games.filter { $0.status == .lost }
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
            if (!runningGames.isEmpty) {
                MacOsSectionView(title: "Active Games", isExpanded: $isRunningSectionExpanded, games: runningGames)
            }
            if (!wonGames.isEmpty) {
                MacOsSectionView(title: "Won Games", isExpanded: $isWonSectionExpanded, games: wonGames)
            }
            if (!lostGames.isEmpty) {
                MacOsSectionView(title: "Lost Games", isExpanded: $isLostSectionExpanded, games: lostGames)
            }
        }
    }
    
    @ViewBuilder
    private func MacOsSectionView(title: String, isExpanded: Binding<Bool>, games: [Game]) -> some View {
        Section(title, isExpanded: isExpanded) {
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
            if (!runningGames.isEmpty) {
                IosSectionViewBuilder("Active Games", $isRunningSectionExpanded, runningGames)
            }
            if (!wonGames.isEmpty) {
                IosSectionViewBuilder("Games Won", $isWonSectionExpanded, wonGames)
            }
            if (!lostGames.isEmpty) {
                IosSectionViewBuilder("Games Lost", $isLostSectionExpanded, lostGames)
            }
        }
    }
    
    @ViewBuilder
    func IosSectionViewBuilder(_ title: String, _ expanded: Binding<Bool>, _ games: [Game]) -> some View {
        Section(title, isExpanded: expanded) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    if #available(iOS 18.0, *) {
                        GameCardView(game: game, selectedGame: $selectedGame)
                            .matchedTransitionSource(id: game.id, in: navigationNamespace)
                    } else {
                        GameCardView(game: game, selectedGame: $selectedGame)
                    }
                }
            }
        }
        .headerProminence(.increased)
    }
#endif
}

//#Preview {
//    GamesListView()
//}
