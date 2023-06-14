//
//  SubscriptionShopView.swift
//  meet-subscriptionstoreview-in-iOS17
//
//  Created by Huang Runhua on 6/14/23.
//

import SwiftUI
import StoreKit

struct SubscriptionShopView: View {
    
    @Environment(PassStatusModel.self) var passStatusModel: PassStatusModel
    @Environment(\.passIDs.group) private var passGroupID
    
    var body: some View {
        SubscriptionStoreView(groupID: passGroupID)
    }
}

#Preview {
    SubscriptionShopView()
        .environment(PassStatusModel())
}
