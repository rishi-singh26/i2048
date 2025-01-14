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
    case score // Game score
    
    var id: Self {
        self
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.openWindow) var openWindow
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var backgroundArtManager: BackgroundArtManager
    @EnvironmentObject var gameLogic: GameLogic
    
    @State private var settingsSheetOpen: Bool = false
    @State private var addGameSheetOpen: Bool = false
    @State private var showStatisticsView: Bool = false
    @State private var searchText: String = ""
    @State private var sortBy: SortOrder = .createdOn
    /// **sortOrder** true -> Ascending; false -> descending
    @State private var sortOrder: Bool = false
    
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
#if os(iOS)
        .sheet(isPresented: $settingsSheetOpen, content: {
            SettingsView()
        })
        .fullScreenCover(isPresented: $showStatisticsView) {
            StatisticsView()
        }
        .sheet(isPresented: $addGameSheetOpen, content: {
            AddGameView()
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
        GamesListView(sortBy: sortBy, sortOrder: sortOrder, searchText: searchText)
        .navigationSplitViewColumnWidth(min: 220, ideal: 230)
        .toolbar(content: MacOSToolbarBuilder)
        .navigationTitle("i2048")
    }
    
    @ToolbarContentBuilder
    func MacOSToolbarBuilder() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            HStack(spacing: 0) {
                Button {
                    openWindow(id: "newGame")
                } label: {
                    Image(systemName: "plus.circle")
                }
                Menu {
                    Button("Quick 3x3 Game", systemImage: "3.square") {
                        addGame(3)
                    }
                    Button("Quick 4x4 Game", systemImage: "4.alt.square") {
                        addGame(4)
                    }
                    Picker("Sort Games By", selection: $sortBy) {
                        Text("Name")
                            .tag(SortOrder.name)
                        Text("Score")
                            .tag(SortOrder.score)
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
                    Button("Statistics", systemImage: "chart.bar") {
                        openWindow(id: "statistics")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
    
    func gameHotKeys(_ event: NSEvent) -> NSEvent? {
        if event.modifierFlags.contains(.command) && gameLogic.selectedGame != nil {
            switch event.keyCode {
            case KeyCode.upArrow:
                withTransaction(Transaction(animation: .spring())) {
                    gameLogic.move(.up)
                }
                return nil // disable beep sound
            case KeyCode.downArrow:
                withTransaction(Transaction(animation: .spring())) {
                    gameLogic.move(.down)
                }
                return nil // disable beep sound
            case KeyCode.rightArrow:
                withTransaction(Transaction(animation: .spring())) {
                    gameLogic.move(.right)
                }
                return nil // disable beep sound
            case KeyCode.leftArrow:
                withTransaction(Transaction(animation: .spring())) {
                    gameLogic.move(.left)
                }
                return nil // disable beep sound
            case KeyCode.z:
                if let selectedGame = gameLogic.selectedGame, selectedGame.canUndo {
                    withTransaction(Transaction(animation: .spring())) {
                        gameLogic.undoStep()
                    }
                    return nil // disable beep sound
                } else {
                    return event // dont disable beep sound
                }
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
        NavigationSplitView {
            IosGamesListBuilder()
        } detail: {
            DetailView()
        }
        .searchable(text: $searchText)
    }
    
    @ViewBuilder
    func IosGamesListBuilder() -> some View {
        GamesListView(sortBy: sortBy, sortOrder: sortOrder, searchText: searchText)
        .listStyle(.sidebar)
        .toolbar(content: IosToolbarBuilder)
        .navigationTitle("i2048")
    }
    
    @ToolbarContentBuilder
    func IosToolbarBuilder() -> some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Menu {
                    Button("Quick 4x4 Game", systemImage: "4.alt.square") {
                        addGame(4)
                    }
                    Button("Quick 3x3 Game", systemImage: "3.square") {
                        addGame(3)
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add game")
                            .font(.headline)
                    }
                } primaryAction: {
                    addGameSheetOpen = true
                }
                Spacer()
                Button(action: {
                    showStatisticsView.toggle()
                }, label: {
                    Image(systemName: "chart.bar")
                })
                Divider().frame(height: 30)
                Button(action: {
                    settingsSheetOpen.toggle()
                }, label: {
                    Image(systemName: "switch.2")
                })
                Divider().frame(height: 30)
                Menu {
                    Picker("Sort Games By", selection: $sortBy) {
                        Text("Name")
                            .tag(SortOrder.name)
                        Text("Score")
                            .tag(SortOrder.score)
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
    
    // MARK: - Detail view
    /// Detail view is used on macos and ipad for navigation split view
    @ViewBuilder
    func DetailView() -> some View {
        if let _ = gameLogic.selectedGame {
            AnimatedGameView()
        } else {
            GameBackgroundImageView()
        }
    }
    
    func addGame(_ gridSize: Int) {
        let game = Game(
            name: "\(userDefaultsManager.quickGameNamePrefix) #\(gridSize)x\(gridSize)",
            gridSize: gridSize,
            allowUndo: userDefaultsManager.quickGameAllowUndo,
            newBlockNumber: userDefaultsManager.quickGameNewBlocNum,
            targetScore: gridSize == 3 ? userDefaultsManager.quick3GameTarget : userDefaultsManager.quick4GameTarget
        )
        modelContext.insert(game)
        gameLogic.selectedGame = game
    }
}

#Preview {
    ContentView()
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(BackgroundArtManager.shared)
        .environmentObject(GameLogic())
}
