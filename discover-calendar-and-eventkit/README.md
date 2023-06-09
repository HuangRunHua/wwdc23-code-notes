# EventKitUI in iOS 17

WWDC brings some changes to `EventKit` and `EventKitUI` framework. In iOS 17, one's app can add events to Calendar without prompting the user for access using [`EKEventEditViewController`](https://developer.apple.com/documentation/eventkitui/ekeventeditviewcontroller). If the purpose of your app is to create, configure, and present calendar events in an editor UI, consider saving events to Calendar without prompting the user for authorization in your app. In this article I will create a simple app to show how to add events to Calendar in iOS 17. The following picture shows the app we will create later on, it just has one view which shows the ticket's information, and when user tap the **Add to calendar** button, the event editor will show up to enable users to save the event or change some information before saving the event.

![](https://github.com/HuangRunHua/wwdc23-code-notes/raw/main/discover-calendar-and-eventkit/images/IMG_7703.JPEG)

## Ticket Model

First of all, we need to define our `Ticket` structure which contains the basic information of one ticket.

```swift
struct Ticket: Identifiable {
    var id: UUID = UUID()
    var title: String
    var theater: String
    var location: String
    var start: String
    var end: String
    var image: String
}
```

Then define a `Ticket` object inside your `ContentView.swift`:

```swift
private let ticket: Ticket = Ticket(title: "哆啦A梦：大雄与天空的理想乡",
                                     theater: "Wanda Cinemas",
                                     location: "Orient Cinema Rongchuangmao",
                                     start: "2023-06-10T02:39:32Z",
                                     end: "2023-06-10T04:58:32Z",
                                     image: "movie")
```

Before we move on, we need to check the ticket view I create. The ticket view contains several sections:

- the poster of the movie
- the name of the theater
- the name of the movie
- the opening and closing dates of the movie
- the location of the theater
- the **Add to calendar** button

Some information can be fetched easily through `ticket` we define, but note the the format of opening dates and the format of closing dates of the movie are different from the `ticket.start` and `ticket.end`. We need to add some member variables in the `Ticket` structure to meet our needs. I am going to use `DateFormatter` to change `String` date to target `Date` date:

```swift
struct Ticket: Identifiable {
  	...
  	private var dateFormatter: DateFormatter {
        let dfm = DateFormatter()
        dfm.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dfm
    }
    private var _startDate: Date? {
        if let startDate = dateFormatter.date(from: self.start) {
            return startDate
        }
        return nil
    }
    private var _endDate: Date? {
        if let endDate = dateFormatter.date(from: self.end) {
            return endDate
        }
        return nil
    }
}
```

Now `_startDate` and `_endDate` store the movie's opening date and ending date in the format of `Date`. It is even better to access the single information such as year, month and day etc. To achieve this, I add `startDate` and `endDate` to `Ticket` which are tuples contains all the information of each date:

```swift
struct Ticket: Identifiable {
  	...
  	var startDate: (year: Int, month: Int, day: Int, hour: Int, minute: Int)? {
        if let components = _startDate?.get(.day, .month, .year, .hour, .minute) {
            if let year = components.year,
                let day = components.day,
                let month = components.month,
                let hour = components.hour,
                let minute = components.minute {
                return (year, month, day, hour, minute)
            }
        }
        return nil
    }
    var endDate: (year: Int, month: Int, day: Int, hour: Int, minute: Int)? {
        if let components = _endDate?.get(.day, .month, .year, .hour, .minute) {
            if let year = components.year,
                let day = components.day,
                let month = components.month,
                let hour = components.hour,
                let minute = components.minute {
                return (year, month, day, hour, minute)
            }
        }
        return nil
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
```

Now we can access the single information such as year by using the syntax `ticket.startDate.year`.

## Ticket View

Ticket view is easy to implement, here I just give the full code of ticket view:

```swift
struct ContentView: View {
    private let ticket: Ticket = Ticket(title: "哆啦A梦：大雄与天空的理想乡",
                                     theater: "Wanda Cinemas",
                                     location: "Orient Cinema Rongchuangmao",
                                     start: "2023-06-10T02:39:32Z",
                                     end: "2023-06-10T04:58:32Z",
                                     image: "movie")
    
    var body: some View {
        ZStack(alignment: .bottom, content: {
            Image(ticket.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(ticket.theater)
                        .foregroundStyle(.blue)
                        .bold()
                    Text(ticket.title)
                        .font(.system(size: 20))
                    if let startDate = ticket.startDate, let endDate = ticket.endDate {
                        Text("\(startDate.month)月\(startDate.day)日 \(startDate.hour):\(startDate.minute)-\(endDate.hour):\(endDate.minute)")
                    }
                    HStack {
                        Image(systemName: "mappin")
                            .foregroundStyle(.red)
                        Text(ticket.location)
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 7)
                    .font(.system(size: 16))
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(.blue)
                        Button("Add to calendar") {
                            /// Add to calendar...
                        }
                    }
                    .padding(.top, 7)
                }
                Spacer()
            }
            .padding()
            .frame(width: 350)
            .background(Color.white)
        })
        .frame(width: 350)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}
```

## Save events using EventKitUI

On iOS, the EventKitUI framework is to show calendar and reminder information to the user modally. EventKitUI provides view controllers for viewing and editing calendar and reminder information, choosing which calendar to view, and for determining whether to present calendars as read-only or readable and writeable. Since we don't have SwiftUI-version EventKitUI we have to convert a `UIViewController` to `View`.

### What is new in Calendar

As I said earlier, In iOS 17, your app can add events to Calendar without prompting the user for access using [`EKEventEditViewController`](https://developer.apple.com/documentation/eventkitui/ekeventeditviewcontroller). **It means you don't have to provide the NSCalendarsUsageDescription  key (this key has been deprecated in iOS 17.0) or any other key in `info.plist`**. And app should only request the specific level of access it requires to complete its calendar data tasks. The iOS 17 SDK also introduces new calendar usage description strings, the ability to add events to Calendar without prompting the user for access, and a new write-only access. Since we only add events without any key, I am not going to talk those details here, you can see [Accessing the event store](https://developer.apple.com/documentation/eventkit/accessing_the_event_store) for details. Now let's see how to create `EventEditViewController`.

### EventEditViewController

To make `EKEventEditViewController` work in SwiftUI, we need to turn to `UIViewControllerRepresentable` for help. Our `UIViewControllerType` is defined to be `EKEventEditViewController`.

```swift
import EventKitUI

struct EventEditViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = EKEventEditViewController
  	func makeUIViewController(context: Context) -> EKEventEditViewController {
        
    }
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
}
```

Adding an event with `EventKitUI` is a **four-step** process:

1. Create an event store.
2. Create an event and fill in the details. 
3. Create a view controller configured to edit the event. 
4. Present the view controller.

Create an event store is easy, just one line of code:

```swift
private let store = EKEventStore()
```

Creating an `EKEvent` object instance is a more complicated process, because we need to add detailed information to the object instance. Here I created a private variable named `event`, which converts the information in the variable `ticket` into `EKEvent` type:

```swift
struct EventEditViewController: UIViewControllerRepresentable {		
		let ticket: Ticket
    private var event: EKEvent {
        let event = EKEvent(eventStore: store)
        event.title = ticket.title
        if let startDate = ticket.startDate, let endDate = ticket.endDate {
            let startDateComponents = DateComponents(year: startDate.year,
                                                     month: startDate.month,
                                                     day: startDate.day,
                                                     hour: startDate.hour,
                                                     minute: startDate.minute)
            event.startDate = Calendar.current.date(from: startDateComponents)!
            let endDateComponents = DateComponents(year: endDate.year,
                                                     month: endDate.month,
                                                     day: endDate.day,
                                                     hour: endDate.hour,
                                                     minute: endDate.minute)
            event.endDate = Calendar.current.date(from: endDateComponents)!
            event.location = ticket.location
            event.notes = "Don't forget to bring popcorn🍿️!"
        }
        return event
    }
  ...
}
```

Every event needs a title. The title is used in many places including widgets and notifications, so keep it simple. The most important properties are the start and end date. Use date components to make the start date and end date. Set a location to let people know where the event takes place. Including a full address or using a MapKit handle will enable features like Maps suggestions and Time to Leave alerts. Finally, I add some notes to provide some extra detail.

Now you've set the event properties, the next step is to create the `EKEventEditViewController`. Assign the event and event store properties. The code is written inside method `makeUIViewController(context:)`.

```swift
func makeUIViewController(context: Context) -> EKEventEditViewController {
		let eventEditViewController = EKEventEditViewController()
   	eventEditViewController.event = event
    eventEditViewController.eventStore = store
    return eventEditViewController
}
```

### Add to Calendar

Now back to our ticket view, we have some left work to finish. Add a variable called `showEventEditView` which is used to show the `EventEditViewController`:

```swift
@State private var showEventEditView: Bool = false
```

When user taps the **Add to Calendar** button, `showEventEditView` should become `true` and then shows the `EventEditViewController`:

```swift
Button("Add to calendar") {
		self.showEventEditView.toggle()
}
.sheet(isPresented: $showEventEditView, content: {
		EventEditViewController(ticket: self.ticket)
})
```

Now when we tap the button, the event edit view should present. However, you may find that when tapping cancel or add button, the event edit view won't dismiss. That is because the calendar edits happen out of process, inspecting the properties of the dismissed controller can help us dismiss the view.

### Enable Dismiss

Since `UIViewControllerRepresentable` doesn’t automatically communicate changes occurring within our view controller to other parts of our SwiftUI interface. When we want our view controller to coordinate with other SwiftUI views, we must provide a [`Coordinator`](doc://com.apple.documentation/documentation/swiftui/nsviewcontrollerrepresentable/coordinator) instance to facilitate those interactions.

```swift
struct EventEditViewController: UIViewControllerRepresentable {
  	@Environment(\.presentationMode) var presentationMode
  	...
  	func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventEditViewController
        
        init(_ controller: EventEditViewController) {
            self.parent = controller
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
```

Finally in method `makeUIViewController` add the following code:

```swift
func makeUIViewController(context: Context) -> EKEventEditViewController {
  	...
		eventEditViewController.editViewDelegate = context.coordinator
		return eventEditViewController
}
```

Run your project and change the event date for name to see what happens.

## Source Code

You can find the source code on [GitHub](https://github.com/HuangRunHua/wwdc23-code-notes/tree/main/discover-calendar-and-eventkit).

> If you think this article is helpful, you can support me by downloading my first Mac App which named [FilerApp](https://huangrunhua.github.io/FilerApp/) on the [Mac App Store](https://apps.apple.com/us/app/filerapp/id1626627609?mt=12&itsct=apps_box_link&itscg=30200). FilerApp is a Finder extension for your Mac which enables you to easily create files in supported formats anywhere on the system. It is free and useful for many people. Hope you like it.