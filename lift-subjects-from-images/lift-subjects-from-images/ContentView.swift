//
//  ContentView.swift
//  lift-subjects-from-images
//
//  Created by Huang Runhua on 6/20/23.
//

import SwiftUI
import VisionKit

struct ContentView: View {
    @State private var deviceSupportLiftSubject = false
    @State private var showDeviceNotCapacityAlert = false
    @State private var showImageLiftView = false
    var body: some View {
        Button {
            if deviceSupportLiftSubject {
                self.showImageLiftView = true
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
        .alert("Lift Subject Unavailable", isPresented: $showDeviceNotCapacityAlert, actions: {})
        .sheet(isPresented: $showImageLiftView, content: {
            ImageLiftView()
        })
        .onAppear {
            self.deviceSupportLiftSubject = ImageAnalyzer.isSupported
        }
    }
}

#Preview {
    ContentView()
}
