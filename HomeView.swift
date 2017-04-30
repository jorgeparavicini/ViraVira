//
//  HomeView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 8/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit

class HomeView: UIViewController, SWRevealViewControllerDelegate {
    //MARK: - Properties
	
	@IBOutlet weak var welcome: UILabel!
	@IBOutlet weak var welcomeLabel: UILabel!
	@IBOutlet weak var adventureLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	
	var menuButton: UIButtonAnimation! = nil
	
	var comesFromSegue: Bool = false
    
    @IBOutlet weak var navBar: UINavigationItem!
	
	@IBOutlet weak var footer: UIView!
	@IBOutlet weak var viravira: UILabel!
	@IBOutlet weak var date: UILabel!
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//MARK: Navbar setup
		
		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		
		(UIApplication.shared.delegate as! AppDelegate).currentViewController = self
		
		//Navbar setup end
		
		//NotificationCenter.default.addObserver(self, selector: #selector(HomeView.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
		
		//setTextSize()
	//	updateTextViewSize()
		
		setColors()
		date.text = formattedDate()
    }
	
	/*func setTextSize() {
		let font = textView.font
		switch UIScreen.main.bounds.width {
			//iPhone 4
		default:
			break
		}
	}*/
	
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
		welcome.textColor = UIColor.primary
		welcome.backgroundColor = UIColor.secondary
		welcomeLabel.textColor = UIColor.primary
		welcomeLabel.backgroundColor = UIColor.secondary
		adventureLabel.textColor = UIColor.primary
		imageView.backgroundColor = UIColor.secondary
		footer.backgroundColor = UIColor.secondary.withAlphaComponent(UIColor.transparency)
		viravira.textColor = UIColor.primary
		date.textColor = UIColor.primary
	}
	
	func formattedDate() -> String {
		let formatter = DateFormatter()
		let locale = NSLocale.current
		formatter.locale = locale
		let date = Date()
		formatter.timeStyle = .none
		formatter.dateStyle = .medium
		
		return formatter.string(from: date)
	}
	
	func rotate() {
		//The device rotated
	}
	
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
}
