//
//  UIColorExtension.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 16/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

extension UIColor {
    func getRGB() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
	
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(netHex:Int) {
		self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
	}
	
	@nonobjc static let viraviraGoldColor = UIColor(red: 147/255, green: 117/255, blue: 56/255, alpha: 1)
	
	@nonobjc static let viraviraBrownColor = UIColor(red: 40/255, green: 27/255, blue: 5/255, alpha: 1)
	
	@nonobjc static let viraviraDarkBrownColor = UIColor(red: 27/255, green: 18/255, blue: 3/255, alpha: 1)
	
	/// Main color for fonts - Gold color
	@nonobjc static let primary = UIColor.viraviraGoldColor
	
	/// Main background color - Dark brown color
	@nonobjc static let secondary = UIColor.viraviraDarkBrownColor
	
	/// Color for special cases - Brown color
	@nonobjc static let tertiary = UIColor.viraviraBrownColor
	
	
//	@nonobjc static let primary = UIColor.blue
//	@nonobjc static let secondary = UIColor.black
//	@nonobjc static let tertiary = UIColor.red
	
	@nonobjc static let transparency: CGFloat = 0.99
}
