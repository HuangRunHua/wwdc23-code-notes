//
//  EventEditView.swift
//  discover-calendar-and-eventkit
//
//  Created by Huang Runhua on 6/9/23.
//

import SwiftUI
import EventKitUI

struct EventEditViewController: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    typealias UIViewControllerType = EKEventEditViewController
    
    let movie: Movie
    
    private let store = EKEventStore()
    private var event: EKEvent {
        let event = EKEvent(eventStore: store)
        event.title = movie.title
        if let startDate = movie.startDate, let endDate = movie.endDate {
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
            event.location = movie.location
            event.notes = "Don't forget to bring popcorn🍿️!"
        }
        return event
    }
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = event
        eventEditViewController.eventStore = store
        eventEditViewController.editViewDelegate = context.coordinator
        return eventEditViewController
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
    
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
