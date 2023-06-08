//
//  ModelData.swift
//  discover-observation-in-swiftui
//
//  Created by Huang Runhua on 6/8/23.
//

import SwiftUI
import Observation

@Observable class MusicModel {
    var musics: [Music] = [
        Music(title: "Spirals", singer: "Nick Leng"),
        Music(title: "Rocky", singer: "Still Woozy"),
        Music(title: "Time Square", singer: "Jam City"),
        Music(title: "The Only One", singer: "Phoenix"),
        Music(title: "Away X5", singer: "Yaeji")
    ]
    var musicCount: Int {
        musics.count
    }
}
