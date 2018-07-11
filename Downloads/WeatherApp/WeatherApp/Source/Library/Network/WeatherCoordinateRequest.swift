//
//  WeatherCoordinateRequest.swift
//  WeatherAppLecture
//
//  Created by Denis on 7/3/17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

class WeatherCoordinateRequest: CoordinatesRequest {
    
    override var path: String {
        return APIConstants.Path.weather
    }
    
    override var resultParser: ResultParser {
        return WeatherModelParser()
    }
}

class WeatherModelParser: ResultParser {
    
    func parseResult(_ result: Any?) -> Any? {
        return WeatherModel.init(result: result)
    }
    
}
