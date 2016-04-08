//
//  WeatherCodeMapper.swift
//  WeatherSample
//
//  Created by Rechen- und Medienzentrum on 08/04/16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import Foundation

// https://developer.yahoo.com/weather/documentation.html

class WeatherCodeMapper {
    
    static func getConditionFor(yahooCode: Int64 ) -> WeatherCondition{
    
        var myCondition: WeatherCondition?
        
        switch yahooCode {
        case 0...4:
            myCondition = WeatherCondition.Thunderstorm
        case 5...10:
            myCondition = WeatherCondition.Snow
        case 11, 12:
            myCondition = WeatherCondition.ScatteredRain
        case 13...18:
            myCondition = WeatherCondition.Snow
        case 19...22:
            myCondition = WeatherCondition.Fog
        case 23...28:
            myCondition = WeatherCondition.HeavyClouds
        case 29, 30:
            myCondition = WeatherCondition.PartlyCloudy
        case 31...34:
            myCondition = WeatherCondition.Sun
        case 35:
            myCondition = WeatherCondition.Rain
        case 36:
            myCondition = WeatherCondition.Sun
        case 37...39:
            myCondition = WeatherCondition.Thunderstorm
        case 40:
            myCondition = WeatherCondition.ScatteredRain
        case 41...43:
            myCondition = WeatherCondition.Snow
        case 44:
            myCondition = WeatherCondition.PartlyCloudy
        case 45...47:
            myCondition = WeatherCondition.Thunderstorm
            
        
            
        default:
            myCondition = WeatherCondition.PartlyCloudy
        }
        
        
        return myCondition!
    }
    
}