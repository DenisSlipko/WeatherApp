//
//  WeatherForecastRequest.swift
//  WeatherAppLecture
//
//  Created by Denis on 7/12/17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

class WeatherForecastRequest: CoordinatesRequest {

    override var path: String {
        return APIConstants.Path.forecast
    }
    
    override var resultParser: ResultParser {
        return WeatherModelsParser()
    }
    
}

class WeatherModelsParser: ResultParser {
    
    func parseResult(_ result: Any?) -> Any? {
        guard let result = result as? [String : Any],
            let modelList = result["list"] as? [Any] else {
                return nil
        }
        
        let res: [WeatherModel] = modelList.flatMap { modelDict in
            return WeatherModel.init(result: modelDict)
        }
        
        return res
    }
    
}

