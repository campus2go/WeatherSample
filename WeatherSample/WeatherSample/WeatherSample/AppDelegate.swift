//
//  AppDelegate.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

//  Swift Schulung

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
        
        // Dem WeatherViewController muss sein Wetterdatenanbieter übergeben werden. 
        // Der WeatherViewController ist gleichzeitig rootViewController. Wäre er das nicht, dann könnte eine Referenz zur Instanz
        // aus dem Storyboard bezogen werden.
        let viewController = window?.rootViewController
        
		if let weatherController : WeatherViewController = viewController as? WeatherViewController {
            // Falls weitere bzw. andere Wetterdatenprovider herangezogen werden sollen, müssen hier die entsprechend anderen Klassen
            // instanziiert und übergeben werden.
            // Für einen ersten Schritt würde an dieser Stelle ein DummyWeatherProvider und DummyWeatherIconProvider instanziiert.
			weatherController.setProviders(OpenWeatherProvider(), iconProvider: SimpleWeatherIconProvider())
		}
		
		return true
	}

}

