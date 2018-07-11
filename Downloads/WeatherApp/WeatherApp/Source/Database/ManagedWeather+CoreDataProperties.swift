//
//  ManagedWeather+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Denis on 02.04.18.
//  Copyright © 2018 Denis. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedWeather> {
        return NSFetchRequest<ManagedWeather>(entityName: "ManagedWeather")
    }

    @NSManaged public var id: Int64
    @NSManaged public var temperature: Float
    @NSManaged public var date: NSDate?
    @NSManaged public var iconIdentifier: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var dateDay: Int64

}
