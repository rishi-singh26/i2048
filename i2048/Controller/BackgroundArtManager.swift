//
//  BackgroundArtManager.swift
//  i2048
//
//  Created by Rishi Singh on 19/12/24.
//

import SwiftUI

class BackgroundArtManager: ObservableObject {
    /// Singleton instance for centralized management if needed
    static let shared = BackgroundArtManager()
    
    @Published private(set) var backgroundImages: [BackgroundArtist] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    init() {
        self.fetchUsers()
    }

    func fetchUsers() {
        guard let url = URL(string: "https://raw.githubusercontent.com/rishi-singh26/i2048/refs/heads/main/i2048/Data/ImageData.json") else {
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
                    print(self.errorMessage ?? "")
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    print(self.errorMessage ?? "")
                    return
                }

                do {
                    // Extract JSON from the file data
                    if let jsonString = String(data: data, encoding: .utf8), let jsonData = jsonString.data(using: .utf8) {
                        let decodedImagesData = try JSONDecoder().decode([BackgroundArtist].self, from: jsonData)
                        self.backgroundImages = decodedImagesData
                    } else {
                        self.errorMessage = "Unable to process file data"
                    }
                } catch {
                    self.errorMessage = "Failed to decode JSON: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func getImageById(imageId: Int, artistId: Int) -> BackgroundArt? {
        if backgroundImages.count > 0 {
            if let artist = backgroundImages.first(where: { $0.id == artistId }) {
                if let image = artist.images.first(where: { $0.id == imageId }) {
                    return image
                }
            }
        }
        return nil
    }
    
    func getAllImages() -> [BackgroundArt] {
        var result: [BackgroundArt] = []
        backgroundImages.forEach { artist in
            artist.images.forEach { art in
                result.append(art)
            }
        }
        return result
    }
}
