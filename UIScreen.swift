//
//  UIScreen.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 4/06/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension UIScreen {
	
	static var traits: (UIUserInterfaceSizeClass, UIUserInterfaceSizeClass) {
		get {
			return (UIScreen.main.traitCollection.horizontalSizeClass, UIScreen.main.traitCollection.verticalSizeClass)
		}
	}
	
}
