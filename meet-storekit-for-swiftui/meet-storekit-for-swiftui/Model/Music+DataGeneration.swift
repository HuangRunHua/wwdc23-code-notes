//
//  SongProduct+DataGeneration.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import Foundation

extension SongProduct {
    static let allSongProducts: [SongProduct] = [
        SongProduct(id: 0,
                    productID: "com.meet.storekit.for.swiftui.cold.winter",
                    name: "Cold Winter",
                    summary: "Hip-Hop/Rap 2020",
                    isPurchased: false),
        SongProduct(id: 1,
                    productID: "com.meet.storekit.for.swiftui.platinum.disco",
                    name: "Platinum Disco",
                    summary: "J-Pop 2014, Lossless",
                    isPurchased: false),
        SongProduct(id: 2,
                    productID: "com.meet.storekit.for.swiftui.drunk",
                    name: "Drunk",
                    summary: "International Pop 2015, Lossless",
                    isPurchased: false)
    ]
}
