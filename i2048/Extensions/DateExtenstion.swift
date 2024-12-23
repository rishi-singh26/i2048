//
//  DateExtenstion.swift
//  i2048
//
//  Created by Rishi Singh on 23/12/24.
//

import Foundation

extension Date {
    /// Returns a formatted date string based on relative time and context.
    func formattedString() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let isToday = calendar.isDateInToday(self)
        let isYesterday = calendar.isDateInYesterday(self)
        let isSameYear = calendar.isDate(self, equalTo: now, toGranularity: .year)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        if isToday {
            return "Today at \(timeFormatter.string(from: self))"
        } else if isYesterday {
            return "Yesterday, at \(timeFormatter.string(from: self))"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = isSameYear ? "d'\(daySuffix())' MMM" : "d'\(daySuffix())' MMM yyyy"
            return "\(dateFormatter.string(from: self)), at \(timeFormatter.string(from: self))"
        }
    }
    
    /// Returns the day suffix for the date (e.g., 1st, 2nd, 3rd, 4th).
    private func daySuffix() -> String {
        let day = Calendar.current.component(.day, from: self)
        switch day {
        case 11, 12, 13: return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
}
