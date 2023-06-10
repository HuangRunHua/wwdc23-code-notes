//
//  Music.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI
import Observation

class Music {
    var id: String
    public var name: String
    public var summary: String
    public var priority: Int
    
    public var products: [Product]
    public var ownedQuantity: Int
    
    public var isPremium: Bool {
        !products.isEmpty
    }
    
    public var orderedProducts: [Product] {
        products.sorted { lhs, rhs in
            lhs.quantity < rhs.quantity
        }
    }
    
    public struct Product: Identifiable, Codable {
        public var id: String
        public var quantity: Int
    }
    
    public init(
        id: String,
        name: String,
        summary: String,
        products: [Product] = [],
        priority: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.products = products
        self.ownedQuantity = 0
        self.priority = priority ?? (products.isEmpty ? 0 : 1)
    }
}

extension Music {
    var image: Image {
        Image("Musics/\(id)")
            .resizable()
    }
}

extension Sequence where Element == Music {
    
    func music(for productID: String) -> (Music, Music.Product)? {
        lazy.compactMap { music in
            music.products
                .first { $0.id == productID }
                .map { (music, $0) }
        }
        .first
    }
    
}
