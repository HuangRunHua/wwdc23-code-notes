//
//  NoteEditView.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/17/23.
//

import SwiftUI

struct NoteEditView: View {
//    @Bindable var note: Note
    @Binding var title: String
    @Binding var subtitle: String
    @Binding var content: String

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack(alignment: .top) {
                        MarkerView(text: "H1").frame(width: 20)
                        TextField("Enter title...", text: $title, axis: .vertical)
                            .font(.title)
                            .bold()
                    }
                    HStack(alignment: .top) {
                        MarkerView(text: "H2").frame(width: 20)
                        TextField("Enter subtitle...", text: $subtitle, axis: .vertical)
                            .font(.headline)
                    }
                    .padding(.top, -7)
                    HStack(alignment: .top) {
                        MarkerView(text: "B1").frame(width: 20)
                        TextField("Enter content...", text: $content, axis: .vertical)
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
                        
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    NoteEditView(title: .constant("ETIAM SIT AMETEST DONEC"),
                 subtitle: .constant(
                    """
                    Lorem ipsum dolor sit amet, ligula suspendisse nulla pretium, rhoncus tempor fermentum.
                    """
                 ),
                 content: .constant(
                    """
                    Vitae et, nunc hasellus hasellus, donec dolor, id elit donec hasellus ac pede, quam amet. Arcu nibh maecenas ac, nullam duis elit, ligula pellentesque viverra morbi tellus molestie, mi. Sodales nunc suscipit sit pretium aliquet integer, consectetuer pede, et risus hac diam at, commodo in.
                    """
                 ))
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
