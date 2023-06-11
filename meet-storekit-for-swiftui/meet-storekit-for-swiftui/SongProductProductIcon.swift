//
//  SongProductProductIcon.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI

struct SongProductProductIcon: View {
    
    var productID: String
    var song: SongProduct? {
        SongProduct.allSongProducts.song(for: productID)
    }
    
    var body: some View {
        if let song {
            song.image
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 7))
        } else {
            EmptyView()
        }
    }
}

#Preview {
    SongProductProductIcon(productID: "com.meet.storekit.for.swiftui.cold.winter")
}
