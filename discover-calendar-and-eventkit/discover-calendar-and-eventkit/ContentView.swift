//
//  ContentView.swift
//  discover-calendar-and-eventkit
//
//  Created by Huang Runhua on 6/9/23.
//

import SwiftUI
///
///   In iOS 17, an app with write-only access can create and save events to Calendar, display
///   events using EKEventEditViewController, and allow the user to select another calendar using
///   EKCalendarChooser. If your app needs to write data directly, consider implementing
///   write-only access in your app following these steps:
///    1. Add the `NSCalendarsWriteOnlyAccessUsageDescription` key to
///      the `Info.plist` file of the target building your app.
///    2. To request write-only access to events, use `requestWriteOnlyAccessToEvents(completion:)`
///      or `requestWriteOnlyAccessToEvents()`.
struct ContentView: View {
    
    /// Orient Cinema Rongchuangmao F B1 Guangying Shiji North Side, Huangdao, Qingdao, Shandong China
    private let ticket: Ticket = Ticket(title: "哆啦A梦：大雄与天空的理想乡",
                                     theater: "Wanda Cinemas",
                                     location: "Orient Cinema Rongchuangmao",
                                     start: "2023-06-10T02:39:32Z",
                                     end: "2023-06-10T04:58:32Z",
                                     image: "movie")
    
    @State private var showEventEditView: Bool = false
    
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
                            self.showEventEditView.toggle()
                        }
                        .sheet(isPresented: $showEventEditView, content: {
                            EventEditViewController(ticket: self.ticket)
                        })
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

#Preview {
    ContentView()
}
