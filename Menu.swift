//
//  Menu.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 6/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

struct Menu{
    static func setup(_ target: AnyObject, menuButton: UIBarButtonItem) {
		if target.revealViewController() != nil {
			
            menuButton.target = target.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            target.view.addGestureRecognizer(target.revealViewController().panGestureRecognizer())
            target.revealViewController().rearViewRevealWidth = Constants.menuWidth
            target.revealViewController().rearViewRevealOverdraw = 0
		} else {
			print("No Menu target found: Menu unable to Initialize")
		}
    }
	
	static func setup(_ target: AnyObject, menuButton: UIButton) {
		if target.revealViewController() != nil {
			
			menuButton.addTarget(target.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
			
			//menuButton.target = target.revealViewController()
			//menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
			target.view.addGestureRecognizer(target.revealViewController().panGestureRecognizer())
			target.revealViewController().rearViewRevealWidth = Constants.menuWidth
			target.revealViewController().rearViewRevealOverdraw = 0
		} else {
			print("No Menu target found: Menu unable to Initialize")
		}
	}
	
	enum Animation {
		case Arrow
		case ArrowWithoutStick
		case Cross
		case HamburgerToCross
	}
	
	static func menuButton(_ target: AnyObject, animation: Animation?) -> UIButtonAnimation {
		var button: UIButtonAnimation! = nil
		if animation != nil {
			switch animation! {
			case Animation.Arrow:
				button = MenuButtonArrow(frame: Constants.navigationItemRect)
			case Animation.ArrowWithoutStick:
				button = MenuButtonArrowNoStick(frame: Constants.navigationItemRect)
			case Animation.Cross:
				button = MenuButtonCross(frame: Constants.navigationItemRect)
			case Animation.HamburgerToCross:
				button = HamburgerCrossAnimation(frame: Constants.navigationItemRect)
			}
		} else {
			button = UIButtonAnimation(frame: Constants.navigationItemRect)
		}
		
		button.tintColor = NavigationController.fontColor
		
		button.addTarget(target.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
		
		target.view?.addGestureRecognizer(target.revealViewController().panGestureRecognizer())
		target.revealViewController().rearViewRevealWidth = Constants.menuWidth
		target.revealViewController().rearViewRevealOverdraw = 0
		
		return button
	}
	
}
