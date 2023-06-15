//
//  SubscriptionShopContent.swift
//  meet-subscriptionstoreview-in-iOS17
//
//  Created by Huang Runhua on 6/15/23.
//

import SwiftUI

struct SubscriptionShopContent: View {
    var body: some View {
        VStack {
            image
            VStack(spacing: 3) {
                title
                desctiption
            }
        }
        .padding(.vertical)
        .padding(.top, 40)
    }
}

#Preview {
    SubscriptionShopContent()
}

extension SubscriptionShopContent {
    @ViewBuilder
    var image: some View {
        Image("movie")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
        
    }
    
    @ViewBuilder
    var title: some View {
        Text("Flower Movie+")
            .font(.largeTitle.bold())
    }
    
    @ViewBuilder
    var desctiption: some View {
        Text("Subscription to unlock all streaming videos, enjoy Blu-ray 4K quality, and watch offline.")
            .fixedSize(horizontal: false, vertical: true)
            .font(.title3.weight(.medium))
            .padding([.bottom, .horizontal])
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
    }
}
