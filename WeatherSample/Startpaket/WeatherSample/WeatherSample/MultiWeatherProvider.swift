//
//  MultiWeatherProvider.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 20/10/15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

import CoreLocation

protocol MultiWeatherProvider : WeatherProvider {
    
    var weathers : [LocatedWeather]? {get}
    
    func requestWeather (receiver : MultiWeatherReceiver, forTopLeft loc1:CLLocationCoordinate2D, andBottomRight loc2: CLLocationCoordinate2D, andZoom zoom : Int)
    
}
