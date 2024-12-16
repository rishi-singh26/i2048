//
//  GameVIew.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Bindable var game: Game
    
    @ObservedObject var viewModel = GameViewModel()
    
    @State private var showingGameOver = false
    @State private var showingWinAlert = false
    
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            
            VStack {
                VStack {
                    Text("Score: \(viewModel.score)")
                        .font(.title)
                        .bold()
                    Text("High Score: \(viewModel.highScore)")
                        .font(.title2)
                }
                .padding()

                VStack(spacing: 6) {
                    ForEach(0..<viewModel.gridSize, id: \.self) { row in
                        HStack(spacing: 6) {
                            ForEach(0..<viewModel.gridSize, id: \.self) { column in
                                CellView(number: viewModel.grid[row][column])
                                    .animation(.easeInOut, value: viewModel.grid[row][column])
                            }
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray)))
                .shadow(radius: 1)
            }

            Spacer()
            Spacer()
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    let horizontalAmount = gesture.translation.width as CGFloat
                    let verticalAmount = gesture.translation.height as CGFloat
                    if abs(horizontalAmount) > abs(verticalAmount) {
                        viewModel.swipe(direction: horizontalAmount > 0 ? .right : .left)
                    }
                    else {
                        viewModel.swipe(direction: verticalAmount > 0 ? .down : .up)
                    }
                    if viewModel.isGameOver() {
                        showingGameOver = true
                    }
                    if viewModel.grid.contains(where: { $0.contains(2048) }) {
                        showingWinAlert = true
                    }
                }
        )
        .alert(isPresented: $showingGameOver) {
            Alert(
                title: Text("Game Over"),
                message: Text("Your score: \(viewModel.score)"),
                dismissButton: .default(Text("Done"))
            )
        }
        .alert("Congratulations!", isPresented: $showingWinAlert) {
           Button("Continue", role: .cancel) { showingWinAlert = false }
       } message: {
           Text("You've reached 2048!")
       }
#if os(iOS)
        .background(LinearGradient(gradient: Gradient(colors: getGradienColors()), startPoint: UnitPoint(x: 0, y: -0.2), endPoint: UnitPoint(x: 0, y: 0.7)))
        .scrollContentBackground(.hidden)
#endif
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

struct CellView: View {
    let number: Int

    var body: some View {
        Text(number == 0 ? "" : "\(number)")
            .frame(width: 70, height: 70)
            .background(colorForValue(number))
            .foregroundColor(.white)
            .font(.title.bold())
            .cornerRadius(10)
            .scaleEffect(number > 0 ? 1.0 : 0.8)
            .opacity(number > 0 ? 1 : 0.5)
    }

    private func colorForValue(_ value: Int) -> Color {
        switch value {
        case 2:
            return Color.yellow
        case 4:
            return Color.orange
        case 8:
            return Color.pink
        case 16:
            return Color.purple
        case 32:
            return Color.red
        case 64:
            return Color.red.opacity(0.8)
        case 128:
            return Color.blue
        case 256:
            return Color.blue.opacity(0.8)
        case 512:
            return Color.green
        case 1024:
            return Color.green.opacity(0.8)
        case 2048:
            return Color.gold
        case 4096:
            return Color.indigo
        case 8192:
            return Color.purple.opacity(0.5)
        default:
            return Color.gray.opacity(0.3)
        }
    }

}

extension Color {
    static let gold = Color(red: 1, green: 215/255, blue: 0)
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Game.self, configurations: config)
        let example = Game(name: "Preview Game", gridSize: 4)
        return GameView(game: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to created model container")
    }
}
