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
    @Environment(\.colorScheme) var colorScheme
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
#endif
        
#if os(macOS)
        Window("Statistics", id: "statistics") {
            StatisticsView()
        }
        .modelContainer(sharedModelContainer)
        Settings {
            SettingsView()
                .environmentObject(userDefaultsManager)
                .environmentObject(artManager)
        }
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
