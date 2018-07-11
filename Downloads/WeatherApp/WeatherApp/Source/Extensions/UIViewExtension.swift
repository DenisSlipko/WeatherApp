//
//  UIViewExtension.swift
//  WeatherApp
//
//  Created by Denis on 11.07.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit

extension UIView {
    
    func addBlurEffect(style: UIBlurEffectStyle) {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.insertSubview(blurEffectView, at: 0)
        }
    }
    
}
