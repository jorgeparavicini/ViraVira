//
//  JPMath.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 16/03/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

class JPMath {
	class func equal(x: CGFloat?, y: CGFloat?) -> Bool {
		guard x != nil, y != nil else {return false}
		return abs(x!-y!) < 0.1
	}
	
	class func equal(x: CGSize?, y: CGSize?) -> Bool {
		guard x != nil, y != nil else {return false}
		return abs(x!.width - y!.width) < 0.1 && abs(x!.height - y!.height) < 0.1
	}
}
