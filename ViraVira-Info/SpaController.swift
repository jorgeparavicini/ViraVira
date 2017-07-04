//
//  SpaController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 18/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit
import KVConstraintExtensionsMaster

class SpaController: UIViewController, SWRevealViewControllerDelegate {
    //MARK: - Properties
	
   // @IBOutlet weak var webView: UIWebView!
	@IBOutlet weak var navBar: UINavigationItem!
	
	var webView: UIWebView? {
		for subView in self.view.subviews {
			if let webView = subView as? UIWebView {
				return webView
			}
		}
		return nil
	}
	
	var menuButton: UIButtonAnimation! = nil
	
	var comesFromSegue: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		menuButton = Menu.menuButton(self, animation: .HamburgerToCross)
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		Menu.currentRootViewController = self
		
		setColors()
		
		
		//WebView initialization
		
		let url = URL(string: "http://viraviraspa.appointy.com/")
		
		/*if appDelegate.spaWebView == nil {
			appDelegate.spaWebView = UIWebView()
			self.automaticallyAdjustsScrollViewInsets = true
			DispatchQueue.global().async {
				let requestObj = URLRequest(url: url!)
				appDelegate.spaWebView!.loadRequest(requestObj)
			}
		} else {
			self.automaticallyAdjustsScrollViewInsets = false
		}
		appDelegate.spaWebView?.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(appDelegate.spaWebView!)
		print(view.subviews.count)
		
		*/
		if let webView = webView {
			print(webView.translatesAutoresizingMaskIntoConstraints)
			webView.applyTopAndBottomPinConstraint(toSuperview: 0)
			//webView.applyTopPinConstraint(toSuperview: 44)
//			webView.applyBottomPinConstraint(toSuperview: 0)
			
			webView.applyLeadingAndTrailingPinConstraint(toSuperview: 0)
			
		}
		
		/*for subview in view.subviews {
			if let webView = subview as? UIWebView {
				webView.frame = self.view.frame
				webView.applyTopAndBottomPinConstraint(toSuperview: 0)
				webView.applyLeadingAndTrailingPinConstraint(toSuperview: 0)
				self.view.setNeedsUpdateConstraints()
			}
		}*/
		
		if let webView = self.view.subviews[0] as? UIWebView {
			webView.applyTopAndBottomPinConstraint(toSuperview: 0)
			webView.applyLeadingAndTrailingPinConstraint(toSuperview: 0)
		}
		
		
		//webView = appDelegate.spaWebView!
		
	}
	
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
	}
	
	func toggle(_ sender: AnyObject) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
}
