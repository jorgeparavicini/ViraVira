//
//  ViraViraFonts.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 4/06/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

//To create a string using these font, the string needs to be attributed as we take advantage of various attributes here
struct ViraViraFontAttributes {
	
	static var title: [String: Any] {
		get {
			let dict: [String: Any] = [
				NSFontAttributeName : UIFont(name: "Verdana", size: titleFontSize)!,
				//NSFontAttributeName : UIFont(name: "Verdana-Italic", size: titleFontSize)!,
				//NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue,
				NSForegroundColorAttributeName : UIColor.primary
			]
			return dict
		}
	}
	
	static var titleFontSize: CGFloat {
		get {
			switch UIScreen.traits {
			case (.regular, .regular):
				return 36
			default:
				return 24
			}
		}
	}
	
	
	static var sectionHeader: [String: Any] {
		let dict: [String: Any] = [
			NSFontAttributeName: UIFont(name: "Verdana", size: sectionHeaderFontSize)!,
			NSForegroundColorAttributeName: UIColor.primary
		]
		
		return dict
	}
	
	static var sectionHeaderFontSize: CGFloat {
		switch UIScreen.traits {
		case (.regular, .regular):
			return 32
		default:
			return 17
		}
	}
	
	
	static var cellTitles: [String: Any] {
		let dict: [String: Any] = [
			NSFontAttributeName: UIFont(name: "Verdana", size: cellTitlesFontSize)!,
			NSForegroundColorAttributeName: UIColor.primary
		]
		
		return dict
	}
	
	static var cellTitlesFontSize: CGFloat {
		switch UIScreen.traits {
		case (.regular, .regular):
			return 27
			
		default:
			return 20
		}
	}
	
	static var description: [String: Any] {
		get {
			let dict: [String: Any] = [
				NSFontAttributeName : UIFont(name: "Verdana", size: descriptionFontSize)!,
				NSForegroundColorAttributeName : UIColor.primary
			]
			
			return dict
		}
	}
	
	static var descriptionFontSize: CGFloat {
		switch UIScreen.traits {
		case (.regular, .regular):
			return 22
			
		default:
			return 15
		}
	}
	
	static var temp: [String: Any] {
		let dict: [String: Any] = [
			NSFontAttributeName : UIFont(name: "Verdana", size: tempFontSize)!,
			NSForegroundColorAttributeName : UIColor.primary
		]
		return dict
	}
	
	static var tempFontSize: CGFloat {
		switch UIScreen.traits {
		case (.regular, .regular):
			return 42
		default:
			return 34
		}
	}
	
	static var smallInfo: [String: Any] {
		let dict: [String: Any] = [
			NSFontAttributeName : UIFont(name: "Verdana", size: smallInfoFontSize)!,
			NSForegroundColorAttributeName : UIColor.primary
		]
		
		return dict
	}
	
	static var smallInfoFontSize: CGFloat {
		switch UIScreen.traits {
		case (.regular, .regular):
			return 22
			
		default:
			return 14
		}
	}
	
}
