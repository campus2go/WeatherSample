//
//  PlzStorage.swift
//  WeatherSample
//
//  Created by Benni on 08.04.16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import Foundation

class PlzStorage{
    
    static let unitKey = "de.benjamin.weather.plz"
    
    static var _currentPlz : String?
    static var currentPlz : String {
        get {
            if _currentPlz == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let strValue = defaults.stringForKey(unitKey)
                _currentPlz = strValue
            }
            if _currentPlz == nil {
                // No value was found in NSUserDefaults - default value is Celsius
                _currentPlz = ""
            }
            return _currentPlz!
        }
        set {
            if let plz : String = newValue {
                _currentPlz = newValue
                let defaults = NSUserDefaults.standardUserDefaults()
                
                defaults.setObject(plz, forKey: unitKey)
            }
            
        }
    }
    
    
}