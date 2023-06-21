# Lift Subjects from Images in Your App

Discover how you can easily pull the subject of an image from its background in your apps. 

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/lift-subjects-from-images/cover.png) 

WWDC23 brings a lot of updates to enable developers create greatest user experience ever. Now VisionKit enables users lift subjects from images. With just a few lines of code, you can help users easily pull the subject of an image from its background in your apps. 

In this article, I will share my experience of how to get the most out of VisionKit (lift subjects, Live Text, recognize machine-readable codes, such as QR codes and visual look up and so on) inside your SwiftUI project.

## Build a Main View

Create a new Xcode project and we will focus on the `ContentView.swift` file now. The following code is similar to the code putting in my previous article: [WWDC22: Enabling Live Text Interactions With Images in SwiftUI](https://medium.com/better-programming/enabling-live-text-interactions-with-images-in-swiftui-5dd1d7f1676). I suppose that you have the basic knowledge of SwiftUI, if no please check Apple’s official document: [Introducing SwiftUI](https://developer.apple.com/tutorials/swiftui).

```swift
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
            LiveTextInteractionView()
        })
        .onAppear {
        		// Do something when view appears
        }
    }
}
```

The above code generate a view that only contains a `Button` view, its function is to present the Live Text view and let users copy or do something else to the detected texts or machine readable code as well as lift subjects. However, not all device is capable with that function, according to Apple:

> For iOS apps, Live Text is only available on devices with the A12 Bionic chip and later.

Fortunately, Apple provides us a new API to check whether the device supports Live Text. If the device isn’t support Live Text, when attempting to tap the button to present the Live Text view, the app will present an alert that illustrates device is not capable with the Live Text.

![](https://miro.medium.com/v2/resize:fit:1024/format:webp/1*9D03J3Lys0ykNfQf5ewR2A.png)

# Build a Live Text View

Live Text view contains all the features that is need to perform actions with text, QR codes and subjects that appear in images.

Create a new SwiftUI file named `ImageLiftView.swift`, and add the following code to the file:

```swift
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
```

## Check whether the device supports Live Text

Before showing a Live Text interface in your app, check whether the device supports Live Text. If the `ImageAnalyzer` `isSupported` property is `true`, show the Live Text interface.

In your `ContentView` add the following check sentence inside your `onAppear`code:

```swift
.onAppear {
		self.deviceSupportLiftSubject = ImageAnalyzer.isSupported
}
```

This will enable your app to check whether the device supports Live Text as soon as the app is launched.

## Add a Image interaction object to your view in iOS

This article only contains the instructions on how to implement the API inside an iOS or iPadOS app, so I will not analyze the API in macOS.

To embed a `UIView` inside a SwiftUI view, we need `UIViewRepresentable` to help us.

Create a new swift file named `ImageLift.swift`, and add the following code:

```swift
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
      	
    }
}
```

`imageName` here is a String type value, so you’d better prepare an image and add it to `Assets`. I named this image `dog.png` .

`imageView` is a `LiftImageView` type value inherited from `UIImageView` . `LiftImageView` only use for resizing the image when embedding a `UIImageView` inside a SwiftUI view.

```swift
class LiftImageView: UIImageView {
    // Use intrinsicContentSize to change the default image size
    // so that we can change the size in our SwiftUI View
    override var intrinsicContentSize: CGSize {
        .zero
    }
}
```

For iOS apps, you add the Live Text interface by adding an interaction object to the view containing the image. Add an `ImageAnalysisInteraction` object to the view’s interactions.

## Find items and start the interaction with an image

`ImageAnalyzer.Configuration` object is used for specifying the types of items in the image we want to find. In this case, we want to consider all types of items. The initializing of `ImageAnalyzer.Configuration` object is easy:

```swift
func updateUIView(_ uiView: UIViewType, context: Context) {
   	Task {
        if let image = imageView.image {
            // Here I set configuration to contian all the configurations.
            let configuration = ImageAnalyzer.Configuration([.text, .visualLookUp, .machineReadableCode])
        }
    }
}
```

Then analyze the image by sending `analyze(_:configuration:)` to an `ImageAnalyzer` object, passing the image and the configuration. To improve performance, use a single shared instance of the analyzer throughout the app.

```swift
func updateUIView(_ uiView: UIViewType, context: Context) {
   	Task {
        if let image = imageView.image {
            // Here I set configuration to contian all the configurations.
            let configuration = ImageAnalyzer.Configuration([.text, .visualLookUp, .machineReadableCode])
            let analysis = try? await analyzer.analyze(image, configuration: configuration)
        }
    }
}
```

For iOS apps, start the image interface by setting the `analysis` property of the `ImageAnalysisInteraction` object to the results of the analyze method. For example, set the `analysis` property in the action method of a control that starts user interact with an image.

```swift
func updateUIView(_ uiView: UIViewType, context: Context) {
   	Task {
        if let image = imageView.image {
            // Here I set configuration to contian all the configurations.
            let configuration = ImageAnalyzer.Configuration([.text, .visualLookUp, .machineReadableCode])
            let analysis = try? await analyzer.analyze(image, configuration: configuration)
          	if let analysis = analysis {
                interaction.analysis = analysis
            }
        }
    }
}
```

## Customize the interface using interaction types

You can change the behavior of the interface by enabling types of interactions with items found in the image. If you set the interaction or overlay view `preferredInteractionTypes` property to `automatic`, users can interact with all types of items that the analyzer finds in an image. For the text items, you can change the `preferredInteractionTypes` to `textSelection` .

```swift
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
```

Now run this project and enjoy yourself.

## Source Code

You can find the source code on [Github](https://github.com/HuangRunHua/wwdc23-code-notes/tree/main/lift-subjects-from-images).

## Supports Me

If you think this article is helpful, you can support me by downloading my first Mac App which named [FilerApp](https://huangrunhua.github.io/FilerApp/) on the [Mac App Store](https://apps.apple.com/us/app/filerapp/id1626627609?mt=12&itsct=apps_box_link&itscg=30200). FilerApp is a Finder extension for your Mac which enables you to easily create files in supported formats anywhere on the system. It is free and useful for many people. Hope you like it.
