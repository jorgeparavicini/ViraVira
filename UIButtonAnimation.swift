//
//  UIButtonAnimation.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 21/11/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

class UIButtonAnimation: UIButton {
	var showsMenu: Bool = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func animate(animationType: CAnimationType) {}
	
	func updateFrame(frame: CGRect) {}
}

enum CAnimationType {
	case Automatic
	case Force_Open
	case Force_Close
}
