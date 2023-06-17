# Meet  StoreKit SubscriptionStoreView in iOS 17

Explore how the new StoreKit views help you build in-app subscriptions with just a few lines of code.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/meet-subscriptionstoreview-in-iOS17/article-images/1.JPEG)

The emergence of [SubscriptionStoreView](https://developer.apple.com/documentation/storekit/subscriptionstoreview) frees developers from tedious and complicated code. WWDC23 brought a declarative in-app purchase UI, which allows developers to use Apple's pre-designed app purchase interface. Only a few lines of code need to be inserted into the code to realize functions that previously required a lot of design and code.

In the last few days, I have been researching how to use the in-app subscription function on iOS 17 with clean code, and handle a series of operations including user cancellation and refund in a smart way. This article mainly introduces how the “**SubscriptionStoreView**” brought by WWDC 23 can help developers realize the **in-app subscription** interface with only a few lines of code. A practical example is used to illustrate the specific implementation method and clarify how to support **auto-renewable subscriptions** in your application.

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

