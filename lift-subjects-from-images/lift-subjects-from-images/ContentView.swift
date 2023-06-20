//
//  ContentView.swift
//  lift-subjects-from-images
//
//  Created by Huang Runhua on 6/20/23.
//

import SwiftUI
import VisionKit

struct ContentView: View {
    @State private var deviceSupportLiveText = false
    @State private var showDeviceNotCapacityAlert = false
    @State private var showLiveTextView = false
    var body: some View {
        Button {
            if deviceSupportLiveText {
                self.showLiveTextView = true
            } else {
                self.showDeviceNotCapacityAlert = true
            }
        } label: {
            Text("Pick an Image")
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .alert("Live Text Unavailable", isPresented: $showDeviceNotCapacityAlert, actions: {})
        .sheet(isPresented: $showLiveTextView, content: {
            ImageLiftView()
        })
        .onAppear {
            self.deviceSupportLiveText = ImageAnalyzer.isSupported
        }
    }
}

#Preview {
    ContentView()
}
