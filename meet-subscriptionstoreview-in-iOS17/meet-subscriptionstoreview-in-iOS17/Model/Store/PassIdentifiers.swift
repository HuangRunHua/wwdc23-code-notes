//
//  PassIdentifiers.swift
//  meet-subscriptionstoreview-in-iOS17
//
//  Created by Huang Runhua on 6/14/23.
//

import SwiftUI

struct PassIdentifiers {
    var group: String
    
    var monthly: String
    var quarterly: String
    var yearly: String
}

extension EnvironmentValues {
    private enum PassIDsKey: EnvironmentKey {
        static var defaultValue = PassIdentifiers(
            group: "506F71A6",
            //group: "21408633",
            monthly: "com.pass.monthly",
            quarterly: "com.pass.quarterly",
            yearly: "com.pass.yearly"
        )
    }
    
    var passIDs: PassIdentifiers {
        get { self[PassIDsKey.self] }
        set { self[PassIDsKey.self] = newValue }
    }
}
