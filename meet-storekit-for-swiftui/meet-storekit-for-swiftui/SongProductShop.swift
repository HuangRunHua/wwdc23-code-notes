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
    
    @State private var isRestoring = false
    
    var body: some View {
        NavigationView {
            StoreView(ids: productIDs) { product in
                SongProductProductIcon(productID: product.id)
            }
            .navigationTitle("Song Shop")
            .storeButton(.hidden, for: .cancellation)
            .productViewStyle(.regular)
            .toolbar {
                ToolbarItem {
                    Button("Restore") {
                        isRestoring = true
                        Task.detached {
                            defer { isRestoring = false }
                            try await AppStore.sync()
                        }
                    }
                    .disabled(isRestoring)
                }
            }
        }
    }
}

#Preview {
    SongProductShop()
}

extension SongProductShop {
    private var productIDs: some Collection<Product.ID> {
        musics.lazy
            .map(\.productID)
    }
}
