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
    @State private var rotationAngle: Double = 0
    
    private let rotationDuration: Double = 30 // seconds per rotation
    
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
        Group {
            if userDefaultsManager.isPremiumUser {
                BuildPremiumUserView(features: features)
            } else {
                BuildBuyPremoimView(features: features, desktopView: desktopView)
            }
        }
        .navigationTitle("Premium")
#if os(iOS)
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
#elseif os(macOS)
        .toolbar {
            if !isWindow {
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
#endif
    }
    
    @ViewBuilder
    func DismissBtnBuilder() -> some View {
        Button {
            dismiss()
        } label: {
            Text("Great")
                .font(.title3.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 8)
                .background(.blue)
                .cornerRadius(12)
        }
    }
    
    @ViewBuilder
    func BuildBuyPremoimView(features: [String], desktopView: Bool) -> some View {
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
                
                ProductView(id: "in.rishisingh.i2048.lifetime", prefersPromotionalIcon: true) {
//                        Label("Premium", systemImage: "crown.fill")
//                            .labelStyle(.iconOnly)
                }
            }
            .accessibilityElement(children: .contain)
            .storeProductsTask(for: ["in.rishisingh.i2048.lifetime"]) { taskState in
                switch taskState {
                case .loading, .success:
                    userDefaultsManager.unlockLifetimeAccess()
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
                    .cornerRadius(10)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
            Text("Restore your purchase if it hasn't synced automatically")
                .font(.caption)
        }
        .padding(.vertical, desktopView ? 20 : 0)
    }
    
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
            
            Text("You have lifetime premium access to i2048.")
                .font(.body.bold())
            
            Text("Premium Features")
                .font(.title.bold())
//                .padding(.top)
            
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
#if os(iOS)
            DismissBtnBuilder()
#elseif os(macOS)
            if !isWindow {
                DismissBtnBuilder()
            }
#endif
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

#Preview {
    IAPView()
//        .environmentObject(InAppPurchaseManager.shared)
}
