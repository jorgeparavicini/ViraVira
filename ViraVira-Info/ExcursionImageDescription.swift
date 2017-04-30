//
//  ExcursionImageDescription.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 20/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class ExcursionImageDescription: UITextView {
	
	var open = true
	var height: CGFloat?
	
	var gl: CAGradientLayer?
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if gl == nil {
			
			let colorTop = UIColor.secondary.withAlphaComponent(0.0).cgColor
			let colorBot = UIColor.secondary.withAlphaComponent(1.0).cgColor
			
			gl = CAGradientLayer()
			gl!.colors = [colorTop, colorBot, colorBot]
			gl!.locations = [0.0, 0.8, 1.0]
			
			gl!.zPosition = 0
			
			gl!.frame = self.bounds
			self.layer.addSublayer(gl!)
		} else {
			gl!.frame = self.bounds
		}
	}
	
	func animate() {
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
			var frame = self.frame
			if self.open {
				self.height = self.frame.height
				
				frame.size.height = 0
				//frame.origin.y += self.height!
			} else {
				frame.size.height = self.height!
				//frame.origin.y -= self.height!
			}
			
			self.open = !self.open
			
			self.frame = frame
		}, completion: nil)
	}
}
