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
    @State private var showNewNoteView: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    ZStack(alignment: .leading) {
                        NavigationLink {
                            NoteView(note: note)
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showNewNoteView = true
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                }
            }
        }
        .sheet(isPresented: $showNewNoteView, content: {
            NoteEditView()
        })
    }
}

#Preview {
    MainActor.assumeIsolated {
        ContentView()
            .modelContainer(previewContainer)
    }
}
