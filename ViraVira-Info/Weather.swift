//
//  Weather.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 7/07/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension Weather {
	static let icons: [String : UIImage] = ["01d": #imageLiteral(resourceName: "01d"), "01n": #imageLiteral(resourceName: "01n"), "02d": #imageLiteral(resourceName: "02d"), "02n": #imageLiteral(resourceName: "02n"), "03d": #imageLiteral(resourceName: "03d"), "03n": #imageLiteral(resourceName: "03n"), "04d": #imageLiteral(resourceName: "04d"), "04n": #imageLiteral(resourceName: "04n"), "09d": #imageLiteral(resourceName: "09d"), "09n": #imageLiteral(resourceName: "09n"), "10d": #imageLiteral(resourceName: "10d"), "10n": #imageLiteral(resourceName: "10n"), "11d": #imageLiteral(resourceName: "11d"), "11n": #imageLiteral(resourceName: "11n"), "13d": #imageLiteral(resourceName: "13d"), "13n": #imageLiteral(resourceName: "13n"), "50d": #imageLiteral(resourceName: "50d"), "50n": #imageLiteral(resourceName: "50n")]
	
	enum Temperature: String {
		case Kelvin
		case Celsius
		case Fahrenheit
	}
	
	func day() -> String {
		
		guard dateTime != nil else { return "" }
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE"
		
		return dateFormatter.string(from: dateTime! as Date)
		
	}
	
	func time() -> String {
		
		guard dateTime != nil else { return "" }
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH"
		
		return dateFormatter.string(from: dateTime! as Date)
	}
}
