//
//  WeatherMapViewController.swift
//  WeatherSample
//
//  Created by Hermann Klecker on 20/10/15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

//  Swift Schulung
//  Zeigt Wetterdaten in einer Karte an

import UIKit
import MapKit

class WeatherMapViewController: UIViewController, MKMapViewDelegate, MultiWeatherReceiver, CLLocationManagerDelegate {

    private var zoomLevel = 10
    
    private let latLonDelta = 0.5 // Initaler Span der Map
    
    var weatherProvider : MultiWeatherProvider?
    var weatherIconProvider : WeatherIconProvider?
    
    let numberFormatter : NSNumberFormatter = NSNumberFormatter();
	
    var requestedForRegion : MKCoordinateRegion? = nil;
    
    @IBOutlet weak var map : MKMapView?
    @IBOutlet weak var toggleButton : UIButton?
    @IBOutlet weak var locationButton : UIButton?

    // Analog zum WeatherViewController werden die Provider von aussen gesetzt. 
    // Um diesen ViewController testen zu können, ist das hilfreich. Im Testfall kann dem Viewcontroller ein Dummy/Stub übergeben werden, 
    // der wohldefinierte Werte ausliefert, damit anschließend auf der UI überprüft werden kann, ob diese Werte dort korrekt angezeigt werden. 
    
    func setProviders (weatherProvider : WeatherProvider, iconProvider : WeatherIconProvider) {
        self.weatherProvider = weatherProvider as? MultiWeatherProvider
        self.weatherIconProvider = iconProvider
        
        // Anders als im WeatherViewController werden an dieser Stelle noch keine Wetterdaten angefordert, da die Koordinaten dafür noch nicht feststehen.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup des Number-Formatters
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.maximumFractionDigits = 1
        
        // Um die Region einzugrenzen, die von der Karte dargestellt werden soll, muß jetzt zunächst schon der Span Gesetzt werden, auch wenn
        // der Standort noch nicht feststeht. Die Karte würde beim ersten Start der App zunächst 0/0 anzeigen, also viel Blau in der Mitte
        // des Atlantiks wo der Null-Mededian den Äquator trifft.
        map?.setRegion(MKCoordinateRegionMake((map?.centerCoordinate)!, MKCoordinateSpan(latitudeDelta: latLonDelta,longitudeDelta: latLonDelta)), animated: false)
        
        // Die Position des Anwenders soll festgestellt werden. 
        // Höchstwahrscheinlich reagiert Core Locations sehr schnell, weil die Position bereits relativ genau ermittelt wurde da dieser 
        // ViewController aus dem WeatherViewController heraus angezeigt wird, für den die Position bereits ermittelt wurde. 
        // Daher wird der Anweder kaum mit der blauen leeren Karte konfrontiert werden.
        startLocating()
        
    }

    override func didReceiveMemoryWarning() {
        // Wir haben nichts freizugeben. 
        // Ggf. wird die Map Annotation Views freigeben, die ausserhalb der aktuellen Sicht liegen und diese Erneut von diesem Controller
        // bzw. dem MapViewDelegate anfordern, sobald sie in Sichtweite kommen. 
        
        super.didReceiveMemoryWarning()
    }
    
    
	// MARK: - Geo Geometry

    // Ermittelt die "obere linke" Ecke der Region
	func northWestCorner (region : MKCoordinateRegion) -> CLLocationCoordinate2D {
		
		let center   = region.center
		return CLLocationCoordinate2D(latitude: center.latitude  - region.span.latitudeDelta, longitude: center.longitude - region.span.longitudeDelta)
		
	}
	
    // Ermittelt die "untere rechte" Ecke der Region
	func southEastCorner (region : MKCoordinateRegion) -> CLLocationCoordinate2D {
		
		let center   = region.center
		return CLLocationCoordinate2D(latitude: center.latitude  + region.span.latitudeDelta, longitude: center.longitude + region.span.longitudeDelta)
	
	}
	
    // Stellt fest, ob die Koordinate coordinate in der Region region liegt
	func isInRegion (region : MKCoordinateRegion, coordinate : CLLocationCoordinate2D) -> Bool {
		
		let northWestCorner = self.northWestCorner(region)
		let southEastCorner = self.southEastCorner(region)
		
		return (
			coordinate.latitude  >= northWestCorner.latitude &&
			coordinate.latitude  <= southEastCorner.latitude &&
				
			coordinate.longitude >= northWestCorner.longitude &&
			coordinate.longitude <= southEastCorner.longitude
		)
	}
	
    // MARK: - Actions
	
