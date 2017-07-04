//
//  MenuController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 1/07/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

class MenuController {
	
	static var shared: MenuController = MenuController()

	fileprivate var m_currentViewController: UIViewController! = nil
	
	var menuButton: UIButtonAnimation! = nil
	
	var currentViewController: UIViewController! {
		return m_currentViewController
	}
	
	func setCurrentViewController(sender: UIViewController) {
		m_currentViewController = sender
	}
	
	
	@discardableResult
	func assignRevealViewControllerDelegateTo(viewController: UIViewController) -> Bool {
		if viewController.conforms(to: SWRevealViewControllerDelegate.self) {
			viewController.revealViewController().delegate = viewController as! SWRevealViewControllerDelegate
			return true
		}
		
		return false
	}
}
