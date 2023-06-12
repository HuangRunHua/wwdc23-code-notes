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
        VStack {
            HStack {
                music.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                VStack(alignment: .leading, spacing: 3) {
                    Text(music.name)
                        .font(.system(size: 17))
                    Text(music.summary)
                        .foregroundStyle(.gray)
                        .font(.system(size: 15))
                }
                .frame(height: 50)
                Spacer()
            }
            Divider()
        }
    }
}

#Preview {
    SongCellView(music: SongProduct.allSongProducts[0])
}
