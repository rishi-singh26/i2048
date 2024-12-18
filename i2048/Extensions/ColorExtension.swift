//
//  ColorExtension.swift
//  i2048
//
//  Created by Rishi Singh on 17/12/24.
//

import SwiftUI

extension Color {
    /// Initialize a Color using a hex code
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)

        let r, g, b, a: Double
         switch hexSanitized.count {
         case 6: // RGB (e.g., "#RRGGBB")
             r = Double((int >> 16) & 0xFF) / 255.0
             g = Double((int >> 8) & 0xFF) / 255.0
             b = Double(int & 0xFF) / 255.0
             a = 1.0
         case 8: // RGBA (e.g., "#RRGGBBAA")
             r = Double((int >> 24) & 0xFF) / 255.0
             g = Double((int >> 16) & 0xFF) / 255.0
             b = Double((int >> 8) & 0xFF) / 255.0
             a = Double(int & 0xFF) / 255.0
         default:
             r = 0
             g = 0
             b = 0
             a = 1.0
         }
         
         self.init(red: r, green: g, blue: b, opacity: a)
    }
}

