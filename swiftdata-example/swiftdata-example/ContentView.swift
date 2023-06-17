//
//  ContentView.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/11/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \.createDate, order: .reverse) private var notes: [Note]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    ZStack(alignment: .leading) {
                        NavigationLink {
                            ScrollView {
                                Text("\(note.createDate.formatted(date: .abbreviated, time: .shortened))")
                                    .foregroundStyle(.gray)
                                HStack {
                                    Text(note.title)
                                        .font(.title)
                                        .bold()
                                    Spacer()
                                }
                                .padding([.leading,.trailing])
                                HStack {
                                    Text(note.subtitle)
                                        .font(.headline)
                                        .padding([.leading,.trailing])
                                        .padding(.top, -7)
                                    Spacer()
                                }
                                Text(note.content)
                                    .foregroundStyle(Color.init(UIColor.darkGray))
                                    .padding([.leading,.trailing])
                                    .padding(.top, -3)
                                    .lineSpacing(5)
                            }
                            .fontDesign(.rounded)
                            .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            EmptyView()
                        }
                        .opacity(0)
                        NotePreviewCell(note: note)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Notes")
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        ContentView()
            .modelContainer(previewContainer)
    }
}
