//
//  WeatherParser.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 3/07/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

class WeatherParser {
	
	static var shared = WeatherParser()
	
	private var cache = NSCache<NSString, [WeatherModel]>()
	
	private var download: URLSessionTask? = nil
	
	private var apiKey: URL? {
		get {
			let plistPath = Bundle.main.path(forResource: "appInfo", ofType: "plist")!
			let contentOfPlist = FileManager.default.contents(atPath: plistPath)!
			var plistData: [String: Any] = [:]
			var format = PropertyListSerialization.PropertyListFormat.xml
			
			do {
				plistData = try PropertyListSerialization.propertyList(from: contentOfPlist,
				                                                       options: .mutableContainersAndLeaves,
				                                                       format: &format) as! [String: Any]
			} catch {
				print(error)
			}
			
			if let apiString = (plistData["API Keys"] as? [String: Any])?["Weather Key"] as? String {
				return URL(string: apiString)
			} else {
				return nil
			}
			
		}
	}
	
	public func getExcursionModels(completion: @escaping ([WeatherModel]?) -> Void) {
		completion(loadCachedWeatherModels())
		
		if NetworkManager.connectedToNetwork() {
			
			downloadExcursionData(completion: {(data) in
				if data != nil {
					let parsedData = self.parseExcursion(data: data!)
					cache(parsedData)
					completion(parsedData)
				}
			})
		} else {
			let alert = UIAlertController(title: "Internet Connection appears to be offline", message: "Reconnect to the Internet to access data", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
			
			Menu.currentRootViewController.present(alert, animated: true, completion: nil)
		}
	}
	
	private func downloadExcursionData(completion: @escaping (NSArray?) -> Void) {
		guard apiKey != nil else {return}
		download = URLSession.shared.dataTask(with: apiKey!) { (data, response, error) in
			if error != nil {
				print(error)
			} else {
				do {
					let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
				
					completion(parsedData["list"] as! NSArray)
				} catch {
					print(error)
				}
			}
		}
	}
	
	private func parseExcursion(data: NSArray) -> [WeatherModel] {
		var models = [WeatherModel]()
		
		for index in 0..<data.count {
			let element = data[index] as! [String: Any]
			
			let timeStamp = element["dt"] as! Int
			let main = element["main"] as! [String: Any]
			let temp = main["temp"] as! Double
			let pressure = main["pressure"] as! Double
			let humidity = main["humidity"] as! Double
			
			let weatherArray = element["weather"] as! NSArray
			let weather = weatherArray[0] as! [String: Any]
			
			let weatherMain = weather["main"] as! String
			let weatherDescription = weather["description"] as! String
			let weatherIconID = weather["icon"] as! String
			
			let clouds = (element["clouds"] as! [String: Any])["all"] as! Float
			
			let wind = element["wind"] as! [String: Any]
			let windSpeed = wind["speed"] as! Double
			let windDirection = wind["deg"] as! Float
			
			let rain = element["rain"] as? [String: Any]
			let rainAmount = rain?["3h"] as? Double
			
			models.append(
				WeatherModel(time: timeStamp,
				             temp: temp,
				             pressure: pressure,
				             humidity: humidity,
				             weatherMain: weatherMain,
				             weatherDescription: weatherDescription,
				             iconID: weatherIconID,
				             clouds: clouds,
				             windSpeed: windSpeed,
				             windDir: windDirection,
				             rain: rainAmount)
			)
		}
		
		return models
	}
	
	private func cache(weatherModels: [WeatherModel]) {
		cache.setObject(weatherModels, forKey: "weatherModels")
	}
	
	private func loadCachedWeatherModels() -> [WeatherModel]? {
		return cache.object(forKey: "weatherModels")
	}
}

/*func updateWeather(){
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
}*/
