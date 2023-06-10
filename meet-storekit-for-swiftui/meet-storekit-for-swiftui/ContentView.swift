//
//  ContentView.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showShopStore: Bool = false
    
    var musicModel: MusicModel
    
    var body: some View {
        NavigationView {
            VStack {
                if musicModel.ownedMusics.isEmpty {
                    Text("Empty Library")
                        .font(.title)
                        .foregroundStyle(.gray)
                        .navigationTitle("Songs")
                } else {
                    List {
                        ForEach(musicModel.ownedMusics) { music in
                            MusicCellView(music: music)
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
            MusicShop()
        })
        .onInAppPurchaseCompletion { product, purchaseResult in
            if case .success(.success(let transaction)) = purchaseResult {
                if let result = await MusicPurchase().process(transaction: transaction) {
                    if result.flag {
                        musicModel.ownedMusics.append(result.music)
                    } else {
                        musicModel.ownedMusics.removeAll(where: { $0.id == result.music.id })
                    }
                }
            }
            self.showShopStore = false
        }
    }
}

#Preview {
    ContentView(musicModel: MusicModel())
}
