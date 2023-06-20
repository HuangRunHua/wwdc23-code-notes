# First Glance at SwiftData

SwiftData enables you to add persistence to your app quickly, with minimal code and no external dependencies. Using modern language features like macros, SwiftData enables you to write code that is fast, efficient, and safe, enabling you to describe the entire model layer (or object graph) for your app. The framework handles storing the underlying model data, and optionally, syncing that data across multiple devices.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/swiftdata-example/cover.jpg)

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

### Specifying original property names

If you change the name of some variables in your model, that would be seen as a new property in generated schema and SwiftData will create new properties for them. If you want to preserve the existing data you can map the original name to the property name using `@Attribute` and specifying the `originalName:` parameter.

```swift
@Attribute(originalName: "subtitle") var description: String
```

## Migration of Models

As your app’s model layer evolves, SwiftData performs automatic migrations of the underlying model data so it remains in a consistent state. If the aggregate changes between two versions of the model layer exceed the capabilities of automatic migrations, use `Schema` and `SchemaMigrationPlan` to participate in those migrations and help them complete successfully.

### Evolving schemas

- Encapsulate your models at a specific version with `VersionedSchema`
- Order your versions with `SchemaMigrationPlan`
- Define each migration stage

### Migration stages

1. **Lightweight migration stage**: Lightweight migrations do not require any additional code to migrate the existing data for app release. Modifications like adding new variable to `Note` properties or specifying the delete rules on my relationships are lightweight migration eligible. 
2. **Custom migration stage**: Operations like making the title of a `Note` unique is not eligible for a lightweight migration and require custom migration stage.

#### Encapsulate original schema in a `VersionedSchema`

```swift
enum NoteSchemaV1: VersionedSchema {
    static var versionIdentifier: String? = "noteschemav1"
    static var models: [any PersistentModel.Type] {
        [Note.self]
    }
    @Model
    class Note {
        var createDate: Date
        var title: String
        var subtitle: String
        var content: String
        
        init(createDate: Date = .now, title: String, subtitle: String, content: String) {
            self.createDate = createDate
            self.title = title
            self.subtitle = subtitle
            self.content = content
        }
    }
}
```

#### Add NoteSchemaV2

```swift
enum NoteSchemaV2: VersionedSchema {
    static var versionIdentifier: String? = "noteschemav2"
    static var models: [any PersistentModel.Type] {
        [Note.self]
    }
    @Model
    class Note {
        var createDate: Date
        @Attribute(.unique) var title: String
        var subtitle: String
        var content: String
        
        init(createDate: Date = .now, title: String, subtitle: String, content: String) {
            self.createDate = createDate
            self.title = title
            self.subtitle = subtitle
            self.content = content
        }
    }
}
```

#### Handle migrations

```swift
enum NoteMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        // Provide the ordering of schemas.
        [NoteSchemaV1.self, NoteSchemaV2.self]
    }
    
    static var stages: [MigrationStage] {
        [migrationV1toV2]
    }
    
    static let migrationV1toV2 = MigrationStage.custom(
        fromVersion: NoteSchemaV1.self,
        toVersion: NoteSchemaV2.self,
        willMigrate: { context in
            let notes = try? context.fetch(FetchDescriptor<NoteSchemaV1.Note>())
            try? context.save()
        }, didMigrate: nil
    )
}
```

#### Configure the migration plan

From the WWDC video, you can configure the migration plan through the code below, but it crashed in current version of Xcode 15.0 beta (15A5160n)

```swift
@main
struct swiftdata_exampleApp: App {
    let container = try! ModelContainer(
        for: Schema([Note.self]),
        migrationPlan: NoteMigrationPlan.self
    )
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Note.self)
    }
}
```

## Configure the model storage

Before SwiftData can examine your models and generate the required schema, you need to tell it — at runtime — which models to persist, and optionally, the configuration to use for the underlying storage.

To set up the default storage, use the `modelContainer(for:inMemory:isAutosaveEnabled:isUndoEnabled:onSetup:)` view modifier (or the scene equivalent) and specify the array of model types to persist. If you use the view modifier, add it at the very top of the view hierarchy so all nested views inherit the properly configured environment:

```swift
import SwiftData
@main
struct swiftdata_exampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Note.self)
    }
}
```

If there are more than one models, use list instead:

```swift
import SwiftData
@main
struct swiftdata_exampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(
          for: [Note.self, Tag.self]
        )
    }
}
```

**To use SwiftData, any application has to set up at least one ModelContainer.** It creates the whole storage stack, including the context that `@Query` will use. A View has a single model container, but an application can create and use as many containers as it needs for different view hierarchies. If the application does not set up its modelContainer, its windows and the views it creates can not save or query models via SwiftData. 

If your app only has a single model container, the window and its views will inherit the container, as well as any other windows created from the same group. All of these views will write and read from a single container. 

Some apps need a few storage stacks, and they can set up several model containers for different windows.

