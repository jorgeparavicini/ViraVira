//
//  UIFont.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 4/06/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension UIFont {
	class func printFonts() {
		for familyName in familyNames {
			print("_________________________")
			print("Font Family Name = [\(familyName)]")
			let names = UIFont.fontNames(forFamilyName: familyName)
			print("Font Names = [\(names)]")
		}
	}
}
