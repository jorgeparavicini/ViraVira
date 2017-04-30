//
//  NavigationController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 7/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
	
	static var backgroundColor = UIColor.primary
	static var fontColor = UIColor.secondary

	override func viewDidLoad() {
		
		super.viewDidLoad()
		
        let nav = self.navigationBar
		nav.tintColor = NavigationController.fontColor
        nav.barTintColor = NavigationController.backgroundColor
        nav.titleTextAttributes = Constants.navigationFont
		
		//nav.topItem?.leftBarButtonItem?.image = nav.topItem?.leftBarButtonItem?.image?.withRenderingMode(.alwaysTemplate)
		//nav.topItem?.leftBarButtonItem?.tintColor = NavigationController.fontColor
		
		/*nav.layer.masksToBounds = false
		nav.layer.shadowColor = NavigationController.fontColor.cgColor
		nav.layer.shadowRadius = 5
		nav.layer.opacity = 0.5
		nav.layer.shadowOffset.height = 2*/
		
		setItemsColor()
		
		self.edgesForExtendedLayout = .bottom
    }
	
	//Loops through all the items present in the navigation bar, and if they have an image it will be set to the font color
	func setItemsColor() {
		let nav = self.navigationBar
		guard nav.items != nil else {return}
		for item in nav.items! {
			if item.rightBarButtonItems != nil {
				for rightItem in item.rightBarButtonItems! {
					setItemColor(item: rightItem)
				}
			}
			if item.leftBarButtonItems != nil {
				for leftItem in item.leftBarButtonItems! {
					setItemColor(item: leftItem)
				}
			}
		}
	}
	
	func setItemColor(item: UIBarButtonItem) {
		item.image = item.image?.withRenderingMode(.alwaysTemplate)
		item.tintColor = NavigationController.fontColor
	}
	
	override func viewWillLayoutSubviews() {
		let buttonHeightRatio: CGFloat = 0.7
		
		let customView = self.navigationBar.topItem?.leftBarButtonItem?.customView as? UIButtonAnimation
		let navBarHeight = self.navigationBar.frame.height
		
		customView?.frame.size = CGSize(width: navBarHeight * buttonHeightRatio, height: navBarHeight * buttonHeightRatio)
		
		if customView != nil {
			
			customView?.updateFrame(frame: customView!.frame)
			
		}
		
		self.navigationBar.setNeedsLayout()
	}
}
