//
//  ViewController.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 06/04/16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherReceiver {
    
    @IBOutlet var labelTemperatur: UILabel?
    @IBOutlet var labelTown: UILabel?
    let weatherProvider: DummyWeatherProvider = DummyWeatherProvider()
    var weather: Weather?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        weatherProvider.requestWeather(self)
        labelTemperatur?.text = "\(labelTemperatur!.text!):"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWeather(weather: Weather) {
        self.weather = weather
        labelTemperatur?.text = "\(weather.temperature!) °C"
        labelTown?.text = weather.placeName
    }


}

