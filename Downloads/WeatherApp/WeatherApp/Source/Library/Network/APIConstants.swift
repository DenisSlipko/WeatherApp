//
//  APIConstants.swift
//  WeatherAppLecture
//
//  Created by Denis on 7/3/17.
//  Copyright © 2017 Denis. All rights reserved.
//

import Foundation

struct APIConstants {

    static let baseURL = "http://api.openweathermap.org/data/2.5/"
    static let apiKey = "572d600f7822f878f6d1d4fbe3b985f5"
    
    struct Path {
        static let weather = "weather"
        static let forecast = "forecast"
    }
    
    struct Keys {
        static let appID = "appid"
        
        struct Coordinates {
            static let latitude = "lat"
            static let longitude = "lon"
        }
    }
    
    struct TemeperatureFormat {
        static let inCelsius = "units=metric"
        static let inFahrenheit = "units=imperial"
    }
}
