//
//  ArticleEditView.swift
//  discover-observation-in-swiftui
//
//  Created by Huang Runhua on 6/8/23.
//

import SwiftUI

struct ArticleEditView: View {
    
    // If Article is not conforms to Observable
    // Xcode will throw an error: 'init(wrappedValue:)'
    // is unavailable: The wrapped value must be an
    // object that conforms to Observable
    @Bindable var article: Article

//    @Binding var article: Article
    var body: some View {
        VStack {
            TextField("Title", text: $article.title)
            TextField("Subtitle", text: $article.subtitle)
        }.padding()
    }
}

#Preview {
    ArticleEditView(article: Article())
//    ArticleEditView(article: .constant(Article()))
}
