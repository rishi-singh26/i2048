//
//  NetworkAvatar.swift
//  i2048
//
//  Created by Rishi Singh on 20/12/24.
//

import SwiftUI

struct NetworkAvatar: View {
    var url: String
    var width: CGFloat?
    var height: CGFloat?
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: width ?? 30, height: height ?? 30)
                    .cornerRadius((width ?? 30) / 2)
                    .padding(8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            case .success(let image):
                image
                    .resizable()
                    .frame(width: width ?? 30, height: height ?? 30)
                    .cornerRadius((width ?? 30) / 2)
                    .padding(8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            case .failure:
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: width ?? 30, height: height ?? 30)
                    .cornerRadius((width ?? 30) / 2)
                    .padding(8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            @unknown default:
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: width ?? 30, height: height ?? 30)
                    .cornerRadius((width ?? 30) / 2)
                    .padding(8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }
}

#Preview {
    NetworkAvatar(url: "https://cdn.dribbble.com/users/1633085/avatars/normal/3696aba8d59791031fd53af1115f3bba.jpg?1720752462")
}
