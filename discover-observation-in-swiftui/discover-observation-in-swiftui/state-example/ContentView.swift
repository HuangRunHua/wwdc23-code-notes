//
//  ContentView.swift
//  discover-observation-in-swiftui
//
//  Created by Huang Runhua on 6/8/23.
//

import SwiftUI

struct ContentView: View {
    
    let model: MusicModel
    
    @State private var showAddMusicView: Bool = false
    @State private var musicToAdd: Music = Music(title: "", singer: "")
    
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
                    showAddMusicView.toggle()
                }
                .sheet(isPresented: $showAddMusicView, content: {
                    TextField("Title", text: $musicToAdd.title)
                        .padding([.leading, .trailing])
                    TextField("Singer", text: $musicToAdd.singer)
                        .padding([.leading, .trailing])
                    Button("Save") {
                        model.musics.append(musicToAdd)
                        showAddMusicView.toggle()
                    }
                    Button("Cancel") { showAddMusicView.toggle() }
                })
            } header: {
                Text("Musics")
            } footer: {
                Text("\(model.musicCount) songs")
            }
        }
    }
}

#Preview {
    ContentView(model: MusicModel())
}
