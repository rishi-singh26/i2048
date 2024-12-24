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
    @State private var animationValues: [[Double]] = []
    @State private var settingsSheetOpen: Bool = false
    
    @Namespace var navigationNamespace
    
    private let gameController = GameController()
    
    init() {
        _ = CacheManager.shared
    }
    
    var body: some View {
        Group {
#if os(macOS)
            MacOSViewBuilder()
#elseif os(iOS)
            IosViewBuilder()
#endif
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
                    GameCardView(game: game, selectedGame: $selectedGame)
                }
            }
        }
        .navigationSplitViewColumnWidth(min: 220, ideal: 230)
        .toolbar(content: MacOSToolbarBuilder)
        .navigationTitle("i2048")
    }
    
    @ToolbarContentBuilder
    func MacOSToolbarBuilder() -> some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Button(action: addGame) {
                Label("Add Game", systemImage: "plus.circle")
            }
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
        }
    }
    
    @ViewBuilder
    func DetailView() -> some View {
        if let selectedGame = selectedGame {
            GameView(selectedGame: selectedGame, animationValues: $animationValues)
        } else {
            GameBackgroundImageView()
        }
    }
    
    func openSettingsWindow() {
        
    }
    
    func gameHotKeys(_ event: NSEvent) -> NSEvent? {
        if event.modifierFlags.contains(.command) && selectedGame != nil {
            switch event.keyCode {
            case KeyCode.upArrow:
                gameController.moveUp(on: selectedGame!, $animationValues)
                updateScore()
                return nil // disable beep sound
            case KeyCode.downArrow:
                gameController.moveDown(on: selectedGame!, $animationValues)
                updateScore()
                return nil // disable beep sound
            case KeyCode.rightArrow:
                gameController.moveRight(on: selectedGame!, $animationValues)
                updateScore()
                return nil // disable beep sound
            case KeyCode.leftArrow:
                gameController.moveLeft(on: selectedGame!, $animationValues)
                updateScore()
                return nil // disable beep sound
            default:
                return event // beep sound will be here
            }
        } else {
            return event
        }
    }
    
    func updateScore() {
        if selectedGame!.score > userDefaultsManager.highScore {
            userDefaultsManager.highScore = selectedGame!.score
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
