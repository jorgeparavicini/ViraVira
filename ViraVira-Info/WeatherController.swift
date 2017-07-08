//
//  WeatherController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 4/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import KVConstraintExtensionsMaster

class WeatherController: UIViewController, SWRevealViewControllerDelegate {
	
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var condition: UILabel!
	@IBOutlet weak var iconView: UIImageView!
	@IBOutlet weak var currentTemp: UILabel!
	
	@IBOutlet weak var navBar: UINavigationItem!
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var tableView: WeatherTableView!
	@IBOutlet weak var openWeatherMapLink: UIButton!
	
    @IBOutlet weak var activityIndicatorView: UIView!
	
	var activityIndicator: NVActivityIndicatorView!
    
    
    
	var comesFromSegue: Bool = false
	var menuButton: UIButtonAnimation! = nil
	
	var refreshControl: UIRefreshControl!
	
	var download: URLSessionDataTask?
	
	//var currentWeatherMap: WeatherModel?
	//var weatherDays: [WeatherDay]?
	
	var weatherMaps: [[Weather]] = []
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//Rework
		Menu.currentRootViewController = self
		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		//End rework
		self.revealViewController().delegate = self
		
		initializeActivityIndicator()
		
		loadWeatherMaps()
		
		tableView.delegate = tableView
		tableView.dataSource = tableView
		
		setColors()
		setAttributes()
		
    }
	
	func setColors() {
		cityLabel.textColor = UIColor.primary
		condition.textColor = UIColor.primary
		iconView.tintColor = UIColor.primary
		currentTemp.textColor = UIColor.primary
		
		self.view.backgroundColor = UIColor.secondary
		tableView.backgroundColor = UIColor.clear
		tableView.separatorColor = UIColor.primary
	}
	
	func setAttributes() {
		cityLabel.attributedText = NSAttributedString(string: cityLabel.text!, attributes: ViraViraFontAttributes.title)
		condition.attributedText = NSAttributedString(string: condition.text!, attributes: ViraViraFontAttributes.description)
		currentTemp.attributedText = NSAttributedString(string: currentTemp.text!, attributes: ViraViraFontAttributes.temp)
		
		openWeatherMapLink.setAttributedTitle(NSAttributedString(string: "Open Weather Map", attributes: ViraViraFontAttributes.smallInfo), for: .normal)
	}
	
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
	
	func initializeRefreshView() {
		self.refreshControl = UIRefreshControl()
		let refreshView = UIView(frame: CGRect(x: 0, y: 10, width: 0, height: 0))
		self.scrollView.addSubview(refreshView)
		refreshView.addSubview(refreshControl)
		refreshControl.addTarget(self, action: #selector(WeatherController.loadWeatherMaps), for: UIControlEvents.allEvents)
	}
	
	func initializeActivityIndicator() {
		activityIndicator = NVActivityIndicatorView(frame: activityIndicatorView.frame, type: NVActivityIndicatorType.ballClipRotateMultiple, color: UIColor.primary, padding: 0)
		
		
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicatorView.addSubview(activityIndicator)
		
		activityIndicator.applyConstraintFitToSuperview()
		
		//activityIndicator?.isHidden = true
	}
	
	func loadWeatherMaps() {
		
		
		WeatherParser.shared.delegate = self
		
		WeatherParser.shared.loadWeatherMaps() { (maps) in
			self.updateWeather(maps: maps)
		}
	}
	
	func updateWeather(maps: [Weather]) {
		let sortedMaps = sortWeatherMaps(maps: maps)
		guard let weatherMaps = create2DimensionalWeatherArray(maps: sortedMaps) else { print("Failed creating Weather Maps"); return }
		
		self.weatherMaps = weatherMaps
		
		tableView.weatherMaps = weatherMaps
		
		updateDisplay()
	}
	
	func create2DimensionalWeatherArray(maps: [Weather]) -> [[Weather]]? {
		//2 Dimensional array where
		//X = Days
		//Y = Time
		
		var dayIndex = 0
		var maps2D: [[Weather]] = []
		
		
		for map in maps {
			if maps2D.count == 0 {
				maps2D.append([map])
			} else if maps2D.count > dayIndex && maps2D[dayIndex].count > 0 {
				let lastObject = maps2D[dayIndex].last!
				
				guard map.dateTime != nil && lastObject.dateTime != nil else { return nil }
				
				//Is the current weather map in the same day as the last one?
				if Calendar.current.isDate(map.dateTime! as Date, inSameDayAs: lastObject.dateTime! as Date) {
					maps2D[dayIndex].append(map)
				} else { //Not the same day, create new index
					dayIndex += 1
					maps2D.append([map])
				}
			}
		}
		
		return maps2D
	}
	
	//Used to sort the maps in case they were saved unsorted
	func sortWeatherMaps(maps: [Weather]) -> [Weather] {
		return maps.sorted() {
			guard $0.dateTime != nil && $1.dateTime != nil else {return false}
			
			return ($0.dateTime! as Date) < ($1.dateTime! as Date)
		}
	}
	
	
	func updateDisplay() {
		guard weatherMaps.count > 0 && weatherMaps[0].count > 0 else { return }
		let currentWeatherModel = weatherMaps[0][0]
		
		cityLabel.text = currentWeatherModel.cityName
		condition.text = currentWeatherModel.weather0Description
		//Icon
		iconView.image = currentWeatherModel.weather0Icon != nil ? Weather.icons[currentWeatherModel.weather0Icon!] : nil
		
		switch AppInfoParser.temperature {
		case .Celsius:
			currentTemp.text = String(format: "%.1f", currentWeatherModel.mainTempCelsius) + "ºC"
		case .Fahrenheit:
			currentTemp.text = String(format: "%.1f", currentWeatherModel.mainTempFahrenheit) + "ºF"
		case .Kelvin:
			currentTemp.text = String(format: "%.1f", currentWeatherModel.mainTempKelvin) + "ºK"
		}
		
		setAttributes()
	}
	
	@IBAction func openLink(_ sender: Any) {
		let url = URL(string: "https://openweathermap.org/")!
		if #available(iOS 10.0, *) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(url)
		}
	}
}

extension WeatherController : WeatherParserDelegate {
	
	func didStartDownload() {
		
		activityIndicator?.isHidden = false
		activityIndicator?.startAnimating()
	}
	
	func didEndDownload() {
		
		//activityIndicator?.stopAnimating()
		//activityIndicator?.isHidden = true
	}
}

