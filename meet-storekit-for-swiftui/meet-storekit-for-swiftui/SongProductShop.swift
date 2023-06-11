//
//  SongProductShop.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI
import StoreKit

struct SongProductShop: View {
    private var musics: [SongProduct] {
        SongProduct.allSongProducts
    }
    
    var body: some View {
        NavigationView {
            StoreView(ids: productIDs) { product in
                SongProductProductIcon(productID: product.id)
            }
            .navigationTitle("SongProduct Shop")
            .storeButton(.hidden, for: .cancellation)
            .productViewStyle(.regular)
        }
    }
}

#Preview {
    SongProductShop()
}

extension SongProductShop {
    private var productIDs: some Collection<Product.ID> {
        musics.lazy
            .flatMap(\.orderedProducts)
            .map(\.id)
    }
}
