//
//  swiftdata_exampleApp.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/11/23.
//

import SwiftUI
import SwiftData

@main
struct swiftdata_exampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Note.self)
    }
}
