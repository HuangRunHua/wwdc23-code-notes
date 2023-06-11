//
//  SongProductPurchase.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import Foundation
import StoreKit

actor SongProductPurchase {
    
    private(set) static var shared: SongProductPurchase!
    
    func process(transaction verificationResult: VerificationResult<Transaction>) async -> (song: SongProduct, flag: Bool)? {
        let transaction: Transaction
        switch verificationResult {
        case .verified(let t):
            transaction = t
        case .unverified( _, let error):
            print("error in process: \(error.localizedDescription)")
            return nil
        }
        
        if case .nonConsumable = transaction.productType {
            guard let (song, _) = song(for: transaction.productID) else {
                return nil
            }
            if transaction.revocationDate == nil, transaction.revocationReason == nil {
                return (song, true)
            } else {
                return (song, false)
            }
        } else {
            await transaction.finish()
        }
        return nil
    }
    
    private func song(for productID: Product.ID) -> (SongProduct, SongProduct.Product)? {
        SongProduct.allSongProducts.song(for: productID)
    }
}
