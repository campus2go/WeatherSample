//
//  ViewController.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

//  Swift Schulung
//  Dieser Viewcontroller zeigt das aktuelle Wetter am Standort an.

import UIKit

class WeatherViewController: UIViewController, WeatherReceiver{

	private var weatherProvider : WeatherProvider?
	private var weatherIconProvider : WeatherIconProvider?
	private var currentWeather : Weather?
	
	@IBOutlet weak var temperatureText : UILabel?
	@IBOutlet weak var descriptionText : UILabel?
	@IBOutlet weak var weatherIcon : UIImageView?
	@IBOutlet weak var roundBackground : UIView?
	
	private let numberFormatter : NSNumberFormatter = NSNumberFormatter();
	
    // setProviders reicht von aussen Instanzen der Anbieter für Wetterdaten und Icons herein.
    // Diese Archtiektur erleichtert das spätere Testen. Ausserdem garantiert sie, dass andere Wetterdatenprovider, die im Rahmen
    // der Übungen der Schulung von den Teilnehmern entwickelt werden, auch in dieser Musterlösungsapp erprobt werden können, sofern
    // sie die vorgegebenen Protokolle korrekt implementieren 
    
	func setProviders (weatherProvider : WeatherProvider, iconProvider : WeatherIconProvider) {
		self.weatherProvider = weatherProvider
		self.weatherIconProvider = iconProvider
		
        // Es ist nicht gesichert, dass zum Ausführungszeitpunkt dieses Setters die UI bereits geladen wurde. Im Gegenteil, bei der aktuellen
        // Implementierung ist das eher unwahrscheinlich. Daher kann die UI nicht direkt gesetzt werden. 
        // Allerdings ist es der perfekte Zeitpukt, um vom Wetterdatenanbieter zu verlangen, aktuelle Wetterdaten von seinem Service zu beziehen.
		receiveOrRequestWeather();
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        // Setup des NumberFormatters
		numberFormatter.minimumIntegerDigits = 1
		numberFormatter.maximumFractionDigits = 1
		
		// Add round corners to background
		roundBackground?.clipsToBounds = true
		roundBackground?.layer.cornerRadius = 16.0
		
	}
	
	override func viewWillAppear(animated: Bool) {
        // Falls zu diesem Zeitpunkt bereits ein Wetterdatenanbieter gesetzt wurde und diesem bereits ein Wetter vorliegt,
        // kann die UI die Wetterdaten beretis anzeigen.
        if let provider = weatherProvider  {
            if provider.hasWeather {
                updateUI(provider.weather!)
            }
        }
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// Mark: - UI related
	
	func noWeather() {
        // Zeigt Platzhalter bzw. kein Icon an, wenn keine Wetterdaten vorliegen.
		temperatureText?.text = "-.-"
		descriptionText?.text = "..."
		weatherIcon?.image = nil
	}
	
	func showWeather(weather : Weather) {
        
        // Wetterdaten aus dem Wetterdatenanbieter kopieren.
		let temp = weather.temperature!  // Der Wetterdatenanbieter sollte die Temperatur immer in der Einheit bereitstellen, die der Anwender ausgewählt hat.
		let unit = TemperatureConverter.currentUnit.unitLiteral() // Zeichenkette zur Anzeige der Temperatureinheit
		let tempString = numberFormatter.stringFromNumber(temp)
		
        // UI-Elemente entsprechend befüllen
		temperatureText?.text = "\(tempString!) \(unit)"
		descriptionText?.text = weather.placeName!
		weatherIcon?.image = weatherIconProvider?.iconForCondition(weather.weatherCondition!)
	}
	
	func updateUI (weather : Weather?) {
		
		// mehod may be called before ui is loaded
		if temperatureText == nil {
			return
		}
		
		if let ourWeather = weather {
			// set the UI
			showWeather(ourWeather)
		} else {
			noWeather()
		}
	}
	
	func updateUI () {
		
		// U.U. wird diese Methode bereits aufgerufen, noch bevor die UI geladen wurde.
		if temperatureText == nil {
			return
		}
		
        // Die UI wurde geladen, also können wir die Wetterdaten auch direkt anzeigen, falls 
        // es auchder Wetterdatenanbieter bereits gesetzt wurde.
		if let provider = weatherProvider {
			if provider.hasWeather && provider.istWeatherCurrent {
				showWeather((weatherProvider?.weather)!)
			} else {
                // Es gibt einen Wetterdatenanbieter, dem allerdings noch kein Wetter oder veraltete Daten vorliegen. 
                // In dem Fall  zeigen wir nichts an.
				noWeather()
			}
		}
	}

	
	// Mark: - WeatherReceiver Implementation
	
	func updateWeather (weather : Weather) {
        updateUI(weather)
	}
	
	func receiveOrRequestWeather () {
        // Prüfen, ob bereits ein Wetterdatenprovider gesetzt wurde
		if let provider : WeatherProvider = weatherProvider! {
            // Prüfen, ob der Wetterdatenprovider aktuelles Wetter zur Verfügung hat
			if provider.hasWeather && provider.istWeatherCurrent {
                // Das aktuelle Wetter direkt verwenden ohne neue Wetterdaten anzufordern.
				currentWeather = provider.weather!
                updateUI (currentWeather)
			} else {
				// Wetterdaten anfordern.
                // Dabei wird eine Referenz auf die Instanz dieses ViewControllers übergeben als WeatherReceiver. 
                // Der WeatherReceiver bzw. dessen Methode updateWeather wird vom Wetterdatenprovider aufgerufen, sobald 
                // die neue Wetterdaten vorliegen. Das kann asynchron geschehen.
				provider.requestWeather(self)
			}
		}
	}

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Make sure your segue name in storyboard is the same as this line
        if segue.identifier == "MAP"
        {
            // Get reference to the destination view controller
            let vc = segue.destinationViewController as! WeatherMapViewController
    
            vc.setProviders(OpenMulitWeatherProvider(), iconProvider: weatherIconProvider!)
        }
    }
    

}

