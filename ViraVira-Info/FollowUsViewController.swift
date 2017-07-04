//
//  FollowUsTableViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 16/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit

struct FollowUsItem {
	var icon: UIImage
	var title: String
	var url: URL
	
	var shouldTemplate: Bool = true
	
	static let viravira = FollowUsItem(icon: #imageLiteral(resourceName: "logo"), title: "Vira Vira", url: URL(string: "https://www.hotelviravira.com")!, shouldTemplate: true)
	static let facebook = FollowUsItem(icon: #imageLiteral(resourceName: "Facebook_Golden"), title: "Facebook", url: URL(string: "https://www.facebook.com/hotelviravira/")!, shouldTemplate: true)
	static let twitter = FollowUsItem(icon: #imageLiteral(resourceName: "Twitter_Golden"), title: "Twitter", url: URL(string: "https://twitter.com/hotelviravira")!, shouldTemplate: true)
	static let tripadvisor = FollowUsItem(icon: #imageLiteral(resourceName: "Tripadvisor"), title: "Tripadvisor", url: URL(string: "https://www.tripadvisor.com/Hotel_Review-g294297-d4605635-Reviews-Hotel_Vira_Vira_Relais_Chateaux-Pucon_Araucania_Region.html")!, shouldTemplate: true)
}

class FollowUsViewController: UIViewController, SWRevealViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Properties
	
	static let items: [FollowUsItem] = [.viravira, .facebook, .twitter, .tripadvisor]
	
	@IBOutlet weak var navBar: UINavigationItem!
	var menuButton: UIButtonAnimation! = nil
	var comesFromSegue: Bool = false
	
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iconLinkButton: UIButton!
	
	let cellHeightMultiplier: CGFloat = 0.125
    
	let identifier = "FollowUsCell"
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
		menuButton = Menu.menuButton(self, animation: .HamburgerToCross)
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		
		Menu.currentRootViewController = self
		
		
		
		var attrs: [String: Any] = [
			NSFontAttributeName : UIFont.init(name: "Verdana", size: 14)!,
			NSForegroundColorAttributeName : UIColor.primary]
		
		let attributedString = NSMutableAttributedString(string: "All icons provided by ", attributes: attrs)
		
		attrs[NSUnderlineStyleAttributeName] = 1
		
		attributedString.append(NSAttributedString(string: "Icons8", attributes: attrs))
		
		iconLinkButton.setAttributedTitle(attributedString, for: .normal)
		
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = 75
		
		setColors()
    }
	
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
		self.tableView.separatorColor = UIColor.primary
		self.tableView.backgroundColor = UIColor.secondary
	}

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return FollowUsViewController.items.count
	}
	
    func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if #available(iOS 10.0, *) {
			UIApplication.shared.open(FollowUsViewController.items[indexPath.row].url, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(FollowUsViewController.items[indexPath.row].url)
		}
	}
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FollowUsTableViewCell
		let item = FollowUsViewController.items[indexPath.row]
		
		cell.content.backgroundColor = UIColor.clear
		cell.set(image: item.icon)
		cell.title.text = item.title
		
		cell.setColors()
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		/*let bounds = UIScreen.main.bounds
		let height = bounds.width > bounds.height ? bounds.width : bounds.height
		return height * cellHeightMultiplier*/
		return UITableViewAutomaticDimension
	}
	
	//MARK: - Menu view data source
	
	func toggle(_ sender: AnyObject) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
    
    //MARK: - Action
    
    @IBAction func openLink(_ sender: Any) {
		let url = URL(string: "https://de.icons8.com/")!
		if #available(iOS 10.0, *) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(url)
		}
    }
    
}
