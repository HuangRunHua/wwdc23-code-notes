 

# First Glance at SwiftData

SwiftData enables you to add persistence to your app quickly, with minimal code and no external dependencies. Using modern language features like macros, SwiftData enables you to write code that is fast, efficient, and safe, enabling you to describe the entire model layer (or object graph) for your app. The framework handles storing the underlying model data, and optionally, syncing that data across multiple devices.

## Turn classes into models to make them persistable

To let SwiftData save instances of a model class, import the framework and annotate that class with the `Model` macro. The macro updates the class with conformance to the `PersistentModel` protocol, which SwiftData uses to examine the class and generate an internal schema. Additionally, the macro enables change tracking for the class by adding conformance to the `Observable` protocol.

```swift
import SwiftData
// Annotate new or existing model classes with the @Model macro.
@Model
class Note {
    var createDate: Date
    var title: String
    var subtitle: String
    var content: String
    
    init(createDate: Date = .now, 
         title: String, 
         subtitle: String, 
         content: String) {
        self.createDate = createDate
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }
}
```

By default, SwiftData includes all noncomputed properties of a class as long as they use compatible types. The framework supports primitive types such as `Bool`, `Int`, and `String`, as well as complex value types such as structures, enumerations, and other value types that conform to the `Codable` protocol.

## Providing Options for @Attribute and @Relationship

If you want to avoid conflicts in your model data by **specifying that an attribute’s value is unique** across all instances of that model, use `@Attribute(.unique)`:

```swift
@Attribute(.unique) var title: String
```

If you want to delete all the tags (`Tag` is also a model or a collection of models) when deleting the a note, using `@Relationship(.cascade)` to annotate the property:

```swift
@Relationship(.cascade) var tags: [Tag]
```

Annotate properties with the `Transient` macro and SwiftData won’t write their values to disk:

```swift
@Transient var wordsCount: Int
```

