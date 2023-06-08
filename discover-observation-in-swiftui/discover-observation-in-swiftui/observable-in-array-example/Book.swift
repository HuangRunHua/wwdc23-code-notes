//
//  Book.swift
//  discover-observation-in-swiftui
//
//  Created by Huang Runhua on 6/8/23.
//

import Foundation
import Observation

/// Storing `@Observable` types in Array
@Observable class Book: Identifiable {
    var id = UUID()
    var title: String = ""
    var loved: Bool = false
    
    init(title: String) {
        self.title = title
    }
}

//class Book: Identifiable {
//    var id = UUID()
//    var title: String = ""
//    var loved: Bool = false
//    
//    init(title: String) {
//        self.title = title
//    }
//}
