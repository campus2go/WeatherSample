//
//  OpenWeatherProvider.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class OpenWeatherProvider : NSObject, WeatherProvider, CLLocationManagerDelegate {

    
    // Ich bitte darum, an dieser Stelle den jeweils eigenen API-Key zu verwenden.
    static let apiKey = "bbd1070e955b9cd5cbca4989089eb1ec"

    // Zeitraum, nachdem das Nachladen der Wetterdaten erzwungen wird.
    private static let accuracyTimeInterval : NSTimeInterval = (30 * 60)  // 30 Minuten
	
	// JSON Keys (of imprtance)
	private static let weatherKey = "weather"
	private static let cityKey = "name"
	private static let conditionDescriptionKey = "description"
	private static let conditionKey = "id"
	private static let tempKey = "temp"
	private static let mainKey = "main"
	
    // Wenn eine Anfrage gesendet wird, dann wird diese Variable auf true gesetzt. 
    // Wie wird wieder zrurück gesetzt, wenn die Anfrage beendet ist, und sei es mit Fehler. 
    // Neue Anfragen können so verhindert werden, während eine Anfrage aktuell läuft.
	private var requestOngoing = false
    
	private var lastLocation : CLLocation?
	
	private var weatherReceiver : WeatherReceiver?

	private var openWeather : OpenWeather?
	
	var weather : Weather? {
		get {
            return openWeather
		}
	}
	
	var recentUpdate : NSDate?
	
	var hasWeather : Bool {
		get {
            return openWeather != nil
		}
	}
	
	var istWeatherCurrent : Bool {
		get {
			if let lastUpdate : NSDate = recentUpdate {
				if lastUpdate.timeIntervalSinceNow < OpenWeatherProvider.accuracyTimeInterval {
					return true;
				}
			}
			return false
		}
	}
	
	
	func requestWeather (receiver : WeatherReceiver) {
	
		NSLog("Requesting Weather, starting to locate")
		
		weatherReceiver = receiver
		
		startLocating()
		
	}
	
    private func weatherUrlString (lat : CLLocationDegrees, lon : CLLocationDegrees) -> String {
		// Appartently there is a bug in the api. units=standard, which is default, is supposed to return temperature in kelvin. However, it returns celsius.
		// This is the case regaredless whether the units= parameter is given or omitted.
		// To make sure that our code works even when openwheather.org fixes the bug, we request the units in metric, which is celsius.
		
		return "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(OpenWeatherProvider.apiKey)"
	}

	private func sendWeatherRequest (lat : CLLocationDegrees, lon : CLLocationDegrees) {
		
		NSLog("Sending requrest to openweather.org")
		
		let urlString = weatherUrlString(lat, lon: lon)
        
        sendUrlRequest(urlString)

	}
    
    func sendUrlRequest (urlString : String) {
    
        if requestOngoing {
            return
        }
        
        requestOngoing = true
		
		if let url = NSURL(string: urlString) {
			let request: NSURLRequest = NSURLRequest(URL: url)
			let queue: NSOperationQueue = NSOperationQueue.mainQueue()
			NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
				//ToDo: Check for errors
				NSLog("Response received")
				self.requestOngoing = false
				self.recentUpdate = NSDate()
				if let jsonData :NSData = data {
					NSLog("JSON Data received")
					self.unmarshalWeather(jsonData)
				}
			})
		}
		
    }
	
    func makeWeatherFromDict (rootJson : NSDictionary?) -> OpenWeather {
        
        // City
        let placeName : String? = rootJson?.objectForKey(OpenWeatherProvider.cityKey) as? String
        
        // Weather
        let weatherJson : NSArray? = rootJson?.objectForKey(OpenWeatherProvider.weatherKey) as? NSArray
        let weatherDict : NSDictionary? = weatherJson?[0] as? NSDictionary
        let description : String? = weatherDict?.objectForKey(OpenWeatherProvider.conditionDescriptionKey) as? String
        let condition32 : Int32? = weatherDict?.objectForKey(OpenWeatherProvider.conditionKey)?.intValue
        var condition : Int?
        if let condition32a : Int32 = condition32! {
            condition = Int(condition32a)
        }
        
        let mainJson : NSDictionary? = rootJson?.objectForKey(OpenWeatherProvider.mainKey) as? NSDictionary
        let temp : Float? = mainJson?.objectForKey(OpenWeatherProvider.tempKey)?.floatValue
        
        let openWeather = OpenWeather()
        openWeather.placeName = placeName
		// Workaround: The temperature is delivered in C, we need to convert it to K
        openWeather.tempInK = TemperatureConverter.c2K(temp!)
        openWeather.openCondition = condition!
        openWeather.weatherConditionDescription = description
        
        return openWeather
    }
    
    func unmarshalWeather(jsonData: NSData) {
		do {
			// ToDo: Check for errors (nil returns from JSON Objects, check array count etc.)
			
			var rootJson : NSDictionary?
			try rootJson = NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as? NSDictionary
            
            openWeather = makeWeatherFromDict(rootJson)
            if let weather = openWeather {
                if let receiver = weatherReceiver {
                    receiver.updateWeather(weather)
                }
            }

			
		} catch {
		    // don't do anything for the time being - we just don't have or update any weather
		}
		
	}
	
	// MARK: - Core Location implementation
	
	private let locationManager = CLLocationManager()
	
	private func startLocating() {
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		if #available(iOS 8.0, *) {
			locationManager.requestWhenInUseAuthorization()
		}
		locationManager.startUpdatingLocation()
		
	}
	
	private func isMoveSignificant (old : CLLocation?, new : CLLocation?) -> Bool {
		if old == nil || new == nil {
			return true
		}
		
		// Auf zwei Stellen abrunden - mit 100 multiplizieren und in Int umwanden, dann vergleichen. 
		// Das entspricht in Deutschland etwa 111m
		if Int(old!.coordinate.latitude * 100 ) != Int(new!.coordinate.latitude * 100 )  {
			return true
		}
		
		if Int(old!.coordinate.longitude * 100 ) != Int(new!.coordinate.longitude * 100 )  {
			return true
		}
		
		return false
	}
	
    // Mark: CLLocationManagerDelegate
    
	func locationManager(manager: CLLocationManager,	didUpdateLocations locations: [CLLocation]) {

		let currentLocation : CLLocation = locations[locations.count-1]
		
		if isMoveSignificant(self.lastLocation, new: currentLocation) {
			lastLocation = currentLocation
			sendWeatherRequest(currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
		}
	}
	
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if weatherReceiver != nil {
            
            var authorized = false;
            if #available(iOS 8.0, *) {
                if	status == CLAuthorizationStatus.AuthorizedAlways ||
                    status == CLAuthorizationStatus.AuthorizedWhenInUse ||
                    status == CLAuthorizationStatus.Authorized {
                        authorized = true
                }
            } else {
                if	status == CLAuthorizationStatus.Authorized {
                    authorized = true
                }
            }
            
            if authorized {
                startLocating()
            }
        }
    }
	
}
