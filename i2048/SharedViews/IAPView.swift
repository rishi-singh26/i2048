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
    @EnvironmentObject var purchaseManager: IAPManager
    
    @Environment(\.dismiss) var dismiss
    @State private var rotationAngle: Double = 0
    
    private let rotationDuration: Double = 30 // seconds per rotation
    
    var isWindow: Bool = false
        
    @State private var error: (any Error)?
//    @State private var storeKitError: StoreKitError?
    @State private var showErrorAlert: Bool = false
    @State private var showStoreKitErrorAlert: Bool = false
    @State private var hasDonated = false

    
    let iOSPremiumFeatures: [String] = [
        "App Icons:app.gift",
        "Create Quick Games:bolt.circle",
        "Play 3x3 Games:square.grid.3x3",
        "Undo Game Step:arrow.uturn.backward.circle",
        "Enable Haptic Feedback:hand.point.up.left.and.text",
        "Choose Target Score for games:target",
        "Choose the number on New Blocks:2.square",
    ]
    
    let macOSPremiumFeatures: [String] = [
        "One hand keyboard shortcuts:keyboard",
        "Create Quick Games:bolt.circle",
        "Play 3x3 Games:square.grid.3x3",
        "Undo Game Step:arrow.uturn.backward.circle",
        "Choose Target Score for games:target",
        "Choose the number on New Blocks:2.square",
    ]

    var body: some View {
        Group {
#if os(iOS)
            NavigationView {
                IAPVIOSiewBuilder(features: iOSPremiumFeatures)
            }
#elseif os(macOS)
            IAPMacOSViewBuilder(features: macOSPremiumFeatures)
                .frame(width: 400, height: 700)
#endif
        }
        .onAppear(perform: {
            Task {
                await purchaseManager.refreshPurchaseStatus()
            }
        })
        .alert("Alert!", isPresented: .constant(purchaseManager.loadProductsError != nil || purchaseManager.purchaseError != nil)) {
            Button("Ok") {
                purchaseManager.loadProductsError = nil
                purchaseManager.purchaseError = nil
            }
        } message: {
            Text(purchaseManager.purchaseError ?? purchaseManager.purchaseError ?? "")
        }
    }
    
#if os(iOS)
    @ViewBuilder
    func IAPVIOSiewBuilder(features: [String]) -> some View {
        Group {
            if userDefaultsManager.isPremiumUser {
                BuildPremiumUserView(features: features)
            } else if let product = purchaseManager.premiumProduct {
                BuildIOSBuyPremiumView(product: product)
            } else {
                VStack {
                    Text(purchaseManager.isLoading ? "Loading..." : "Something went wrong, please contact developer")
                }
            }
        }
        .navigationTitle("Premium")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Label("Done", systemImage: "xmark.circle.fill")
                }
            }
        }
    }
    
    @ViewBuilder
    func BuildIOSBuyPremiumView(product: Product) -> some View {
        ZStack(alignment: .bottom) {
            List {
                Section {
                    VStack(alignment: .leading) {
                        Image("PremiumScreenIcon")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .shadow(color: Color(hex: "#54F06F"), radius: 20)
                        Text(product.displayName)
                            .font(.title2.bold())
                        Text(product.description)
                            .font(.body.bold())
                        Divider()
                        HStack {
                            Image(systemName: "creditcard")
                            Text("\(product.displayPrice) one time purchase")
                        }
                        .padding(.top, 5)
                    }
                }
                Section {
                    VStack(alignment: .leading) {
                        Text("Premium Features")
                            .font(.title2.bold())
                            .padding(.bottom, 5)
                        ForEach(iOSPremiumFeatures, id: \.self) { feature in
                            HStack {
                                Image(systemName: String(feature.split(separator: ":")[1]))
                                    .foregroundStyle(.blue)
                                    .padding(.trailing, 8)
                                Text(feature.split(separator: ":")[0])
                            }
                            .padding(.bottom, 1)
                        }
                    }
                }
            }
            
            VStack(alignment: .center) {
                Text("\(product.displayPrice) one time purchase")
                    .font(.footnote)
                    .padding(.top, 8)
                Button {
                    Task {
                        await purchaseManager.purchasePremiumAccess()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Buy Premium")
                            .font(.body.bold())
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                        Spacer()
                    }
                    .background(.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 15)
                }
                
                Button {
                    Task {
                        await purchaseManager.restorePurchases()
                    }
                } label: {
                    Text("Restore Purchase")
                        .font(.body.bold())
                        .foregroundColor(.blue)
                        .padding(.vertical, 6)
                }
                Text("Restore your purchase if it hasn't synced automatically")
                    .font(.caption)
            }
            .frame(height: 160)
            .background(.thinMaterial)
        }
    }
