//
//  WeatherView.swift
//  WeatherAppLecture
//
//  Created by Denis on 10.07.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherView: BaseView {
    
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var rainValueLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    
    func fillWithModel(weatherModel: WeatherModel?) {
        temperatureLabel.text = (weatherModel?.temperature.map { String(Int($0)) } ?? "-") + "°"
        weatherLabel.text = weatherModel?.weatherDescription.map{ $0 } ?? "-"
        windSpeedLabel.text = (weatherModel?.windSpeed.map{ String($0) } ?? "-") + " m/s"
        rainValueLabel.text = (weatherModel?.rainVolume.map{ String($0) } ?? "-") + " %"
        
        if let url = weatherModel?.imagePath.map({URL.init(string: $0)}) {
            weatherImage.kf.setImage(with: url)
        }
    }
}
