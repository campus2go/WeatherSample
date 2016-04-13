//
//  OpenLocatedWeather.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 20/10/15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

import CoreLocation

class OpenLocatedWeather : OpenWeather, LocatedWeather {

    var location : CLLocation?
    
    init(weather:OpenWeather) {
        super.init()
        self.weatherConditionDescription  = weather.weatherConditionDescription
        self.placeName = weather.placeName
        self.tempInK = weather.tempInK
        self.openCondition = weather.openCondition
    }
    
}