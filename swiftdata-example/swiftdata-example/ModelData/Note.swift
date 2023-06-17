//
//  Note.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/11/23.
//

import Foundation
import SwiftData

@Model
class Note {
    var createDate: Date
    var title: String
    var subtitle: String
    var content: String
    
    init(createDate: Date = .now, title: String, subtitle: String, content: String) {
        self.createDate = createDate
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }
}
