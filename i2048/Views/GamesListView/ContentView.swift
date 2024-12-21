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
    
    var body: some View {
        NavigationSplitView {
            gamesListView
        } detail: {
            DetailView()
        }
        .onChange(of: selectedGame) { oldValue, newValue in
            updateGameController()
        }
        .sheet(isPresented: $settingsSheetOpen, content: {
            SettingsView()
        })
#if os(macOS)
        .keyboardReaction { gameHotKeys($0) }
#endif
    }
    
#if os(macOS)
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
        .navigationSplitViewColumnWidth(min: 220, ideal: 230)
        .toolbar(content: MacOSToolbarBuilder)
#endif
#if os(iOS)
        .toolbar(content: IosToolbarBuilder)
#endif
        .navigationTitle("i2048")
    }

    @ViewBuilder
    func DetailView() -> some View {
        Group {
            if let _ = selectedGame, let gameController = gameController {
                GameView(gameController: .constant(gameController), animationValues: $animationValues)
            } else {
                PlaceholderView()
            }
        }
    }
    
    @ViewBuilder
    func PlaceholderView() -> some View {
        if userDefaultsManager.isNetworkImageSelected {
            GameBackgroundImageView()
        } else {
            Image(userDefaultsManager.imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
    
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
    
    #if os(macOS)
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
    
    func openSettingsWindow() {
        
    }
    #endif
    
    #if os(iOS)
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
}

#Preview {
    ContentView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
