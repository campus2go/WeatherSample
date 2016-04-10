//
//  RealWeather.swift
//  WeatherSample
//
//  Created by Benni on 08.04.16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import Foundation

class RealWeather : Weather {
    
    var weatherCondition : WeatherCondition? = .Sun
    
    var temperature : Float? = 22.0
    
    var weatherConditionDescription : String? = "sonnig"
    
    var placeName : String? = "Reutlingen"
    
    //optional wenn verfügbar
    //var icon_url : String? = ""
    
    
}