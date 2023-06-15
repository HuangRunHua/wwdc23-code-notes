//
//  ProductSubscription.swift
//  meet-subscriptionstoreview-in-iOS17
//
//  Created by Huang Runhua on 6/15/23.
//

import Foundation
import StoreKit

actor ProductSubscription {
        
    private init() {}
    
    private(set) static var shared: ProductSubscription!
        
    static func createSharedInstance() {
        shared = ProductSubscription()
    }
    
    // For other in-app purchase use this method to check for status.
    func process(transaction verificationResult: VerificationResult<Transaction>) async {}
    
    // Subscription Only Handle Here.
    func status(for statuses: [Product.SubscriptionInfo.Status], ids: PassIdentifiers) -> PassStatus {
        let effectiveStatus = statuses.max { lhs, rhs in
            let lhsStatus = PassStatus(
                productID: lhs.transaction.unsafePayloadValue.productID,
                ids: ids
            ) ?? .notSubscribed
            let rhsStatus = PassStatus(
                productID: rhs.transaction.unsafePayloadValue.productID,
                ids: ids
            ) ?? .notSubscribed
            return lhsStatus < rhsStatus
        }
        guard let effectiveStatus else {
            return .notSubscribed
        }
        
        let transaction: Transaction
        switch effectiveStatus.transaction {
        case .verified(let t):
            transaction = t
        case .unverified(_, let error):
            print("Error occured in status(for:ids:): \(error)")
            return .notSubscribed
        }
        
        if case .autoRenewable = transaction.productType {
            if !(transaction.revocationDate == nil && transaction.revocationReason == nil) {
                return .notSubscribed
            }
            if let subscriptionExpirationDate = transaction.expirationDate {
                if subscriptionExpirationDate.timeIntervalSince1970 < Date().timeIntervalSince1970 {
                    return .notSubscribed
                }
            }
        }
        
        return PassStatus(productID: transaction.productID, ids: ids) ?? .notSubscribed
    }
    
    func checkForUnfinishedTransactions() async {
        for await transaction in Transaction.unfinished {
            Task.detached(priority: .background) {
                await self.process(transaction: transaction)
            }
        }
    }
    
    // To discard this warning:
    //  Making a purchase without listening for
    //  transaction updates risks missing successful purchases.
    //  Create a Task to iterate Transaction.updates at launch.
    func observeTransactionUpdates() async {
        for await update in Transaction.updates {
            await self.process(transaction: update)
        }
    }
}
