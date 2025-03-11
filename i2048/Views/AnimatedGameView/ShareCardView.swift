//
//  ShareCardView.swift
//  i2048
//
//  Created by Rishi Singh on 05/03/25.
//

import SwiftUI
import SwiftData

struct ShareCardView: View {
    @EnvironmentObject var gameLogic: GameLogic
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
        
    var body: some View {
#if os(iOS)
        BuildIOSGameInfo(selectedGame: gameLogic.selectedGame, showShareButton: true)
#elseif os(macOS)
        BuildMacGameInfo(selectedGame: gameLogic.selectedGame)
#endif
    }
    
    // MARK: - iOS Game card
    @ViewBuilder
    func BuildIOSGameInfo(selectedGame: Game?, showShareButton: Bool = false) -> some View {
        VStack(alignment: .center) {
            if let selectedGame = gameLogic.selectedGame {
                BlockGridView(
                    matrix: gameLogic.blockMatrix,
                    blockEnterEdge: .from(gameLogic.lastGestureDirection)
                )
                BuildScoreCard(selectedGame: selectedGame)
                NewBlockCard(selectedGame: selectedGame)
                BuildGameConfigCard(selectedGame: selectedGame)
                // Share Button
//                if showShareButton {
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            takeScreenshotAndShare()
//                        }) {
//                            Text("Share Game")
//                                .font(.title2)
//                                .foregroundColor(.white)
//                                .padding(.vertical)
//                                .frame(width: 200)
//                                .background(.black)
//                                .cornerRadius(20)
//                        }
//                        .buttonStyle(.plain)
//                        Spacer()
//                    }
//                    .padding(.top, 30)
//                }
            }
        }
        .padding(30)
    }
    
    // MARK: - MacOS Game card
    @ViewBuilder
    func BuildMacGameInfo(selectedGame: Game?) -> some View {
        ZStack(alignment: .center) {
            GameBackgroundImageView(game: selectedGame)
            BuildIOSGameInfo(selectedGame: selectedGame)
        }
    }
    
    // MARK: - Score card builder
    @ViewBuilder
    func BuildScoreCard(selectedGame: Game) -> some View {
        HStack {
            VStack {
                Text("High Score")
                Text("\(userDefaultsManager.highScore)")
                    .font(.title)
            }
            .frame(maxWidth: .infinity)
            Divider().frame(height: 60)
            VStack {
                Text("Score")
                Text("\(selectedGame.score)")
                    .font(.title)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(minWidth: 300, maxWidth: 350)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .environment(\.colorScheme, selectedGame.gameColorMode ? .light : .dark)
        .cornerRadius(10)
    }
    
    // MARK: - New bloc in game card
    @ViewBuilder
    func NewBlockCard(selectedGame: Game) -> some View {
        HStack {
            if selectedGame.newBlockNumber == 0 {
                HStack {
                    Image(systemName: "2.square")
                    Text("/")
                    Image(systemName: "4.square")
                }
            } else if selectedGame.newBlockNumber == 2 {
                Image(systemName: "2.square")
            } else if selectedGame.newBlockNumber == 4 {
                Image(systemName: "4.square")
            } else {
                Image(systemName: "4.square")
            }
            Spacer()
            Text("New Block")
        }
        .font(.title2)
        .padding(.horizontal, 20)
        .padding()
        .frame(minWidth: 300, maxWidth: 350)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .environment(\.colorScheme, selectedGame.gameColorMode ? .light : .dark)
        .cornerRadius(10)
    }
    
    // MARK: - Game config card builder
    @ViewBuilder
    func BuildGameConfigCard(selectedGame: Game) -> some View {
        HStack {
            HStack {
                Image(systemName: "arrow.uturn.backward.circle")
                Text(selectedGame.allowUndo ? "Enabled" : "Disabled")
                .frame(maxWidth: .infinity)
            }
            .font(.title2)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .environment(\.colorScheme, selectedGame.gameColorMode ? .light : .dark)
            .cornerRadius(10)
            HStack {
                Image(systemName: "target")
                Text(String(selectedGame.targetScore))
                    .frame(maxWidth: .infinity)
            }
            .font(.title2)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .environment(\.colorScheme, selectedGame.gameColorMode ? .light : .dark)
            .cornerRadius(10)
        }
        .frame(minWidth: 300, maxWidth: 350)
    }
}

#Preview {
    ShareCardView()
        .environmentObject(GameLogic.shared)
        .environmentObject(UserDefaultsManager.shared)
}
