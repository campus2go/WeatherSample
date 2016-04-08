//
//  SimpleWeatherIconProvider.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

import UIKit

class SimpleWeatherIconProvider : WeatherIconProvider {
	
	static let filenameSun = "ic_weather_01d.png"
	static let filenameClouds = "ic_weather_03d.png"
	static let filenameHeavyClouds = "ic_weather_04d.png"
	static let filenamePartlyCloudy = "ic_weather_02d.png"
	static let filenameRain = "ic_weather_09d.png"
	static let filenameScatteredRain = "ic_weather_10d.png"
	static let filenameSnow = "ic_weather_13d.png"
	static let filenameFog = "ic_weather_50d.png"
	static let filenameThunderstorm = "ic_weather_11d.png"
	
	private func filenameForCondition (condition : WeatherCondition) -> String {
		
		switch condition {
		case .Sun:
			return SimpleWeatherIconProvider.filenameSun
		case .Clouds:
			return SimpleWeatherIconProvider.filenameClouds
		case .HeavyClouds:
			return SimpleWeatherIconProvider.filenameHeavyClouds
		case .PartlyCloudy:
			return SimpleWeatherIconProvider.filenamePartlyCloudy
		case .Rain:
			return SimpleWeatherIconProvider.filenameRain
		case .ScatteredRain:
			return SimpleWeatherIconProvider.filenameScatteredRain
		case .Snow:
			return SimpleWeatherIconProvider.filenameSnow
		case .Fog:
			return SimpleWeatherIconProvider.filenameFog
		case .Thunderstorm:
			return SimpleWeatherIconProvider.filenameThunderstorm
		}
		
	}
	
	func iconForCondition (condition : WeatherCondition) -> UIImage? {
		
		let theImage = UIImage(named: filenameForCondition(condition))
		return theImage
	}

	
}
