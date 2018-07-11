//
//  WeatherTableViewCell.swift
//  
//
//  Created by Denis on 12.07.17.
//
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillWith(weatherModel: WeatherModel?) {
        if let date = weatherModel?.date {
            self.dayLabel.text = date.dayOfWeek()
        }
        self.maxTemperatureLabel.text = (weatherModel?.temperature.map { String(Int($0)) } ?? "-") + "°"
        self.minTemperatureLabel.text = (weatherModel?.minTemp.map { String(Int($0)) } ?? "-") + "°"
        
        if let url = weatherModel?.imagePath.map({URL.init(string: $0)}) {
            self.weatherImage.kf.setImage(with: url)
        }
    }
    
    override func prepareForReuse() {
        self.weatherImage.image = nil
    }
}
