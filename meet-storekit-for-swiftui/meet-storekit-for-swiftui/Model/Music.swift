//
//  Music.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI
import Observation

class Music: Identifiable {
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

extension Music {
    var image: Image {
        Image("Musics/\(id)")
            .resizable()
    }
}

extension Sequence where Element == Music {
    
    func music(for productID: String) -> (music: Music, product: Music.Product)? {
        lazy.compactMap { music in
            music.products
                .first { $0.id == productID }
                .map { (music, $0) }
        }
        .first
    }
    
}
