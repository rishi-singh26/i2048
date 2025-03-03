//
//  DateExtenstion.swift
//  i2048
//
//  Created by Rishi Singh on 23/12/24.
//

import Foundation

extension Date {
    /// ## Returns a formatted date string based on relative time and context.
    /// - Today, at 1:17 PM
    /// - Yesterday, at 12:30 PM
    /// - 12 Jan, at 9:00 PM - `For current year`
    /// - 12 Jan 2024, at 9:00 PM
    func formattedString() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let isToday = calendar.isDateInToday(self)
        let isYesterday = calendar.isDateInYesterday(self)
        let isSameYear = calendar.isDate(self, equalTo: now, toGranularity: .year)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        if isToday {
            return "Today, at \(timeFormatter.string(from: self))"
        } else if isYesterday {
            return "Yesterday, at \(timeFormatter.string(from: self))"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = isSameYear ? "d'\(daySuffix())' MMM" : "d'\(daySuffix())' MMM yyyy"
            return "\(dateFormatter.string(from: self)), at \(timeFormatter.string(from: self))"
        }
    }
    
    /// ## Date formatted in below pattern
    /// - 23rd Feb, 2025
    /// - 01st Mar, 2024
    /// - 02nd Oct, 2020
    func formattedDate() -> String {
        let date = Date.now
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy" // Basic format without suffix
        let dateString = formatter.string(from: date)
        
        // Extract day to determine suffix
        let day = Calendar.current.component(.day, from: date)
        let suffix: String
        
        switch day {
        case 11...13: suffix = "th" // Special case for 11th, 12th, 13th
        default:
            switch day % 10 {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: suffix = "th"
            }
        }
        
        // Insert suffix into the formatted date
        return dateString.replacingOccurrences(of: "dd", with: "\(day)\(suffix)")
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
