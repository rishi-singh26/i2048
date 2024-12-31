//
//  AnimatedIconsView.swift
//  i2048
//
//  Created by Rishi Singh on 31/12/24.
//

import SwiftUI

import SwiftUI

struct AnimatedIconsView: View {
    let symbols: [String] // Array of SF Symbol names
    let animationDuration: Double // Duration per symbol
    
    @State private var timer: Timer? = nil
    @State private var currentSymbolIndex = 0
    
    init(symbols: [String], animationDuration: Double) {
        self.currentSymbolIndex = 0
        self.symbols = symbols
        self.animationDuration = animationDuration
        stopTimer()
    }
    
    var body: some View {
        Image(systemName: symbols[safe: currentSymbolIndex] ?? symbols.first ?? "questionmark.circle")
            .onAppear(perform: startAnimation)
            .onDisappear(perform: stopTimer)
    }
    
    private func startAnimation() {
        guard symbols.count > 1 else { return }
        timer = Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
            guard symbols.count > 1 else { return }
            withAnimation(.easeInOut(duration: 1)) {
                currentSymbolIndex = (currentSymbolIndex + 1) % symbols.count
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    AnimatedIconsView(
        symbols: ["die.face.1", "die.face.2", "die.face.3", "die.face.4"],
        animationDuration: 2.0
    )
}
