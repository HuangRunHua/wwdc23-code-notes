//
//  SongProduct.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI
import Observation

class SongProduct: Identifiable {
    var id: String
    public var name: String
    public var summary: String
    public var products: [Product]
    
    public var orderedProducts: [Product] {
        products.sorted { lhs, rhs in
            lhs.index < rhs.index
        }
    }
    
    public struct Product: Identifiable, Codable {
        /// The product id
        public var id: String
        public var index: Int
    }
    
    public init(
        id: String,
        name: String,
        summary: String,
        products: [Product] = []
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.products = products
    }
}

extension SongProduct {
    var image: Image {
        Image("Musics/\(id)")
            .resizable()
    }
}

extension Sequence where Element == SongProduct {
    
    func song(for productID: String) -> (song: SongProduct, product: SongProduct.Product)? {
        lazy.compactMap { song in
            song.products
                .first { $0.id == productID }
                .map { (song, $0) }
        }
        .first
    }
    
}
