//
//  UITableViewCellExtension.swift
//  WeatherApp
//
//  Created by Denis on 13.07.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

extension UITableViewCell {
    @nonobjc class var defaultIdentifier: String {
        let classString = NSStringFromClass(self)
        
        return classString.components(separatedBy: ".").last ?? classString
    }
}

extension UICollectionViewCell {
    @nonobjc class var defaultIdentifier: String {
        let classString = NSStringFromClass(self)
        
        return classString.components(separatedBy: ".").last ?? classString
    }
}
