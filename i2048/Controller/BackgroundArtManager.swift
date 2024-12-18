//
//  BackgroundImageManager.swift
//  i2048
//
//  Created by Rishi Singh on 19/12/24.
//

import SwiftUI

// MARK: - Model
struct User: Identifiable, Codable {
    let id: Int
    let name: String
    let email: String
}

// MARK: - ViewModel
class BackgroundImageManager: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func fetchUsers() {
        guard let url = URL(string: "https://raw.githubusercontent.com/rishi-singh26/TempBox-Flutter/refs/heads/main/LICENSE") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Failed to load data: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                print(data)
//                do {
//                    let decodedUsers = try JSONDecoder().decode([User].self, from: data)
//                    self.users = decodedUsers
//                } catch {
//                    self.errorMessage = "Failed to decode JSON: \(error.localizedDescription)"
//                }
            }
        }.resume()
    }
}
