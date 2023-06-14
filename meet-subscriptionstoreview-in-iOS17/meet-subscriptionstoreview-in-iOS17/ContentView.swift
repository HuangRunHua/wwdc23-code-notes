//
//  ContentView.swift
//  meet-subscriptionstoreview-in-iOS17
//
//  Created by Huang Runhua on 6/14/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showScriptionView: Bool = false
    @Environment(PassStatusModel.self) var passStatusModel: PassStatusModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Flower Movie+")
                            .font(.system(size: 17))
                        Text("Subscription to unlock all streaming videos, enjoy Blu-ray 4K quality, and watch offline.")
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                    }
                    Button {
                        self.showScriptionView = true
                    } label: {
                        Text("View Options")
                    }
                } header: {
                    Text("SUBSCRIPTION")
                }
            }
            .navigationTitle("Account")
            .sheet(isPresented: $showScriptionView, content: {
                SubscriptionShopView()
                    .environment(passStatusModel)
            })
        }
    }
}

#Preview {
    ContentView()
        .environment(PassStatusModel())
}
