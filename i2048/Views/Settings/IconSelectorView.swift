//
//  IconSelectorView.swift
//  i2048
//
//  Created by Rishi Singh on 25/02/25.
//

#if os(iOS)
import SwiftUI

@MainActor
struct IconSelectorView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    @State private var currentIcon = UIApplication.shared.alternateIconName ?? Icon.primary.appIconName
    @State private var showIAPSheet: Bool = false
    
    private let columns = [GridItem(.adaptive(minimum: 125, maximum: 1024))]
    
    enum Icon: Int, CaseIterable, Identifiable {
        var id: String {
            "\(rawValue)"
        }
        
        init(string: String) {
            if string == "AppIcon" {
                self = .primary
            } else {
                self = .init(rawValue: Int(String(string.replacing("AppIcon", with: "")))!)!
            }
        }
        
        case primary = 0
        case alt1, alt2
        case alt3, alt4, alt5, alt6, alt7
        case alt8, alt9, alt10, alt11, alt12
        case alt13, alt14, alt15, alt16, alt17
        case alt18, alt19, alt20, alt21, alt22
        case alt23, alt24, alt25, alt26, alt27
        
        var appIconName: String {
            return "AppIcon\(rawValue)"
        }
        
        var previewImageName: String {
            return "AppIcon\(rawValue)-image"
        }
    }
    
    struct IconSelector: Identifiable {
        var id = UUID()
        let title: String
        let icons: [Icon]
        
        static let items = [
            IconSelector(
                title: "Base".localized,
                icons: [.primary, .alt1, .alt2]),
            IconSelector(
                title: "\("Play 2048".localized)",
                icons: [.alt3, .alt4, .alt5, .alt6, .alt7]),
            IconSelector(
                title: "\("2048 Game".localized)",
                icons: [.alt8, .alt9, .alt10, .alt11, .alt12]),
            IconSelector(
                title: "\("Add 2048".localized)",
                icons: [.alt13, .alt14, .alt15, .alt16, .alt17]),
            IconSelector(
                title: "\("2048".localized)",
                icons: [.alt18, .alt19, .alt20, .alt21, .alt22]),
            IconSelector(
                title: "\("2048".localized)",
                icons: [.alt23, .alt24, .alt25, .alt26, .alt27]),
        ]
    }
    
    var body: some View {
        List {
            ForEach(IconSelector.items) { item in
                Section {
                    makeIconGridView(icons: item.icons)
                } header: {
                    Text(item.title)
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            if let alternateAppIcon = UIApplication.shared.alternateIconName, let appIcon = Icon.allCases.first(where: { $0.appIconName == alternateAppIcon }) {
                currentIcon = appIcon.appIconName
            } else {
                currentIcon = Icon.primary.appIconName
            }
        }
        .sheet(isPresented: $showIAPSheet, content: {
            IAPView()
        })
    }
    
    private func makeIconGridView(icons: [Icon]) -> some View {
        LazyVGrid(columns: columns, spacing: 6) {
            ForEach(icons) { icon in
                Button {
                    if(userDefaultsManager.isPremiumUser) {
                        currentIcon = icon.appIconName
                        if icon.rawValue == Icon.primary.rawValue {
                            setAppIcon(nil)
                        } else {
                            setAppIcon(icon.appIconName)
                        }
                    } else {
                        showIAPSheet = true
                    }
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        Image(icon.previewImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minHeight: 125, maxHeight: 512)
                            .cornerRadius(6)
                            .shadow(radius: 3)
                        if icon.appIconName == currentIcon {
                            Image(systemName: "checkmark.seal.fill")
                                .padding(4)
                                .tint(.green)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    func setAppIcon(_ name: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            print("Alternate icons are not supported")
            return
        }
        
        UIApplication.shared.setAlternateIconName(name) { error in
            if let error = error {
                print("Error changing icon: \(error.localizedDescription)")
            } else {
                print("Icon changed successfully!")
            }
        }
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
#endif
