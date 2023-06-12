//
//  ContentView.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showShopStore: Bool = false
    
    var storeModel: StoreModel
    
    var body: some View {
        NavigationView {
            VStack {
                if storeModel.ownedSongProducts.isEmpty {
                    Text("Empty Library")
                        .font(.title)
                        .foregroundStyle(.gray)
                        .navigationTitle("Songs")
                } else {
                    List {
                        ForEach(storeModel.ownedSongProducts) { song in
                            SongCellView(music: song)
                        }
                    }
                    .navigationTitle("Songs")
                }
            }
            .toolbar(content: {
                ToolbarItem {
                    Button(action: {
                        self.showShopStore = true
                    }, label: {
                    Label("Shop Store", systemImage: "cart")
                    })
                }
            })
        }
        .sheet(isPresented: $showShopStore, content: {
            SongProductShop()
        })
        .onInAppPurchaseCompletion { product, purchaseResult in
            if case .success(.success(let transaction)) = purchaseResult {
//                await SongProductPurchase.shared.process(transaction: transaction)
                await SongProductPurchase(storeModel: storeModel).process(transaction: transaction)
            }
//            storeModel.ownedSongProducts = SongProduct.allSongProducts.filter({ $0.isPurchased })
            self.showShopStore = false
        }
        .task {
            // Begin observing StoreKit transaction updates in case a
            // transaction happens on another device.
            await SongProductPurchase(storeModel: storeModel).observeTransactionUpdates()
        }
    }
}

#Preview {
    ContentView(storeModel: StoreModel())
}
