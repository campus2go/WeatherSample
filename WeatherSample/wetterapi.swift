//
//  wetter-api.swift
//  WeatherSample
//
//  Created by Benni on 08.04.16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import Foundation

class wetterapi :  NSObject, NSXMLParserDelegate{
    
    //1. PLZ des Ortes
    private var plz : String = ""
    
    
    
    
    
    //2. API ansprechen
    var url : String? {
        return "http://www.wetter-api.de/wetter-0a09c8844ba8f0936c20bd791130d6b6-"+plz+".xml"
    }
    
    
    
    //var url = "http://www.wetter-api.de/wetter-ihr-api-key-35759.xml"
    
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var myort = NSMutableString()
    var temperatur = NSMutableString()
    var weatherConditionDescription = NSMutableString()
    var weatherCondition = NSMutableString()
   
    
    func urlGenerator(_plz: String) {
        plz = _plz
        
    }
    
    
    func beginParsing() -> ()
    {
        posts = []
        parser = NSXMLParser(contentsOfURL:(NSURL(string: url!))!)!
        parser.delegate = self
        parser.parse()
      //  tbData!.reloadData()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName
        if (elementName as NSString).isEqualToString("item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            myort = NSMutableString()
            myort = ""
            temperatur = NSMutableString()
            temperatur = ""
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        //print(string)
        if element.isEqualToString("ort") {
            myort.appendString(string)
            
        } else if element.isEqualToString("temperatur") {
            temperatur.appendString(string)
        }else if element.isEqualToString("warnungvor"){
            weatherConditionDescription.appendString(string)
        }else if  element.isEqualToString("icon"){
            
            weatherCondition.appendString(string)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("item") {
            if !myort.isEqual(nil) {
                elements.setObject(myort, forKey: "ort")
            }
            if !temperatur.isEqual(nil) {
                elements.setObject(temperatur, forKey: "temperatur")
            }
            if !weatherConditionDescription.isEqual(nil) {
                elements.setObject(weatherConditionDescription, forKey: "warnungvor")
            }
            if !weatherCondition.isEqual(nil) {
                elements.setObject(weatherCondition, forKey: "icon")
            }
            posts.addObject(elements)
        }
    }
    
 
    
  
    func getWeather() -> (Weather){
        
        plz = PlzStorage.currentPlz
        beginParsing()
        let weatherObj = RealWeather()
        
        
        
        weatherObj.placeName = String(myort)
        //tempartur kann nicht kovertiert werden
        weatherObj.temperature = temperatur.floatValue
        weatherObj.weatherConditionDescription = String(weatherConditionDescription)
        
        
        
        
        
        //ToDo: String besteht noch aus mehreren Werten, es uss der erste Wert geholt werden!
        switch(weatherCondition){
            case "chanceflurries": weatherObj.weatherCondition = WeatherCondition.Rain
            case "chancerain":      weatherObj.weatherCondition = WeatherCondition.Rain
            case "chancesleet":     weatherObj.weatherCondition = WeatherCondition.Rain
            case "chancesnow":      weatherObj.weatherCondition = WeatherCondition.Snow
            case "chancetstorms":   weatherObj.weatherCondition = WeatherCondition.HeavyClouds
            case "clear":           weatherObj.weatherCondition = WeatherCondition.Sun
            case "cloudy":          weatherObj.weatherCondition = WeatherCondition.Clouds
            case "flurries":        weatherObj.weatherCondition = WeatherCondition.Rain
            case "flog":            weatherObj.weatherCondition = WeatherCondition.Fog
            case "hazy":            weatherObj.weatherCondition = WeatherCondition.HeavyClouds
            case "partlycloudy":    weatherObj.weatherCondition = WeatherCondition.Clouds
            case "mostlycloudy":    weatherObj.weatherCondition = WeatherCondition.Clouds
            case "mostlysunny":     weatherObj.weatherCondition = WeatherCondition.Sun
            case "partlysunny":     weatherObj.weatherCondition = WeatherCondition.PartlyCloudy
            case "sleet":           weatherObj.weatherCondition = WeatherCondition.Rain
            case "rain":            weatherObj.weatherCondition = WeatherCondition.Rain
            case "snow":            weatherObj.weatherCondition = WeatherCondition.Snow
            case "sunny":           weatherObj.weatherCondition = WeatherCondition.Sun
            case "tstorms":         weatherObj.weatherCondition = WeatherCondition.Thunderstorm
            case "cloudy":          weatherObj.weatherCondition = WeatherCondition.Clouds
        default: weatherObj.weatherCondition = WeatherCondition.Fog
        }
        
        
            
            
       
            
        
        
        return weatherObj
    }
    
    
    
    //3. Daten auswerten 
    
    //4. Auf UI bringen
    
    
    
}