    // Wenn der Toggle-Button gedrückt wird, soll der aufrufende ViewController wieder sichtbar werden.
	@IBAction func toggleButton(sender: UIButton) {
        
		self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Der Location-Button wurde gedrückt.
    @IBAction func locationButton(sender: UIButton) {
        // Zunächst ermitteln wir den aktuellen Standort.
        startLocating()
    }
	
    // Stellt fest, ob die Kartenmitte noch innerhalb der Region liegt, für welche Wetterdaten angezeigt werden.
	func didMoveSignificantly(region newRegion : MKCoordinateRegion) -> Bool {
		
        // ToDo: Anstatt mit dem Center zu arbeiten müssten wir die Bounding-Boxen vergleichen, also schauen ob north-west und south-east
        // innerhalb der Region liegen, für die Daten angefordert wurden. 
        // Die aktuelle Logik dürfte beim herauszoomen versagen.
        
		// If this is the first request, then return true
		if self.requestedForRegion == nil {
			self.requestedForRegion = newRegion;
			return true;
		}
		
		return !isInRegion(self.requestedForRegion!, coordinate: newRegion.center)
	}
    
    func zoomLevelForRegion(region: MKCoordinateRegion) -> Int {
        
        // OWM Zoom-Level: (circa)
        // 1 ... 4 - Eine Handvoll pro Kontinent
        // 5       - Eine Handvoll für Deutschland, ca. zwei Duzend für Europa
        // 6       - Ein Duzend für Deutschland, ca 100 für Europa
        // 7       - Ca 50 für Deutschland, mehrere 100 für Europa, in etwa alle größeren Städte und Regionen
        // 8       - Eine Handvoll pro größerem Bundesland
        // 9       - Ein Duzend pro größerem Bundesland
        // 10      - Eine Handvoll pro Region
        // 11      - Etwa ein Duzend pro Region
        // 12      - In etwa Kreisebene.
        // 13 ...  - Leere Ergebnismenge
        
        
        // ToDo: Diese Logik müsste eigentlich noch die Größe der Anzeige berücksichtigen. 
        // Auf einem kleinen Smartphone muss schneller in geringere Zoom-Level gewechselt werden 
        // als auf einem iPhone 6 und noch schneller auf einem iPad. 
        
        if region.span.longitudeDelta < 0.4 {
            return 12
        } else if region.span.longitudeDelta < 0.7 {
            return 11
        } else if region.span.longitudeDelta < 2 {
            return 10
        } else if region.span.longitudeDelta < 3 {
            return 9
        } else if region.span.longitudeDelta < 5 {
            return 8
        } else if region.span.longitudeDelta < 10 {
            return 7
        } else if region.span.longitudeDelta < 15 {
            return 6
        } else if region.span.longitudeDelta < 30 {
            return 5
        }
    
        return 1
        
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let region = mapView.region
        let newZoom = zoomLevelForRegion(region)
        
        // Die Wetterdaten sollen neu geladen werden, wenn der Anwender signifikant scrollt oder zoomt.
        if didMoveSignificantly(region: region) || newZoom != zoomLevel {
            
            zoomLevel = newZoom
            self.weatherProvider?.requestWeather(self, forTopLeft: self.northWestCorner(region), andBottomRight: self.southEastCorner(region), andZoom: zoomLevel)
            
        }
    }
	
    // Erzeugt eine View zur Anzeige eines Wetters zur Verwendung als Annotation View.
    func createView(temp : Float, cond : WeatherCondition) -> MKAnnotationView {
        
        // Grundsätzlich könnte auch diese View im IB layoutet werden und dann von hier aus aus dem entsprechenden .NIB bzw. .XIB file
        // geladen werden. An dieser Stelle wird statt dessen exemplarisch gezeigt, wie eine View auch programmatisch erzeugt werden kann.
        
        let size = 50.0
        
        // Zunächst wird die Annotation View instanziiert. Alle anderen Views sind Subviews dieses Trägers
        let view = MKAnnotationView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
        
        // Hintergrund
        let background = UIView(frame: view.bounds)
        background.backgroundColor = UIColor.blackColor()
        background.alpha = 0.25
        
        // Wetter-Icon setzen
        let image = UIImageView(frame: CGRect(x: size/2 - 28.0/2, y: 0, width: 28.0, height: 28.0))
        image.image = weatherIconProvider?.iconForCondition(cond)
        
        // Text für die Temperaturangabe
        let text = UILabel(frame: CGRect(x: 0.0, y: 30.0 , width: size, height: size - 30))
        text.textColor = UIColor.whiteColor()
        text.textAlignment = .Center
        text.text = numberFormatter.stringFromNumber(temp)
        text.font = UIFont(name: text.font.fontName, size: 10)
        
        // Die einzelnen Views werden als Subview zugefügt.
        // Dabei ist wichtig, dass image und text auf der gleichen Hierarchie stehen wie der background und nach dem background zugefügt werden. 
        // Auf diese Weise wird erst der background gerendert und danach image und text darüber gezeichnet. 
        // Augenscheinlich würde sich anbieten, image und text als Subviews des Background zuzufügen. Das ginge, aber dann würde die Transparenz
        // (alpha) des background auf auf dessen Subviews kaskadieren. Wenn das gewünscht ist, dann wäre es richtig, sie als Subviews zuzufügen. 
        // Hier wurde aber angestrebt, voll sichtbare als nicht transparente Grafiken vor einem transparenten Hintergrund zu positionieren.
        view.addSubview(background)
        view.addSubview(image)
        view.addSubview(text)
        
        // Die runden Ecken werden in iOS üblicher Weise über den Layer gebildet. 
        // Alternativ dazu könnte als Hintergrund nicht einfach nur eine schwarze transparente View verwendet werden, sondern ein PNG oder JPEG
        // mit runden Ecken, dass ggf als RezisableImageWithCapInsets konfiguriert wird, falls die Rundungen bei verschiedenen Größen ihren Radius
        // erhalten sollen.
        // Für einen Hintergrund mit runden Ecken würde es genügen, diese Methoden auf background auszuführen. Da wir sie auf view ausführen bewirkt 
        // das, das auch sämtliche SubViews entsprechend beschnitten würden, falls die Grafik oder der Text über die Ränder der AnnotationView hinaus
        // ragen.
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        
        return view
        
    }
    
    // Wird von der Map aufgerufen, sobald eine Annotation in die Nähe des sichtbaren Ausschnitts kommt. 
    // Die Reihenfolge in welcher die Annotations abgearbeiet werden und in der es zu diesen Aufrufen kommt, ist prinzipiell nicht 
    // vorherzusehen.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let myAnnotation : WeatherMapAnnotation = annotation as? WeatherMapAnnotation {
            // An dieser Stelle zahlt es sich aus, der Annotation eine Referenz auf die Wetterdaten mitgegeben zu haben. 
            // Ansonsten stünden wir hier vor der herausforderung, herauszufinden, welche Wetterdaten zu dieser Lokation gehören. 
            // Das ist sicher nicht unmöglich aber umständlich und fehleranfällig, da die Darstellung der Annotations asynchron erfolgt
            // und ggf. neue Wetterdaten ebenfalls asynchron geladen werden.
            return createView(myAnnotation.weather.temperature!, cond: myAnnotation.weather.weatherCondition!)
        }
        return nil
    }
    
    // MARK: - Action
    
    // Ohne Wetterdaten zeigen wir nichts an.
    func noWeather() {
        map?.removeAnnotations((map?.annotations)!)
    }
    
    // Wetterdaten der Map zufügen.
    func showWeather(weather : LocatedWeather) {
        // Der Custom-Class WeatherMapAnnotation wird das jeweilige Wetter mit übergeben.
        map?.addAnnotation(WeatherMapAnnotation(weather: weather))
    }
	
    
    // Die UI ist zu aktualisieren.
    func updateUI (weathers : [LocatedWeather]) {
        
        // mehod may be called before ui is loaded
        if toggleButton == nil {
            return
        }
        
        if weathers.count == 0 {
            noWeather()
            return
		} else {
			// remove all annotations before adding the new ones
			map?.removeAnnotations((map?.annotations)!)
		}
			
        for weather in weathers {
            showWeather(weather)
        }
        
    }
    
    // Mark: - WeatherReceiver Implementation
    
    // Wird vom Wetterdatenliefereanten aufgerufen, wenn aktuelle Wetterdaten vorliegen.
    func updateWeathers (weathers : [LocatedWeather]) {
        if weathers.count > 0 {
            updateUI(weathers)
        }
    }

    // Mark:- Location Services
    
    private let locationManager = CLLocationManager()
    
    private func startLocating() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        if #available(iOS 8.0, *) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager,	didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation : CLLocation = locations[locations.count-1]
        map?.setCenterCoordinate(currentLocation.coordinate, animated: true)
        // Weiter Locatin-Updates verhindern. Wenn wir das nicht machen, dann wird die Karte der Bewegung des Anwenders folgen. 
        // D.h., egal wie er zoomt und scrollt, die Karte wird immer dann den Standort in ihrer Mitte darstellen, also von selbst 
        // scrollen, wenn iOS bzw. Core Location meint, uns eine neue Position übermitteln zu müssen. Und das passiert häufiger, #
        // als man annimmt.
        locationManager.stopUpdatingLocation()
    }

    
}
