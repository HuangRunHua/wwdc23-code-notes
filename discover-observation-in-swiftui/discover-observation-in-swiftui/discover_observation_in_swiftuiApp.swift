//
//  discover_observation_in_swiftuiApp.swift
//  discover-observation-in-swiftui
//
//  Created by Huang Runhua on 6/8/23.
//

import SwiftUI

@main
struct discover_observation_in_swiftuiApp: App {
    @StateObject private var modelData = MusicModelOOversion()
    var body: some Scene {
        WindowGroup {
             ContentView(model: MusicModel())
//            ContentView_OOVersion()
//                .environmentObject(modelData)
        }
    }
}
