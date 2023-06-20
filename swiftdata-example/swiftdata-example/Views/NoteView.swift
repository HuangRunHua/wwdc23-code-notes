//
//  NoteView.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/17/23.
//

import SwiftUI

struct NoteView: View {
    
    var note: Note
    @State private var showEditView: Bool = false
    
    var body: some View {
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
            HStack {
                Text(note.content)
                    .foregroundStyle(Color.init(UIColor.darkGray))
                    .padding([.leading,.trailing])
                    .padding(.top, -3)
                    .lineSpacing(5)
                Spacer()
            }
        }
        .fontDesign(.rounded)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showEditView = true
                }, label: {
                    Text("Edit")
                })
            }
        }
        .sheet(isPresented: $showEditView, content: {
            NoteEditView(edit: true,
                         note: note,
                         title: note.title,
                         subtitle: note.subtitle,
                         content: note.content)
        })
    }
}
