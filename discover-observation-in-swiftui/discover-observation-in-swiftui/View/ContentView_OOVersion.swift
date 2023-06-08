//
//  ContentView_OOVersion.swift
//  discover-observation-in-swiftui
//
//  Created by Huang Runhua on 6/8/23.
//

import SwiftUI

struct ContentView_OOVersion: View {
    
    @EnvironmentObject var model: MusicModelOOversion
    
    var body: some View {
        List {
            Section {
                ForEach(model.musics) { music in
                    VStack(alignment: .leading) {
                        Text(music.title)
                        Text(music.singer)
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                    }
                }
                Button("Add new music") {
                    model.addMusic()
                }
            } header: {
                Text("Musics")
            } footer: {
                Text("\(model.musicCount) songs")
            }
        }
    }
}

#Preview {
    ContentView_OOVersion()
        .environmentObject(MusicModelOOversion())
}
