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
                if let result = await SongProductPurchase().process(transaction: transaction) {
                    if result.flag {
                        storeModel.ownedSongProducts.append(result.song)
                    } else {
                        storeModel.ownedSongProducts.removeAll(where: { $0.id == result.song.id })
                    }
                }
            }
            self.showShopStore = false
        }
    }
}

#Preview {
    ContentView(storeModel: StoreModel())
}
