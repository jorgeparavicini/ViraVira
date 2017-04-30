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
	
	/*let requiredInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
	
	override var separatorInset: UIEdgeInsets {
		didSet {
			print(separatorInset)
			if separatorInset != requiredInset {
				separatorInset = requiredInset
			}
		}
	}*/
	
	var weatherDays: [WeatherDay]? {
		didSet {
			self.reloadData()
		}
	}
	var viewController: WeatherController?
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let days = weatherDays {
			return days.count
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WeatherTableViewCell
		
		cell.dayTag.text = weatherDays?[indexPath.item].day()
		cell.collectionView.weatherDay = weatherDays![indexPath.item]
		cell.collectionView.delegate = cell.collectionView
		cell.collectionView.dataSource = cell.collectionView
		
		//tableView.separatorColor = UIColor.primary
		
		cell = setColor(for: cell)
		
		return cell
	}
	
	func setColor(for cell: WeatherTableViewCell) -> WeatherTableViewCell{
		cell.dayTag.textColor = UIColor.primary
		cell.collectionView.backgroundColor = UIColor.clear
		cell.backgroundColor = UIColor.clear
		
		return cell
	}
}
