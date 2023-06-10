//
//  MusicProductIcon.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI

struct MusicProductIcon: View {
    
    var productID: String
    var music: Music? {
        Music.allMusics.music(for: productID)?.music
    }
    
    var body: some View {
        if let music {
            music.image
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 7))
        } else {
            EmptyView()
        }
    }
}

#Preview {
    MusicProductIcon(productID: "com.meet.storekit.for.swiftui.cold.winter")
}
