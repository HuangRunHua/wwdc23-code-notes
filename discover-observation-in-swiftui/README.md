# First glance at @Observable macro

WWDC23 brings enormous magical new features in Swift. In Tuesday's video [Discover Observation in SwiftUI](https://developer.apple.com/wwdc23/10149) Philipe taught us how the `@Observable` macro can help simplify models and improve app's performance. In this article, I want to go over some concepts about `Observable`  in that video and then shows some examples of how to combine `@State`, `@Environment` `@Bindable` with the new `@Observable` macro.

## How does Observable Simplify Models?

Before the advent of `@Observable` if we want to declare a data model, we usually enforce our data model to comply `ObservableObject` protocol. Inside the data model we have to declare a number of properties that were marked with the `@Published` property wrapper. For example, here is a music model I declared:

```swift
public class MusicModelOOversion: ObservableObject {
    @Published var musics: [Music] = [
        Music(title: "Spirals", singer: "Nick Leng"),
        Music(title: "Rocky", singer: "Still Woozy"),
        Music(title: "Time Square", singer: "Jam City"),
        Music(title: "The Only One", singer: "Phoenix"),
        Music(title: "Away X5", singer: "Yaeji")
    ]
    
    var musicCount: Int {
        musics.count
    }
}
```

`Music` is a struct which defines in the following way:

```swift
struct Music: Identifiable {
    var id: UUID = UUID()
    var title: String
    var singer: String
}
```

The model data has a list property called `musics` which shows all the musics together with a property called `musicCount` which shows the number of the music declared in `musics`. The counterpart version rewritten by `Observable` shows below:

```swift
import Observation

@Observable public class MusicModel {
    var musics: [Music] = [
        Music(title: "Spirals", singer: "Nick Leng"),
        Music(title: "Rocky", singer: "Still Woozy"),
        Music(title: "Time Square", singer: "Jam City"),
        Music(title: "The Only One", singer: "Phoenix"),
        Music(title: "Away X5", singer: "Yaeji")
    ]
    var musicCount: Int {
        musics.count
    }
}
```

Changing over to the `@Observable` macro was pretty easy. All we needed to do is remove the conformance to `ObservableObject`, remove the `@Published`, and mark it with the `@Observable` macro. When it comes to the views, the OO-version (OO means ObservableObject) needs to declare `@ObservedObject` or `@EnvironmentObject` property wrapper before any variable.

```swift
struct ContentView_OOVersion: View {
    @ObservedObject var model: MusicModelOOversion
    var body: some View {
        List {
            Section {
                ForEach(model.musics) { music in
                    VStack(alignment: .leading) {
                        Text(music.title)
                        Text(music.singer)
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                    }
                }
                Button("Add new music") {
                    model.addMusic()
                }
            } header: {
                Text("Musics")
            } footer: {
                Text("\(model.musicCount) songs")
            }
        }
    }
}
```

However, O-version (O means Observable) gives us a more graceful coding style. For `@ObservedObject` property wrapper we just remove it and everything is the same.

```swift
  struct ContentView: View {  
    var model: MusicModel
    var body: some View {
        List {
            Section {
                ForEach(model.musics) { music in
                    VStack(alignment: .leading) {
                        Text(music.title)
                        Text(music.singer)
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                    }
                }
                Button("Add new music") {
                    model.addMusic()
                }
            } header: {
                Text("Musics")
            } footer: {
                Text("\(model.musicCount) songs")
            }
        }
    }
}
```

If there are a lot of models, by using OO-version, the code would be:

```swift
@ObservedObject var musicModel: MusicModel
@ObservedObject var songModel: SongModel
@ObservedObject var singerModel: SingerModel
/// And so on...
```

Compare with the OO-version, the O-version looks not so complicated and it looks just like declaring ordinary variables:

```swift
var musicModel: MusicModel
var songModel: SongModel
var singerModel: SingerModel
@Environment(AccountStore.self) private var accountStore
/// And so on...
```

When it coms to `@EnvironmentObject` you can simply it to `@Environment`:

```swift
/// OO-version
@EnvironmentObject private var accountStore: AccountStore
/// O-version
@Environment(AccountStore.self) private var accountStore
```

## What is @Bindable

The newest of the family of property wrappers is `@Bindable`. The former version `@Binding` is highly recommended by Apple to be replaced by `@Bindable` in the newer version of SwiftUI. The bindable property wrapper is really lightweight. All it does is allow bindings to be created from that type. Getting binding out of a bindable wrapped property is really easy. Just use the $ syntax to get the binding to that property. Most often, this will be bindings to observable types. 

If we attach `@Observable` to a class then we can attach `@Bindable` to any object it create.

```swift
@Observable class Article {
    var title: String = ""
    var subtitle: String = ""
}

struct ArticleEditView: View {
    @Bindable var article: Article
    var body: some View {
        VStack {
            TextField("Title", text: $article.title)
            TextField("Subtitle", text: $article.subtitle)
        }.padding()
    }
}
```

The above code create an `Article` class with `@Observable` attached to it. `Article` contains two properties: `title` and `subtitle`. The code also create an `ArticleEditView` which enables users to change the title and subtitle of an article. Here I use `TextField ` to give users choice to change the basic information of an article. That TextField takes a binding. It reads from the binding to populate the value of the TextField, but it also writes back to the binding when the user changes the value. To make bindings to the article, all we need to do is use the `@Bindable` property wrapper on the article property. The property wrapper annotation allows us to use the `$article.title`  or `$article.subtitle` syntax and creates a binding when used. 

## When to Use @State, @Bindable and @Environment

SwiftUI now only focus on the three primary property wrappers: `@State`, `@Environment` and `@Bindable`. There are only three questions you need to answer for using observable models in SwiftUI. Does this model need to be state of the view itself? If so, use `@State`. Does this model need to be part of the global environment of the application? If so, use `@Environment`. Does this model just need bindings? If so, use the new `@Bindable`. And if none of these questions have the answer as yes, just use the model as a property of your view.

