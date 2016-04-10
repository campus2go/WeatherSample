//
//  Weather.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

protocol Weather {
	
	var weatherCondition : WeatherCondition? {get}
	
	var temperature : Float? {get}

	var weatherConditionDescription : String? {get}
	
	var placeName : String? {get}
    
    //optional wenn verfügbar
    //var icon_url : String? {get}
	
}
