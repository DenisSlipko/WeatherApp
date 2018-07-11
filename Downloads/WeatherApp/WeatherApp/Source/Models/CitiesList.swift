//
//  CitiesList.swift
//  WeatherApp
//
//  Created by Denis on 17.07.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

class CitiesList {
    static let sharedInstance = CitiesList()
    var citiesList: [Any] = []
    
    private init() {
        readJson()
    }

    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "city.list", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let object = json as? [Any] {
                    self.citiesList = object
                    
                    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true,
                                                          selector: #selector(NSString.localizedStandardCompare(_:)))
                    self.citiesList = (object as NSArray).sortedArray(using: [sortDescriptor])
                } else {
                    print("JSON is invalid")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
