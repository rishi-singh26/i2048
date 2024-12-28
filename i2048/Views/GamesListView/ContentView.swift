//
//  ContentView.swift
//  i2048
//
//  Created by Rishi Singh on 16/12/24.
//

import SwiftUI
import SwiftData

enum SortOrder {
    case name // Name
    case createdOn // Game Created Date
    case lastPlayedOn // Last Played Date
    
    var id: Self {
        self
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var backgroundArtManager: BackgroundArtManager
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif
    
    @State private var selectedGame: Game?
    @State private var animationValues: [[Double]] = []
    @State private var settingsSheetOpen: Bool = false
    @State private var searchText: String = ""
    @State private var sortBy: SortOrder = .createdOn
    /// **sortOrder** true -> Ascending; false -> descending
    @State private var sortOrder: Bool = false
    
    
    
    private let gameController = GameController()
    
    init() {
        _ = CacheManager.shared
    }
    
    var body: some View {
        Group {
#if os(macOS)
            MacOSViewBuilder()
#elseif os(iOS)
            if horizontalSizeClass == .compact {
                IosViewBuilder()
            } else {
                IpadOSViewBuilder()
            }
#endif
        }
        .onChange(of: sortBy) { oldValue, newValue in
            print(oldValue)
            print(newValue)
        }
        .onChange(of: sortOrder) { oldValue, newValue in
            print(oldValue)
            print(newValue)
        }
#if os(iOS)
        .sheet(isPresented: $settingsSheetOpen, content: {
            SettingsView()
        })
#endif
    }
    
    #if os(macOS)
    @ViewBuilder
    func MacOSViewBuilder() -> some View {
        NavigationSplitView {
            MacOsGamesListBuilder()
                .frame(minWidth: 280, idealWidth: 300, maxWidth: 340)
                .searchable(text: $searchText, placement: .sidebar)
        } detail: {
            DetailView()
        }
        .keyboardReaction { gameHotKeys($0) }
    }
    
    @ViewBuilder
    func MacOsGamesListBuilder() -> some View {
        GamesListView(selectedGame: $selectedGame, animationValues: $animationValues, sortBy: sortBy, sortOrder: sortOrder, searchText: searchText)
        .navigationSplitViewColumnWidth(min: 220, ideal: 230)
        .toolbar(content: MacOSToolbarBuilder)
        .navigationTitle("i2048")
    }
    
    @ToolbarContentBuilder
    func MacOSToolbarBuilder() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Picker("Sort Games By", selection: $sortBy) {
                    Text("Name")
                    .tag(SortOrder.name)
                    Text("Game Created Date")
                    .tag(SortOrder.createdOn)
                    Text("Last Played Date")
                    .tag(SortOrder.lastPlayedOn)
                }
                .pickerStyle(.inline)
                Picker("Sort Order", selection: $sortOrder) {
                    Text("Ascending")
                    .tag(true)
                    Text("Descending")
                    .tag(false)
                }
                .pickerStyle(.inline)
            } label: {
                Image(systemName: "plus.circle")
            } primaryAction: {
                addGame()
            }
            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
        }
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
            IosGamesListBuilder()
        }
        .searchable(text: $searchText)
    }
    
    @ViewBuilder
    func IpadOSViewBuilder() -> some View {
        NavigationSplitView {
            IosGamesListBuilder()
        } detail: {
            DetailView()
        }
        .searchable(text: $searchText)
    }
    
    @ViewBuilder
    func IosGamesListBuilder() -> some View {
        GamesListView(selectedGame: $selectedGame, animationValues: $animationValues, sortBy: sortBy, sortOrder: sortOrder, searchText: searchText)
        .listStyle(.sidebar)
        .toolbar(content: IosToolbarBuilder)
        .navigationTitle("i2048")
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
                Divider().frame(height: 30)
                Menu {
                    Picker("Sort Games By", selection: $sortBy) {
                        Text("Name")
                        .tag(SortOrder.name)
                        Text("Game Created Date")
                        .tag(SortOrder.createdOn)
                        Text("Last Played Date")
                        .tag(SortOrder.lastPlayedOn)
                    }
                    .pickerStyle(.inline)
                    Picker("Sort Order", selection: $sortOrder) {
                        Text("Ascending")
                        .tag(true)
                        Text("Descending")
                        .tag(false)
                    }
                    .pickerStyle(.inline)
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
    #endif
    
    // MARK: - The detail view
    /// Detail view is used on macos and ipad for navigation split view
    @ViewBuilder
    func DetailView() -> some View {
        if let selectedGame = selectedGame {
            GameView(selectedGame: selectedGame, animationValues: $animationValues)
        } else {
            GameBackgroundImageView()
        }
    }
    
    func addGame() {
        let game = Game(name: "New Game", gridSize: 4)
        modelContext.insert(game)
        selectedGame = game
    }
}

#Preview {
    ContentView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
}
