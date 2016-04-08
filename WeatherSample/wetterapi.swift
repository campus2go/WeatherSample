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
    //var url_x = "http://www.wetter-api.de/wetter-0a09c8844ba8f0936c20bd791130d6b6-"+plz+".xml"
    var url = "http://www.wetter-api.de/wetter-ihr-api-key-35759.xml"
    
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var myort = NSMutableString()
    var temperatur = NSMutableString()
    
    
    func beginParsing()
    {
        posts = []
        parser = NSXMLParser(contentsOfURL:(NSURL(string: url))!)!
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
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
        //print(string)
        if element.isEqualToString("ort") {
            myort.appendString(string)
            print(element)
        } else if element.isEqualToString("temperatur") {
            temperatur.appendString(string)
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if (elementName as NSString).isEqualToString("item") {
            if !myort.isEqual(nil) {
                elements.setObject(myort, forKey: "ort")
            }
            if !temperatur.isEqual(nil) {
                elements.setObject(temperatur, forKey: "temperatur")
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
        
            
            
       
            
        print(weatherObj.placeName)
        print(weatherObj.temperature)
        
        return weatherObj
    }
    
    
    
    //3. Daten auswerten 
    
    //4. Auf UI bringen
    
    
    
}
