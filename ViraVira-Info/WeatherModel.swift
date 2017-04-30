//
//  WeatherModel.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 5/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

class WeatherModel {
	var time: NSDate
	//This has to be in KELVIN ALWAYS
	private var temp: Double
	var pressure: Double
	var humidity: Double
	
	var weatherMain: String
	var weatherDescription: String
	var iconID: String
	var icon: UIImage? {
		return WeatherModel.icons[iconID]
	}
	
	//Clouds in percentage
	var clouds: Float
	var windSpeed: Double
	//Wind direction in degrees
	var windDir: Float
	
	//Amount of rain in the past 3 hours
	var rain: Double
	
	static let icons: [String : UIImage] = ["01d": #imageLiteral(resourceName: "01d"), "01n": #imageLiteral(resourceName: "01n"), "02d": #imageLiteral(resourceName: "02d"), "02n": #imageLiteral(resourceName: "02n"), "03d": #imageLiteral(resourceName: "03d"), "03n": #imageLiteral(resourceName: "03n"), "04d": #imageLiteral(resourceName: "04d"), "04n": #imageLiteral(resourceName: "04n"), "09d": #imageLiteral(resourceName: "09d"), "09n": #imageLiteral(resourceName: "09n"), "10d": #imageLiteral(resourceName: "10d"), "10n": #imageLiteral(resourceName: "10n"), "11d": #imageLiteral(resourceName: "11d"), "11n": #imageLiteral(resourceName: "11n"), "13d": #imageLiteral(resourceName: "13d"), "13n": #imageLiteral(resourceName: "13n"), "50d": #imageLiteral(resourceName: "50d"), "50n": #imageLiteral(resourceName: "50n")]
	
	init(time: Int, temp: Double, pressure: Double, humidity: Double, weatherMain: String, weatherDescription: String, iconID: String, clouds: Float, windSpeed: Double, windDir: Float, rain: Double?) {
		self.time = NSDate(timeIntervalSince1970: TimeInterval(time))
		self.temp = temp
		self.pressure = pressure
		self.humidity = humidity
		self.weatherMain = weatherMain
		self.weatherDescription = weatherDescription
		self.iconID = iconID
		
		self.clouds = clouds
		self.windSpeed = windSpeed
		self.windDir = windDir
		
		if let rainAmount = rain {
			self.rain = rainAmount
		} else {
			self.rain = 0
		}
	}
	
	func description() -> String {
		return "At \(time) the temperature will be at \(temp) degrees kelvin, \(pressure) hPa, \(humidity) % Humid. weather main: \(weatherMain), weather description: \(weatherDescription), iconID: \(iconID), clouds %: \(clouds), windSpeed: \(windSpeed), windDirection: \(windDir), rain int the last 3 hours: \(rain) mm."
	}
	
	func temp(unit: Weather.TemperatureUnits) -> Double{
		switch unit {
		case .Celsius:
			return temp - 273.15
			
		case .Kelvin:
			return temp
			
		case .Fahrenheit:
			return (9/5)*(temp - 273.15)+32
		}
	}
	
	func temp(unit: Weather.TemperatureUnits, roundToDecimal: Int) -> Double {
		var roundFactor = 1
		for _ in 0..<roundToDecimal {
			roundFactor *= 10
		}
		
		return Double(round(temp(unit: unit)*Double(roundFactor))/Double(roundFactor))
	}
	
	func day() -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE"
		
		return dateFormatter.string(from: time as Date)
		
	}
	
	func timeStamp() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH"
		
		return dateFormatter.string(from: time as Date)
	}
}

extension Array where Element:WeatherModel {
	func createWeatherDays() -> [WeatherDay] {
		var weatherDays = [WeatherDay]()
		var currentWeatherDay: WeatherDay?
		for weather in self {
			if currentWeatherDay == nil {
				currentWeatherDay = WeatherDay()
				currentWeatherDay?.weatherModels.append(weather)
				continue
			} else if currentWeatherDay?.day() == weather.day() {
				currentWeatherDay?.weatherModels.append(weather)
			} else if currentWeatherDay?.day() != weather.day() {
				weatherDays.append(currentWeatherDay!)
				currentWeatherDay = WeatherDay()
				currentWeatherDay?.weatherModels.append(weather)
			}
		}
		if currentWeatherDay != nil {
			weatherDays.append(currentWeatherDay!)
		}
		return weatherDays
	}
}

class Weather {
	enum TemperatureUnits {
		case Kelvin
		case Celsius
		case Fahrenheit
	}
}
