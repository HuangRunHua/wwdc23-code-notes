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
                } else {
                    ScrollView {
                        ForEach(storeModel.ownedSongProducts) { song in
                            SongCellView(music: song)
                                .padding([.leading, .trailing])
                        }
                    }
                }
            }
            .navigationTitle("Songs")
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
        .onAppear(perform: {
            SongProductPurchase.createSharedInstance(storeModel: storeModel)
        })
        .onInAppPurchaseCompletion { product, purchaseResult in
            if case .success(.success(let transaction)) = purchaseResult {
                await SongProductPurchase.shared.process(transaction: transaction)
            }
            self.showShopStore = false
        }
        .task {
            // Begin observing StoreKit transaction updates in case a
            // transaction happens on another device.
            await SongProductPurchase.shared.observeTransactionUpdates()
            // Check if we have any unfinished transactions where we
            // need to grant access to content
            await SongProductPurchase.shared.checkForUnfinishedTransactions()
        }
    }
}

#Preview {
    ContentView(storeModel: StoreModel())
}
