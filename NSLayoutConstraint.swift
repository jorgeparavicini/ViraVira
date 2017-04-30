//
//  NSLayoutConstraint.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 3/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
	func constraintWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
	}
	class func reportAmbiguity ( v:UIView?) {
		var v = v
		if v == nil {
			v = UIApplication.shared.keyWindow
		}
		for vv in v!.subviews {
			print("\(vv) \(vv.hasAmbiguousLayout)")
			if vv.subviews.count > 0 {
				self.reportAmbiguity(v: vv)
			}
		}
	}
	class func listConstraints ( v:UIView?) {
		var v = v
		if v == nil {
			v = UIApplication.shared.keyWindow
		}
		for vv in v!.subviews {
			let arr1 = vv.constraintsAffectingLayout(for: .horizontal)
			let arr2 = vv.constraintsAffectingLayout(for: .vertical)
			NSLog("\n\n%@\nH: %@\nV:%@", vv, arr1, arr2);
			if vv.subviews.count > 0 {
				self.listConstraints(v: vv)
			}
		}
	}
}
