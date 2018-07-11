//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Denis on 02.04.18.
//  Copyright © 2018 Denis. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    
    typealias RequestCompletion = (_ coordinates: CLLocation) -> Void

    fileprivate let locationManager: CLLocationManager
    fileprivate var locationUpdated: RequestCompletion?
    
    var status: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    var isAuthorized: Bool {
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func requestLocation(_ completion: @escaping RequestCompletion) {
        if isAuthorized, let myLocation = locationManager.location {
            completion(myLocation)
            return
        }
        locationUpdated = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let myLocation = locations.first {
            locationUpdated?(myLocation)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription); \(error)")
        locationManager.stopUpdatingLocation()
    }
}
