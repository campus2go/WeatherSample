//
//  SettingsController.swift
//  WeatherSample
//
//  Created by Benni on 06.04.16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    
    @IBOutlet var plz : UITextField?
    @IBOutlet var btnOk : UIButton?
    
    
    @IBAction func pressOk(sender: UIButton){
        PlzStorage.currentPlz = (plz?.text)!
    }
    
    @IBOutlet var chooser : UISegmentedControl?
    
    @IBAction func doOnChange(sender: UISegmentedControl){
        let selectedSegment = sender.selectedSegmentIndex
        
        switch selectedSegment{
        case 0:  TemperatureConverter.currentUnit = TemperatureUnit.K
        case 1:  TemperatureConverter.currentUnit = TemperatureUnit.F
        case 2:  TemperatureConverter.currentUnit = TemperatureUnit.C
        default: break
            
        }
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        chooser?.selectedSegmentIndex = TemperatureConverter.currentUnit.rawValue
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
