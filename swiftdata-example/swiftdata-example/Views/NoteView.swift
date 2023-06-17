//
//  NoteView.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/17/23.
//

import SwiftUI

struct NoteView: View {
    
    var note: Note
    
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
            Text(note.content)
                .foregroundStyle(Color.init(UIColor.darkGray))
                .padding([.leading,.trailing])
                .padding(.top, -3)
                .lineSpacing(5)
        }
        .fontDesign(.rounded)
        .navigationBarTitleDisplayMode(.inline)
    }
}
