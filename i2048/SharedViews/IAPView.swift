//
//  IAPView.swift
//  i2048
//
//  Created by Rishi Singh on 15/02/25.
//

import SwiftUI
import StoreKit

struct IAPView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @Environment(\.dismiss) var dismiss
    
    var isWindow: Bool = false
        
    @State private var error: (any Error)?
    @State private var storeKitError: StoreKitError?
    @State private var showErrorAlert: Bool = false
    @State private var showStoreKitErrorAlert: Bool = false
    @State private var hasDonated = false

    
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
#elseif os(macOS)
        IAPViewBuilder(desktopView: true, features: macOSPremiumFeatures)
            .frame(width: 350, height: 700)
#endif
    }
    
    @ViewBuilder
    func IAPViewBuilder(desktopView: Bool, features: [String]) -> some View {
        ZStack(alignment: .top) {
            VStack {
                Image("PremiumScreenIcon")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.top)
                    .shadow(color: Color(hex: "#54F06F"), radius: 50)
                
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
                
                VStack(alignment: .leading) {
//                    Text("Get Access to Premium Features")
//                        .font(.system(size: 14))
//                        .accessibilityAddTraits(.isHeader)
                    
                    ProductView(id: "in.rishisingh.i2048.lifetime", prefersPromotionalIcon: true) {
//                        Label("Premium", systemImage: "crown.fill")
//                            .labelStyle(.iconOnly)
                    }
                }
                .accessibilityElement(children: .contain)
                .storeProductsTask(for: ["in.rishisingh.i2048.lifetime"]) { taskState in
                    switch taskState {
                    case .loading, .success:
                        userDefaultsManager.isPremiumUser = true
                        break
                    case .failure(let error):
                        self.presentError(error)
                    @unknown default:
                        assertionFailure()
                    }
                }
                .alert(error?.localizedDescription ?? "", isPresented: $showErrorAlert, actions: {
                    Button("OK", role: .cancel) { }
                })
                .alert(storeKitError?.localizedDescription ?? "", isPresented: $showStoreKitErrorAlert, actions: {
                    Button("OK", role: .cancel) { }
                })
                
//                ForEach(iapManager.products, id: \.productIdentifier) { product in
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(product.localizedTitle)
//                                .font(.headline)
//                            Text(product.localizedDescription)
//                                .font(.subheadline)
//                        }
//                        Spacer()
//                        Button(action: {
//                            iapManager.purchaseProduct(product)
//                        }) {
//                            Text(product.priceString())
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .padding(.vertical, 6)
//                                .padding(.horizontal, 10)
//                                .background(Color.blue)
//                                .cornerRadius(10)
//                        }
//                        .buttonStyle(.plain)
//                    }
//                    .padding(15)
//                    .background(Color("SecondaryBackground"))
//                    .cornerRadius(15)
//                    .padding(20)
//                }
                
                // Restore Purchases Button
                Button(action: {
                    Task {
                        do {
                            try await AppStore.sync()
                        } catch {
                            self.presentError(error)
                        }
                    }
                }) {
                    Text("Restore Purchases")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 15)
//                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
                Text("Restore your purchase if it hasn't synced automatically")
                    .font(.caption)
            }
            .padding(.vertical, desktopView ? 20 : 0)
            
            if !isWindow {
                HStack {
                    Spacer()
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
    
    private func presentError(_ error: any Error) {
        switch error {
        case StoreKitError.userCancelled:
            break
        case let error as StoreKitError:
            self.storeKitError = error
            self.showStoreKitErrorAlert = true
        default:
            self.error = error
            self.showErrorAlert = true
        }
    }
}

private struct OnetimeProductViewStyle: ProductViewStyle {
    
    @State private var error: (any Error)?
    @State private var showErrorAlert: Bool = false
    
    
    func makeBody(configuration: Configuration) -> some View {
        
        switch configuration.state {
        case .success(let product):
            self.productView(product, icon: configuration.icon)
        default:
            ProductView(configuration)
        }
    }
    
    
    /// Returns the view to display when the state is success.
    @ViewBuilder private func productView(_ product: Product, icon: ProductViewStyleConfiguration.Icon) -> some View {
        
        HStack(alignment: .top, spacing: 10) {
            icon
                .font(.system(size: 28))
                .foregroundStyle(.secondary)
                .productIconBorder()
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    HStack {
                        Text(product.displayName)
                            .fixedSize()
                            .frame(minWidth: 28, alignment: .trailing)
                    }.accessibilityElement(children: .combine)
                }
                
                Text(product.description)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button {
                    Task {
                        do {
                            _ = try await product.purchase()
                        } catch {
                            self.error = error
                        }
                    }
                } label: {
                    Text(product.price.formatted(product.priceFormatStyle))
                        .font(.system(size: 11))
                }
                .monospacedDigit()
                .fixedSize()
                .padding(.top, 6)
            }
            .accessibilityElement(children: .contain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .alert(error?.localizedDescription ?? "", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    IAPView()
//        .environmentObject(InAppPurchaseManager.shared)
}
