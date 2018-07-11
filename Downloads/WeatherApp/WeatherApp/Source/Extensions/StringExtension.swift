//
//  StringExtension.swift
//  WeatherApp
//
//  Created by Denis on 14.07.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation

extension String {
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.date(from: self)
    }
    
    func countryNameFromCountryCode() -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: self) {
            return name
        } else {
            return self
        }
    }
}
