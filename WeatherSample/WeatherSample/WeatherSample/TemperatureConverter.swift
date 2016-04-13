//
//  TemperaturConverter.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

class TemperatureConverter {
	
	static let c0inK : Float = 273.15
	static let c0inF : Float = 32.0
	static let factorCtoF : Float = 9.0/5.0
	static let factorFtoC : Float = 5.0/9.0
	
	static let unitKey = "de.klecker.weather.units"
	
	static var _currentUnit : TemperatureUnit?
	static var currentUnit : TemperatureUnit {
		get {
			if _currentUnit == nil {
				let defaults = NSUserDefaults.standardUserDefaults()
				let intValue = defaults.integerForKey(unitKey)
				_currentUnit = TemperatureUnit(rawValue: intValue)
			}
			if _currentUnit == nil {
				// No value was found in NSUserDefaults - default value is Celsius
				_currentUnit = .C
			}
			return _currentUnit!
		}
		set {
			if let temp : TemperatureUnit = newValue {
				_currentUnit = newValue
				let defaults = NSUserDefaults.standardUserDefaults()
				defaults.setInteger(temp.rawValue, forKey: unitKey)
			}
			
		}
	}
	
	static func c2F (c : Float) -> Float {
		
		return c * factorCtoF + c0inF;
	}
	
	static func c2K (c : Float) -> Float {
		
		return c + c0inK
	}
	
	static func k2C (k : Float) -> Float {
		
		return k - c0inK
	}
	
	static func k2F (k : Float) -> Float {
		
		return c2F(k2C(k))
	}
	
	static func f2C (f : Float) -> Float {
		
		return f * factorFtoC - c0inF
	}
	
	static func f2K (f : Float) -> Float {
		
		return c2K(f2C(f))
	}
	
	static func k2Current (k : Float) -> Float {
		switch currentUnit {
		case .C:
			return k2C(k)
		case .K:
			return k
		case .F:
			return k2F(k)
		}
	}
	
	static func c2Current (c : Float) -> Float {
		switch currentUnit {
		case .C:
			return c
		case .K:
			return c2K(c)
		case .F:
			return c2F(c)
		}
	}
	
	static func f2Current (f : Float) -> Float {
		switch currentUnit {
		case .C:
			return f2C(f)
		case .K:
			return f2K(f)
		case .F:
			return f
		}
	}
}
