//
//  Song.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/11/23.
//

import Foundation
import SwiftData

@Model
final class Song: Identifiable {
    var title: String
    var singer: String
    var createDate: Date
    
    init(title: String, singer: String, createDate: Date) {
        self.title = title
        self.singer = singer
        self.createDate = createDate
    }
}
