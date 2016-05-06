//
//  LocatedWeather.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 20/10/15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

import CoreLocation

protocol LocatedWeather: Weather {
    
  var location : CLLocation? {get}

}