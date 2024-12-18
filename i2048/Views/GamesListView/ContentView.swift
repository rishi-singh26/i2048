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
    
    @Query var games: [Game]
    
    @State private var selectedGame: Game?
    @State private var gameController: GameController?
    @State private var animationValues: [[Double]] = []
    
    var body: some View {
        NavigationSplitView {
            gamesListView
        } detail: {
            detailView
        }
        .onChange(of: selectedGame) { oldValue, newValue in
            updateGameController()
        }
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
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        .toolbar {
            ToolbarItem {
                Button(action: addGame) {
                    Label("Add Game", systemImage: "plus.circle")
                }
                .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
            }
        }
#endif
#if os(iOS)
        .toolbar(removing: .sidebarToggle)
        .toolbar {
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
                    Text("\(games.count) Games")
                        .font(.headline)
                }
            }
        }
#endif
        .navigationTitle("i2048")
        .background(.orange.opacity(0.1))
//        .background(Gradient(colors: [Color(hex: "#bac895"), Color(hex: "#f4ee93"), Color(hex: "#ebbe44")]))
        .scrollContentBackground(.hidden)
    }

    var detailView: some View {
        Group {
            if let _ = selectedGame, let gameController = gameController {
                GameView(gameController: .constant(gameController), animationValues: $animationValues)
            } else {
                placeholderView
            }
        }
    }
    
    var placeholderView: some View {
        Image(userDefaultsManager.imageName)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
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
}

#Preview {
    ContentView()
        .environmentObject(UserDefaultsManager.shared)
}
