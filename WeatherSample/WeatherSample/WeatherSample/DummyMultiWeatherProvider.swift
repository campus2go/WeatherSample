//
//  DummyMultiWeatherProvider.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 01/04/16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import Foundation

import UIKit

import CoreLocation

class DummyMultiWeatherProvider : DummyWeatherProvider, MultiWeatherProvider {
    
    
    var weathers : [LocatedWeather]? = [DummyLocatedWeather()]
    
    func requestWeather (receiver : MultiWeatherReceiver, forTopLeft loc1:CLLocationCoordinate2D, andBottomRight loc2: CLLocationCoordinate2D, andZoom zoom : Int){
        // for the dummy call the receiver with some delay
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            receiver.updateWeathers(self.weathers!);
        })
    }
}