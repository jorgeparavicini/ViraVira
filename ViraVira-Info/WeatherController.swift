//
//  WeatherController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 4/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class WeatherController: UIViewController, SWRevealViewControllerDelegate {
	@IBOutlet weak var cityLabel: UILabel!
	
	@IBOutlet weak var navBar: UINavigationItem!
	var comesFromSegue: Bool = false
	var menuButton: UIButtonAnimation! = nil
	
	@IBOutlet weak var currentTemp: UILabel!
	
	var weatherMaps: [WeatherModel] = [WeatherModel]()
	var currentWeatherMap: WeatherModel?
	
	var weatherDays: [WeatherDay]? {
		didSet {
			//pickerView.reloadData()
		}
	}
	
	@IBOutlet weak var scrollView: UIScrollView!
	var refreshControl: UIRefreshControl!
	
	
	@IBOutlet weak var condition: UILabel!
	@IBOutlet weak var iconView: UIImageView!
	
	@IBOutlet weak var tableView: WeatherTableView!
	
	@IBOutlet weak var openWeatherMapLink: UIButton!
	
	var tempUnit: Weather.TemperatureUnits = .Celsius
	
	var download: URLSessionDataTask?
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		
		updateWeather()
		
		(UIApplication.shared.delegate as! AppDelegate).currentViewController = self
		
		self.refreshControl = UIRefreshControl()
		let refreshView = UIView(frame: CGRect(x: 0, y: 10, width: 0, height: 0))
		self.scrollView.addSubview(refreshView)
		refreshView.addSubview(refreshControl)
		refreshControl.addTarget(self, action: #selector(WeatherController.updateWeather), for: UIControlEvents.allEvents)
		
		//Picker view initialization
		//picker = AKPickerView(frame: pickerView.frame)
		
		//picker.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin]
		
		tableView.delegate = tableView
		tableView.dataSource = tableView
		
		let attrs: [String: Any] = [
			NSFontAttributeName : UIFont(name: "Verdana", size: 12)!,
			NSForegroundColorAttributeName : UIColor.primary,
			NSUnderlineStyleAttributeName : 1]
		let attributedString = NSAttributedString(string: "Open Weather Map", attributes: attrs)
		openWeatherMapLink.setAttributedTitle(attributedString, for: .normal)
		
		setColors()
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

	
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
	
	
	func updateWeather(){
		let urlString = "http://api.openweathermap.org/data/2.5/forecast?id=3875070&APPID=e4a17bba974001fa1f0138645553c559"
		let url = URL(string: urlString)
		
		//Creates an alert telling to please wait for the update
		addOverlay()
		
		var failed = false
		
		download = URLSession.shared.dataTask(with:url!) { (data, response, error) in
			if error != nil {
				failed = true
				//self.removeOverlay()
				//print(error as! URLError)
				let urlError = error as! URLError
				
				DispatchQueue.main.async {
					self.dismiss(animated: true, completion:  ({
						self.displayError(error: urlError)
						}))
				}
				
			} else {
				do {
					self.weatherMaps.removeAll()
					
					let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
					
					let list = parsedData["list"] as! NSArray
					
					for index in 0..<list.count {
						let element = list[index] as! Dictionary<String, Any>
						let timeStamp = element["dt"] as! Int
						let main = element["main"] as! Dictionary<String, Any>
						let temp = main["temp"] as! Double
						let pressure = main["pressure"] as! Double
						let humidity = main["humidity"] as! Double
						
						let weatherArray = element["weather"] as! NSArray
						let weather = weatherArray[0] as! Dictionary<String, Any>
						
						let weatherMain = weather["main"] as! String
						let weatherDescription = weather["description"] as! String
						let weatherIconID = weather["icon"] as! String
						
						let clouds = (element["clouds"] as! Dictionary<String, Any>)["all"] as! Float
						
						let wind = element["wind"] as! Dictionary<String, Any>
						let windSpeed = wind["speed"] as! Double
						let windDirection = wind["deg"] as! Float
						
						let rain = element["rain"] as? Dictionary<String, Any>
						let rainAmount = rain?["3h"] as? Double
						
						let weatherModel = WeatherModel(time: timeStamp, temp: temp, pressure: pressure, humidity: humidity, weatherMain: weatherMain, weatherDescription: weatherDescription, iconID: weatherIconID, clouds: clouds, windSpeed: windSpeed, windDir: windDirection, rain: rainAmount)
						
						//print(weatherModel.description())
						
						self.weatherMaps.append(weatherModel)
					}
					
				} catch let error as NSError {
					print(error)
				}
			}
			let days = self.weatherMaps.createWeatherDays()
			self.weatherDays = days
			
			//Remove the overlay since the weather has been updated
			if !failed {
				self.removeOverlay()
			}
			self.updateDisplay()
			}
		self.download?.resume()
	}
	
	func updateDisplay() {
		
		DispatchQueue.main.async {
			if self.weatherMaps.count <= 0 {
				return
			}
			self.currentWeatherMap = self.weatherMaps[0]
			self.condition.text = self.currentWeatherMap?.weatherDescription
			self.iconView.image = self.currentWeatherMap?.icon?.withRenderingMode(.alwaysTemplate)
			//iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
			if let temperature = self.currentWeatherMap?.temp(unit: self.tempUnit) {
				let convertedTemp = Double(round(temperature*10)/10)
				
				self.currentTemp.text = "\(convertedTemp)°"
				
				switch self.tempUnit {
				case .Celsius:
					self.currentTemp.text = self.currentTemp.text?.appending("C")
				case .Fahrenheit:
					self.currentTemp.text = self.currentTemp.text?.appending("F")
				case .Kelvin:
					self.currentTemp.text = self.currentTemp.text?.appending("K")
					
				}
			} else {
				self.currentTemp.text = "--"
			}
			
			self.tableView.weatherDays = self.weatherDays
		}
	}
	
	func addOverlay() {
		let alert = UIAlertController(title: "Updating", message: "Please Wait", preferredStyle: .alert)
		//xalert.view.tintColor = UIColor.viraviraGoldColor
		
		let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = .white
		activityIndicator.startAnimating()
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
			self.download?.cancel()
			self.refreshControl.endRefreshing()
		}))
		
		alert.view.addSubview(activityIndicator)
		DispatchQueue.main.async {
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func displayError(error: URLError) {
		let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
		DispatchQueue.main.async {
			self.refreshControl.endRefreshing()
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func removeOverlay() {
		DispatchQueue.main.async {
			self.refreshControl.endRefreshing()
			self.dismiss(animated: true, completion: nil)
		}
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

/*extension WeatherController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
	
}
*/

