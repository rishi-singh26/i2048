//
//  ArrayExtension.swift
//  i2048
//
//  Created by Rishi Singh on 29/12/24.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
