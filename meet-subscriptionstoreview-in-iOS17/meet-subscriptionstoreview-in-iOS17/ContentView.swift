//
//  ContentView.swift
//  meet-subscriptionstoreview-in-iOS17
//
//  Created by Huang Runhua on 6/14/23.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    @State private var showScriptionView: Bool = false
    @State private var status: EntitlementTaskState<PassStatus> = .loading
    
    @Environment(PassStatusModel.self) var passStatusModel: PassStatusModel
    @Environment(\.passIDs) private var passIDs
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text(passStatusModel.passStatus.description)
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
        .onAppear(perform: {
            ProductSubscription.createSharedInstance()
        })
        .subscriptionStatusTask(for: passIDs.group) { taskStatus in
            self.status = await taskStatus.map { statuses in
                await ProductSubscription.shared.status(
                    for: statuses,
                    ids: passIDs
                )
            }
            switch self.status {
            case .failure(let error):
                passStatusModel.passStatus = .notSubscribed
                print("Failed to check subscription status: \(error)")
            case .success(let status):
                passStatusModel.passStatus = status
                print("status = \(status.description)")
            case .loading: break
            @unknown default: break
            }
        }
        .task {
            await ProductSubscription.shared.observeTransactionUpdates()
            await ProductSubscription.shared.checkForUnfinishedTransactions()
        }
    }
}

#Preview {
    ContentView()
        .environment(PassStatusModel())
}
