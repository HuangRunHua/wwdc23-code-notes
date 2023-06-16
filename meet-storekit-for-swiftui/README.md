# Meet StoreKit for SwiftUI in iOS 17

A Complete Guide to the Implementation of In-App Purchase in iOS 17. Explore how the new StoreKit views help you build in-app purchase with just a few lines of code.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-storekit-for-swiftui/article-images/IMG_7762.JPEG)

"In Xcode 15, StoreKit now provides a collection of SwiftUI views, which help you build declarative in-app purchase UI" said Greg, an engineer on the StoreKit team, as he unveiled the technology giant's latest develop tools for in-app purchase. Before StoreKit2, it would be an awkward thing to enable in-app purchase in app, you are forced to spend gargantuan time writing a large mount of code to achieve the same functions which actually only need to write a few lines of code if you add in-app purchase with the help of the new declarative in-app purchase UI in iOS 17. 

In the last few days, I have been researching how to use the in-app purchase function on iOS 17 with clean code, and handle a series of operations including user cancellation and refund in a smart way. This article mainly introduces how the "**StoreKit Views**" brought by WWDC 23 can help developers realize the in-app purchase interface with only a few lines of code.  A practical example is used to illustrate the specific implementation method and clarify how to support non-consumable in-app purchases in your application.

## Example

People like to listen to music, but not every song is free, and some songs need to be paid before they can be listened to. So in the sample project for this article, I focused on songs. At the beginning, there is no music in the user's music library. After clicking the shopping button in the upper right corner, the user can choose to buy the music he likes. After the transaction is completed, the purchased songs will appear in the database. The image below describes the above transaction process in detail.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-storekit-for-swiftui/article-images/IMG_7754.JPEG)

Now let's analyze in detail how to implement this simple program.

## Create In-App Purchase

After creating a new project, we need to add in-app purchase items. In this example, note that music is a non-consumable (no one wants to buy a song repeatedly), so you need to pay attention to setting the in-app purchase item as a non-consumable attribute when setting. In your project, create a new **StoreKit Configuration File**, we will need to test everything through this file under Xcode environment. 

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-storekit-for-swiftui/article-images/1.png)

Before StoreKit2, if you need to test in-app purchase, you need to configure your product on App Store Connect, now you can directly use Xcode to test whether the in-app purchase function is perfect.

Name your configuration file, here I named it `Store`. After creating your StoreKit configuration file, you may need to give your items' information. Tap plus button and then choose **Add Non-Consumable In-App Purchase**.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-storekit-for-swiftui/article-images/2.png)

Name your item's  *Reference Name* . Here for convenient, the reference name of the first song is set to the name of the song *Cold Winter* (from July). The *Product ID* must be unique and cannot be duplicated with other products. The *Product ID* will be passed in as the retrieval parameter of the `StoreView`. Set the *Price* to whatever you want. At least add one *Localization*, the *Display Name* and *Description* will be shown if you use the new StoreKit views in iOS 17.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-storekit-for-swiftui/article-images/3.png)

The number of items can be added arbitrarily. For illustration purposes here, I have created a total of three items for purchase.

### Change StoreKit Configuration Scheme

We will use the configuration file we just created when testing, so we need to go to **Scheme** and change the **StoreKit Configuration** to the `Store.storekit` we created.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-storekit-for-swiftui/article-images/4.png)

## Create Product Class

After creating the product, we need to access the basic information of the product in the program, for which we need to create a class corresponding to the product.

Create a new swift file and name it `SongProduct.swift`. `SongProduct` should include the basic information of the product, such as product name, product id, etc. It also needs to include some things that were not covered when creating the product, such as whether the user bought it or not. The `image` member variable inside the class is used to specify the cover of the product.

```swift
class SongProduct: Identifiable {
    public var id: Int
    public var productID: String
    public var name: String
    public var summary: String
    public var isPurchased: Bool
    
    var image: Image {
        Image("Musics/\(name)")
            .resizable()
    }
    
    public init(
        id: Int,
        productID: String,
        name: String,
        summary: String,
        isPurchased: Bool
    ) {
        self.id = id
        self.productID = productID
        self.name = name
        self.summary = summary
        self.isPurchased = isPurchased
    }
}
```

