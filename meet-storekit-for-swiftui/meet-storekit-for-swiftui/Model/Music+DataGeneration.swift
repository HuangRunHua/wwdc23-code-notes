//
//  SongProduct+DataGeneration.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import Foundation

extension SongProduct {
    static let allSongProducts: [SongProduct] = [
        SongProduct(id: "Cold Winter",
              name: "Cold Winter",
              summary: "Hip-Hop/Rap 2020",
              products: [
                  Product(
                      id: "com.meet.storekit.for.swiftui.cold.winter",
                      index: 1
                  )
              ]),
        SongProduct(id: "Platinum Disco",
              name: "Platinum Disco",
              summary: "J-Pop 2014, Lossless",
              products: [
                  Product(
                      id: "com.meet.storekit.for.swiftui.platinum.disco",
                      index: 1
                  )
              ]),
        SongProduct(id: "Drunk",
              name: "Drunk",
              summary: "International Pop 2015, Lossless",
              products: [
                  Product(
                      id: "com.meet.storekit.for.swiftui.drunk",
                      index: 1
                  )
              ])
    ]
}
