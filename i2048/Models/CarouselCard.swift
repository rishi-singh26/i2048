//
//  CarouselCard.swift
//  i2048
//
//  Created by Rishi Singh on 21/12/24.
//

import Foundation

struct CarouselCard: Identifiable, Hashable {
    var id: UUID = .init()
    var imageId: Int
    var artistId: Int
    var artistName: String
    var title: String
    var subTitle: String
    var image: String
    var backGroundColor: String
}
