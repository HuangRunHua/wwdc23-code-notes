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
    
    private var productIDs: some Collection<Product.ID> {
        musics.lazy
            .flatMap(\.orderedProducts)
            .map(\.id)
    }
    
    private func music(for productID: Product.ID) -> (Music, Music.Product)? {
        musics.music(for: productID)
    }
    
    var body: some View {
        NavigationView {
            StoreView(ids: productIDs) { product in
                if let (music, _) = music(for: product.id) {
                    MusicProductIcon(music: music)
                }
            }
            .navigationTitle("Music Shop")
            .storeButton(.hidden, for: .cancellation)
        }
    }
}

#Preview {
    MusicShop()
}
