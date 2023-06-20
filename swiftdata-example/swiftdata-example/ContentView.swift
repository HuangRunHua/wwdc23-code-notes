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
    @Query(sort: \.createDate, order: .reverse) private var notes: [Note]
    @State private var showNewNoteView: Bool = false
    @Environment(\.modelContext) private var modelContext
    
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
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            // Known Issue in iOS 17:
                            // After deleting an item, SwiftUI may attempt to reference
                            // the deleted content during the animation causing a crash. (109838173)
                            // Workaround: The workaround is to explicitly save after a delete.
                            modelContext.delete(note)
                            try? modelContext.save()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
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
            .overlay {
                if notes.isEmpty {
                    ContentUnavailableView {
                         Label("No Nots", systemImage: "square.and.pencil.circle")
                    } description: {
                         Text("New notes you create will appear here.")
                    }
                }
            }
        }
        .sheet(isPresented: $showNewNoteView, content: {
            let note = Note(title: "", subtitle: "", content: "")
            NoteEditView(edit: false,
                         note: note,
                         title: note.title,
                         subtitle: note.subtitle,
                         content: note.content)
        })
    }
}

#Preview {
    MainActor.assumeIsolated {
        ContentView()
            .modelContainer(PreviewSampleData.previewContainer)
    }
}
