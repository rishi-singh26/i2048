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
    // State for collapsible sections
    @State private var isWonSectionExpanded = false
    @State private var isRunningSectionExpanded = true
    @State private var isLostSectionExpanded = false
    
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
        DisclosureGroup(isExpanded: isExpanded) {
            ForEach(games) {game in
                NavigationLink(value: game) {
                    GameCardView(game: game, selectedGame: $selectedGame)
                }
            }
        } label: {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .font(.headline)
                Spacer()
                Image(systemName: isExpanded.wrappedValue ? "chevron.down" : "chevron.right")
                    .font(.footnote.bold())
                    .foregroundColor(.secondary)
            }
            .onTapGesture {
                withAnimation(.easeIn) {
                    isExpanded.wrappedValue = !isExpanded.wrappedValue
                }
            }
            .padding(5)
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
                if #available(iOS 18.0, *) {
                    NavigationCardBuilder(game: game)
                        .matchedTransitionSource(id: game.id, in: navigationNamespace)
                } else {
                    NavigationCardBuilder(game: game)
                }
            }
            .onDelete(perform: deleteGames)
        }
        .headerProminence(.increased)
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
