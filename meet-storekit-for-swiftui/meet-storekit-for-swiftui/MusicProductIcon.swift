//
//  MusicProductIcon.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI

struct MusicProductIcon: View {
    var music: Music
    var body: some View {
        music.image
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

#Preview {
    MusicProductIcon(music: Music.allMusics[0])
}
