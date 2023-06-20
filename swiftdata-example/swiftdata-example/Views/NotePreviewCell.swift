//
//  NotePreviewCell.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/17/23.
//

import SwiftUI

struct NotePreviewCell: View {
    var note: Note
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(note.title)
                    .bold()
                    .lineLimit(1)
                Spacer()
                Text("\(note.createDate.formatted(date: .omitted, time: .shortened)) \(Image(systemName: "chevron.right"))")
                    .foregroundStyle(.gray)
            }
            Text(note.subtitle)
                .lineLimit(1)
            Text(note.content)
                .lineLimit(2)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        NotePreviewCell(note: .preview)
            .modelContainer(PreviewSampleData.previewContainer)
    }
}
