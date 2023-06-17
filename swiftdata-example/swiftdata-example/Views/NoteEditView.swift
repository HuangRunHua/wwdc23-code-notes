//
//  NoteEditView.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/17/23.
//

// Bugs:
//  1. 进入编辑界面时候无论什么操作都会自动被保存
// Shartage:
//  1. 删除功能

import SwiftUI
import SwiftData

struct NoteEditView: View {
    
    let edit: Bool
    @Bindable var note: Note
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack(alignment: .top) {
                        MarkerView(text: "H1").frame(width: 20)
                        TextField("Enter title...", text: $note.title, axis: .vertical)
                            .font(.title)
                            .bold()
                    }
                    HStack(alignment: .top) {
                        MarkerView(text: "H2").frame(width: 20)
                        TextField("Enter subtitle...", text: $note.subtitle, axis: .vertical)
                            .font(.headline)
                    }
                    .padding(.top, -7)
                    HStack(alignment: .top) {
                        MarkerView(text: "B1").frame(width: 20)
                        TextField("Enter content...", text: $note.content, axis: .vertical)
                            .foregroundStyle(Color.init(UIColor.darkGray))
                            
                    }
                    .padding(.top, -3)
                }
                .fontDesign(.rounded)
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        if edit {
//                            try modelContext.save()
                        } else {
                            modelContext.insert(object: note)
                        }
                        dismiss()
                    }
                    .disabled(note.title=="" ? true: false)
                }
            }
        }
    }
}

struct MarkerView: View {
    let text: String
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(text.split(separator: "").first ?? "")
                .foregroundStyle(.gray)
            Text(text.split(separator: "").last ?? "")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
        }
    }
}
