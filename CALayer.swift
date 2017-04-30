//
//  Extensions.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 21/11/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

extension CALayer {
	func ocb_applyAnimation(_ animation: CABasicAnimation) {
		let copy = animation.copy() as! CABasicAnimation
		
		if copy.fromValue == nil {
			copy.fromValue = self.presentation()!.value(forKeyPath: copy.keyPath!)
		}
		
		self.add(copy, forKey: copy.keyPath)
		self.setValue(copy.toValue, forKeyPath:copy.keyPath!)
	}
}
