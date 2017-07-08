//
//  WeatherParser.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 3/07/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation
import Cache
import Alamofire
import CoreData

protocol WeatherParserDelegate {
	func didStartDownload()
	func didEndDownload()
}

class WeatherParser {
	
	//MARK: - Properties
	
	//Singleton
	static var shared = WeatherParser()
	
	//Alamofire manager that manages the download of the API
	private var manager: SessionManager
	
	public var delegate: WeatherParserDelegate?
	
	
	//Should we print any errors found to the console?
	private let kDebugOn: Bool = true
	
	//Should we print all processes to the console?
	private let kDebugDetailOn: Bool = false
	
	//Time interval in minutes that determines if new version should be downloaded
	private let kDataCacheIntervalInSeconds: Double = 180*60
	
	//MARK: JSON Codes
	//JSON Names - These are the corresponding names of the JSON fields from the OpenWeatherMap API
	private let kJsonBase = "base"
	private let kJsonCod = "cod"
	private let kJsonMessage = "message"
	private let kJsonCnt = "cnt"
	
	private let kJsonList = "list"
	
	private let kJsonListDt = "dt"
	private let kJsonListDtText = "dt_txt"
	
	private let kJsonListMain = "main"
	private let kJsonListMainHumidity = "humidity"
	private let kJsonListMainTempMin = "temp_min"
	private let kJsonListMainTempMax = "temp_max"
	private let kJsonListMainTemp = "temp"
	private let kJsonListMainPressure = "pressure"
	private let kJsonListMainGrndLevel = "grnd_level"
	private let kJsonListMainSeaLevel = "sea_level"
	
	private let kJsonListWeather = "weather"
	private let kJsonList0WeatherId = "id"
	private let kJsonList0WeatherMain = "main"
	private let kJsonList0WeatherIcon = "icon"
	private let kJsonList0WeatherDescription = "description"
	private let kJsonList1WeatherId = "id"
	private let kJsonList1WeatherMain = "main"
	private let kJsonList1WeatherIcon = "icon"
	private let kJsonList1WeatherDescription = "description"
	
	private let kJsonListClouds = "clouds"
	private let kJsonListCloudsAll = "all"
	
	private let kJsonListWind = "wind"
	private let kJsonListWindSpeed = "speed"
	private let kJsonListWindDeg = "deg"
	
	private let kJsonListRain = "rain"
	private let kJsonListRain3h = "3h"
	
	private let kJsonListSnow = "snow"
	private let kJsonListSnow3h = "3h"
	
	private let kJsonListSys = "sys"
	private let kJsonListSysType = "type"
	private let kJsonListSysId = "id"
	private let kJsonListSysMessage = "message"
	private let kJsonListSysCountry = "country"
	private let kJsonListSysSunset = "sunset"
	private let kJsonListSysSunrise = "sunrise"
	
	private let kJsonCity = "city"
	private let kJsonCityId = "id"
	private let kJsonCityName = "name"
	private let kJsonCityCoord = "coord"
	private let kJsonCityCoordLon = "lon"
	private let kJsonCityCoordLat = "lat"
	private let kJsonCityCountry = "country"
	
	//MARK: Core Data Codes
	//Entity Names - Names of corresponding values in the CoreData 'Entity' - Weather
	private let kEntityWeather = "Weather"
	
	private let kEntityBase = "base"
	private let kEntityCod = "cod"
	private let kEntityMessage = "message"
	private let kEntityCnt = "cnt"
	
	private let kEntityDt = "dateTime"
	private let kEntityDtText = "dateText"
	
