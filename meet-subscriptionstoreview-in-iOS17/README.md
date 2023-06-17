# Meet  StoreKit SubscriptionStoreView in iOS 17

Explore how the new StoreKit views help you build in-app subscriptions with just a few lines of code.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-subscriptionstoreview-in-iOS17/article-images/1.JPEG)

The emergence of [SubscriptionStoreView](https://developer.apple.com/documentation/storekit/subscriptionstoreview) frees developers from tedious and complicated code. WWDC23 brought a declarative in-app purchase UI, which allows developers to use Apple's pre-designed app purchase interface. Only a few lines of code need to be inserted into the code to realize functions that previously required a lot of design and code.

In the last few days, I have been researching how to use the in-app subscription function on iOS 17 with clean code, and handle a series of operations including user cancellation and refund in a smart way. This article mainly introduces how the “**SubscriptionStoreView**” brought by WWDC 23 can help developers realize the **in-app subscription** interface with only a few lines of code. A practical example is used to illustrate the specific implementation method and clarify how to support **auto-renewable subscriptions** in your application.

> If you are looking for the way to support non-consumable in-app purchases in your application, please check this article: [Meet StoreKit for SwiftUI in iOS 17](https://medium.com/better-programming/meet-storekit-for-swiftui-in-ios-17-12ae73295b15)

## Example

The following picture describes the demo app in this article. This app is similar to the other video apps. People need to subscribe to the **Flower Movie+** to access all the content of movies. At first, there are **View Options** button appears on the screen. When users tap the button, the subscription view will show up and if user chooses one of the plan, the view will update to the plan and show the details according to the selection. The **Handle Subscription** button aims to help users change the subscription plan at any time they want.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-subscriptionstoreview-in-iOS17/article-images/2.JPEG)

Now let’s analyze in detail how to implement this simple program.

## Create Auto-Renewable Subscription 

After creating a new project, we need to add in-app purchase items. In this example you should pay attention to setting the in-app purchase item as an auto-renewable subscription attribute when setting. In your project, create a new **StoreKit Configuration File**, we will need to test everything through this file under Xcode environment.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-subscriptionstoreview-in-iOS17/article-images/3.png)

Before StoreKit2, if you need to test in-app purchase, you need to configure your product on App Store Connect, now you can directly use Xcode to test whether the in-app purchase function is perfect.

Name your configuration file, here I named it `Store`. After creating your StoreKit configuration file, you may need to give your subscriptions' information. Tap plus button and then choose **Add Auto-Renewable Subscription**.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-subscriptionstoreview-in-iOS17/article-images/4.png)

Name your subscription group and when you create a new auto-renewable subscription, select the group you created before. Here I named my group **Flower Movie+**.  There are three ways to subscribe to Flower Movie+, monthly payment, quarterly payment and annual payment. So you need to continue to create three auto-renewable subscriptions. Here I set their **Reference Names** to Monthly, Quarterly and Yearly respectively. Prices are set according to your preferences. Whether users can try it for free before paying for the subscription depends on your idea. Usually, I prefer to let users experience it for a period of time before paying. At least has one localization because the detail information is needed for **SubscriptionStoreView**. The following is a detailed configuration list of my `Store.storekit`.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-subscriptionstoreview-in-iOS17/article-images/5.png)

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-subscriptionstoreview-in-iOS17/article-images/6.png)

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-subscriptionstoreview-in-iOS17/article-images/7.png)

## Change StoreKit Configuration Scheme

We will use the configuration file we just created when testing, so we need to go to **Scheme** and change the **StoreKit Configuration** to the `Store.storekit`we created.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-subscriptionstoreview-in-iOS17/article-images/8.png)

## Create Subscription Status

Note that there are four types of subscription states: 

1. the user does not subscribe to the product, 
2. the user subscribes on a monthly basis, 
3. the user subscribes on a quarterly basis
4. the user subscribes on an annual basis. 

This is obviously an enumeration problem, so we consider trying to use `enum` to list all subscription states. Create a new file named `PassStatus.swift` and add following code:

