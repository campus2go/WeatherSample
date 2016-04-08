//
//  ViewController.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 06/04/16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, WeatherReceiver {
    
    //View Elemente
    @IBOutlet var labelTemperatur: UILabel?
    @IBOutlet var labelTown: UILabel?
    @IBOutlet var imageWeather: UIImageView?
    @IBOutlet var buttonSettings: UIButton?
    
    //Provider + Objekte
    let weatherProvider: WeatherProvider = OnlineWeatherProvider()
    let iconProvider: WeatherIconProvider = SimpleWeatherIconProvider()
    var weather: Weather?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if weatherProvider.hasWeather && weatherProvider.istWeatherCurrent {
            weather = weatherProvider.weather
        }else{
            weatherProvider.requestWeather(self)
        }
        
        
        labelTemperatur?.text = "\(labelTemperatur!.text!):"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWeather(weather: Weather) {
        self.weather = weather
        
        labelTown?.text = weather.placeName
        
        if let condition = weather.weatherCondition {
            imageWeather?.image = iconProvider.iconForCondition(condition)
        }
        
        //print (currentUnitAsInt)
        var convertedTemp: Float
        
        switch weather.unit! {
            
        case .F:
            convertedTemp = TemperatureConverter.f2Current( weather.temperature!)
        case .C:
            convertedTemp = TemperatureConverter.c2Current( weather.temperature!)
        case .K:
            convertedTemp = TemperatureConverter.k2Current( weather.temperature!)
            
            
        }
        
        
        labelTemperatur?.text = "\(convertedTemp) \(TemperatureConverter.currentUnit.unitLiteral())"
        
        
    }


}

