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
	var weatherDay: WeatherDay? {
		didSet {
			self.reloadData()
		}
	}
	
	var controllerView: WeatherController?
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let forecasts = weatherDay?.weatherModels {
			return forecasts.count
		} else {
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = dequeueReusableCell(withReuseIdentifier: WeatherCollectionView.cellIdentifier, for: indexPath) as! WeatherCollectionViewCell
		
		let weatherModel = weatherDay!.weatherModels[indexPath.item]
		
		cell.timeStamp.attributedText = NSAttributedString(string: weatherModel.timeStamp(), attributes: ViraViraFontAttributes.smallInfo)
		
		var tempUnit = Weather.TemperatureUnits.Celsius
		if controllerView != nil {
			tempUnit = controllerView!.tempUnit
		}
		cell.temperature.attributedText = NSAttributedString(string: "\(weatherModel.temp(unit: tempUnit, roundToDecimal: 1))°", attributes: ViraViraFontAttributes.description)
		cell.icon.image = weatherModel.icon
		
		setColors(for: cell)
		
		return cell
	}
	
	func setColors(for cell: WeatherCollectionViewCell) {
		cell.timeStamp.textColor = UIColor.primary
		cell.temperature.textColor = UIColor.primary
		cell.icon.image = cell.icon.image?.withRenderingMode(.alwaysTemplate)
		cell.icon.tintColor = UIColor.primary
		
		self.backgroundColor = UIColor.clear
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
