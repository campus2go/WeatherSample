//
//  SettingsViewController.swift
//  WeatherSample
//
//  Created by Hermann on 18.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

//  Swift Schulung
//  Dieser Viewcontroller zeigt lediglich eine Auswahl der Temperatureinheiten an. 
//  Zusätzlich wird das OWM-Icon angezeigt und zu OWM verlinkt. 

import UIKit

class SettingsViewController: UIViewController {

	@IBOutlet weak var unitChoice : UISegmentedControl?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		switch TemperatureConverter.currentUnit {
		case .K:
			unitChoice?.selectedSegmentIndex = 0
			
		case .C:
			unitChoice?.selectedSegmentIndex = 1
			
		case .F:
			unitChoice?.selectedSegmentIndex = 2
			
		}
        
        // Alternative, da die Reihenfolge in der UI der Reihenfolge im Enum entspricht und da das Enum vom Typ Int ist:
        // unitChoice?.selectedSegmentIndex = TemperatureConverter.currentUnit.rawValue
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
	// MARK: Action

	@IBAction func indexChanged(sender: UISegmentedControl) {
		
		switch sender.selectedSegmentIndex
		{
		case 0:
			TemperatureConverter.currentUnit = TemperatureUnit.K

		case 1:
			TemperatureConverter.currentUnit = TemperatureUnit.C
		
		case 2:
			TemperatureConverter.currentUnit = TemperatureUnit.F

		default:
			break;
		}
        
        // Alternative, da die Reihenfolge in der UI der Reihenfolge im Enum entspricht und da das Enum vom Typ Int ist:
        // TemperatureConverter.currentUnit = TemperatureUnit(rawValue: sender.selectedSegmentIndex)!
        
        // Da die Einstellung für die Einheit die einzige Einstellung ist, die der Anwender vornehmen kann, können wir nach Auswahl einer Einheit 
        // diese Settings-UI auch schließen.
        self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func okButton(sender: UIButton) {
		// Der OK-Button schließt die Settings-Ansicht
		self.dismissViewControllerAnimated(true, completion: nil)

	}
	
	
	@IBAction func owmButton(sender: UIButton) {
		// Um die Lizenzbestimmungen von OpenWeatherMap zu erfüllen, wird das OWM-Logo als Button angezeigt. 
        // Sobald der Anwender darauf drückt, wird extern die Startseite von OWM aufgerufen.
		UIApplication.sharedApplication().openURL(NSURL(string: "http://openweathermap.org")!)
		
	}
	


}
