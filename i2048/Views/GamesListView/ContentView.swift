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
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var backgroundArtManager: BackgroundArtManager
    
    @Query var games: [Game]
    
    @State private var selectedGame: Game?
    @State private var gameController: GameController?
    @State private var animationValues: [[Double]] = []
    @State private var settingsSheetOpen: Bool = false
    
    @Namespace var navigationNamespace
    
    var body: some View {
        Group {
#if os(macOS)
            MacOSViewBuilder()
#elseif os(iOS)
            IosViewBuilder()
#endif
        }
        .onChange(of: selectedGame) { oldValue, newValue in
            updateGameController()
        }
        .sheet(isPresented: $settingsSheetOpen, content: {
            SettingsView()
        })
    }
    
    #if os(macOS)
    @ViewBuilder
    func MacOSViewBuilder() -> some View {
        NavigationSplitView {
            MacOsGamesListBuilder()
        } detail: {
            DetailView()
        }
        .keyboardReaction { gameHotKeys($0) }
    }
    
    @ViewBuilder
    func MacOsGamesListBuilder() -> some View {
        List(selection: $selectedGame) {
            ForEach(games) {game in
                NavigationLink(value: game) {
                    if #available(iOS 18.0, *) {
                        GameCardView(game: game, selectedGame: $selectedGame)
                            .navigationTransition(.zoom(sourceID: game.id, in: navigationNamespace))
                    } else {
                        GameCardView(game: game, selectedGame: $selectedGame)
                    }
                }
            }
        }
        .navigationSplitViewColumnWidth(min: 220, ideal: 230)
        .toolbar(content: MacOSToolbarBuilder)
        .navigationTitle("i2048")
    }
    
    @ToolbarContentBuilder
    func MacOSToolbarBuilder() -> some ToolbarContent {
        ToolbarItem {
            Menu {
                Button("Duplicate", action: openSettingsWindow)
                Button("Rename", action: openSettingsWindow)
                Button("Delete…", action: openSettingsWindow)
                Menu("Copy") {
                    Button("Copy", action: openSettingsWindow)
                    Button("Copy Formatted", action: openSettingsWindow)
                    Button("Copy Library Path", action: openSettingsWindow)
                }
            } label: {
                Label("Settings", systemImage: "switch.2")
            }

            Button(action: openSettingsWindow) {
                Label("Settings", systemImage: "switch.2")
            }
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
        }
        ToolbarItem {
            Button(action: addGame) {
                Label("Add Game", systemImage: "plus.circle")
            }
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
        }
    }
    
    @ViewBuilder
    func DetailView() -> some View {
        Group {
            if let _ = selectedGame, let gameController = gameController {
                GameView(gameController: .constant(gameController), animationValues: $animationValues)
            } else {
                GameBackgroundImageView()
            }
        }
    }
    
    func openSettingsWindow() {
        
    }
    
    func gameHotKeys(_ event: NSEvent) -> NSEvent? {
        if event.modifierFlags.contains(.command) && gameController != nil {
            switch event.keyCode {
            case KeyCode.upArrow:
                gameController!.moveUp($animationValues)
                return nil // disable beep sound
            case KeyCode.downArrow:
                gameController!.moveDown($animationValues)
                return nil // disable beep sound
            case KeyCode.rightArrow:
                gameController!.moveRight($animationValues)
                return nil // disable beep sound
            case KeyCode.leftArrow:
                gameController!.moveLeft($animationValues)
                return nil // disable beep sound
            default:
                return event // beep sound will be here
            }
        } else {
            return event
        }
    }
    #endif
    
    #if os(iOS)
    @ViewBuilder
    func IosViewBuilder() -> some View {
        NavigationStack {
            List(selection: $selectedGame) {
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
            .toolbar(content: IosToolbarBuilder)
            .navigationTitle("i2048")
        }
    }
    
    func NavigationCardBuilder(game: Game) -> some View {
        NavigationLink {
            if let controller = gameController {
                if #available(iOS 18.0, *) {
                    GameView(gameController: .constant(controller), animationValues: $animationValues)
                        .navigationTransition(.zoom(sourceID: game.id, in: navigationNamespace))
                } else {
                    GameView(gameController: .constant(controller), animationValues: $animationValues)
                }
            }
        } label: {
            GameCardView(game: game, selectedGame: $selectedGame)
        }
    }
    
    @ToolbarContentBuilder
    func IosToolbarBuilder() -> some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button(action: addGame) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add game")
                            .font(.headline)
                    }
                }
                .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
                Spacer()
                Button(action: {
                    settingsSheetOpen = true
                }, label: {
                    Image(systemName: "switch.2")
                })
            }
        }
    }
    #endif
    
    func updateGameController() {
        if let selectedGame = selectedGame {
            gameController = GameController(game: selectedGame, userDefaultsManager: userDefaultsManager)
        }
    }
    
    func addGame() {
        let game = Game(name: "Game #\(games.count + 1)", gridSize: 4)
        modelContext.insert(game)
        selectedGame = game
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

#Preview {
    ContentView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
