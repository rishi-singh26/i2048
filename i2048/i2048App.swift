//
//  i2048App.swift
//  i2048
//
//  Created by Rishi Singh on 16/12/24.
//

import SwiftUI
import SwiftData

@main
struct i2048App: App {
    @Environment(\.openWindow) var openWindow
    @StateObject private var userDefaultsManager = UserDefaultsManager()
    @StateObject private var artManager = BackgroundArtManager()
    @StateObject private var gameLogic = GameLogic()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Game.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, migrationPlan: GamesMigrationPlan.self, configurations: [modelConfiguration])
        } catch {
            print(error)
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
//        Window Group
//        Document Group
//        Settings
//        Window
//        Menu Bar Extra
        WindowGroup {
            ContentView()
                .environmentObject(userDefaultsManager)
                .environmentObject(artManager)
                .environmentObject(gameLogic.updateUserDefaults(defaultsManager: userDefaultsManager))
        }
        .modelContainer(sharedModelContainer)
#if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandMenu("Game") {
                Button("Add Game") {
                    openWindow(id: "newGame")
                }
                .keyboardShortcut("N", modifiers: [.command, .shift])
                Divider()
                Button("Quick 3x3 Game", systemImage: "3.square") {
                    addGame(3)
                }
                .keyboardShortcut(KeyEquivalent("3"), modifiers: .command)
                
                Button("Quick 4x4 Game", systemImage: "4.alt.square") {
                    addGame(4)
                }
                .keyboardShortcut(KeyEquivalent("4"), modifiers: .command)
                Divider()
                Button("Statistics", systemImage: "chart.bar") {
                    openWindow(id: "statistics")
                }
                .keyboardShortcut(KeyEquivalent("S"), modifiers: .command)
            }
        }
#endif
        
#if os(macOS)
        Window("Statistics", id: "statistics") {
            StatisticsView()
        }
        .modelContainer(sharedModelContainer)
        .defaultSize(width: 300, height: 650)
        
        Window("New Game", id: "newGame") {
            AddGameView()
                .environmentObject(gameLogic.updateUserDefaults(defaultsManager: userDefaultsManager))
        }
        .modelContainer(sharedModelContainer)
        .defaultSize(width: 400, height: 400)
        
        WindowGroup("Edit Game", for: Game.ID.self) { $gameId in
            AddGameView(gameId: gameId)
                .environmentObject(gameLogic.updateUserDefaults(defaultsManager: userDefaultsManager))
        }
        .modelContainer(sharedModelContainer)
        .defaultSize(width: 400, height: 400)
        .commandsRemoved()
        
        Settings {
            SettingsView()
                .environmentObject(userDefaultsManager)
                .environmentObject(artManager)
        }
        .windowStyle(.hiddenTitleBar)
#endif
    }
    
    func addGame(_ gridSize: Int) {
        let game = Game(
            name: "\(userDefaultsManager.quickGameNamePrefix) #\(gridSize)x\(gridSize)",
            gridSize: gridSize,
            allowUndo: userDefaultsManager.quickGameAllowUndo,
            newBlockNumber: userDefaultsManager.quickGameNewBlocNum
        )
        sharedModelContainer.mainContext.insert(game)
        gameLogic.selectedGame = game
    }
}
