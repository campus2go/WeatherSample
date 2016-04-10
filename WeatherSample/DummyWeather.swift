//
//  DummyWeather.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

class DummyWeather : Weather {

	var weatherCondition : WeatherCondition? = .Sun
	
	var temperature : Float? = 22.0
	
	var weatherConditionDescription : String? = "sonnig"
	
	var placeName : String? = "Reutlingen"
    
    var icon_url : String? = ""

}

