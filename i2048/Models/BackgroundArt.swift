//
//  BackgroundArt.swift
//  i2048
//
//  Created by Rishi Singh on 19/12/24.
//


struct BackgroundArtist: Identifiable, Codable {
    let id: Int
    let name: String
    let dribbleLink: String
    let profileImage: String
    let images: [BackgroundArt]
}

struct BackgroundArt: Identifiable, Codable {
    let id: Int
    let url: String
    let previewUrl: String
    let dribbleUrl: String
    let name: String
    let mode: Bool
    let forGroundColor: String
    let gameVictoryColor: String
    let gameLossColor: String
    let backGroundColor: String
    let color2: String
    let color4: String
    let color8: String
    let color16: String
    let color32: String
    let color64: String
    let color128: String
    let color256: String
    let color512: String
    let color1024: String
    let color2048: String
    let color4096: String
    let color8192: String
    let color16384: String
}