```swift
import StoreKit

enum PassStatus: Comparable, Hashable {
    case notSubscribed
    case monthly
    case quarterly
    case yearly
    
    init?(productID: Product.ID, ids: PassIdentifiers) {
        switch productID {
        case ids.monthly: self = .monthly
        case ids.quarterly: self = .quarterly
        case ids.yearly: self = .yearly
        default: return nil
        }
    }
    
    var description: String {
        switch self {
        case .notSubscribed:
            "Not Subscribed"
        case .monthly:
            "Monthly"
        case .quarterly:
            "Quarterly"
        case .yearly:
            "Yearly"
        }
    }
}
```

The `PassIdentifiers` contains all the subscriptions' product identifier:

```swift
struct PassIdentifiers {
    var group: String
    
    var monthly: String
    var quarterly: String
    var yearly: String
}

extension EnvironmentValues {
    private enum PassIDsKey: EnvironmentKey {
        static var defaultValue = PassIdentifiers(
            group: "506F71A6",
            monthly: "com.pass.monthly",
            quarterly: "com.pass.quarterly",
            yearly: "com.pass.yearly"
        )
    }
    
    var passIDs: PassIdentifiers {
        get { self[PassIDsKey.self] }
        set { self[PassIDsKey.self] = newValue }
    }
}
```

In this article we will use `@Environment(\.passIDs)` to get all the identifiers of products. You can get the group ID in your `Store.storekit`.

## Store Model

In order to display the status of the subscription on the interface, we use `passStatus` to help us monitor the status.

`passStatus` is a member variable of the class `PassStatusModel`, and the `@Observable` macro is added in front of the class `PassStatusModel`, so that if the `passStatus` changes inside the program, the view will change accordingly.

