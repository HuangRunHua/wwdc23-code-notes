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
    
//    let container = try! ModelContainer(
//        for: Schema([Note.self]),
//        migrationPlan: NoteMigrationPlan.self
//    )
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
        //.modelContainer(container)
        .modelContainer(for: Note.self)
    }
}
