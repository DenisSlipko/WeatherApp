//
//  ViewController.swift
//  WeatherAppLecture
//
//  Created by Denis on 6/26/17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


fileprivate struct Constants {
    static let WeatherForecastViewHeight: CGFloat = UIScreen.main.bounds.size.height
    static let AnimationDuration = 0.5
}


class ViewController: UIViewController, CLLocationManagerDelegate, CityDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var weatherView: WeatherView!
    @IBOutlet weak var weatherForecastView: WeatherForecastView!
    @IBOutlet weak var weatherForecastViewBottomOffset: NSLayoutConstraint!
    
    fileprivate let locationManager = LocationManager()
    
    var currentWeatherRequest: APIRequest?
    var forecastRequest: WeatherForecastRequest?
    
    var didPerformInitialRequest: Bool = false
    
    var currentWeatherModel: WeatherModel? {
        didSet {
            if isViewLoaded {
                self.weatherView.fillWithModel(weatherModel: currentWeatherModel)
                self.navigationController?.navigationBar.topItem?.title = currentWeatherModel?.city
            }
        }
    }
    
    var weatherModels: [WeatherModel] = [] {
        didSet {
            self.weatherForecastView.fillWith(currentWeatherModel: self.currentWeatherModel, weatherModels: weatherModels)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = CitiesList.sharedInstance
        self.weatherForecastViewBottomOffset.constant =  -Constants.WeatherForecastViewHeight
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeDown.direction = .down
        self.weatherForecastView.addGestureRecognizer(swipeDown)
        
        locationManager.requestLocation { [weak self] location in
            self?.loadRequest(with: location, saving: false)
            self?.addAnnotation(to: location)
        }
    }
    
    
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.down {
            self.showWeatherForecat(NSObject())
        }
    }
    
    fileprivate func loadRequest(with location: CLLocation, saving shouldSave: Bool) {
        centerMapOnLocation(location: location)
        createRequest(latitude: location.coordinate.latitude,
                      longitude: location.coordinate.longitude,
                      shouldSave: shouldSave)
    }
    
// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCitySearchViewController" {
            let citySearchViewController = segue.destination as! CitySearchViewController
            citySearchViewController.delegate = self
        }
    }
    
    @IBAction func location(_ sender: Any) {
        locationManager.requestLocation { [weak self] location in
            self?.loadRequest(with: location, saving: true)
            self?.addAnnotation(to: location)
        }
    }
    
    func createRequest(latitude: Double, longitude: Double, shouldSave: Bool = true) {
        currentWeatherRequest = WeatherCoordinateRequest(latitude: latitude, longitude: longitude)
        currentWeatherRequest?.execute { (result, error) in
            let result = result as? WeatherModel
            self.currentWeatherModel = result
            if let result = result {
                if shouldSave {
                    ManagedWeather.save(with: result)
                }
            }
        }
        
        forecastRequest = WeatherForecastRequest(latitude: latitude, longitude: longitude)
        forecastRequest?.execute(completion: { [weak self] (result, error) in
            self?.weatherModels = result as? [WeatherModel] ?? []
        })
    }
    
    func addAnnotation(to location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                       longitude: location.coordinate.longitude)
        mapView.addAnnotation(annotation)
    }
   
    
    @IBAction func showWeatherForecat(_ sender: Any) {
        self.weatherForecastViewBottomOffset.constant = self.weatherForecastViewBottomOffset.constant == 0 ? -Constants.WeatherForecastViewHeight : 0
        UIView.animate(withDuration: Constants.AnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
// MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
    
// MARK: CityDelegate
    
    func setCoorinates(city: [String : Any]?) {
        let coord = city?["coord"] as? [String : Any]
        let latitude = coord?["lat"] as? Double
        let longitude = coord?["lon"] as? Double
        
        if let lat = latitude, let lon = longitude {
            loadRequest(with: CLLocation(latitude: lat, longitude: lon), saving: true)
            addAnnotation(to: CLLocation(latitude: lat, longitude: lon))
        }
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 300000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