```swift
import SwiftData
@main
struct swiftdata_exampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Note.self, Tag.self])
      
      	WindowGroup("Note Deisgner") {
            NoteDeisgnerView()
        }
        .modelContainer(for: Designer.self)
    }
}
```

SwiftUI also allows for a granular setup on a view level. Different views in the same window can have separate containers, and saving in one container won’t affect another.

```swift
struct AnotherView: View {
    var body: some View {
        ScrollView {
          	Form {...}
          	LibraryView()
           			.modelContainer(for: Library.self)
        }
    }
}
```

## Save models for later use

To manage instances of your model classes at runtime, use a *model context* — the object responsible for the in-memory model data and coordination with the model container to successfully persist that data. To get a context for your model container that’s bound to the main actor, use the `modelContext` environment variable:

```swift
import SwiftData
struct NoteEditView: View {
    @Environment(\.modelContext) private var modelContext
  	...
}
```

### Add New Data

To enable SwiftData to persist a model instance and begin tracking changes to it, insert the instance into the context:

```swift
var note: Note = Note(title: title,
                      subtitle: subtitle,
                      content: content)
context.insert(note)
```

> Note that the default behavior of context will be auto-save. If you don't want context to auto-save your data, use `.modelContainer(isAutosaveEnabled:false)` .

Following the insert, you can save immediately by invoking the context’s `save()`method, or rely on the context’s implicit save behavior instead. Contexts automatically track changes to their known model instances and include those changes in subsequent saves. In addition to saving, you can use a context to fetch, enumerate, and delete model instances. 

### Delete Data

```swift
context.delete(note)
```

### Manually Save Changes

```swift
try context.save()
```

### Update Data Automatically

Pass your data with the  `@Bindable` macro, when something change the data in the database will change as well:

```swift
struct NoteEditView: View {
    @Bindable var note: Note
}
```

## Fetch models for display or additional processing

After you begin persisting model data, you’ll likely want to retrieve that data, materialized as model instances, and display those instances in a view or take some other action on them. SwiftData provides the `Query` property wrapper and the `FetchDescriptor` type for performing fetches.

To fetch model instances, and optionally apply search criteria and a preferred sort order, use `@Query` in your SwiftUI view. The `@Model` macro adds `Observable` conformance to your model classes, enabling SwiftUI to refresh the containing view whenever changes occur to any of the fetched instances.

### Using @Query to load and filter data

```swift
import SwiftData
struct ContentView: View {
    @Query(sort: \.createDate, order: .reverse) private var notes: [Note]
  	...
}
```

### Fetch the specific data

Use `Predicate` for searching or filtering your database.

```swift
let notePredictate = #Predicate<Note> { note in
		note.title.count > 5
}

@Query(filter: notePredictate, sort: \.createDate, order: .reverse) private var notes: [Note]
```

## Preview in SwiftUI

If you want to preview some sample data in Xcode using SwiftUI, you may need to create a preview container.

### Create preview container

```swift
import SwiftData
@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Note.self, ModelConfiguration(inMemory: true)
        )
        for note in SampleNotes.contents {
            container.mainContext.insert(object: note)
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

struct SampleNotes {
    static var contents: [Note] = [...]
}
```

You can also declare the container in the following way:

```swift
actor PreviewSampleData {
    @MainActor
    static var previewContainer: ModelContainer = {
        do {
            let container = try ModelContainer(
                for: Note.self, ModelConfiguration(inMemory: true)
            )
            for note in SampleNotes.contents {
                container.mainContext.insert(object: note)
            }
            return container
        } catch {
            fatalError("Failed to create container")
        }
    }()
}
```

If there are more than one models in your app, you can migrate two containers in one:

```swift
actor PreviewSampleData {
    @MainActor
    static var container: ModelContainer = {
        let schema = Schema([Note.self, Tag.self])
        let configuration = ModelConfiguration(inMemory: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let sampleData: [any PersistentModel] = [
            Note.preview, Tag.preview
        ]
        sampleData.forEach {
            container.mainContext.insert($0)
        }
        return container
    }()
}

/// Declare the preview data inside the models
extension Note {
  	static var preview: Note {
        Note(...)
    }
}

extension Tag {
  	static var preview: Tag {
        Tag(...)
    }
}
```

### Enable preview in SwiftUI

#### Display all the notes 

```swift
#Preview {
  	/// Xcode15.0 beta (15A5160n)
    MainActor.assumeIsolated {
        ContentView()
            .modelContainer(previewContainer)
    }
  	/// Later may change to
  	ContentView()
        .modelContainer(previewContainer)
}
```

#### Display single note

```swift
struct NotePreviewCell: View {
    var note: Note
  	...
}

#Preview {
  	/// This is the method provided by Apple's example code
  	/// but still not working in Xcode15.0 beta (15A5160n)
    MainActor.assumeIsolated {
        NotePreviewCell(note: .preview)
            .modelContainer(PreviewSampleData.previewContainer)
    }
}
```

