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
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var gameLogic: GameLogic
    @Query(sort: \Game.createdAt, order: .reverse) private var games: [Game]
    
    var searchText: String
    
    init(sortBy: SortOrder, sortOrder: Bool, searchText: String) {
        self.searchText = searchText
        
        let sortDescriptors: [SortDescriptor<Game>] = switch sortBy {
        case .name:
            [
                SortDescriptor(\Game.name, order: sortOrder ? .forward : .reverse),
                SortDescriptor(\Game.createdAt, order: .reverse)
            ]
        case .score:
            [
                SortDescriptor(\Game.score, order: sortOrder ? .forward : .reverse),
                SortDescriptor(\Game.name)
            ]
        case .createdOn:
            [
                SortDescriptor(\Game.createdAt, order: sortOrder ? .forward : .reverse),
                SortDescriptor(\Game.name)
            ]
        case .lastPlayedOn:
            [
                SortDescriptor(\Game.modifiedAt, order: sortOrder ? .forward : .reverse),
                SortDescriptor(\Game.name)
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
        games.filter { $0.status == .active }
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
        List(selection: $gameLogic.selectedGame.animation()) {
            if (!runningGames.isEmpty) {
                MacOsSectionView(title: "Active Games", isExpanded: $userDefaultsManager.isRunningSectionExpanded, games: runningGames)
            }
            if (!wonGames.isEmpty) {
                MacOsSectionView(title: "Won Games", isExpanded: $userDefaultsManager.isWonSectionExpanded, games: wonGames)
            }
            if (!lostGames.isEmpty) {
                MacOsSectionView(title: "Lost Games", isExpanded: $userDefaultsManager.isLostSectionExpanded, games: lostGames)
            }
        }
    }
    
    @ViewBuilder
    private func MacOsSectionView(title: String, isExpanded: Binding<Bool>, games: [Game]) -> some View {
        Section(title, isExpanded: isExpanded) {
            ForEach(games) {game in
                NavigationLink(value: game) {
                    GameCardView(game: game)
                }
            }
        }
    }
#endif
    
#if os(iOS)
    @ViewBuilder
    func IosGamesListBuilder() -> some View {
        List(selection: $gameLogic.selectedGame.animation()) {
            if (!runningGames.isEmpty) {
                IosSectionViewBuilder("Active Games", $userDefaultsManager.isRunningSectionExpanded, runningGames)
            }
            if (!wonGames.isEmpty) {
                IosSectionViewBuilder("Games Won", $userDefaultsManager.isWonSectionExpanded, wonGames)
            }
            if (!lostGames.isEmpty) {
                IosSectionViewBuilder("Games Lost", $userDefaultsManager.isLostSectionExpanded, lostGames)
            }
        }
    }
    
    @ViewBuilder
    func IosSectionViewBuilder(_ title: String, _ expanded: Binding<Bool>, _ games: [Game]) -> some View {
        Section(title, isExpanded: expanded) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameCardView(game: game)
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
