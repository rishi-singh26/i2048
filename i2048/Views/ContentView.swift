//
//  ContentView.swift
//  i2048
//
//  Created by Rishi Singh on 16/12/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    @Query var games: [Game]
    @State private var path = [Game]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(games) {game in
                    NavigationLink(value: game) {
                        GameTileView(game: game)
                    }
                }
                .onDelete(perform: deleteGames)
            }
#if os(iOS)
            .background(LinearGradient(gradient: Gradient(colors: getGradienColors()), startPoint: UnitPoint(x: 0, y: -0.2), endPoint: UnitPoint(x: 0, y: 0.7)))
            .scrollContentBackground(.hidden)
#endif
            .navigationTitle("i2048")
            .navigationDestination(for: Game.self, destination: { game in
                GameView(game: game)
            })
            .toolbar {
                Button("Add", action: addGame)
            }
        }
    }
    
    func addGame() {
        let game = Game(name: "Game #\(games.count + 1)", gridSize: 4)
        modelContext.insert(game)
        path = [game]
    }
    
    func deleteGames(_ indexSet: IndexSet) {
        for index in indexSet {
            let game = games[index]
            modelContext.delete(game)
        }
    }
    
#if os(iOS)
    func getGradienColors() -> [Color] {
        if colorScheme == .dark {
            return [
                Color(red: 0.57, green: 0.21, blue: 0.07, opacity: 1.00),
                .black,
                .black,
            ]
        } else {
            return [
                Color(red: 1.00, green: 0.69, blue: 0.53, opacity: 1.00),
                Color(uiColor: UIColor.secondarySystemBackground),
                Color(uiColor: UIColor.secondarySystemBackground),
            ]
        }
    }
#endif
}

#Preview {
    ContentView()
}
