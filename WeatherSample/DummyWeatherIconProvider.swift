//
//  DummyWeatherIconProvider.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

import UIKit

class DummyWeatherIconProvider : WeatherIconProvider {
	
	func iconForCondition (condition : WeatherCondition) -> UIImage? {
		return UIImage(named: "ic_weather_02d.png")
	}
}
