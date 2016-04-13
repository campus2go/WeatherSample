//
//  DummyLocatedWeather.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 01/04/16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import Foundation

import UIKit

import CoreLocation

class DummyLocatedWeather : DummyWeather, LocatedWeather {
    
    
    var location : CLLocation? = CLLocation(latitude: 48.48, longitude: 9.22)
    
}