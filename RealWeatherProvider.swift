//
//  DummyWeatherProvider.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

class RealWeatherProvider : WeatherProvider {
    
    
    var hasWeather : Bool = false
    
    var istWeatherCurrent : Bool = true
    
    var weather : Weather? = RealWeather()
    
    func requestWeather (receiver : WeatherReceiver) {
        // for the dummy call the receiver with some delay
        
        var myApi : wetterapi = wetterapi()
        var weather2 = myApi.getWeather()
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            receiver.updateWeather(weather2)
            
        })
    }
    
    func cancelWeatherRequest (receiver : WeatherReceiver){
        // for the dummy don't do anything
    }
    
}
