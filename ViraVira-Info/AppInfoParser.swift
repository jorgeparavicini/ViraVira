//
//  AppInfoParser.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 7/07/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

class AppInfoParser {
	
	//Gets the api key from the appInfo plist
	public static var weatherApiKey: URL? {
		if let apiString = (plistData["API Keys"] as? [String: Any])?["Weather Key"] as? String {
			return URL(string: apiString)
		} else {
			return nil
		}
	}
	
	public static var excursionApiKey: URL? {
		if let apiString = (plistData["API Keys"] as? [String: Any])?["Excursion Key"] as? String {
			return URL(string: apiString)
		} else {
			return nil
		}
	}
	
	public static var temperature: Weather.Temperature {
		if let tempString = (plistData["User Preference"] as? [String: Any])?["Temperature"] as? String {
			if let temp = Weather.Temperature(rawValue: tempString) {
				return temp
			}
		}
		
		return Weather.Temperature.Celsius
	}
	
	private static var plistData: [String: Any] {
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
		
		return plistData
	}
}
