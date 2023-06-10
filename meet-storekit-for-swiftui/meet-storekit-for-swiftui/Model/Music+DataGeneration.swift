//
//  Music+DataGeneration.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import Foundation

extension Music {
    static let allMusics: [Music] = [
        Music(id: "Cold Winter",
              name: "Cold Winter",
              summary: "Hip-Hop/Rap 2020",
              products: [
                  Product(
                      id: "com.meet.storekit.for.swiftui.cold.winter",
                      quantity: 1
                  )
              ],
              priority: 1),
        Music(id: "Platinum Disco",
              name: "Platinum Disco",
              summary: "J-Pop 2014, Lossless",
              products: [
                  Product(
                      id: "com.meet.storekit.for.swiftui.platinum.disco",
                      quantity: 1
                  )
              ],
              priority: 2),
        Music(id: "Drunk",
              name: "Drunk",
              summary: "International Pop 2015, Lossless",
              products: [
                  Product(
                      id: "com.meet.storekit.for.swiftui.drunk",
                      quantity: 1
                  )
              ],
              priority: 3)
    ]
}
