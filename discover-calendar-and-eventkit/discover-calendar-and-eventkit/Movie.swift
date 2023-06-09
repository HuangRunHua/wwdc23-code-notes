//
//  Movie.swift
//  discover-calendar-and-eventkit
//
//  Created by Huang Runhua on 6/9/23.
//

import Foundation

struct Movie: Identifiable {
    var id: UUID = UUID()
    var title: String
    var theater: String
    var location: String
    var start: String
    var end: String
    
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


extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
