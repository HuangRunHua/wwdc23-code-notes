//
//  meet_subscriptionstoreview_in_iOS17App.swift
//  meet-subscriptionstoreview-in-iOS17
//
//  Created by Huang Runhua on 6/14/23.
//

import SwiftUI

@main
struct meet_subscriptionstoreview_in_iOS17App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(PassStatusModel())
        }
    }
}
