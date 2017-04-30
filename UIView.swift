//
//  UIView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 14/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension UIView {
	func rotate(toValue: CGFloat, duration: CFTimeInterval = 0.2) {
		let animation = CABasicAnimation(keyPath: "transform.rotation")
		
		animation.toValue = toValue
		animation.duration = duration
		animation.isRemovedOnCompletion = false
		animation.fillMode = kCAFillModeForwards
		
		self.layer.add(animation, forKey: nil)
	}
}
