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
	
    @IBOutlet weak var welcomeTitle: UILabel!
	@IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var adventureTitle: UILabel!
	@IBOutlet weak var adventureLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collage: UIImageView!
	
	var menuButton: UIButtonAnimation! = nil
	
	var comesFromSegue: Bool = false
    
    @IBOutlet weak var navBar: UINavigationItem!
	
	//TODO: Change View controller init(menubuttons)
	
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
		
		Menu.currentRootViewController = self
		
		
		setAttributes()
    }
	
	
	func setColors() {
		view.backgroundColor = UIColor.secondary
		welcomeTitle.textColor = UIColor.primary
		welcomeTitle.backgroundColor = UIColor.secondary
		welcomeLabel.textColor = UIColor.primary
		welcomeLabel.backgroundColor = UIColor.secondary
		adventureLabel.textColor = UIColor.primary
		imageView.backgroundColor = UIColor.secondary
	}
	
	func setAttributes() {
		welcomeTitle.attributedText = NSAttributedString(string: welcomeTitle.text!, attributes: ViraViraFontAttributes.title)
		adventureTitle.attributedText = NSAttributedString(string: adventureTitle.text!, attributes: ViraViraFontAttributes.title)
		welcomeLabel.attributedText = NSAttributedString(string: welcomeLabel.text!, attributes: ViraViraFontAttributes.description)
		adventureLabel.attributedText = NSAttributedString(string: adventureLabel.text!, attributes: ViraViraFontAttributes.description)
	}
	
	func toggle(_ sender: AnyObject!) {
		menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
}
