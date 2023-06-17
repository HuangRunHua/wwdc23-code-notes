//
//  SubscriptionShopView.swift
//  meet-subscriptionstoreview-in-iOS17
//
//  Created by Huang Runhua on 6/14/23.
//

import SwiftUI
import StoreKit

struct SubscriptionShopView: View {
    @Environment(\.passIDs.group) private var passGroupID
    
    var body: some View {
        SubscriptionStoreView(groupID: passGroupID) {
            SubscriptionShopContent()
        }
        .backgroundStyle(.clear)
        .subscriptionStoreButtonLabel(.multiline)
        .subscriptionStorePickerItemBackground(.thinMaterial)
        .storeButton(.visible, for: .restorePurchases)
    }
}

#Preview {
    SubscriptionShopView()
}
