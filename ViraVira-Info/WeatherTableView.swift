//
//  WeatherTableView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class WeatherTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
	let cellIdentifier = "WeatherTableCell"
	
	var weatherDays: [WeatherDay]? {
		didSet {
			self.reloadData()
		}
	}
	
	var weatherMaps: [[Weather]] = [] {
		didSet {
			self.reloadData()
		}
	}
	
	var viewController: WeatherController?
	
	func setColor(for cell: WeatherTableViewCell) -> WeatherTableViewCell{
		cell.dayTag.textColor = UIColor.primary
		cell.collectionView.backgroundColor = UIColor.clear
		cell.backgroundColor = UIColor.clear
		
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return weatherMaps.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WeatherTableViewCell
		
		if let map = weatherMaps[indexPath.row].first {
			cell.dayTag.attributedText = NSAttributedString(string: map.day(), attributes: ViraViraFontAttributes.cellTitles)
		}
		
		if weatherMaps.count > indexPath.row {
			let maps = weatherMaps[indexPath.row]
			cell.collectionView.weatherMaps = maps
		}
		
		
		cell.collectionView.delegate = cell.collectionView
		cell.collectionView.dataSource = cell.collectionView
		
		cell = setColor(for: cell)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch UIScreen.traits {
		case (.regular, .regular):
			return 200
			
		default:
			return 125
		}
	}
}
