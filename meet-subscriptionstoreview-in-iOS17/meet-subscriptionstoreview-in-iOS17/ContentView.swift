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
    @State private var presentingSubscriptionSheet = false
    
    @Environment(PassStatusModel.self) var passStatusModel: PassStatusModel
    @Environment(\.passIDs) private var passIDs
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    planView
                    // Show the option button if user does not have a plan.
                    if passStatusModel.passStatus == .notSubscribed {
                        Button {
                            self.showScriptionView = true
                        } label: {
                            Text("View Options")
                        }
                    }
                } header: {
                    Text("SUBSCRIPTION")
                } footer: {
                    if passStatusModel.passStatus != .notSubscribed {
                        Text("Flower Movie+ Plan: \(String(describing: passStatusModel.passStatus.description))")
                    }
                }
            }
            .navigationTitle("Account")
            .sheet(isPresented: $showScriptionView, content: {
                SubscriptionShopView()
                    .environment(passStatusModel)
            })
            .manageSubscriptionsSheet(
                isPresented: $presentingSubscriptionSheet,
                subscriptionGroupID: passIDs.group
            )
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


extension ContentView {
    @ViewBuilder
    var planView: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(passStatusModel.passStatus == .notSubscribed ? "Flower Movie+": "Flower Movie+ Plan: \(passStatusModel.passStatus.description)")
                .font(.system(size: 17))
            Text(passStatusModel.passStatus == .notSubscribed ? "Subscription to unlock all streaming videos, enjoy Blu-ray 4K quality, and watch offline.": "Enjoy all streaming Blu-ray 4K quality videos, and watch offline.")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            if passStatusModel.passStatus != .notSubscribed {
                Button("Handle Subscription \(Image(systemName: "chevron.forward"))") {
                    self.presentingSubscriptionSheet = true
                }
            }
        }
    }
}
