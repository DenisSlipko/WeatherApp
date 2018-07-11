//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Denisv on 18.07.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation

extension Date {
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    var readableHistory: String {
        let daysDiff = Calendar.current.dateComponents([.day], from: Date(), to: self).day ?? 0
        switch daysDiff {
        case 0:
            return "Today"
        case 1:
            return "Yesterday"
        default:
            return DateFormatter.readable.string(from: self)
        }
    }
}

extension DateFormatter {
    static var readable: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.copy() as! DateFormatter
    }
}
