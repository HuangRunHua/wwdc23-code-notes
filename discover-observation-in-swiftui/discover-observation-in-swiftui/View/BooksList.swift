//
//  BooksList.swift
//  discover-observation-in-swiftui
//
//  Created by Huang Runhua on 6/8/23.
//

import SwiftUI

// Storing `@Observable` types in Array
struct BooksList: View {
    
    var books: [Book] = [
        Book(title: "Great Expectations"),
        Book(title: "Little Women"),
        Book(title: "Pride and Prejudice")
    ]
    
    var body: some View {
        List {
            ForEach(books) { book in
                HStack {
                    Text(book.title)
                    Spacer()
                    Button(action: {
                        // If there is no `@Observable`
                        // attached to  Book class, when tapping
                        // the love button the view won't auto update
                        book.loved.toggle()
                    }, label: {
                        Image(systemName: book.loved ? "heart.fill": "heart")
                    })
                }
            }
        }
    }
}

#Preview {
    BooksList()
}
