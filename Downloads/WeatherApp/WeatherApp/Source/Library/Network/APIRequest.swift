//
//  APIRequest.swift
//  WeatherAppLecture
//
//  Created by Denis on 7/3/17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit
//  http://openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b1b15e88fa797225412429c1c50c122a1

fileprivate struct APIStatusCode {
    static let success = 200
}

class APIRequest: ResultParser {
    
    var loading = false
    let session: URLSession
    private var task: URLSessionDataTask?
    
    private var urlPath: String {
        return APIConstants.baseURL + path
    }
    
    private var request: URLRequest? {
        let path = urlPath
        let baseParameters = "?" + APIConstants.Keys.appID + "=" + APIConstants.apiKey + "&" + APIConstants.TemeperatureFormat.inCelsius
        let string = bodyParameters?.map { (key, value) in
            return key + "=" + String(describing: value)
            }
            .reduce(baseParameters) { (string, parameter) -> String in
                return string + "&" + parameter
        } ?? baseParameters
        
        return URL(string: path + string).map { URLRequest(url: $0) }
    }

    //MARK: - Methods to overrice
    
    var path: String {
        return ""
    }
    
    var bodyParameters: [String: Any]? {
        return nil
    }
    
    var resultParser: ResultParser {
        return self
    }
    
    //MARK: -
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func execute(completion: @escaping (Any?, Error?) -> Void) {
        guard !loading, let request = request else {
            return
        }
        
        loading = true
        task = session.dataTask(with: request) { [weak self] (data, response, error) in
            self?.loading = false
            guard (response as? HTTPURLResponse)?.statusCode == 200, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let result = data.flatMap { self?.parseData($0) }
            let parsedResult = self?.resultParser.parseResult(result)
            DispatchQueue.main.async {
                completion(parsedResult, nil)
            }
        }
        
        task?.resume()
    }
    
    fileprivate func parseData(_ data: Data) -> Any? {
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    func cancel() {
        task?.cancel()
    }

}
