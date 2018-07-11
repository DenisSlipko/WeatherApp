//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Vlad Kolesnykov on 10.07.17.
//  Copyright © 2017 Vladyslav Kolesnykov. All rights reserved.
//

import UIKit
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupCoreData()
        
        return true
    }

    private func setupCoreData() {
        MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: "DataModel")
    }
}

