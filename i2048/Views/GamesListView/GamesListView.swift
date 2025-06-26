//
//  GamesListView.swift
//  i2048
//
//  Created by Rishi Singh on 28/12/24.
//

import SwiftUI
import SwiftData

struct GamesListView: View {
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
    
    var gamesByDate: [[Game]] {
        let calendar = Calendar.current
        return Dictionary(grouping: games) { game in
            calendar.startOfDay(for: game.createdAt)
        }
        .values
        .map { Array($0) }
        .sorted { group1, group2 in
            guard let date1 = group1.first?.createdAt,
                  let date2 = group2.first?.createdAt else {
                return false
            }
            return date1 > date2
        }
    }
    
    var body: some View {
        List(selection: $gameLogic.selectedGame.animation()) {
            ForEach(Array(gamesByDate.enumerated()), id: \.offset) { index, gameGroup in
                if let firstGame = gameGroup.first {
                    Section(header: Text(formatDate(firstGame.createdAt))) {
                        ForEach(gameGroup) { game in
                            NavigationLink(value: game) {
                                GameCardView(game: game)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

//#Preview {
//    GamesListView()
//}
