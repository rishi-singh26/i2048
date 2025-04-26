//
//  IAPManager.swift
//  i2048
//
//  Created by Rishi Singh on 15/02/25.
//

//import Foundation
//import StoreKit
//import SwiftUI
//
//let productIDs: Set<String> = ["in.rishisingh.i2048.lifetime"]
//
//class InAppPurchaseManager: NSObject, ObservableObject, SKProductsRequestDelegate {
//    static let shared = InAppPurchaseManager()
//    @Published var products: [SKProduct] = []
//
//    func fetchProducts() {
//        let request = SKProductsRequest(productIdentifiers: productIDs)
//        request.delegate = self
//        request.start()
//    }
//
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        DispatchQueue.main.async {
//            self.products = response.products
//        }
//    }
//    
//    func purchaseProduct(_ product: SKProduct) {
//        let payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
//    }
//    
//    func restorePurchases() {
//        SKPaymentQueue.default().restoreCompletedTransactions()
//    }
//}
//
//
//// MARK: - IAP Purchase Observer
//class InAppPurchaseObserver: NSObject, SKPaymentTransactionObserver {
//    @ObservedObject var userDefaultsManager = UserDefaultsManager()
//    
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            switch transaction.transactionState {
//            case .purchased:
//                // Handle successful purchase
//                unlockFeature(for: transaction.payment.productIdentifier)
//                SKPaymentQueue.default().finishTransaction(transaction)
//            case .restored:
//                // Handle restored purchase
//                unlockFeature(for: transaction.payment.productIdentifier)
//                SKPaymentQueue.default().finishTransaction(transaction)
//            case .failed:
//                SKPaymentQueue.default().finishTransaction(transaction)
//            default:
//                break
//            }
//        }
//    }
//
//    private func unlockFeature(for productIdentifier: String) {
//        // Unlock your feature here based on the product identifier
//        if productIdentifier == productIDs.first {
//            userDefaultsManager.unlockLifetimeAccess()
//        }
//    }
//}
//
