//
//  IAPManager.swift
//  i2048
//
//  Created by Rishi Singh on 15/02/25.
//

import SwiftUI
import StoreKit

@MainActor
class IAPManager: ObservableObject {
    static let shared = IAPManager()

    @Published var premiumProduct: Product?
    @Published var isLoading: Bool = false
    
    @Published var loadProductsError: String? = nil
    @Published var purchaseError: String? = nil

    private let productID = "in.rishisingh.i2048.premium"

    init() {
        Task {
            await loadProduct()
            await refreshPurchaseStatus()
            await listenForTransactionUpdates()
        }
    }

    func loadProduct() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let products = try await Product.products(for: [productID])
            premiumProduct = products.first
        } catch {
            loadProductsError = "Failed to load products"
//            print("Failed to load product: \(error)")
        }
    }

    func refreshPurchaseStatus() async {
        isLoading = true
        defer { isLoading = false }
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == productID,
               transaction.revocationDate == nil {
                UserDefaultsManager.shared.unlockPremiumAccess()
                return
            }
        }
        UserDefaultsManager.shared.resetPremiumAccess()
    }

    func purchasePremiumAccess() async {
        isLoading = true
        defer { isLoading = false }
        guard let product = premiumProduct else {
            loadProductsError = "Product not loaded."
            return
        }

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    UserDefaultsManager.shared.unlockPremiumAccess()
                case .unverified(_, let error):
                    purchaseError = "Purchase failed: Could not verify transaction. \(error.localizedDescription)"
//                    print("Transaction unverified: \(error)")
                    UserDefaultsManager.shared.resetPremiumAccess()
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            purchaseError = "Purchase failed"
//            print("Purchase failed: \(error)")
        }
    }
    
    private func listenForTransactionUpdates() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result,
               transaction.productID == productID {
                await transaction.finish()
                UserDefaultsManager.shared.unlockPremiumAccess()
            }
        }
    }

    func restorePurchases() async {
        await refreshPurchaseStatus()
    }
}
