# Use Swift macros to initialize a structure

In Swift 5.9, Apple is introducing **Swift macros**, which facilitate the generation of repetitive code during compilation. This enhancement enhances the expressiveness and readability of your app's codebases. In the WWDC video unveiled by Apple on Tuesday, titled [Write Swift Macros](https://developer.apple.com/wwdc23/10166), Alex guides us meticulously through the process of creating a straightforward Swift macro. Prior to delving into this article, I highly recommend watching the aforementioned video for a comprehensive understanding.

Within this article, I will present an alternative example to further acquaint you with Swift macros and illustrate how you can leverage Xcode to optimize the development of your own Swift macros.

## Example

It is evident that in Swift, when declaring a structure, one can choose to either explicitly initialize it or leave it uninitialized. Consequently, in this discourse, we shall conceive a Swift macro christened as `StructInit`. With the utilization of the `@StructInit` keyword, the compiler seamlessly engenders the process of structure initialization on your behalf.

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

By using the `@StructInit` macro the sample code above is equivalent to the following code:

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

Since you may use the macro for every situation It is prudent to choose a nice name for your macro. Here I named my macro `StructInit`. This name is very intuitive, and it can be seen at a glance that this macro is used to initialize a structure.

After naming your macro, you may need to declare your macro right in the package. Open file `struct_initial_macro.swift` (It is my file's name, the file you need to open is `your_package_name.swift`) and update the code there:

```swift
@attached(member, names: named(init))
public macro StructInit() = #externalMacro(module: "struct_initial_macroMacros", type: "StructInitMacro")
```

Noted that the initializer is the member of any structure if you want to initialize it explicitly, so we need to declare an attached member macro by using the `@attached(member)` attribute. Because I plan to name my macro `StructInit`, I declare a `StructInit()` macro here. Note that parentheses need to be added when declaring the macro. The second sentence means the implementation of the expansion that our macro actually performs will be defined inside `StructInitMacro` type in the `struct_initial_macroMacros` module.

## Implementation of Macro

After naming and declaring your macro, we now need to declare the method. Open `struct_initial_macroMacros.swift` file, add a public structure called `StructInitMacro` which is ostensibly the same type name which defined in `StructInit()` before. Since we declared an attached member macro so here we need to make structure `StructInitMacro` conform to the `MemberMacro` protocol:

```swift
public struct StructInitMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
    /// Code will be added here later.
}
```

Noted that in `struct_initial_macroPlugin` you need to add your macro to the `providingMacros` so that you can make `StructInitMacro` visible to the compiler:

```swift
@main
struct struct_initial_macroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StructInitMacro.self,
    ]
}
```

Back to `expension(:)` function defined before. The `expansion` function takes the node attribute with which we apply the macro to a declaration, as well as the declaration that the macro is being applied to. In our case, this will be the any `Structure` declaration. The macro then returns the list of all the new members it wants to add to that declaration.

We want this macro to be used only on the keyword `struct`, so we start by casting `declaration` to an `struct` declaration, inside your `expansion(:)`method, add the following code to check the `struct` declaration:

```swift
guard let structDecl = declaration.as(StructDeclSyntax.self) else {
		throw StructInitError.onlyApplicableToStruct
}
```

The `StructInitError` is used to emit an error when the `@StructInit` is not attached to a type that is not a struct and the definition of `StructInitError` shows below:

```swift
enum StructInitError: CustomStringConvertible, Error {
    case onlyApplicableToStruct
    
    var description: String {
        switch self {
        case .onlyApplicableToStruct: return "@StructInit can only be applied to a structure"
        }
    }
}
```

Next, we need to get all the elements that any structure declares. To figure out how to do that, we can inspect the syntactic structure of that structure in the SwiftSyntax tree. Similar to the WWDC video, we force the `expansion` method return empty list first and then set a breakpoint in that line code:

```swift
public struct StructInitMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
    /// Code will be added here later.
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
				throw StructInitError.onlyApplicableToStruct
		}
    return [] /// <--- Set a breakpoint here.
}
```

### Set Test Data

Before we debug we need to set the test data in `struct_initial_macroTests.swift` file. For better coding and debugging, we can first set the test data to the full lines of code that we want the macro to expand:

```swift
final class struct_initial_macroTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            @StructInit
            struct Book {
                var id: Int
                var title: String
                var subtitle: String
                var description: String
                var author: String
              	init(id: Int, title: String, subtitle: String, description: String, author: String) {
                    self.id = id
                    self.title = title
                    self.subtitle = subtitle
                    self.description = description
                    self.author = author
                }
            }
            """,
            expandedSource:
            """
            
            struct Book {
                var id: Int
                var title: String
                var subtitle: String
                var description: String
                var author: String
                init(id: Int, title: String, subtitle: String, description: String, author: String) {
                    self.id = id
                    self.title = title
                    self.subtitle = subtitle
                    self.description = description
                    self.author = author
                }
            }
            """,
            macros: testMacros
        )
    }
}
```

### Debugging

Now run the test cases to hit our breakpoint. After running we now have the debugger paused inside the macro’s implementation and `structDecl` is the Book structure. We can print it in the debugger by typing `po structDecl` inside the Xcode console:

```bash
po structDecl
```

The output contains a lot of nodes of the syntax tree represent the struct elements which shows below.

```bash
StructDeclSyntax
├─attributes: AttributeListSyntax
│ ╰─[0]: AttributeSyntax
│   ├─atSignToken: atSign
│   ╰─attributeName: SimpleTypeIdentifierSyntax
│     ╰─name: identifier("StructInit")
├─structKeyword: keyword(SwiftSyntax.Keyword.struct)
├─identifier: identifier("Book")
╰─memberBlock: MemberDeclBlockSyntax
  ├─leftBrace: leftBrace
  ├─members: MemberDeclListSyntax
  │ ├─[0]: MemberDeclListItemSyntax
  │ │ ╰─decl: VariableDeclSyntax
  │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.var)
  │ │   ╰─bindings: PatternBindingListSyntax
  │ │     ╰─[0]: PatternBindingSyntax
  │ │       ├─pattern: IdentifierPatternSyntax
  │ │       │ ╰─identifier: identifier("id")
  │ │       ╰─typeAnnotation: TypeAnnotationSyntax
  │ │         ├─colon: colon
  │ │         ╰─type: SimpleTypeIdentifierSyntax
  │ │           ╰─name: identifier("Int")
  │ ├─[1]: MemberDeclListItemSyntax
  │ │ ╰─decl: VariableDeclSyntax
  │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.var)
  │ │   ╰─bindings: PatternBindingListSyntax
  │ │     ╰─[0]: PatternBindingSyntax
  │ │       ├─pattern: IdentifierPatternSyntax
  │ │       │ ╰─identifier: identifier("title")
  │ │       ╰─typeAnnotation: TypeAnnotationSyntax
  │ │         ├─colon: colon
  │ │         ╰─type: SimpleTypeIdentifierSyntax
  │ │           ╰─name: identifier("String")
  │ ├─[2]: MemberDeclListItemSyntax
  │ │ ╰─decl: VariableDeclSyntax
  │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.var)
  │ │   ╰─bindings: PatternBindingListSyntax
  │ │     ╰─[0]: PatternBindingSyntax
  │ │       ├─pattern: IdentifierPatternSyntax
  │ │       │ ╰─identifier: identifier("subtitle")
  │ │       ╰─typeAnnotation: TypeAnnotationSyntax
  │ │         ├─colon: colon
  │ │         ╰─type: SimpleTypeIdentifierSyntax
  │ │           ╰─name: identifier("String")
  │ ├─[3]: MemberDeclListItemSyntax
  │ │ ╰─decl: VariableDeclSyntax
  │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.var)
  │ │   ╰─bindings: PatternBindingListSyntax
  │ │     ╰─[0]: PatternBindingSyntax
  │ │       ├─pattern: IdentifierPatternSyntax
  │ │       │ ╰─identifier: identifier("description")
  │ │       ╰─typeAnnotation: TypeAnnotationSyntax
  │ │         ├─colon: colon
  │ │         ╰─type: SimpleTypeIdentifierSyntax
  │ │           ╰─name: identifier("String")
  │ ├─[4]: MemberDeclListItemSyntax
  │ │ ╰─decl: VariableDeclSyntax
  │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.var)
  │ │   ╰─bindings: PatternBindingListSyntax
  │ │     ╰─[0]: PatternBindingSyntax
  │ │       ├─pattern: IdentifierPatternSyntax
  │ │       │ ╰─identifier: identifier("author")
  │ │       ╰─typeAnnotation: TypeAnnotationSyntax
  │ │         ├─colon: colon
  │ │         ╰─type: SimpleTypeIdentifierSyntax
  │ │           ╰─name: identifier("String")
  │ ╰─[5]: MemberDeclListItemSyntax
  │   ╰─decl: InitializerDeclSyntax
  │     ├─initKeyword: keyword(SwiftSyntax.Keyword.init)
  │     ├─signature: FunctionSignatureSyntax
  │     │ ╰─input: ParameterClauseSyntax
  │     │   ├─leftParen: leftParen
  │     │   ├─parameterList: FunctionParameterListSyntax
  │     │   │ ├─[0]: FunctionParameterSyntax
  │     │   │ │ ├─firstName: identifier("id")
  │     │   │ │ ├─colon: colon
  │     │   │ │ ├─type: SimpleTypeIdentifierSyntax
  │     │   │ │ │ ╰─name: identifier("Int")
  │     │   │ │ ╰─trailingComma: comma
  │     │   │ ├─[1]: FunctionParameterSyntax
  │     │   │ │ ├─firstName: identifier("title")
  │     │   │ │ ├─colon: colon
  │     │   │ │ ├─type: SimpleTypeIdentifierSyntax
  │     │   │ │ │ ╰─name: identifier("String")
  │     │   │ │ ╰─trailingComma: comma
  │     │   │ ├─[2]: FunctionParameterSyntax
  │     │   │ │ ├─firstName: identifier("subtitle")
  │     │   │ │ ├─colon: colon
  │     │   │ │ ├─type: SimpleTypeIdentifierSyntax
  │     │   │ │ │ ╰─name: identifier("String")
  │     │   │ │ ╰─trailingComma: comma
  │     │   │ ├─[3]: FunctionParameterSyntax
  │     │   │ │ ├─firstName: identifier("description")
  │     │   │ │ ├─colon: colon
  │     │   │ │ ├─type: SimpleTypeIdentifierSyntax
  │     │   │ │ │ ╰─name: identifier("String")
  │     │   │ │ ╰─trailingComma: comma
  │     │   │ ╰─[4]: FunctionParameterSyntax
  │     │   │   ├─firstName: identifier("author")
  │     │   │   ├─colon: colon
  │     │   │   ╰─type: SimpleTypeIdentifierSyntax
  │     │   │     ╰─name: identifier("String")
  │     │   ╰─rightParen: rightParen
  │     ╰─body: CodeBlockSyntax
  │       ├─leftBrace: leftBrace
  │       ├─statements: CodeBlockItemListSyntax
  │       │ ├─[0]: CodeBlockItemSyntax
  │       │ │ ╰─item: SequenceExprSyntax
  │       │ │   ╰─elements: ExprListSyntax
  │       │ │     ├─[0]: MemberAccessExprSyntax
  │       │ │     │ ├─base: IdentifierExprSyntax
  │       │ │     │ │ ╰─identifier: keyword(SwiftSyntax.Keyword.self)
  │       │ │     │ ├─dot: period
  │       │ │     │ ╰─name: identifier("id")
  │       │ │     ├─[1]: AssignmentExprSyntax
  │       │ │     │ ╰─assignToken: equal
  │       │ │     ╰─[2]: IdentifierExprSyntax
  │       │ │       ╰─identifier: identifier("id")
  │       │ ├─[1]: CodeBlockItemSyntax
  │       │ │ ╰─item: SequenceExprSyntax
  │       │ │   ╰─elements: ExprListSyntax
  │       │ │     ├─[0]: MemberAccessExprSyntax
  │       │ │     │ ├─base: IdentifierExprSyntax
  │       │ │     │ │ ╰─identifier: keyword(SwiftSyntax.Keyword.self)
  │       │ │     │ ├─dot: period
  │       │ │     │ ╰─name: identifier("title")
  │       │ │     ├─[1]: AssignmentExprSyntax
  │       │ │     │ ╰─assignToken: equal
  │       │ │     ╰─[2]: IdentifierExprSyntax
  │       │ │       ╰─identifier: identifier("title")
  │       │ ├─[2]: CodeBlockItemSyntax
  │       │ │ ╰─item: SequenceExprSyntax
  │       │ │   ╰─elements: ExprListSyntax
  │       │ │     ├─[0]: MemberAccessExprSyntax
  │       │ │     │ ├─base: IdentifierExprSyntax
  │       │ │     │ │ ╰─identifier: keyword(SwiftSyntax.Keyword.self)
  │       │ │     │ ├─dot: period
  │       │ │     │ ╰─name: identifier("subtitle")
  │       │ │     ├─[1]: AssignmentExprSyntax
  │       │ │     │ ╰─assignToken: equal
  │       │ │     ╰─[2]: IdentifierExprSyntax
  │       │ │       ╰─identifier: identifier("subtitle")
  │       │ ├─[3]: CodeBlockItemSyntax
  │       │ │ ╰─item: SequenceExprSyntax
  │       │ │   ╰─elements: ExprListSyntax
  │       │ │     ├─[0]: MemberAccessExprSyntax
  │       │ │     │ ├─base: IdentifierExprSyntax
  │       │ │     │ │ ╰─identifier: keyword(SwiftSyntax.Keyword.self)
  │       │ │     │ ├─dot: period
  │       │ │     │ ╰─name: identifier("description")
  │       │ │     ├─[1]: AssignmentExprSyntax
  │       │ │     │ ╰─assignToken: equal
  │       │ │     ╰─[2]: IdentifierExprSyntax
  │       │ │       ╰─identifier: identifier("description")
  │       │ ╰─[4]: CodeBlockItemSyntax
  │       │   ╰─item: SequenceExprSyntax
  │       │     ╰─elements: ExprListSyntax
  │       │       ├─[0]: MemberAccessExprSyntax
  │       │       │ ├─base: IdentifierExprSyntax
  │       │       │ │ ╰─identifier: keyword(SwiftSyntax.Keyword.self)
  │       │       │ ├─dot: period
  │       │       │ ╰─name: identifier("author")
  │       │       ├─[1]: AssignmentExprSyntax
  │       │       │ ╰─assignToken: equal
  │       │       ╰─[2]: IdentifierExprSyntax
  │       │         ╰─identifier: identifier("author")
  │       ╰─rightBrace: rightBrace
  ╰─rightBrace: rightBrace
```

### Retrieve the Variables

To retrieve the variables of the Book struct, we need to follow the structure that is outlined to us in the syntax tree above. The member variable names and types of the Book structure belong to the node `members`, and `members` are child nodes of `memberBlock`. The internal content of `members` is similar to a list, which is used to store all the variables defined in the Book structure. So to access the members, we start with `structDecl.memberBlock.members`. 

```swift
memberBlock: MemberDeclBlockSyntax
  ├─leftBrace: leftBrace
  ├─members: MemberDeclListSyntax
  │ ├─[0]: MemberDeclListItemSyntax
  │ │ ╰─decl: VariableDeclSyntax
  │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.var)
  │ │   ╰─bindings: PatternBindingListSyntax
  │ │     ╰─[0]: PatternBindingSyntax
  │ │       ├─pattern: IdentifierPatternSyntax
  │ │       │ ╰─identifier: identifier("id")	// <---- id defined here
  │ │       ╰─typeAnnotation: TypeAnnotationSyntax
  │ │         ├─colon: colon
  │ │         ╰─type: SimpleTypeIdentifierSyntax
  │ │           ╰─name: identifier("Int")			// <---- type of id defined here
  │ ├─[1]: MemberDeclListItemSyntax
  │ │ ╰─decl: VariableDeclSyntax
  │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.var)
  │ │   ╰─bindings: PatternBindingListSyntax
  │ │     ╰─[0]: PatternBindingSyntax
  │ │       ├─pattern: IdentifierPatternSyntax
  │ │       │ ╰─identifier: identifier("title") // <---- title defined here
  │ │       ╰─typeAnnotation: TypeAnnotationSyntax
  │ │         ├─colon: colon
  │ │         ╰─type: SimpleTypeIdentifierSyntax
  │ │           ╰─name: identifier("String")   // <---- type of title defined here
	...
```

We are interested in the declarations, in particular those declarations that actually declare variables. Here I will use `.compactMap()` to get a list of all the member declarations that are variables we define. Noted that the variables are declared as `VariableDeclSyntax` according to the syntax tree, so we will use `members.compactMap { $0.decl.as(VariableDeclSyntax.self) }` to retrieve all of the members that has a `VariableDeclSyntax` node inside them.

```swift
let members = structDecl.memberBlock.members
let variableDecl = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
```

Next, we need to dig out the name and type of all the variables that we define. Let's just thrash out one `member`:

```swift
├─members: MemberDeclListSyntax
  │ ├─[0]: MemberDeclListItemSyntax
  │ │ ╰─decl: VariableDeclSyntax
  │ │   ├─bindingKeyword: keyword(SwiftSyntax.Keyword.var)
  │ │   ╰─bindings: PatternBindingListSyntax
  │ │     ╰─[0]: PatternBindingSyntax
  │ │       ├─pattern: IdentifierPatternSyntax
  │ │       │ ╰─identifier: identifier("id") // <---- id defined here
  │ │       ╰─typeAnnotation: TypeAnnotationSyntax
  │ │         ├─colon: colon
  │ │         ╰─type: SimpleTypeIdentifierSyntax
  │ │           ╰─name: identifier("Int") // <---- type of id defined here
	...
```

For variable `id`, both the pattern and type are what we care about. So we can use `variableDecl.compactMap { $0.bindings.first?.pattern }` to fetch all the pattern or the variable's name and use `variableDecl.compactMap { $0.bindings.first?.typeAnnotation?.type }` to get all the type of each variable. Now the code inside the `expansion()` method shows below:

```swift
public static func expansion(
		of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
) throws -> [SwiftSyntax.DeclSyntax] {
        
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
        throw StructInitError.onlyApplicableToStruct
    }
        
    let members = structDecl.memberBlock.members
    let variableDecl = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
    let variablesName = variableDecl.compactMap { $0.bindings.first?.pattern }
    let variablesType = variableDecl.compactMap { $0.bindings.first?.typeAnnotation?.type }
    
    return []
}
```

### Make Initializer Work

Now `variablesName` contains all the variables' name while `variablesType` embodies all the variables' type. The last thing to do is to generate the Book struct Initializer code.  We start by constructing an `InitializerDeclSyntax`. Since the `init` needs both parameters input and expression inside the `init` code block, we choose the method `InitializerDeclSyntax(_ header:bodyBuilder:)` to help us write our code.

Inside the `_ headr` we need to declare the 'init' keyword and all the parameters which in this Book struct case, is the following format:

```swift
init(id: Int, title: String, subtitle: String, description: String, author: String)
```

In oder to generate the code above, I create a new method called `generateInitialCode` which shows below:

```swift
public static func generateInitialCode(variablesName: [PatternSyntax],
                                       variablesType: [TypeSyntax]) -> PartialSyntaxNodeString {
		var initialCode: String = "init("
		for (name, type) in zip(variablesName, variablesType) {
				initialCode += "\(name): \(type), "
		}
		initialCode = String(initialCode.dropLast(2))
		initialCode += ")"
		return PartialSyntaxNodeString(stringLiteral: initialCode)
}
```

`generateInitialCode` method returns a `PartialSyntaxNodeString`variable which can be the input parameter for `_ header` inside `InitializerDeclSyntax`:

```swift
let initializer = try InitializerDeclSyntax(StructInitMacro.generateInitialCode(variablesName: variablesName, variablesType: variablesType)) {
		 
}
```

Inside the `InitializerDeclSyntax`'s body, we just need a single expression to assign values to the member variables of the Book structure, here we use `for-loop` as well as `ExprSyntax()` to achieve that:

```swift
let initializer = try InitializerDeclSyntax(StructInitMacro.generateInitialCode(variablesName: variablesName, variablesType: variablesType)) {
		for name in variablesName {
				ExprSyntax("self.\(name) = \(name)")
    }
}
```

Finally, make sure that the `expansion()` method returns the `initializer`, so change the `return []` to the following code:

```swift
return [DeclSyntax(initializer)]
```

All done. Try some test examples to see what will happen when you attach `@StructInit` to a structure.

## Source Code

You can find the source code on [Github](https://github.com/HuangRunHua/wwdc23-code-notes/tree/main/struct-initial-macro).

## Supports Me

If you think this article is helpful, you can support me by downloading my first Mac App which named [FilerApp](https://huangrunhua.github.io/FilerApp/) on the [Mac App Store](https://apps.apple.com/us/app/filerapp/id1626627609?mt=12&itsct=apps_box_link&itscg=30200). FilerApp is a Finder extension for your Mac which enables you to easily create files in supported formats anywhere on the system. It is free and useful for many people. Hope you like it.



