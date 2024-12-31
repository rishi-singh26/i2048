//
//  BlockGridView.swift
//  SwiftUI2048
//
//  Created by Hongyu on 6/5/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

import SwiftUI

struct AnchoredScale : ViewModifier {
    
    let scaleFactor: CGFloat
    let anchor: UnitPoint
    
    func body(content: Self.Content) -> some View {
        content.scaleEffect(scaleFactor, anchor: anchor)
    }
    
}

struct BlurEffect : ViewModifier {
    
    let blurRaduis: CGFloat
    
    func body(content: Self.Content) -> some View {
        content.blur(radius: blurRaduis)
    }
    
}

struct MergedViewModifier<M1, M2> : ViewModifier where M1: ViewModifier, M2: ViewModifier {
    
    let m1: M1
    let m2: M2
    
    init(first: M1, second: M2) {
        m1 = first
        m2 = second
    }
    
    func body(content: Self.Content) -> some View {
        content.modifier(m1).modifier(m2)
    }
    
}

extension AnyTransition {
    
    static func blockGenerated(from: Edge, position: CGPoint, `in`: CGRect) -> AnyTransition {
        let anchor = UnitPoint(x: position.x / `in`.width, y: position.y / `in`.height)
        
        return .asymmetric(
            insertion: AnyTransition.opacity.combined(with: .move(edge: from)),
            removal: AnyTransition.opacity.combined(with: .modifier(
                active: MergedViewModifier(
                    first: AnchoredScale(scaleFactor: 0.8, anchor: anchor),
                    second: BlurEffect(blurRaduis: 20)
                ),
                identity: MergedViewModifier(
                    first: AnchoredScale(scaleFactor: 1, anchor: anchor),
                    second: BlurEffect(blurRaduis: 0)
                )
            ))
        )
    }
    
}

struct BlockGridView : View {
    @EnvironmentObject var gameLogic: GameLogic
    typealias SupportingMatrix = BlockMatrix<IdentifiedBlock>
    
    let matrix: Self.SupportingMatrix
    let blockEnterEdge: Edge
    
    func createBlock(
        _ block: IdentifiedBlock?,
        at index: IndexedBlock<IdentifiedBlock>.Index,
        width: CGFloat
    ) -> some View {
        let blockView: BlockView
        if let block = block {
            blockView = BlockView(block: block, color: colorForValue(block.number))
        } else {
            blockView = BlockView.blank(color: colorForValue(-1))
        }
        
        // TODO: Still need refactor, these hard-coded values sucks!!
        let blockSize: CGFloat = 65
        let spacing: CGFloat = 12
        
        let position = CGPoint(
            x: CGFloat(index.0) * (blockSize + spacing) + blockSize / 2 + spacing,
            y: CGFloat(index.1) * (blockSize + spacing) + blockSize / 2 + spacing
        )
        
        return blockView
            .frame(width: 65, height: 65, alignment: .center)
            .position(x: position.x, y: position.y)
            .transition(.blockGenerated(
                from: self.blockEnterEdge,
                position: CGPoint(x: position.x, y: position.y),
                in: CGRect(x: 0, y: 0, width: width, height: width)
            ))
    }
    
    var body: some View {
        let gridSize = gameLogic.selectedGame?.gridSize ?? 4
        let width: CGFloat = gameLogic.selectedGame?.gridSize == 4 ? 320.0 : 240.0
        ZStack {
            // Background grid blocks:
            ForEach(0..<gridSize, id: \.self) { x in
                ForEach(0..<gridSize, id: \.self) { y in
                    self.createBlock(nil, at: (x, y), width: width)
                }
            }
            .zIndex(1)
            
            // Number blocks:
            ForEach(self.matrix.flatten, id: \.item.id) {
                self.createBlock($0.item, at: $0.index, width: width)
            }
            .zIndex(1000)
            .animation(.interactiveSpring(response: 0.0, dampingFraction: 0.0), value: true)
        }
        .frame(width: width, height: width, alignment: .center)
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .environment(\.colorScheme, gameLogic.selectedGame?.gameColorMode ?? false ? .light : .dark)
        .cornerRadius(10)
    }
    
    private func colorForValue(_ value: Int) -> Color {
        if let selectedGame = gameLogic.selectedGame {
            switch value {
            case 2:
                return Color(hex: selectedGame.color2)
            case 4:
                return Color(hex: selectedGame.color4)
            case 8:
                return Color(hex: selectedGame.color8)
            case 16:
                return Color(hex: selectedGame.color16)
            case 32:
                return Color(hex: selectedGame.color32)
            case 64:
                return Color(hex: selectedGame.color64)
            case 128:
                return Color(hex: selectedGame.color128)
            case 256:
                return Color(hex: selectedGame.color256)
            case 512:
                return Color(hex: selectedGame.color512)
            case 1024:
                return Color(hex: selectedGame.color1024)
            case 2048:
                return Color(hex: selectedGame.color2048)
                // Color(red: 1.0, green: 0.84, blue: 0.0) // RGB for gold
            case 4096:
                return Color(hex: selectedGame.color4096)
            case 8192:
                return Color(hex: selectedGame.color8192)
            default:
                return Color(hex: selectedGame.color16384)
            }
        } else {
            return Color.clear
        }
    }
}

#Preview {
    AnimatedGameView()
        .environmentObject(GameLogic())
}
