//
//  CoordinatesRequest.swift
//  WeatherAppLecture
//
//  Created by Denis on 7/12/17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

class CoordinatesRequest: APIRequest {

    let latitude: Double
    let longitude: Double
    
    init(session: URLSession = URLSession.shared, latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        super.init(session: session)
    }
    
    override var bodyParameters: [String : Any]? {
        return [APIConstants.Keys.Coordinates.latitude : latitude,
                APIConstants.Keys.Coordinates.longitude : longitude]
    }
    
}
