//
//  MultiWeatherReceiver.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 01/04/16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import Foundation

protocol MultiWeatherReceiver {
    
    func updateWeathers (weathers : [LocatedWeather])
    
}