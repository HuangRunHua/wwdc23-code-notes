//
//  PassStatus.swift
//  meet-subscriptionstoreview-in-iOS17
//
//  Created by Huang Runhua on 6/14/23.
//

import Foundation
import StoreKit

enum PassStatus: Comparable, Hashable {
    case notSubscribed
    case monthly
    case quarterly
    case yearly
    
    init(levelOfService: Int) {
        self = switch levelOfService {
        case 1: .monthly
        case 2: .quarterly
        case 3: .yearly
        default: .notSubscribed
        }
    }
    
    init?(productID: Product.ID, ids: PassIdentifiers) {
        switch productID {
        case ids.monthly: self = .monthly
        case ids.quarterly: self = .quarterly
        case ids.yearly: self = .yearly
        default: return nil
        }
    }        
}