#endif
    
#if os(macOS)
    @ViewBuilder
    func IAPMacOSViewBuilder(features: [String]) -> some View {
        Group {
            if userDefaultsManager.isPremiumUser {
                BuildPremiumUserView(features: features)
            } else if let product = purchaseManager.premiumProduct {
                BuildMacOSBuyPremiumView(product: product)
            } else {
                VStack {
                    Text(purchaseManager.isLoading ? "Loading..." : "Something went wrong, please contact developer")
                }
            }
        }
        .navigationTitle("Premium")
        .toolbar {
            if !isWindow {
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
    }
    
    @ViewBuilder
    func BuildMacOSBuyPremiumView(product: Product) -> some View {
        List {
            MacCustomSection(header: "") {
                VStack {
                    Image("PremiumScreenIcon")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .shadow(color: Color(hex: "#54F06F"), radius: 20)
                    Text(product.displayName)
                        .font(.title2.bold())
                    Text(product.description)
                        .font(.body.bold())
                    Divider()
                    HStack {
                        Image(systemName: "creditcard")
                        Text("\(product.displayPrice) one time purchase")
                    }
                    .padding(.top, 5)
                }
            }
            .listRowSeparator(.hidden)
            
            MacCustomSection {
                VStack(alignment: .leading) {
                    Text("Premium Features")
                        .font(.title2.bold())
                        .padding(.bottom, 5)
                    Divider()
                    ForEach(macOSPremiumFeatures, id: \.self) { feature in
                        HStack {
                            Image(systemName: String(feature.split(separator: ":")[1]))
                                .foregroundStyle(.blue)
                                .padding(.trailing, 8)
                            Text(feature.split(separator: ":")[0])
                        }
                        .padding(.bottom, 1)
                    }
                }
            }
            .listRowSeparator(.hidden)
            
            VStack(alignment: .center) {
                Spacer()
                Text("\(product.displayPrice) one time purchase")
                    .font(.footnote)
                Button {
                    Task {
                        await purchaseManager.purchasePremiumAccess()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Buy Premium")
                            .font(.body.bold())
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                        Spacer()
                    }
                    .background(.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 15)
                }
                .buttonStyle(.plain)
                
                Button {
                    Task {
                        await purchaseManager.restorePurchases()
                    }
                } label: {
                    Text("Restore Purchase")
                        .font(.body.bold())
                        .foregroundColor(.blue)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.plain)
                Text("Restore your purchase if it hasn't synced automatically")
                    .font(.caption)
            }
            .padding(20)
        }
        .listStyle(.plain)
    }
#endif
    
    @ViewBuilder
    func BuildPremiumUserView(features: [String]) -> some View {
        VStack(alignment: .center, spacing: 30) {
            ZStack(alignment: .center) {
                Image(systemName: "seal.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(Color(hex: "54F06F"))
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(.linear(duration: rotationDuration).repeatForever(autoreverses: false), value: rotationAngle)
                Image(systemName: "crown.fill")
                    .resizable()
                    .frame(width: 60, height: 50)
                    .foregroundStyle(.white)
            }
            .shadow(color: Color(hex: "#54F06F"), radius: 50)
            .onAppear {
                rotationAngle = 360
            }
            
            Text("You have premium access to i2048.")
                .font(.body.bold())
            
            Text("Premium Features")
                .font(.title.bold())
//                .padding(.top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(features, id: \.self) { feature in
                        HStack {
                            Image(systemName: String(feature.split(separator: ":")[1]))
                                .foregroundStyle(.blue)
                                .padding(.trailing, 8)
                            Text(feature.split(separator: ":")[0])
                                .font(.headline)
                        }
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 10)
            }
            .padding(.vertical, 6)
#if os(iOS)
            DismissBtnBuilder()
#elseif os(macOS)
            if !isWindow {
                DismissBtnBuilder()
            }
#endif
        }
    }
    
    @ViewBuilder
    func DismissBtnBuilder() -> some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Spacer()
                Text("Great")
                    .font(.body.bold())
                    .foregroundStyle(.white)
                    .padding(.vertical, 12)
                Spacer()
            }
            .background(.blue)
            .cornerRadius(12)
            .padding(.horizontal, 15)
        }
        .padding(.bottom, 10)
#if os(macOS)
        .buttonStyle(.plain)
#endif
    }
}

#Preview {
    IAPView(isWindow: false)
        .environmentObject(UserDefaultsManager.shared)
        .environmentObject(IAPManager.shared)
}
