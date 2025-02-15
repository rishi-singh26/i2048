//
//  SKProductExtension.swift
//  i2048
//
//  Created by Rishi Singh on 15/02/25.
//

import StoreKit

extension SKProduct {
    func priceString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price) ?? "$\(self.price)"
    }
}
