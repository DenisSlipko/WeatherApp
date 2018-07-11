//
//  WeatherHistoryTVCell.swift
//  WeatherApp
//
//  Created by Denis on 02.04.18.
//  Copyright © 2018 Denis. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherHistoryTVCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var countryNameLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    
    func configure(with managedWeather: ManagedWeather) {
        if let iconUrl = managedWeather.iconUrl {
            let imageResource = ImageResource(downloadURL: iconUrl)
            iconImageView.kf.setImage(
                with: imageResource,
                options: [.transition(.fade(0.3))])
        }
        cityNameLabel.text = managedWeather.city ?? "Unnowned city"
        countryNameLabel.text = managedWeather.country ?? "Unnowned country"
        temperatureLabel.text = "\(managedWeather.temperature)°"
    }
}
