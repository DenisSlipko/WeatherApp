//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Denis on 14.07.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillWith(weatherModel: WeatherModel?) {
        if let date = weatherModel?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h a"
            self.timeLabel.text = dateFormatter.string(from: date )
        }
        self.temperatureLabel.text = (weatherModel?.temperature.map { String(Int($0)) } ?? "-") + "°"
        
        if let url = weatherModel?.imagePath.map({URL.init(string: $0)}) {
            self.weatherImage.kf.setImage(with: url)
        }
    }
    
    override func prepareForReuse() {
        self.weatherImage.image = nil
    }
}
