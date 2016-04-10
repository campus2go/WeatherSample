//
//  DummyWeatherIconProvider.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

import UIKit

class RealWeatherIconProvider : WeatherIconProvider {
    
    func iconForCondition (condition : WeatherCondition) -> UIImage? {
        switch(condition){
        case .Sun:          return UIImage(named: "ic_weather_01d.png")
        case .Clouds:       return UIImage(named: "ic_weather_03d.png")
        case .Fog:          return UIImage(named: "ic_weather_50d.png")
        case .HeavyClouds:  return UIImage(named: "ic_weather_04d.png")
        case .PartlyCloudy: return UIImage(named: "ic_weather_02d.png")
        case .Rain:         return UIImage(named: "ic_weather_09d.png")
        case .ScatteredRain:return UIImage(named: "ic_weather_10d.png")
        case .Snow:         return UIImage(named: "ic_weather_13d.png")
        case .Thunderstorm: return UIImage(named: "ic_weather_11d.png")
           
        }
        
        
        
    }
}
