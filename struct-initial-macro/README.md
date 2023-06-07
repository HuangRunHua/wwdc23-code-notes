# Use Swift macros to initialize a structure

In Swift 5.9 Apple are introducing **Swift macros**. Swift macros allow you to generate that repetitive code at compile time, making your app's codebases more expressive and easier to read. In the WWDC video released by Apple on Tuesday: Write Swift Macros, Alex walks us through creating a simple Swift macro step by step. If you haven't seen the video, I highly recommend that you do so before coming back and reading this article.

In this article, I will give a different example to let you know more about Swift macros and how to use Xcode to better write your own Swift macros.

## Example

We know that when declaring a structure in swift, the structure can be initialized or not initialized. Therefore, in this article, we will create a Swift macro named `StructInit`. By using the keyword `@StructInit`, the compiler can automatically generate the operation of initializing a structure for you.

```swift
@StructInit
struct Book {
    var id: Int
    var title: String
		var subtitle: String
		var description: String
		var author: String
}
```

The above sample code is equivalent to the following code:

```swift
struct Book {
		var id: Int
		var title: String
		var subtitle: String
		var description: String
		var author: String
		init(id: Int, 
         title: String, 
         subtitle: String, 
         description: String, 
         author: String) {
				self.id = id
				self.title = title
				self.subtitle = subtitle
				self.description = description
				self.author = author
		}
}
```

Now let's see how to implement this Swift macro through code.

## Create a New Project

In order to create Swift Macros instead of creating a project you have to create a new package. You can find the new macro template appear in the package-choose window.