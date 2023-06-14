# Meet StoreKit for SwiftUI in iOS 17

A Complete Guide to the Implementation of In-App Purchase in iOS 17. Explore how the new StoreKit views help you build in-app purchase with just a few lines of code.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-storekit-for-swiftui/article-images/IMG_7762.JPEG)

Starting from iOS 17, we no longer need to work hard to design the interface of in-app purchases, because Apple provides us with a very good template. WWDC23 brings a brand new StoreKit which embedded **StoreKit Views** that allow developers to implement a streamlined in-app purchase interface with a few lines of code. At the same time, a series of transaction-related processes such as checking whether the user pays within the app can be fulfilled with simplified code.

In the past few days, I have been studying how to use concise code to implement in-app purchase on iOS 17 and effectively handle a series of operations such as user cancellation and refund. In this article, I will introduce how the new `StoreView` allows you to implement a streamlined in-app purchase interface with one line of code, and use an example to fully demonstrate how to support non-consumable in-app purchases in your app.

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

Name your item's  *Reference Name* . Here for convenient, the reference name of the first song is set to the name of the song *Cold Winter* (from July). The *Product ID* must be unique and cannot be duplicated with other products. Set the *Price* to whatever you want. At least add one *Localization*, the *Display Name* and *Description* will be shown if you use the new StoreKit views in iOS 17.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-storekit-for-swiftui/article-images/3.png)

The number of items can be added arbitrarily. For illustration purposes here, I have created a total of three items for purchase.
