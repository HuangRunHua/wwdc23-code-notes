//
//  OrderTogether.swift
//  add-shareplay
//
//  Created by Huang Runhua on 6/7/23.
//

import SwiftUI
import GroupActivities
import WWDC

struct OrderTogether: GroupActivity {
    static let activityIdentifier: String = "com.example.add-shareplay.tickets.OrderTogether"
    
    let orderUUID: UUID
    let truckName: String
    
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = "Order Tickets Together"
        metadata.subtitle = truckName
        metadata.previewImage = UIImage(named: "")?.cgImage
        metadata.type = .shopTogether
        return metadata
    }
}

enum Slope {
    case beginnersParadise
    case practiceRun
    case otherSlope
}


@SlopeSubset
enum EasySlope {
    case beginnersParadise
    case practiceRun

    var slope: Slope {
        switch self {
        case .beginnersParadise:
            return .beginnersParadise
        case .practiceRun:
            return .practiceRun
        }
    }
}
