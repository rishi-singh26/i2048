//
//  GridTileView.swift
//  i2048
//
//  Created by Rishi Singh on 18/12/24.
//

import SwiftUI

struct GridTileView: View {
    let value: Int
    let color: Color // color hexcode
    var scale: Double = 1.0
    
    var body: some View {
        Text(value == 0 ? "" : String(value))
            .frame(width: 70, height: 70)
            .background(color)
            .foregroundColor(Color(forBackground: color))
            .font(getFontSize())
            .cornerRadius(10)
//            .scaleEffect(value > 0 ? 1.0 : 0.8)
            .scaleEffect(scale)
            .opacity(value > 0 ? 1 : 0.5)
    }
    
    private func getFontSize() -> Font {
        let valueCount = String(value).count
        if valueCount < 4 {
            return .title.bold()
        } else if valueCount < 5 {
            return .title2.bold()
        } else {
            return .title3.bold()
        }
    }
}


#Preview {
    GridTileView(value: 2, color: .red)
}
