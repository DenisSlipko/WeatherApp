//
//  ManagedWeather+CoreDataClass.swift
//  WeatherApp
//
//  Created by Denis on 02.04.18.
//  Copyright © 2018 Denis. All rights reserved.
//
//

import Foundation
import CoreData
import MagicalRecord

@objc(ManagedWeather)
public class ManagedWeather: NSManagedObject {

    var iconUrl: URL? {
        if
            let identifier = iconIdentifier,
            let iconUrl = URL(string: "http://openweathermap.org/img/w/\(identifier).png")
        {
            return iconUrl
        }
        return nil
    }
    
    static func save(with weatherModel: WeatherModel, in context: NSManagedObjectContext = .mr_default()) {
        let managedWeather = ManagedWeather.mr_createEntity(in: context)
        managedWeather?.id = Int64(weatherModel.id)
        managedWeather?.iconIdentifier = weatherModel.weatherIconPath
        managedWeather?.temperature = weatherModel.temperature ?? 0
        managedWeather?.city = weatherModel.city
        managedWeather?.country = weatherModel.country
        let currentDate = NSDate()
        managedWeather?.date = currentDate
        let days = Calendar.current.dateComponents([.day], from: .init(timeIntervalSince1970: 0), to: Date()).day
        managedWeather?.dateDay = Int64(days ?? 0)
        context.mr_saveToPersistentStoreAndWait()
    }
}
