//
//  ContentView.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/11/23.
//

import SwiftUI
import SwiftData

//let notePredictate = #Predicate<Note> { note in
//        note.title.count > 5
//}

struct ContentView: View {
//    @Query(filter: notePredictate, sort: \.createDate, order: .reverse) private var notes: [Note]
    @Query(sort: \.createDate, order: .reverse) private var notes: [Note]
    @State private var showNewNoteView: Bool = false
    @State private var note: Note = Note(title: "ETIAM SIT AMETEST DONEC",
                                         subtitle: "Lorem ipsum dolor sit amet, ligula suspendisse nulla pretium, rhoncus tempor fermentum.",
                                         content: "Vitae et, nunc hasellus hasellus, donec dolor, id elit donec hasellus ac pede, quam amet. Arcu nibh maecenas ac, nullam duis elit, ligula pellentesque viverra morbi tellus molestie, mi.")
    
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
            NoteEditView(edit: false, note: note)
        })
    }
}

#Preview {
    MainActor.assumeIsolated {
        ContentView()
            .modelContainer(PreviewSampleData.previewContainer)
    }
}
