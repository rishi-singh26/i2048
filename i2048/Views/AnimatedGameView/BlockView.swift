//
//  BlockView.swift
//  SwiftUI2048
//
//  Created by Hongyu on 6/5/19.
//  Copyright © 2019 Cyandev. All rights reserved.
//

import SwiftUI

struct BlockView : View {
    fileprivate let number: Int?
    private var color: Color
    
    // This is required to make the Text element be a different
    // instance every time the block is updated. Otherwise, the
    // text will be incorrectly rendered.
    //
    // TODO: File a bug.
    fileprivate let textId: String?
    
    init(block: IdentifiedBlock, color: Color) {
        self.number = block.number
        self.textId = "\(block.id):\(block.number)"
        self.color = color
    }
    
    fileprivate init(color: Color) {
        self.number = nil
        self.textId = ""
        self.color = color
    }
    
    static func blank(color: Color) -> Self {
        return self.init(color: color)
    }
    
    fileprivate var numberText: String {
        if number == 0 {
            return ""
        }
        guard let number = number else {
            return ""
        }
        return String(number)
    }
    
    // MARK: Body
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .zIndex(1)

            Text(numberText)
                .font(getFontSize())
                .foregroundColor(Color(forBackground: color))
                .id(textId!)
                // ⚠️ Gotcha: `zIndex` is important for removal transition!!
                .zIndex(1000)
                .transition(AnyTransition.opacity.combined(with: .scale))
        }
        .clipped()
        .cornerRadius(6)
    }
    
    private func getFontSize() -> Font {
        let valueCount = numberText.count
        if valueCount < 4 {
            return .title.bold()
        } else if valueCount < 5 {
            return .title2.bold()
        } else {
            return .title3.bold()
        }
    }
}