	private let kEntityMainHumidity = "mainHumidity"
	private let kEntityMainTempKelvin = "mainTempKelvin"
	private let kEntityMainTempMinKelvin = "mainTempMinKelvin"
	private let kEntityMainTempMaxKelvin = "mainTempMaxKelvin"
	private let kEntityMainTempCelsius = "mainTempCelsius"
	private let kEntityMainTempMinCelsius = "mainTempMinCelsius"
	private let kEntityMainTempMaxCelsius = "mainTempMaxCelsius"
	private let kEntityMainTempFahrenheit = "mainTempFahrenheit"
	private let kEntityMainTempMinFahrenheit = "mainTempMinFahrenheit"
	private let kEntityMainTempMaxFahrenheit = "mainTempMaxFahrenheit"
	private let kEntityMainPressure = "mainPressure"
	private let kEntityMainGrndLevel = "mainGroundLevel"
	private let kEntityMainSeaLevel = "mainSeaLevel"
	
	private let kEntityWeather0Id = "weather0ID"
	private let kEntityWeather0Main = "weather0Main"
	private let kEntityWeather0Icon = "weather0Icon"
	private let kEntityWeather0Description = "weather0Description"
	private let kEntityWeather1Id = "weather1ID"
	private let kEntityWeather1Main = "weather1Main"
	private let kEntityWeather1Icon = "weather1Icon"
	private let kEntityWeather1Description = "weather1Description"
	
	private let kEntityCloudsAll = "cloudsAll"
	
	private let kEntityWindSpeed = "windSpeed"
	private let kEntityWindDeg = "windDirection"
	
	private let kEntityRain3h = "rainThreeHour"
	
	private let kEntitySnow3h = "snowThreeHour"
	
	private let kEntitySysType = "sysType"
	private let kEntitySysId = "sysId"
	private let kEntitySysMessage = "sysMessage"
	private let kEntitySysCountry = "sysCountry"
	private let kEntitySysSunset = "sysSunset"
	private let kEntitySysSunrise = "sysSunrise"
	
	private let kEntityCityId = "identifier"
	private let kEntityCityName = "cityName"
	private let kEntityCityCountry = "country"
	
	private let kEntityCityCoordLon = "coordLon"
	private let kEntityCityCoordLat = "coordLat"
	
	private let kEntityFetchDate = "serverFetchDate"
	
	
	
	
	//MARK: - Constructers
	
	//Default Constructer
	init() {
		manager = SessionManager.default
	}
	
	
	
	
	//MARK: - Download API
	
	private func downloadAPI(completion: @escaping (NSDictionary) -> Void) {
		guard let url = AppInfoParser.weatherApiKey else {
			if kDebugOn{
				print("Error: Could not load API Key from .plist")
			}
			return
		}
		
		delegate?.didStartDownload()
		
		manager.request(url).responseJSON(completionHandler: { response in
			switch response.result {
			case .success(let value):
				completion(value as! NSDictionary)
				
			case .failure(let error as NSError):
				if self.kDebugOn {
					print("Error: \"\(error.code)\", \(error.localizedDescription)")
				}
				
			default:
				if self.kDebugOn {
					print("Unrecognized result received from Alamofire request")
				}
			}
			
			self.delegate?.didEndDownload()
		})
	}
	
	
	
