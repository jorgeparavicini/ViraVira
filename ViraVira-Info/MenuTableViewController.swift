//
//  MenuTableViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit
import MapKit

struct JPMenuItem: Equatable {
	var title: String
	var image: UIImage
	var segueIdentifier: String
	
	static let home = JPMenuItem(title: "Home", image: #imageLiteral(resourceName: "home"), segueIdentifier: "HomeSegue")
	static let info = JPMenuItem(title: "Info", image: #imageLiteral(resourceName: "info"), segueIdentifier: "InfoSegue")
	static let weather = JPMenuItem(title: "Weather", image: #imageLiteral(resourceName: "Weather"), segueIdentifier: "WeatherSegue")
	static let excursion = JPMenuItem(title: "Excursions", image: #imageLiteral(resourceName: "excursion"), segueIdentifier: "ExcursionSegue")
	static let massage = JPMenuItem(title: "Massage", image: #imageLiteral(resourceName: "massage"), segueIdentifier: "SpaSegue")
	static let followUs = JPMenuItem(title: "Follow Us", image: #imageLiteral(resourceName: "follow_us"), segueIdentifier: "FollowUsSegue")
	static let settings = JPMenuItem(title: "Settings", image: #imageLiteral(resourceName: "Settings"), segueIdentifier: "SettingsSegue")
}

func ==(lhsItem: JPMenuItem, rhsItem: JPMenuItem) -> Bool {
	return (lhsItem.title == rhsItem.title && lhsItem.image.isEqual(rhsItem.image) && lhsItem.segueIdentifier == rhsItem.segueIdentifier)
}

class MenuTableViewController: UITableViewController, SWRevealViewControllerDelegate, CLLocationManagerDelegate {
	
	var menuItems: [JPMenuItem] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	
	static var currentItem: JPMenuItem = .home
	
	static var backGroundColor: UIColor = UIColor.secondary
	static var fontColor: UIColor = UIColor.primary

	
	let locationManager = CLLocationManager()

	let identifier = "MenuCell"
	
	var userLocation: CLLocation? {
		didSet {
			createMenu()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: identifier)
		
		self.view.backgroundColor = MenuTableViewController.backGroundColor
		self.tableView.separatorColor = MenuTableViewController.fontColor
		
		self.revealViewController().frontViewShadowColor = UIColor.primary
		
		//self.revealViewController().delegate = self
		
		createMenu()
		
		locationManager.requestWhenInUseAuthorization()
		locationManager.delegate = self
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			if #available(iOS 9.0, *) {
				locationManager.requestLocation()
			}
		}
    }
	
	func createMenu() {
		var items = [JPMenuItem]()
		items.append(.home)
		items.append(.info)
		items.append(.weather)
		items.append(.excursion)
		if userInHotel() {
			items.append(.massage)
		}
		items.append(.followUs)
		
		menuItems = items
	}
	
	func userInHotel() -> Bool {
		guard userLocation != nil else {return false}
		let mapPoint = MKMapPointForCoordinate(userLocation!.coordinate)
		if MKMapRectContainsPoint(Constants.hotelRegion, mapPoint) {
			return true
		} else {
			return false
		}
	}
	
	//MARK: - Location Services
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			userLocation = location
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		let alert = UIAlertController(title: "Could not get user position", message: error.localizedDescription, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MenuTableViewCell else {fatalError("Could not dequeue cell with identifier: \(identifier)")}
		
		cell.imageCell?.image = menuItems[indexPath.row].image
		cell.imageCell.image = cell.imageCell.image?.withRenderingMode(.alwaysTemplate)
		cell.imageCell.tintAdjustmentMode = .normal
		cell.imageCell.tintColor = MenuTableViewController.fontColor
		cell.imageCell.backgroundColor = UIColor.clear
		
		cell.title?.text = menuItems[indexPath.row].title
		cell.title.textColor = MenuTableViewController.fontColor
		cell.title.backgroundColor = UIColor.clear
		
		cell.backgroundColor = MenuTableViewController.backGroundColor
		
		cell.selector.backgroundColor = MenuTableViewController.fontColor
		
		if MenuTableViewController.currentItem == menuItems[indexPath.row] {
			cell.selector?.isHidden = false
		} else {
			cell.selector?.isHidden = true
		}
		
		return cell
	}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let lastItem = MenuTableViewController.currentItem
		MenuTableViewController.currentItem = menuItems[indexPath.row]
		tableView.reloadData()
		if shouldPerformSegue(withIdentifier: lastItem.segueIdentifier, sender: self) {
			performSegue(withIdentifier: MenuTableViewController.currentItem.segueIdentifier, sender: self)
		} else {
			let revealViewController = Menu.currentRootViewController.revealViewController()
			revealViewController?.revealToggle(animated: true)
		}
	}
	
	
	
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		
		if identifier != MenuTableViewController.currentItem.segueIdentifier {
			return true
		} else {
			return false
		}
	}
}
