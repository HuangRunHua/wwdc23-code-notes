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

In order to create Swift Macros instead of creating a project you have to create a new package. You can find the new macro template appear in the package-choose window. Name the template whatever you like, here I named it `struct_initial_macro`

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/struct-initial-macro/article-imgs/pic1.png)

## Name Your Macro 

Since you may use the macro for every situation It is wise to choose a nice name for your macro. Here I named my macro `StructInit`. This name is very intuitive, and it can be seen at a glance that this macro is used to initialize a structure.

After naming your macro, you may need to declare your macro right in the package. Open file `struct_initial_macro.swift` (It is my file's name, the file you need to open is `your_package_name.swift`) and update the code there:

```swift
@attached(member, names: named(init))
public macro StructInit() = #externalMacro(module: "struct_initial_macroMacros", type: "StructInitMacro")
```

Noted that the initializer is the member of any structure if you want to initialize it explicitly, so we need to declare an attached member macro by using the `@attached(member)` attribute. Because I plan to name my macro `StructInit`, I declare a `StructInit()` macro here. Note that parentheses need to be added when declaring the macro. The second sentence means the implementation of the expansion that our macro actually performs will be defined inside `StructInitMacro` type in the `struct_initial_macroMacros` module.

## Implementation of Macro

After naming and declaring your macro, we now need to declare the method.