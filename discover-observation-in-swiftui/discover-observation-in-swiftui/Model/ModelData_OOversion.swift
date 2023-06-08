//
//  ModelData_OOversion.swift
//  discover-observation-in-swiftui
//
//  Created by Huang Runhua on 6/8/23.
//

import SwiftUI

final class MusicModelOOversion: ObservableObject {
    @Published var musics: [Music] = [
        Music(title: "Spirals", singer: "Nick Leng"),
        Music(title: "Rocky", singer: "Still Woozy"),
        Music(title: "Time Square", singer: "Jam City"),
        Music(title: "The Only One", singer: "Phoenix"),
        Music(title: "Away X5", singer: "Yaeji")
    ]
    
    var musicCount: Int {
        musics.count
    }
    
    init() {}
    
    func addMusic() {
        musics.append(Music(title: "Cold Winter", singer: "July"))
    }
}
