//
//  MusicPurchase.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import Foundation
import StoreKit

actor MusicPurchase {
    
    private(set) static var shared: MusicPurchase!
    
    func process(transaction verificationResult: VerificationResult<Transaction>) async -> (music: Music, flag: Bool)? {
        let transaction: Transaction
        switch verificationResult {
        case .verified(let t):
            transaction = t
        case .unverified( _, let error):
            print("error in process: \(error.localizedDescription)")
            return nil
        }
        
        if case .nonConsumable = transaction.productType {
            guard let (music, _) = music(for: transaction.productID) else {
                return nil
            }
            if transaction.revocationDate == nil, transaction.revocationReason == nil {
                return (music, true)
            } else {
                return (music, false)
            }
        } else {
            await transaction.finish()
        }
        return nil
    }
    
    private func music(for productID: Product.ID) -> (Music, Music.Product)? {
        Music.allMusics.music(for: productID)
    }
}
