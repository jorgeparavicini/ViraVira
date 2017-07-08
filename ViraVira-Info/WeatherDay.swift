//
//  WeatherDay.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 6/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

class WeatherDay {
	
	var weatherModels: [WeatherModel]
	
	init() {
		self.weatherModels = [WeatherModel]()
	}
	
	init(weatherModels: [WeatherModel]) {
		self.weatherModels = weatherModels
	}
	
	/*func peakTemp() -> Double {
		var peak: Double = 0
		for timeStamp in weatherModels {
			if timeStamp.temp(unit: .Kelvin) > peak {
				peak = timeStamp.temp(unit: .Kelvin)
			}
		}
		
		return peak
	}*/
	
	func day() -> String? {
		if weatherModels.count == 0 {
			return nil
		}
		return weatherModels[0].day()
		
	}
	
	func description() -> String {
		return "UTC Time from: \(weatherModels[0].time) to: \(weatherModels[weatherModels.count - 1].time)"
	}
}
