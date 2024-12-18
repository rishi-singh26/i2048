//
//  ContentView.swift
//  i2048
//
//  Created by Rishi Singh on 16/12/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var games: [Game]
    @Query var preferences: [UserPreferences]
    
    @State private var userPreference: UserPreferences?
    @State private var selectedGame: Game?
    @State private var gameController: GameController?
    
    var body: some View {
        NavigationSplitView {
            gamesListView
        } detail: {
            detailView
        }
        .onAppear {
            setupPreferences()
        }
        .onChange(of: preferences) { oldValue, newValue in
            updateGameController()
        }
        .onChange(of: selectedGame) { oldValue, newValue in
            updateGameController()
        }
#if os(macOS)
        .keyboardReaction { myMainViewHotkeys($0) }
#endif
    }
    
#if os(macOS)
    func myMainViewHotkeys(_ event: NSEvent) -> NSEvent? {
        if event.modifierFlags.contains(.command) && gameController != nil {
            switch event.keyCode {
            case KeyCode.upArrow:
                gameController!.moveUp()
                return nil // disable beep sound
            case KeyCode.downArrow:
                gameController!.moveDown()
                return nil // disable beep sound
            case KeyCode.rightArrow:
                gameController!.moveRight()
                return nil // disable beep sound
            case KeyCode.leftArrow:
                gameController!.moveLeft()
                return nil // disable beep sound
            default:
                return event // beep sound will be here
            }
        } else {
            return event
        }
    }
#endif
    
    var gamesListView: some View {
        List(selection: $selectedGame) {
            ForEach(games) {game in
                NavigationLink(value: game) {
                    GameCardView(game: game, selectedGame: $selectedGame)
                }
            }
            .onDelete(perform: deleteGames)
        }
#if os(macOS)
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
        .toolbar {
            addToolbarItems()
        }
        .navigationTitle("i2048")
//        .background(.yellow)
//        .scrollContentBackground(.hidden)
    }

    var detailView: some View {
        Group {
            if let _ = selectedGame, let _ = userPreference, let gameController = gameController {
                GameView(gameController: .constant(gameController))
            } else {
                placeholderView
            }
        }
    }
    
    var placeholderView: some View {
        Group {
            if let userPreference = userPreference {
                Image(userPreference.imageName)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Text("Select a game")
            }
        }
    }
    
    func updateGameController() {
        if let selectedGame = selectedGame, let userPreference = userPreference {
            gameController = GameController(game: selectedGame, userPreference: userPreference)
        }
    }
    
    func addGame() {
        let game = Game(name: "Game #\(games.count + 1)", gridSize: 4)
        modelContext.insert(game)
#if os(iOS)
        game = game
#endif
    }
    
    // MARK: - Toolbar Items
    @ToolbarContentBuilder
    private func addToolbarItems() -> some ToolbarContent {
#if os(iOS)
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
        }
#endif
        ToolbarItem {
            Button(action: addGame) {
                Label("Add Game", systemImage: "plus")
            }
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
        }
    }
    
    // MARK: - Setup Preferences
    private func setupPreferences() {
        if let preference: UserPreferences = preferences.first {
            userPreference = preference
        } else {
            let preference = UserPreferences()
            userPreference = preference
            modelContext.insert(preference)
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
}

//#Preview {
//    ContentView()
//}
