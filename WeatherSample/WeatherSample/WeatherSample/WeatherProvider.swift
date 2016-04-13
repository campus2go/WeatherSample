//
//  WeatherProvider.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

protocol WeatherProvider {
	
	var hasWeather : Bool {get}
	
	var istWeatherCurrent : Bool {get}
	
	var weather : Weather? {get}
	
	func requestWeather (receiver : WeatherReceiver)
	
}
