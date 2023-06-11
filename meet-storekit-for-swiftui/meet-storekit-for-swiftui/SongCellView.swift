//
//  MusicCellView.swift
//  meet-storekit-for-swiftui
//
//  Created by Huang Runhua on 6/10/23.
//

import SwiftUI

struct SongCellView: View {
    var music: SongProduct
    var body: some View {
        HStack {
            music.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .clipShape(RoundedRectangle(cornerRadius: 7))
            VStack(alignment: .leading) {
                Text(music.name)
                    .font(.system(size: 20))
                Text(music.summary)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
}

#Preview {
    SongCellView(music: SongProduct.allSongProducts[0])
}
