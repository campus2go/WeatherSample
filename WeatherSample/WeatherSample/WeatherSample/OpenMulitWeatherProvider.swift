//
//  OpenMulitWeatherProvider.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 20/10/15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

import CoreLocation

class OpenMulitWeatherProvider : OpenWeatherProvider, MultiWeatherProvider {
    
    // JSON Keys (of imprtance)
    static let listKey = "list"
    static let coordKey = "coord"
    static let latKey = "lat"
    static let lonKey = "lon"
    
    var weatherArray : [LocatedWeather]? = nil
    var multiWeatherReceiver : MultiWeatherReceiver?
    
    private func weatherUrlString ( forTopLeft loc1:CLLocationCoordinate2D, andBottomRight loc2: CLLocationCoordinate2D, andZoom zoom : Int) -> String {

        let lat1 = loc1.latitude
        let lon1 = loc1.longitude
        let lat2 = loc2.latitude
        let lon2 = loc2.longitude
		
		// Appartently there is a bug in the api. units=standard, which is default, is supposed to return temperature in kelvin. However, it returns celsius.
		// This is the case regaredless whether the units= parameter is given or omitted.
		// To make sure that our code works even when openwheather.org fixes the bug, we request the units in metric, which is celsius.
        
        return "http://api.openweathermap.org/data/2.5/box/city/?bbox=\(lon1),\(lat1),\(lon2),\(lat2),\(zoom)&cluster=yes&units=metric&appid=\(OpenWeatherProvider.apiKey)"
    }
    
    var weathers : [LocatedWeather]? {
        get {
            return weatherArray
            
        }
    }

    func requestWeather (receiver : MultiWeatherReceiver, forTopLeft loc1:CLLocationCoordinate2D, andBottomRight loc2: CLLocationCoordinate2D, andZoom zoom : Int) {
		
	
        let urlString = weatherUrlString(forTopLeft: loc1, andBottomRight: loc2, andZoom: zoom)
		
		NSLog("Requesting Multi-Weather for region from: %@", urlString);
		
        self.multiWeatherReceiver = receiver
        
        sendUrlRequest(urlString)
        
    }
    
    
    func makeLocatedWeatherFromDict (weatherDict : NSDictionary) -> LocatedWeather {
		
        let locatedWeather = OpenLocatedWeather(weather:makeWeatherFromDict(weatherDict))
        
        let coord = weatherDict.objectForKey(OpenMulitWeatherProvider.coordKey)
        
        let lat : Double? = coord!.objectForKey(OpenMulitWeatherProvider.latKey) as? Double
        let lon : Double? = coord!.objectForKey(OpenMulitWeatherProvider.lonKey) as? Double
        
        let location = CLLocation(latitude: lat!, longitude: lon!)
        
        locatedWeather.location = location
        
        return locatedWeather
    }
    
    
    override func unmarshalWeather(jsonData: NSData) {
		
		
        do {
			
            var wetterArray = [LocatedWeather]()
            
            var rootJson : NSDictionary?
            try rootJson = NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as? NSDictionary
            
            let listJson = rootJson?.objectForKey(OpenMulitWeatherProvider.listKey) as? NSArray
            
            for weatherDict in listJson! {
                let weather = makeLocatedWeatherFromDict (weatherDict as! NSDictionary)
                wetterArray.append(weather)
            }
            
            multiWeatherReceiver?.updateWeathers(wetterArray)
            
            self.weatherArray = wetterArray
			
        } catch {
            // don't do anything - we just don't have or update any weather
            NSLog("Error unmarshalling weather")
        }
        
    }
    
}