//
//  SongProduct.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI
import Observation

class SongProduct: Identifiable {
    public var id: Int
    public var productID: String
    public var name: String
    public var summary: String
    
    var image: Image {
        Image("Musics/\(name)")
            .resizable()
    }
    
    public init(
        id: Int,
        productID: String,
        name: String,
        summary: String
    ) {
        self.id = id
        self.productID = productID
        self.name = name
        self.summary = summary
    }
}

extension Sequence where Element == SongProduct {
    func song(for productID: String) -> SongProduct? {
        lazy.first(where: { $0.productID == productID })
    }
}
