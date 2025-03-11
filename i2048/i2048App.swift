//
//  i2048App.swift
//  i2048
//
//  Created by Rishi Singh on 16/12/24.
//

import SwiftUI
import SwiftData
import StoreKit

@main
struct i2048App: App {
    @Environment(\.openWindow) var openWindow
    @StateObject private var userDefaultsManager = UserDefaultsManager()
    @StateObject private var artManager = BackgroundArtManager()
    @StateObject private var gameLogic = GameLogic()
    
    init() {
        SKPaymentQueue.default().add(InAppPurchaseObserver())
    }

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
        .defaultSize(width: 1000, height: 700)
        .modelContainer(sharedModelContainer)
#if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .commands {
            SidebarCommands()
            CommandMenu("Game") {
                Button("New Game") {
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
                Divider()
                Button("Share Game", systemImage: "square.and.arrow.up") {
                    openWindow(id: "shareGame")
                }
                .keyboardShortcut(KeyEquivalent("S"), modifiers: [.command, .shift])
                .disabled(gameLogic.selectedGame == nil)
            }
        }
#endif
        
#if os(macOS)
        Window("i2048 - Statistics", id: "statistics") {
            StatisticsView()
        }
        .modelContainer(sharedModelContainer)
        .defaultSize(width: 300, height: 750)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        
        Window("i2048 - New Game", id: "newGame") {
            AddGameView()
                .environmentObject(userDefaultsManager)
                .environmentObject(gameLogic.updateUserDefaults(defaultsManager: userDefaultsManager))
        }
        .modelContainer(sharedModelContainer)
        .defaultSize(width: 400, height: 400)
        .windowResizability(.contentSize)
        
        Window("i2048 - Buy Lifetime Premium", id: "lifetimePremium") {
            IAPView(isWindow: true)
        }
        .modelContainer(sharedModelContainer)
        .defaultSize(width: 300, height: 720)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        
        Window("i2048 - Share Game", id: "shareGame") {
            ShareCardView()
                .environmentObject(userDefaultsManager)
                .environmentObject(gameLogic)
        }
        .modelContainer(sharedModelContainer)
        .defaultSize(width: 350, height: 600)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        
        WindowGroup("i2048 - Edit Game", for: Game.ID.self) { $gameId in
            AddGameView(gameId: gameId)
                .environmentObject(userDefaultsManager)
                .environmentObject(gameLogic.updateUserDefaults(defaultsManager: userDefaultsManager))
        }
        .modelContainer(sharedModelContainer)
        .defaultSize(width: 400, height: 400)
        .windowResizability(.contentSize)
        .commandsRemoved()
        
        Settings {
            SettingsView()
                .environmentObject(userDefaultsManager)
                .environmentObject(artManager)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 400, height: 800)
#endif
    }
    
    func addGame(_ gridSize: Int) {
        if userDefaultsManager.isPremiumUser {
            var game: Game
            if gridSize == 3 {
                game = Game(
                    name: "\(userDefaultsManager.quick3GameNamePrefix) #\(gridSize)x\(gridSize)",
                    gridSize: gridSize,
                    allowUndo: userDefaultsManager.quick3GameAllowUndo,
                    newBlockNumber: userDefaultsManager.quick3GameNewBlocNum,
                    targetScore: userDefaultsManager.quick3GameTarget
                )
            } else {
                game = Game(
                    name: "\(userDefaultsManager.quick4GameNamePrefix) #\(gridSize)x\(gridSize)",
                    gridSize: gridSize,
                    allowUndo: userDefaultsManager.quick4GameAllowUndo,
                    newBlockNumber: userDefaultsManager.quick4GameNewBlocNum,
                    targetScore: userDefaultsManager.quick4GameTarget
                )
            }
            if let randomBackground = artManager.getAllImages().randomElement() {
                game.selectNetworkImage(randomBackground)
            }
            sharedModelContainer.mainContext.insert(game)
            gameLogic.selectedGame = game
        } else {
            openWindow(id: "lifetimePremium")
        }
    }
}
