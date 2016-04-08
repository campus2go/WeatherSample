//
//  ViewController.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 06/04/16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherReceiver {
    
    
    func updateWeather (_weather : Weather){
        self.weather = _weather
        editLocation()
        editImage()
    }
    
    @IBOutlet var temp : UILabel?
    @IBOutlet var ort : UILabel?
    @IBOutlet var imageView : UIImageView?
    
    
    
    var weather : Weather?
    var myWeatherIconProvider : WeatherIconProvider?
    var myWeatherProvider : WeatherProvider?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWeatherProvider = RealWeatherProvider()
        myWeatherIconProvider = DummyWeatherIconProvider()
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if myWeatherProvider!.hasWeather && myWeatherProvider!.istWeatherCurrent{
            weather = myWeatherProvider!.weather
        }else{
            myWeatherProvider!.requestWeather(self)
        }
        
        
        
        editLocation()
        editImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func editLocation() {
        let nf = NSNumberFormatter()
        var wieWarmEsIst : String
        
        if let w = weather {
            
        
        
        switch TemperatureConverter.currentUnit{
        //Was übergibt uns der Provider als standard?
        case .K: wieWarmEsIst = nf.stringFromNumber(TemperatureConverter.c2K(w.temperature!))!
        case .F: wieWarmEsIst = nf.stringFromNumber(TemperatureConverter.c2F(w.temperature!))!
        case .C: wieWarmEsIst = nf.stringFromNumber((w.temperature!))!
            
        self.view.backgroundColor = UIColor(colorLiteralRed: (w.temperature!/50), green: 0.5, blue: 0.5, alpha: 1)
        }
        
        ort?.text = weather!.placeName
        temp?.text = wieWarmEsIst+TemperatureConverter.currentUnit.unitLiteral()
        }else{
            ort?.text = "-"
            temp?.text = "-"
        }
    }
    
    func editImage(){
        if let w = weather {
        imageView?.image =  myWeatherIconProvider!.iconForCondition((w.weatherCondition)!)
        }
    }
    
}

