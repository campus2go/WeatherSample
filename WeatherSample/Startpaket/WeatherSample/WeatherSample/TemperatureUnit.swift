//
//  TemperatureUnit.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

enum TemperatureUnit : Int {
	case K = 0, F, C
	
	func unitLiteral() -> String {
		switch self {
			case K:
			  return "K"
			case F:
			  return "F"
			case C:
			  return "°C"
		}
	}
}
