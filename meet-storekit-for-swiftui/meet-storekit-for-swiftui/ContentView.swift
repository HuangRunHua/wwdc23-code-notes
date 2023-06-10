//
//  ContentView.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showShopStore: Bool = false
    
    var body: some View {
        NavigationView {
            Text("Empty Library")
                .font(.title)
                .foregroundStyle(.gray)
                .navigationTitle("Songs")
                .toolbar(content: {
                    ToolbarItem {
                        Button(action: {
                            self.showShopStore.toggle()
                        }, label: {
                        Label("Shop Store", systemImage: "cart")
                        })
                    }
                })
        }
        .sheet(isPresented: $showShopStore, content: {
            MusicShop()
        })
    }
}

#Preview {
    ContentView()
}
