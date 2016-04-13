//
//  OpenWeather.swift
//  WeatherSample
//
//  Created by Hermann on 18.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

class OpenWeather : Weather {
	
	var weatherConditionDescription : String? = ""
	
	var placeName : String? = ""
	
	var tempInK : Float = 0.0
	
	var openCondition : Int = 200
	
	var temperature : Float? {
		
		return TemperatureConverter.k2Current(tempInK)
		
	}
	
	var weatherCondition : WeatherCondition? {
		
		switch openCondition {
		case 200...299, 771, 781:
			return WeatherCondition.Thunderstorm
		case 300...399:
			return WeatherCondition.ScatteredRain
		case 500...599:
			return WeatherCondition.Rain
		case 600...699:
			return WeatherCondition.Snow
		case 700...769:
			return WeatherCondition.Fog
		case 800:
			return WeatherCondition.Sun
		case 801:
			return WeatherCondition.PartlyCloudy
		case 802, 803:
			return WeatherCondition.Clouds
		case 804:
			return WeatherCondition.HeavyClouds
		case 950...955:
			return WeatherCondition.Sun //ToDo: Fix this
		case 956...963:
			return WeatherCondition.Thunderstorm //ToDo: Fix this
		default:
			return nil
		}
	}
	
}