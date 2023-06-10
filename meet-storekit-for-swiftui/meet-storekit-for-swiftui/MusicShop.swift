//
//  MusicShop.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI
import StoreKit

struct MusicShop: View {
    private var musics: [Music] {
        Music.allMusics
    }
    
    var body: some View {
        NavigationView {
            StoreView(ids: productIDs) { product in
                MusicProductIcon(productID: product.id)
            }
            .navigationTitle("Music Shop")
            .storeButton(.hidden, for: .cancellation)
            .productViewStyle(.regular)
        }
    }
}

#Preview {
    MusicShop()
}

extension MusicShop {
    private var productIDs: some Collection<Product.ID> {
        musics.lazy
            .flatMap(\.orderedProducts)
            .map(\.id)
    }
}