For `@Observable` macro content, please refer to the article [First glance at @Observable macro](https://medium.com/@h76joker/first-glance-at-observable-macro-ebf97bd82ae1).

```swift
import Observation
@Observable class PassStatusModel {
    var passStatus: PassStatus = .notSubscribed
}
```

## View to Show Subscription Status

As mentioned before, when the `passStatus` is equal to `.notSubscribed`, we need to display the view which enables users to subscribe to the `Flower Movie+`. When the `passStatus` is not `.notSubscribed`, a view that indicates the subscription status should show up.

```swift
import StoreKit

struct ContentView: View {
    
    @State private var showScriptionView: Bool = false
    
    @Environment(PassStatusModel.self) var passStatusModel: PassStatusModel
    @Environment(\.passIDs) private var passIDs
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    planView
                    // Show the option button if user does not have a plan.
                    if passStatusModel.passStatus == .notSubscribed {
                        Button {
                            self.showScriptionView = true
                        } label: {
                            Text("View Options")
                        }
                    }
                } header: {
                    Text("SUBSCRIPTION")
                } footer: {
                    if passStatusModel.passStatus != .notSubscribed {
                        Text("Flower Movie+ Plan: \(String(describing: passStatusModel.passStatus.description))")
                    }
                }
            }
            .navigationTitle("Account")
            .sheet(isPresented: $showScriptionView, content: {
                SubscriptionShopView()
            })
        }
    }
}

extension ContentView {
    @ViewBuilder
    var planView: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(passStatusModel.passStatus == .notSubscribed ? "Flower Movie+": "Flower Movie+ Plan: \(passStatusModel.passStatus.description)")
                .font(.system(size: 17))
            Text(passStatusModel.passStatus == .notSubscribed ? "Subscription to unlock all streaming videos, enjoy Blu-ray 4K quality, and watch offline.": "Enjoy all streaming Blu-ray 4K quality videos, and watch offline.")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            if passStatusModel.passStatus != .notSubscribed {
                Button("Handle Subscription \(Image(systemName: "chevron.forward"))") {
                    self.presentingSubscriptionSheet = true
                }
            }
        }
    }
}
```

The implementation of `SubscriptionShopView` will be described in detail in the next section.

## Subscription Shop View

When the user taps the **View Options** button, the system will display all available products. To this I’m going to use a `SubscriptionStoreView(groupID:)` to the app because it's the quickest way to get the merchandising view up and running. We need to provide it a group identifier from our StoreKit configuration file, which we can get by using `@Environment(\.passIDs.group)`.

Create a new SwiftUI file and name it `SubscriptionShopView.swift`. First declare the group ID.

```swift
import StoreKit
struct SubscriptionShopView: View {
    @Environment(\.passIDs.group) private var passGroupID
}
```

Now just using `SubscriptionStoreView(groupID:)` and we will have a functioning merchandising view.

```swift
import StoreKit
struct SubscriptionShopView: View {
		...
  	var body: some View {
        SubscriptionStoreView(groupID: passGroupID)
        		.backgroundStyle(.clear)
        		.subscriptionStoreButtonLabel(.multiline)
        		.subscriptionStorePickerItemBackground(.thinMaterial)
        		.storeButton(.visible, for: .restorePurchases)
    }
}
```

Just like the `StoreView` and the `ProductView`, the `SubscriptionStoreView` manages the data flow for us and lays out a view with the different plan options. It also checks for existing subscriber status and whether the customer is eligible for an introductory offer. Here I use the background style modifier to make the background behind the subscription controls clear. Then the `subscriptionStoreButtonLabel` is used to choose a multi-line layout for our subscribe button. Notice how the subscribe button contains both the price and "Try it Free." The `subscriptionStorePickerItemBackground` aims to declare a material effect for our subscription options. Finally, I use the new `storeButton` modifier to declare the **Restore Button** as visible.

While this automatic look is great, but I want to replace the marketing content in the header with my SwiftUI view.

```swift
import StoreKit
struct SubscriptionShopView: View {
		...
  	var body: some View {
        SubscriptionStoreView(groupID: passGroupID) {
          	SubscriptionShopContent()
        }
      	...
    }
}
```

The `SubscriptionShopContent` is defined below:

```swift
struct SubscriptionShopContent: View {
    var body: some View {
        VStack {
            image
            VStack(spacing: 3) {
                title
                desctiption
            }
        }
        .padding(.vertical)
        .padding(.top, 40)
    }
}

extension SubscriptionShopContent {
    @ViewBuilder
    var image: some View {
        Image("movie")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
        
    }
    @ViewBuilder
    var title: some View {
        Text("Flower Movie+")
            .font(.largeTitle.bold())
    }
    @ViewBuilder
    var desctiption: some View {
        Text("Subscription to unlock all streaming videos, enjoy Blu-ray 4K quality, and watch offline.")
            .fixedSize(horizontal: false, vertical: true)
            .font(.title3.weight(.medium))
            .padding([.bottom, .horizontal])
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
    }
}
```

The basic subscription view is finished and you can subscribe to the **Flower Movie+** by tapping the button. However, when the purchase is completed the view is not updated to show the plan. So we need to tackle this problem.

## Handle Subscriptions

Handling subscriptions and transactions has never been easier with StoreKit2. Create a new file called `ProductSubscription.swift` and add the following code:

```swift
import StoreKit
actor ProductSubscription {
    private init() {}
    private(set) static var shared: ProductSubscription!  
    static func createSharedInstance() {
        shared = ProductSubscription()
    }
}
```

To protect the stored properties when accessed asynchronously, make `ProductSubscription` to an actor type. By using `ProductSubscription.share ` syntax you can easily call internal member functions inside `ProductSubscription`.

Now we need to handle the results of user subscriptions. When the user tap the button, we need to verify the final purchase result. 

```swift
actor ProductSubscription {
		...
  	func status(for statuses: [Product.SubscriptionInfo.Status], ids: PassIdentifiers) -> PassStatus {
        let effectiveStatus = statuses.max { lhs, rhs in
            let lhsStatus = PassStatus(
                productID: lhs.transaction.unsafePayloadValue.productID,
                ids: ids
            ) ?? .notSubscribed
            let rhsStatus = PassStatus(
                productID: rhs.transaction.unsafePayloadValue.productID,
                ids: ids
            ) ?? .notSubscribed
            return lhsStatus < rhsStatus
        }
        guard let effectiveStatus else {
            return .notSubscribed
        }
        
        let transaction: Transaction
        switch effectiveStatus.transaction {
        case .verified(let t):
            transaction = t
        case .unverified(_, let error):
            print("Error occured in status(for:ids:): \(error)")
            return .notSubscribed
        }
        
        if case .autoRenewable = transaction.productType {
            if !(transaction.revocationDate == nil && transaction.revocationReason == nil) {
                return .notSubscribed
            }
            if let subscriptionExpirationDate = transaction.expirationDate {
                if subscriptionExpirationDate.timeIntervalSince1970 < Date().timeIntervalSince1970 {
                    return .notSubscribed
                }
            }
        }
        return PassStatus(productID: transaction.productID, ids: ids) ?? .notSubscribed
    }
}
```

In the above code, we first check the transaction status. Then we first confirmed whether the transaction values are verified or unverified. If verified pass the transaction to `Transaction`, if not just stop processing and return `.notSubscribed`. Then we need to check the product type. Here I just check the `.autoRenewable` case in code. If the subscription is revocated, return `.notSubscribed`. I also check the whether the subscription is expired or not, if the subscription is expired return `.notSubscribed`.  Finally, return the actual result from App Store.

Back to `ContentView`, we haven't handle the subscription in our view. Handling subscriptions that come from any of the StoreKit views is simple. You just modify a view with `subscriptionStatusTask` and it will load the subscription status and then call the function we provide once the task completes.

```swift
struct ContentView: View {
  	...
  	@State private var status: EntitlementTaskState<PassStatus> = .loading
  	var body: some View {
        NavigationView {...}
        .onAppear(perform: {
            ProductSubscription.createSharedInstance()
        })
        .subscriptionStatusTask(for: passIDs.group) { taskStatus in
            self.status = await taskStatus.map { statuses in
                await ProductSubscription.shared.status(
                    for: statuses,
                    ids: passIDs
                )
            }
            switch self.status {
            case .failure(let error):
                passStatusModel.passStatus = .notSubscribed
                print("Failed to check subscription status: \(error)")
            case .success(let status):
                passStatusModel.passStatus = status
            case .loading: break
            @unknown default: break
            }
        }
    }
}
```

## Handle Subscription Button

It is good to hide the subscription interface when the user has subscribed and allow the user to change the subscription plan in your app. `.manageSubscriptionsSheet` is a good way to show the edit subscription view. But before we add it to our view, we need to add the **Handle Subscription** button first.

```swift
struct ContentView: View {
    ...
    @State private var presentingSubscriptionSheet = false
    var body: some View {
      	...
    }
}  
```

Then use `.manageSubscriptionsSheet` modifier to show the subscription sheet.

```swift
struct ContentView: View {
  	...
  	@State private var status: EntitlementTaskState<PassStatus> = .loading
  	var body: some View {
        NavigationView {...}
      			.manageSubscriptionsSheet(
            		isPresented: $presentingSubscriptionSheet,
            		subscriptionGroupID: passIDs.group
        		)
      			...
    }
}
```

All done. Try to make a subscription and enjoy coding.

## Source Code

You can find the source code on [GitHub](https://github.com/HuangRunHua/wwdc23-code-notes/tree/main/meet-subscriptionstoreview-in-iOS17).

> *If you think this article is helpful, you can support me by downloading my first Mac App which named* [*FilerApp*](https://huangrunhua.github.io/FilerApp/) *on the* [*Mac App Store*](https://apps.apple.com/us/app/filerapp/id1626627609?mt=12&itsct=apps_box_link&itscg=30200)*. FilerApp is a Finder extension for your Mac which enables you to easily create files in supported formats anywhere on the system. It is free and useful for many people. Hope you like it.*