### Create Products

In order to access the items we created programmatically, we need to create a separate list of all items.

```swift
extension SongProduct {
    static let allSongProducts: [SongProduct] = [
        SongProduct(id: 0,
                    productID: "com.meet.storekit.for.swiftui.cold.winter",
                    name: "Cold Winter",
                    summary: "Hip-Hop/Rap 2020",
                    isPurchased: false),
        SongProduct(id: 1,
                    productID: "com.meet.storekit.for.swiftui.platinum.disco",
                    name: "Platinum Disco",
                    summary: "J-Pop 2014, Lossless",
                    isPurchased: false),
        SongProduct(id: 2,
                    productID: "com.meet.storekit.for.swiftui.drunk",
                    name: "Drunk",
                    summary: "International Pop 2015, Lossless",
                    isPurchased: false)
    ]
}
```

## Store Model

In order to display the purchased songs on the interface, we access the purchased songs of the user through a list called `ownedSongProducts`. `ownedSongProducts` is a member variable of the class `StoreModel`, and the `@Observable` macro is added in front of the class `StoreModel`, so that if the `ownedSongProducts` changes inside the program, the view of the software will change accordingly. For `@Observable` macro content, please refer to the article [First glance at @Observable macro](https://medium.com/@h76joker/first-glance-at-observable-macro-ebf97bd82ae1).

```swift
import Observation
@Observable public class StoreModel {
    var ownedSongProducts: [SongProduct] = []
}
```

## Songs Library View

As mentioned above, when `ownedSongProducts` is empty, we should display an empty library on the interface, indicating that the user has not currently purchased any songs. When `ownedSongProducts` is not empty, we display the songs that the user has purchased on the interface.

```swift
struct ContentView: View {
    @State private var showShopStore: Bool = false
    var storeModel: StoreModel
    var body: some View {
        NavigationView {
            VStack {
                if storeModel.ownedSongProducts.isEmpty {
                    Text("Empty Library")
                        .font(.title)
                        .foregroundStyle(.gray)
                } else {
                    ScrollView {
                        ForEach(storeModel.ownedSongProducts) { song in
                            SongCellView(music: song)
                                .padding([.leading, .trailing])
                        }
                    }
                }
            }
          	.navigationTitle("Songs")
            .toolbar(content: {
                ToolbarItem {
                    Button(action: {
                        self.showShopStore = true
                    }, label: {
                    		Label("Shop Store", systemImage: "cart")
                    })
                }
            })
        }
        .sheet(isPresented: $showShopStore, content: {
            SongProductShop()
        })
    }
}
```

where the code of `SongCellView` is as follows:

```swift
struct SongCellView: View {
    var music: SongProduct
    var body: some View {
        VStack {
            HStack {
                music.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                VStack(alignment: .leading, spacing: 3) {
                    Text(music.name)
                        .font(.system(size: 17))
                    Text(music.summary)
                        .foregroundStyle(.gray)
                        .font(.system(size: 15))
                }
                .frame(height: 50)
                Spacer()
            }
            Divider()
        }
    }
}
```

The implementation of `SongProductShop` will be described in detail in the next section.

## Song Product Shop View

When the user clicks the shopping button in the upper right corner, the system will display all available products. to this I'm going to use a `StoreView` to the app because it's the quickest way to get the merchandising view up and running. We need to provide it a collection of product identifiers from our StoreKit configuration file, which we can get from the `SongProduct` model.

Create a new SwiftUI file and name it `SongProductShop.swift`. First declare the all musics that for sell.

```swift
import StoreKit
struct SongProductShop: View {
    private var musics: [SongProduct] {
        SongProduct.allSongProducts
    }
    ...
}
```

Next we need to get all the product identifiers:

```swift
import StoreKit
struct SongProductShop: View {
    ...
    private var productIDs: some Collection<Product.ID> {
	musics.lazy
	      .map(\.productID)
    }
    ...
}
```

Now just using `StoreView(id:)` and we will have a functioning merchandising view.

```swift
import StoreKit
struct SongProductShop: View {
    ...
    var body: some View {
        NavigationView {
            StoreView(ids: productIDs)
            	.navigationTitle("Song Shop")
            	.storeButton(.hidden, for: .cancellation)
            	.productViewStyle(.regular)
        }
    }
}
```

StoreKit loads all the product identifiers from the App Store and presents them in UI for us to view. The display names, descriptions, and prices all come directly from the App Store, which uses what you've set up in App Store Connect or your StoreKit configuration file. StoreKit even handles more subtle, but important, considerations like caching the data until it expires or the system is under memory pressure and checking whether in-app purchase is disabled in Screen Time. 

Views without pictures always look empty. Fortunately, we can add corresponding product pictures to the view. We can add these icons to the Store View just by adding a trailing view builder, and passing in a SwiftUI view representing our icons.

The view builder takes a Product value as a parameter, which we can use to determine an icon to use. The Store View helps us get up and running with ease by turning our product identifiers and icons into a functional and well designed store. 

```swift
struct SongProductShop: View {
    ...
    var body: some View {
        NavigationView {
            StoreView(ids: productIDs) { product in
                SongProductProductIcon(productID: product.id)
            }
            .navigationTitle("Song Shop")
            .storeButton(.hidden, for: .cancellation)
            .productViewStyle(.regular)
        }
    }
}
```

I created a helper view named `SongProductProductIcon` that takes a product ID and looks up the right icon from our asset catalog.

```swift
struct SongProductProductIcon: View {
    var productID: String
    var song: SongProduct? {
        SongProduct.allSongProducts.song(for: productID)
    }
    var body: some View {
        if let song {
            song.image
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 7))
        } else {
            EmptyView()
        }
    }
}

extension Sequence where Element == SongProduct {
    func song(for productID: String) -> SongProduct? {
        lazy.first(where: { $0.productID == productID })
    }
}
```

The store view is finished and you can purchase the song by tapping the purchase button. However, when the purchase is completed the view is not updated to show the purchased one. So we need to tackle this problem.

## Handle Purchases

Handling purchases and transactions has never been easier with StoreKit2. Create a new file called `SongProductPurchase.swift` and add the following code:

```swift
import StoreKit
actor SongProductPurchase {
    var storeModel: StoreModel
  
    private init(storeModel: StoreModel) {
        self.storeModel = storeModel
    }
    private(set) static var shared: SongProductPurchase!
    static func createSharedInstance(storeModel: StoreModel) {
        shared = SongProductPurchase(storeModel: storeModel)
    }
}  
```

To protect the stored properties when accessed asynchronously, make `SongProductPurchase` to an actor type. By using `SongProductPurchase.shared` syntax you can easily call internal member functions inside `SongProductPurchase`.

Now we need to handle the results of user purchases. When the user clicks the buy button, we need to verify the final purchase result. `VerificationResult` is a type that describes the result of a StoreKit verification and before we update our view we have to check whether the values are verified or unverified.

```swift
actor SongProductPurchase {
  	...
  	func process(transaction verificationResult: VerificationResult<Transaction>) async {
        let transaction: Transaction
        switch verificationResult {
        case .verified(let t):
            transaction = t
        case .unverified(_, let error):
            print("error in process: \(error.localizedDescription)")
            return
        }
        
        if case .nonConsumable = transaction.productType {
            guard let songProduct = song(for: transaction.productID) else {
                return
            }
            if transaction.revocationDate == nil, transaction.revocationReason == nil {
                songProduct.isPurchased = true
            } else {
                songProduct.isPurchased = false
            }
        } else {
            await transaction.finish()
        }
        
        storeModel.ownedSongProducts = SongProduct.allSongProducts.filter({ $0.isPurchased })
    }
  
  	private func song(for productID: Product.ID) -> SongProduct? {
        SongProduct.allSongProducts.song(for: productID)
    }
}
```

In the above code, we first confirmed whether the transaction values are verified or unverified.  if verified pass the transaction to `Transaction`, if not just stop processing. Then we need to check the product type. Since we just add the non-consumable items, here I just check the `.nonConsumable` case in code. If the items purchased by user are not revocated, make the `isPurchase` to true, otherwise set it to false. Finally, update the `storeModel` so that the view can update correctly.

Back to `ContentView`, we haven't handle the purchase in our view. Handling purchases that come from any of the StoreKit views is simple. You just modify a view with `onInAppPurchaseCompletion` and provide a function to call whenever a purchase completes. You can modify any view with this method, and it will be called whenever a descendant StoreKit view finishes a purchase. The modifier gives us the product which was purchased and the result of the purchase, whether it was successful or not.

```swift
struct ContentView: View {
  	...
  	var body: some View {
      	NavigationView {...}
      		.onAppear(perform: {
            	SongProductPurchase.createSharedInstance(storeModel: storeModel)
        	})
        	.onInAppPurchaseCompletion { product, purchaseResult in
            	if case .success(.success(let transaction)) = purchaseResult {
                	await SongProductPurchase.shared.process(transaction: transaction)
            	}
            	self.showShopStore = false
        	}
    }
}
```

Now run the app and make a purchase, you can see the purchased item appears on the list.

### Handle OnAppear

If you break the app and run it again, problem occurs! The purchased song does not show in the list. To tackle that, we need to observe transaction updates and check for unfinished transactions together before view appears. In your `SongProductPurchase`, add the following code:

```swift
actor SongProductPurchase {
  	...
  	func checkForUnfinishedTransactions() async {
        for await transaction in Transaction.unfinished {
            Task.detached(priority: .background) {
                await self.process(transaction: transaction)
            }
        }
    }
    func observeTransactionUpdates() async {
        for await update in Transaction.updates {
            await self.process(transaction: update)
        }
    }
}
```

The code above aims to check every transaction detail (purchase, refund etc.). And back to `ContentView`, use `.task` to check the transactions before view appears.

```swift
struct ContentView: View {
  	...
  	var body: some View {
      	NavigationView {...}
      		.onAppear(perform: {...})
        	.onInAppPurchaseCompletion {...}
      		.task {
            	// Begin observing StoreKit transaction updates in case a
            	// transaction happens on another device.
            	await SongProductPurchase.shared.observeTransactionUpdates()
            	// Check if we have any unfinished transactions where we
            	// need to grant access to content
            	await SongProductPurchase.shared.checkForUnfinishedTransactions()
        	}
    }
}
```

### Restore Purchase

Users sometimes need to restore purchased content, such as when they upgrade to a new phone. Include some mechanism in your app, such as a Restore Purchases button, to let them restore their purchases. The button I create just locate in the right corner of the view `SongProductShop`, use `.toolbar` to create a button and call `AppStore.sync()` to enable restore purchase:

```swift
struct SongProductShop: View {
    ...
    @State private var isRestoring = false
    var body: some View {
        NavigationView {
            StoreView(ids: productIDs) {...}
            .navigationTitle("Song Shop")
            .storeButton(.hidden, for: .cancellation)
            .productViewStyle(.regular)
            .toolbar {
                ToolbarItem {
                    Button("Restore") {
                        isRestoring = true
                        Task.detached {
                            defer { isRestoring = false }
                            try await AppStore.sync()
                        }
                    }
                    .disabled(isRestoring)
                }
            }
        }
    }
}
```

All done. Try to make a purchase and enjoy coding.

## Source Code

You can find the source code on [GitHub](https://github.com/HuangRunHua/wwdc23-code-notes/tree/main/meet-storekit-for-swiftui).

> If you think this article is helpful, you can support me by downloading my first Mac App which named [FilerApp](https://huangrunhua.github.io/FilerApp/) on the [Mac App Store](https://apps.apple.com/us/app/filerapp/id1626627609?mt=12&itsct=apps_box_link&itscg=30200). FilerApp is a Finder extension for your Mac which enables you to easily create files in supported formats anywhere on the system. It is free and useful for many people. Hope you like it.
