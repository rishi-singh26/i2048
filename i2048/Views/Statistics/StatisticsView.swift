//
//  StatisticsView.swift
//  i2048
//
//  Created by Rishi Singh on 03/01/25.
//

import SwiftUI
import SwiftData
import Charts

enum TimePeriod: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    
    var id: String { self.rawValue }
}

struct StatisticsView: View {
    @Environment(\.dismiss) var dismiss
    @Query() private var games: [Game]
    
    var totalGames: Int {
        games.count
    }
    
    var wonGames: Int {
        games.filter { $0.status == .won }.count
    }
    
    var lostGames: Int {
        games.filter { $0.status == .lost }.count
    }
    
    var activeGames: Int {
        games.filter { $0.status == .active }.count
    }
    
    var dailyGameCounts: [Date: Int] {
        Dictionary(grouping: games, by: { Calendar.current.startOfDay(for: $0.createdAt) })
            .mapValues { $0.count }
    }
    
    var body: some View {
#if os(iOS)
        IosStatsViewBuilder()
#elseif os(macOS)
        MacOSStatsViewBuilder()
#endif
    }
    
#if os(macOS)
    @ViewBuilder
    func MacOSStatsViewBuilder() -> some View {
        ScrollView {
            VStack {
                MacCustomSection(header: "Game Status") {
                    GameStatusView(totalGames: totalGames, wonGames: wonGames, lostGames: lostGames, activeGames: activeGames)
                }
                MacCustomSection(header: "Daily Game Trends") {
                    BarChartView(data: games)
                }
                .padding(.bottom)
            }
        }
    }
#endif
    
#if os(iOS)
    @ViewBuilder
    func IosStatsViewBuilder() -> some View {
        NavigationView {
            List {
                Section {
                    GameStatusView(totalGames: totalGames, wonGames: wonGames, lostGames: lostGames, activeGames: activeGames)
                } header : {
                    Text("Game Status")
                }
                .headerProminence(.increased)
                Section {
                    BarChartView(data: games)
                } header : {
                    Text("Daily Game Trends")
                }
                .headerProminence(.increased)
            }
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.headline.bold())
                    }
                    
                }
            }
        }
    }
#endif
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Game.self, configurations: config)
        
        let _ = (1...30).map { i in
            let game = Game(name: "Game \(i)", gridSize: 4)
            game.score = Int.random(in: 0...1000)
            game.hasWon = Bool.random()
            game.createdAt = Calendar.current.date(byAdding: .day, value: -Int.random(in: 0...30), to: Date())!
            container.mainContext.insert(game)
        }
        
        return StatisticsView()
            .modelContainer(container)

    }
}
