//
//  InformationController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 19/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit

struct InfoMenuItem {
	var title: String
	var icon: UIImage?
	var viewController: String
	
	static let wellness = InfoMenuItem(title: "Wellness", icon: nil, viewController: "WellnessViewController")
	static let usefullInformation = InfoMenuItem(title: "Useful Information", icon: nil, viewController: "UsefullInformationViewController")
	static let facilityMap = InfoMenuItem(title: "Facility Map", icon: nil, viewController: "FacilityMapViewController")
	static let roomService = InfoMenuItem(title: "Room Service", icon: nil, viewController: "RoomServiceViewController")
	static let minibar = InfoMenuItem(title: "Minibar", icon: nil, viewController: "MinibarViewController")
	static let pillowMenu = InfoMenuItem(title: "Pillow Menu", icon: nil, viewController: "PillowMenuViewController")
}

class InformationController: UITableViewController, SWRevealViewControllerDelegate {
    //MARK: - Properties
	
	@IBOutlet weak var navBar: UINavigationItem!
	var menuButton: UIButtonAnimation! = nil
	var comesFromSegue: Bool = false
	
	var menuItems: [InfoMenuItem] = [.wellness, .usefullInformation, .roomService, .minibar, .pillowMenu, .facilityMap]
	
	let identifier = "cell"
	let iconWidthMultiplier: CGFloat = 0.1
	let cellHeightMultiplier: CGFloat = 0.1
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		navBar?.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		
		
		
		Menu.currentRootViewController = self
		
		setColors()
	}
	
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
		self.tableView.separatorColor = UIColor.primary
		
	}
	
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
	
	
	
//	MARK: - Tableview data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! InfoTableViewCell
		
		guard menuItems.count > indexPath.row else {return cell}
		let item = menuItems[indexPath.row]
		
		cell.title.text = item.title
		cell.title.adjustsFontSizeToFitWidth = true
		//cell.title.font = cell.title.font.withSize(fontSize())
		cell.arrow.textColor = UIColor.primary
		cell.backgroundColor = UIColor.secondary
		if item.icon != nil {
			cell.icon.image = item.icon!
			cell.widthConstraint.constant = UIScreen.main.bounds.rectWidth() * iconWidthMultiplier
		} else {
			cell.widthConstraint.constant = 0
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch (self.traitCollection.horizontalSizeClass, self.traitCollection.verticalSizeClass) {
		case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular):
			return 64
		default:
			return 64
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = menuItems[indexPath.row]
		guard let viewController = destinationViewController(item: item) else {print("Failed to initialize info item. Item: \(item)"); return}
		
		viewController.title = item.title
		self.navigationController!.pushViewController(viewController, animated: true)
	}
	
	func destinationViewController(item: InfoMenuItem) -> UIViewController? {
		
		switch item.title.lowercased() {
		case "wellness":
			return WellnessViewController(nibName: item.viewController, bundle: nil)
		case "useful information":
			return UsefullInformationViewController(nibName: item.viewController, bundle: nil)
		case "facility map":
			return FacilityMapViewController(nibName: item.viewController, bundle: nil)
		case "room service":
			return RoomServiceViewController(nibName: item.viewController, bundle: nil)
		case "minibar":
			return MinibarViewController(nibName: item.viewController, bundle: nil)
		case "pillow menu":
			return PillowMenuViewController(nibName: item.viewController, bundle: nil)
		default:
			return nil
		}
	}
}
