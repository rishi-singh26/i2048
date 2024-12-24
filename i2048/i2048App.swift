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
        WindowGroup {
            ContentView()
                .environmentObject(userDefaultsManager)
                .environmentObject(artManager)
        }
        .modelContainer(sharedModelContainer)
#if os(macOS)
        .windowStyle(.hiddenTitleBar)
#endif
        
#if os(macOS)
        Settings {
            SettingsView()
                .environmentObject(userDefaultsManager)
                .environmentObject(artManager)
        }
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