	public func loadWeatherMaps(completion: @escaping ([Weather]) -> Void) {
		
		//Initialize the variable that will hold the Weather models, regardless of method used
		var models: [Weather] = []
		
		let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
		
		//Get the CoreData Weather Context
		let managedContext = appDelegate.persistentContainer.viewContext
		
		//Create a Fetch Request for the Weather Entity from the Weather Context
		let fetchRequest = NSFetchRequest<Weather>(entityName: "Weather")
		
		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Weather"))
		
		//Hold the error used to debug
		var error: NSError? = nil
		
		//Should we download a new version or just used fetched data
		var needToDownload = false
		
		//Fetch any Weather models from the fetch Request
		do {
			if kDebugDetailOn {
				print("Fetching Weather Maps")
			}
			models = try managedContext.fetch(fetchRequest)
			if kDebugDetailOn {
				print("Fetched \(models.count) Weather Maps")
			}
		} catch let catchedError as NSError {
			
			//Store the error for later debuging
			error = catchedError
		}
		
		//Handle the error
		if error != nil {
			if kDebugOn {
				print("Error: \"\(error!.code)\", \(error!.localizedDescription)")
			}
		} else if models.count == 0 { //If models count equals 0 then download the weather maps
			
			if kDebugDetailOn {
				print("No models found, will download new version.")
			}
			
			needToDownload = true
			
		} else {
			//Compare fetched time to now, if bigger than interval X need to download new version
			let now = Date()
			let fetchDate = models[0].value(forKey: kEntityFetchDate) as! Date
			
			var interval = TimeInterval()
			
			var isInvalid = false
			
			switch fetchDate.compare(now) {
			case .orderedAscending:
				interval = DateInterval(start: fetchDate, end: now).duration
			default:
				isInvalid = true
			}
			
			
			if interval > kDataCacheIntervalInSeconds || isInvalid {
				if kDebugDetailOn {
					print("Fetched data out of date, downloading new version.")
				}
				//Set download mask to true and return out of date models as placeholder
				needToDownload = true
				
				completion(models)
			} else {
				if kDebugDetailOn {
					print("Fetched data up to date, returning it.")
				}
				//Return fetched data
				completion(models)
			}
		}
		
		if needToDownload {
			if kDebugDetailOn {
				print("Connecting to Weather API Server...")
			}
			
			//Download the JSON Dictionary from Open Weather Maps API
			downloadAPI() {(weatherDictionary) in
				
				//print(models)
				
				do {
					try managedContext.execute(batchDeleteRequest)
				} catch let error as NSError {
					if self.kDebugOn {
						print("Error: \"\(error.code)\", \(error.localizedDescription)")
					}
				}
				
				models.removeAll()
				
				//Parse the downloaded JSON file
				
				let list = weatherDictionary["list"] as! NSArray
				
				for index in 0..<list.count {
					//var apiItem = list[index] as! [String: Any]
					
					//Initialize new Core Data Object of type Weather
					let model = Weather(context: managedContext)
					
					//Assign Base value
					if let base = weatherDictionary[self.kJsonBase] as? String {
						model.setValue(base, forKey: self.kEntityBase)
					}
					
					//COD
					if let cod = weatherDictionary[self.kJsonCod] as? Double{
						model.setValue(cod, forKey: self.kEntityCod)
					}
					
					//Message
					if let message = weatherDictionary[self.kJsonMessage] as? String {
						model.setValue(message, forKey: self.kEntityMessage)
					}
					
					//CNT
					if let cnt = weatherDictionary[self.kJsonCnt] as? Double{
						model.setValue(cnt, forKey: self.kEntityCnt)
					}
					
					//List
					if let list = weatherDictionary[self.kJsonList] as? NSArray {
						//Item
						if let item = list[index] as? [String: Any] {
							//dt
							if let dt = item[self.kJsonListDt] as? Double {
								let date = Date(timeIntervalSince1970: dt)
								model.setValue(date, forKey: self.kEntityDt)
							}
							
							//dt_txt
							if let dt_txt = item[self.kJsonListDtText] as? String {
								model.setValue(dt_txt, forKey: self.kEntityDtText)
							}
							
							//Main
							if let main = item[self.kJsonListMain] as? [String: Any] {
								
								//Temp
								if let temp = main[self.kJsonListMainTemp] as? Double {
									//Temp is in Kelvin
									//Kelvin
									model.setValue(temp, forKey: self.kEntityMainTempKelvin)
									
									//Celsius
									let tempC = temp - 273.15
									model.setValue(tempC, forKey: self.kEntityMainTempCelsius)
									
									//Fahrenheit
									let tempF = temp * (9/5) - 459.67
									model.setValue(tempF, forKey: self.kEntityMainTempFahrenheit)
								}
								
								//Min temp
								if let tempMin = main[self.kJsonListMainTempMin] as? Double {
									//TempMin is in Kelvin
									//Kelvin
									model.setValue(tempMin, forKey: self.kEntityMainTempMinKelvin)
									
									//Celsius
									let tempC = tempMin - 273.15
									model.setValue(tempC, forKey: self.kEntityMainTempMinCelsius)
									
									//Fahrenheit
									let tempF = tempMin * (9/5) - 459.67
									model.setValue(tempF, forKey: self.kEntityMainTempMinFahrenheit)
								}
								
								//Max temp
								if let tempMax = main[self.kJsonListMainTempMax] as? Double {
									//TempMax is in Kelvin
									//Kelvin
									model.setValue(tempMax, forKey: self.kEntityMainTempMaxKelvin)
									
									//Celsius
									let tempC = tempMax - 273.15
									model.setValue(tempC, forKey: self.kEntityMainTempMaxCelsius)
									
									//Fahrenheit
									let tempF = tempMax * (9/5) - 459.67
									model.setValue(tempF, forKey: self.kEntityMainTempMaxFahrenheit)
								}
								
								//Pressure
								if let pressure = main[self.kJsonListMainPressure] as? Double {
									model.setValue(pressure, forKey: self.kEntityMainPressure)
								}
								
								//Sea level
								if let seaLevel = main[self.kJsonListMainSeaLevel] as? Double {
									model.setValue(seaLevel, forKey: self.kEntityMainSeaLevel)
								}
								
								//Ground Level
								if let groundLevel = main[self.kJsonListMainGrndLevel] as? Double {
									model.setValue(groundLevel, forKey: self.kEntityMainGrndLevel)
								}
								
								//Humidity
								if let humidity = main[self.kJsonListMainHumidity] as? Double {
									model.setValue(humidity, forKey: self.kEntityMainHumidity)
								}
							}
							
							//Weather
							if let weather = item[self.kJsonListWeather] as? NSArray {
								//First Item
								if weather.count > 0, let first = weather[0] as? [String: Any] {
									
									//Id
									if let id = first[self.kJsonList0WeatherId] as? Double {
										model.setValue(id, forKey: self.kEntityWeather0Id)
									}
									
									//Main
									if let main = first[self.kJsonList0WeatherMain] as? String {
										model.setValue(main, forKey: self.kEntityWeather0Main)
									}
									
									//Description
									if let description = first[self.kJsonList0WeatherDescription] as? String {
										model.setValue(description, forKey: self.kEntityWeather0Description)
									}
									
									//Icon
									if let icon = first[self.kJsonList0WeatherIcon] as? String {
										model.setValue(icon, forKey: self.kEntityWeather0Icon)
									}
								}
								
								//Second Item
								if weather.count > 1, let second = weather[1] as? [String: Any] {
									
									//Id
									if let id = second[self.kJsonList1WeatherId] as? Double {
										model.setValue(id, forKey: self.kEntityWeather1Id)
									}
									
									//Main
									if let main = second[self.kJsonList1WeatherMain] as? String {
										model.setValue(main, forKey: self.kEntityWeather1Main)
									}
									
									//Description
									if let description = second[self.kJsonList0WeatherDescription] as? String {
										model.setValue(description, forKey: self.kEntityWeather1Description)
									}
									
									//Icon
									if let icon = second[self.kJsonList0WeatherIcon] as? String {
										model.setValue(icon, forKey: self.kEntityWeather1Icon)
									}
								}
							}
							
							//Clouds
							if let clouds = item[self.kJsonListClouds] as? [String: Any] {
								//All Clouds
								if let allClouds = clouds[self.kJsonListCloudsAll] as? Double {
									model.setValue(allClouds, forKey: self.kEntityCloudsAll)
								}
							}
							
							//Wind
							if let wind = item[self.kJsonListWind] as? [String: Any] {
								//Speed
								if let speed = wind[self.kJsonListWindSpeed] as? Double {
									model.setValue(speed, forKey: self.kEntityWindSpeed)
								}
								
								//Direction
								if let direction = wind[self.kJsonListWindDeg] as? Double {
									model.setValue(direction, forKey: self.kEntityWindDeg)
								}
							}
							
							//Rain
							if let rain = item[self.kJsonListRain] as? [String: Any] {
								//Three Hour
								if let threeHour = rain[self.kJsonListRain3h] as? Double {
									model.setValue(threeHour, forKey: self.kEntityRain3h)
								}
							}
							
							//Snow 
							if let snow = item[self.kJsonListSnow] as? [String: Any] {
								//Three Hour
								if let threeHour = snow[self.kJsonListSnow3h] as? Double {
									model.setValue(threeHour, forKey: self.kEntitySnow3h)
								}
							}
							
							//Sys
							if let sys = item[self.kJsonListSys] as? [String: Any] {
								//Id
								if let id = sys[self.kJsonListSysId] as? Double {
									model.setValue(id, forKey: self.kEntitySysId)
								}
								
								//Message
								if let message = sys[self.kJsonListSysMessage] as? Double {
									model.setValue(message, forKey: self.kEntitySysMessage)
								}
								
								//Country
								if let country = sys[self.kJsonListSysCountry] as? String {
									model.setValue(country, forKey: self.kEntitySysCountry)
								}
								
								//Sunset
								if let sunset = sys[self.kJsonListSysSunset] as? Double {
									let date = Date(timeIntervalSince1970: sunset)
									model.setValue(date, forKey: self.kEntitySysSunset)
								}
								
								//Sunrise
								if let sunrise = sys[self.kJsonListSysSunrise] as? Double {
									let date = Date(timeIntervalSince1970: sunrise)
									model.setValue(date, forKey: self.kEntitySysSunrise)
								}
							}
						}
					}
					
					//City
					if let city = weatherDictionary[self.kJsonCity] as? [String: Any] {
						//ID
						if let id = city[self.kJsonCityId] as? Double {
							model.setValue(id, forKey: self.kEntityCityId)
						}
						
						//Name
						if let name = city[self.kJsonCityName] as? String {
							model.setValue(name, forKey: self.kEntityCityName)
						}
						
						//Coord
						if let coord = city[self.kJsonCityCoord] as? [String: Any] {
							//Lat
							if let lat = coord[self.kJsonCityCoordLat] as? Double {
								model.setValue(lat, forKey: self.kEntityCityCoordLat)
							}
							
							//Lon
							if let lon = coord[self.kJsonCityCoordLon] as? Double {
								model.setValue(lon, forKey: self.kEntityCityCoordLon)
							}
						}
						
						//Country
						if let country = city[self.kJsonCityCountry] as? String {
							model.setValue(country, forKey: self.kEntityCityCountry)
						}
					}
					
					//Fetch Date
					
					model.setValue(Date(), forKey: self.kEntityFetchDate)
					
					models.append(model)
				}
				
				if self.kDebugDetailOn {
					print("Finished parsing API, returning...")
				}
				
				completion(models)
				
			}
			
			appDelegate.saveContext()
			
		}
	}
	
	
	
	
	
	
	/*private func test() {
	var models: [NSManagedObject] = []
	
	let managedContext = persistentContainer.viewContext
	
	let entity = NSEntityDescription.entity(forEntityName: "Weather", in: managedContext)!
	
	let model = NSManagedObject(entity: entity, insertInto: managedContext)
	
	model.setValue("Pucon", forKey: "cityName")
	
	models.append(model)
	print(model)
	}
	
	private func save(json: NSDictionary, completion: (Bool) -> Void) {
	var models: [NSManagedObject] = []
	
	let managedContext = persistentContainer.viewContext
	let entity = NSEntityDescription.entity(forEntityName: "Weather", in: managedContext)!
	
	let list = json["list"] as! NSArray
	for index in 0..<list.count {
	let model = NSManagedObject(entity: entity, insertInto: managedContext)
	
	
	
	models.append(model)
	}
	}*/
	
	/*public func getExcursionModels(completion: @escaping ([WeatherModel]?) -> Void) {
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
	}*/
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
