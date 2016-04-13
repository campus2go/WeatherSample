//
//  WeatherMapAnnotation.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 21/10/15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

//  Swift Schulung
//  Implementierung einer Map Annotation.

import Foundation

import MapKit

class WeatherMapAnnotation : NSObject, MKAnnotation {
    
    // Die Koordinaten sind in dieser Weise zur Annotation zu speiechern, um das Protokoll MKAnnotation zu erfüllen.
    @objc let coordinate: CLLocationCoordinate2D
    
    // Als zusätzliches Objekt hält diese Annotation eine Referenz auf die Wetterdaten, die sie darzustellen hat.
    let weather : LocatedWeather
    
    init (weather: LocatedWeather) {
        self.weather = weather
        self.coordinate = (weather.location?.coordinate)!
    }
}
