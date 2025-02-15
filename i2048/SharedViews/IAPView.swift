//
//  IAPView.swift
//  i2048
//
//  Created by Rishi Singh on 15/02/25.
//

import SwiftUI

struct IAPView: View {
    var isWindow: Bool = false
    @StateObject private var iapManager = InAppPurchaseManager()
    @Environment(\.dismiss) var dismiss
    
    let iOSPremiumFeatures: [String] = [
        "App Icons",
        "Create Quick Games",
        "Play 3x3 Games",
        "Undo Game Step",
        "Enable Haptic Feedback",
        "Choose Target Score for games",
        "Choose the number on New Blocks",
        "Share Game Score",
    ]
    
    let macOSPremiumFeatures: [String] = [
        "One hand keyboard shortcuts",
        "Create Quick Games",
        "Play 3x3 Games",
        "Undo Game Step",
        "Choose Target Score for games",
        "Choose the number on New Blocks",
        "Share Game Score",
    ]

    var body: some View {
#if os(iOS)
        NavigationView {
            IAPViewBuilder(desktopView: false, features: iOSPremiumFeatures)
        }
        .onAppear {
            iapManager.fetchProducts()
        }
#elseif os(macOS)
        IAPViewBuilder(desktopView: true, features: macOSPremiumFeatures)
            .frame(width: 350, height: 700)
            .onAppear {
                iapManager.fetchProducts()
            }
#endif
    }
    
    @ViewBuilder
    func IAPViewBuilder(desktopView: Bool, features: [String]) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                // Product List
                Image("PremiumScreenIcon")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.top)
                    .shadow(color: Color(hex: "#FBAE2A"), radius: 50)
                
                Text("Upgrade to Premium")
                    .font(.title.bold())
                    .padding(.top)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(features, id: \.self) { feature in
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(.blue)
                                    .padding(.trailing, 8)
                                Text(feature)
                                    .font(.headline)
                            }
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                }
                .padding(.vertical, 6)
                
                ForEach(iapManager.products, id: \.productIdentifier) { product in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(product.localizedTitle)
                                .font(.headline)
                            Text(product.localizedDescription)
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action: {
                            iapManager.purchaseProduct(product)
                        }) {
                            Text(product.priceString())
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(15)
                    .background(Color("SecondaryBackground"))
                    .cornerRadius(15)
                    .padding(20)
                }
                
                // Restore Purchases Button
                Button(action: {
                    iapManager.restorePurchases()
                }) {
                    Text("Restore Purchases")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 15)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
                Text("Restore your subscription if it hasn't synced automatically")
                    .font(.caption)
            }
            .padding(.vertical, desktopView ? 20 : 0)
            
            if !isWindow {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)
                .padding()
            }
        }
    }
}

#Preview {
    IAPView()
        .environmentObject(InAppPurchaseManager.shared)
}
