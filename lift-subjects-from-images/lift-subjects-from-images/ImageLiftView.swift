//
//  ImageLiftView.swift
//  lift-subjects-from-images
//
//  Created by Huang Runhua on 6/20/23.
//

import SwiftUI

struct ImageLiftView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            ImageLift(imageName: "dog")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
                .interactiveDismissDisabled(true)
        }
    }
}

#Preview {
    ImageLiftView()
}

