//
//  UIScreen.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension CGRect {
	
	func rectLength() -> CGFloat{
		return self.width > self.height ? self.width : self.height
	}
	
	func rectWidth() -> CGFloat {
		return self.width < self.height ? self.width : self.height
	}
}
