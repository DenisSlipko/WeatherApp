//
//  WeatherForecastView.swift
//  WeatherApp
//
//  Created by Denis on 11.07.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

fileprivate let itemsPerRow: CGFloat = 3

class WeatherForecastView: BaseView, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet weak var weekForecastTableView: UITableView!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    var weatherModels: [WeatherModel] = []
    var currentWeatherModel: WeatherModel?
    var weatherTableViewCellIdentifier = WeatherTableViewCell.defaultIdentifier
    var forecastCollectionViewCellIdentifier = WeatherCollectionViewCell.defaultIdentifier
    
    
    override func initializeProperties() {
        self.weekForecastTableView.register(UINib(nibName: weatherTableViewCellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: weatherTableViewCellIdentifier)

        self.forecastCollectionView.register((UINib(nibName: forecastCollectionViewCellIdentifier, bundle: Bundle.main)), forCellWithReuseIdentifier: forecastCollectionViewCellIdentifier)
    }
    
    
    func fillWith(currentWeatherModel: WeatherModel?, weatherModels: [WeatherModel]) {
        self.currentWeatherModel = currentWeatherModel
        self.weatherModels = weatherModels
        
        temperatureLabel.text = (currentWeatherModel?.temperature.map { String(Int($0)) } ?? "-") + "°"
        weatherLabel.text = currentWeatherModel?.weatherDescription.map{ $0 } ?? "-"
        cityLabel.text = currentWeatherModel?.city.map{ String($0) } ?? "-"
        
        if let url = currentWeatherModel?.imagePath.map({URL.init(string: $0)}) {
            weatherImage.kf.setImage(with: url)
        }
        
        self.weekForecastTableView.reloadData()
        self.forecastCollectionView.reloadData()
    }
    
// MARK - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: weatherTableViewCellIdentifier, for: indexPath) as! WeatherTableViewCell
        
        if weatherModels.count != 0 {
            cell.fillWith(weatherModel: self.weatherModels[indexPath.row * 8])
        }
        
        return cell
    }
    
//MARK - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: forecastCollectionViewCellIdentifier, for: indexPath) as! WeatherCollectionViewCell
        
        if weatherModels.count != 0 {
            cell.fillWith(weatherModel: self.weatherModels[indexPath.row])
        }
        
        return cell
    }
}
