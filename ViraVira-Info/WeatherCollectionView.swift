//
//  WeatherCollectionReusableView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class WeatherCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	static let cellIdentifier = "WeatherCell"
	
	/*var weatherDay: WeatherDay? {
		didSet {
			self.reloadData()
		}
	}*/
	
	var weatherMaps: [Weather] = [] {
		didSet {
			self.reloadData()
		}
	}
	
	//var controllerView: WeatherController?
	
	func setColors(for cell: WeatherCollectionViewCell) {
		cell.timeStamp.textColor = UIColor.primary
		cell.temperature.textColor = UIColor.primary
		cell.icon.image = cell.icon.image?.withRenderingMode(.alwaysTemplate)
		cell.icon.tintColor = UIColor.primary
		
		self.backgroundColor = UIColor.clear
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return weatherMaps.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = dequeueReusableCell(withReuseIdentifier: WeatherCollectionView.cellIdentifier, for: indexPath) as! WeatherCollectionViewCell
		
		let weatherMap = weatherMaps[indexPath.item]
		
		cell.timeStamp.attributedText = NSAttributedString(string: weatherMap.time(), attributes: ViraViraFontAttributes.smallInfo)
		
		
		switch AppInfoParser.temperature {
		case .Celsius:
			cell.temperature.attributedText = NSAttributedString(string: String(format: "%.1f", weatherMap.mainTempCelsius) + "ºC", attributes: ViraViraFontAttributes.smallInfo)
			
		case .Fahrenheit:
			cell.temperature.attributedText = NSAttributedString(string: String(format: "%.1f", weatherMap.mainTempFahrenheit) + "ºF", attributes: ViraViraFontAttributes.smallInfo)
			
		case .Kelvin:
			cell.temperature.attributedText = NSAttributedString(string: String(format: "%.1f", weatherMap.mainTempKelvin) + "ºK", attributes: ViraViraFontAttributes.smallInfo)
		}
		
		cell.icon.image = weatherMap.weather0Icon != nil ? Weather.icons[weatherMap.weather0Icon!] : nil
		
		setColors(for: cell)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		switch UIScreen.traits {
		case (.regular, .regular):
			return CGSize(width: 150, height: 150)
		default:
			return CGSize(width: 75, height: 75)
		}
	}
}
