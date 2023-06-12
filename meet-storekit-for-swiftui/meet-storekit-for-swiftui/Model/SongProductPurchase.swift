//
//  SongProductPurchase.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import Foundation
import StoreKit

actor SongProductPurchase {
    
    var storeModel: StoreModel
    
    private var updatesTask: Task<Void, Never>?
    
    public init(storeModel: StoreModel) {
        self.storeModel = storeModel
    }
    
    private(set) static var shared: SongProductPurchase = SongProductPurchase(storeModel: StoreModel())
    
    func process(transaction verificationResult: VerificationResult<Transaction>) async {
        let transaction: Transaction
        switch verificationResult {
        case .verified(let t):
            transaction = t
        case .unverified( _, let error):
            print("error in process: \(error.localizedDescription)")
            return
        }
        
        if case .nonConsumable = transaction.productType {
            guard let songProduct = song(for: transaction.productID) else {
                return
            }
            if transaction.revocationDate == nil, transaction.revocationReason == nil {
                SongProduct.allSongProducts.first(where: { $0.productID == transaction.productID})?.isPurchased = true
                print("""
                Finished transaction ID \(transaction.id) for \
                \(transaction.productID)
                """)
            } else {
                songProduct.isPurchased = false
                SongProduct.allSongProducts.first(where: { $0.productID == transaction.productID})?.isPurchased = false
                print("""
                Removed \(songProduct.name) because transaction ID \
                \(transaction.id) was revoked due to \
                \(transaction.revocationReason?.localizedDescription ?? "unknown").
                """)
            }
        } else {
            await transaction.finish()
        }
        
        storeModel.ownedSongProducts = SongProduct.allSongProducts.filter({ $0.isPurchased })
        print("Now we have songs: ")
        for song in SongProduct.allSongProducts {
            print("\(song.name): \(song.isPurchased)")
        }
        
        print("******************************")
    }
    
    func checkForUnfinishedTransactions() async {
        for await transaction in Transaction.unfinished {
            let unsafeTransaction = transaction.unsafePayloadValue
            print("""
            Processing unfinished transaction ID \(unsafeTransaction.id) for \
            \(unsafeTransaction.productID)
            """)
            Task.detached(priority: .background) {
                await self.process(transaction: transaction)
            }
        }
    }
    
    func observeTransactionUpdates() async {
        for await update in Transaction.updates {            
            await self.process(transaction: update)
        }
//        self.updatesTask = Task { [weak self] in
//            for await update in Transaction.updates {
//                guard let self else { break }
//                await self.process(transaction: update)
//            }
//        }
    }
    
    private func song(for productID: Product.ID) -> SongProduct? {
        SongProduct.allSongProducts.song(for: productID)
    }
}
