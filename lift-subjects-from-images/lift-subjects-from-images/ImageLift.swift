//
//  ImageLift.swift
//  lift-subjects-from-images
//
//  Created by Huang Runhua on 6/20/23.
//

import SwiftUI
import VisionKit

@MainActor
struct ImageLift: UIViewRepresentable {
    var imageName: String
    let imageView = LiftImageView()
    let analyzer = ImageAnalyzer()
    let interaction = ImageAnalysisInteraction()
    
    func makeUIView(context: Context) -> some UIView {
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.addInteraction(interaction)
        return imageView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        Task {
            if let image = imageView.image {
                // Here I set configuration to contian all the configurations.
                let configuration = ImageAnalyzer.Configuration([.text, .visualLookUp, .machineReadableCode])
                let analysis = try? await analyzer.analyze(image, configuration: configuration)
                if let analysis = analysis {
                    interaction.analysis = analysis
                    // If just want recognize subject
                    // use .imageSubject instead.
                    interaction.preferredInteractionTypes = .automatic
                }
            }
        }
    }
}


class LiftImageView: UIImageView {
    // Use intrinsicContentSize to change the default image size
    // so that we can change the size in our SwiftUI View
    override var intrinsicContentSize: CGSize {
        .zero
    }
}
