//
//  HamburgerPointerAnimation.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 22/11/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//  http://holko.pl/2014/07/15/hamburger-button-animation/

import Foundation
import QuartzCore

class HamburgerCrossAnimation: UIButtonAnimation {
	
	var top: CAShapeLayer! = CAShapeLayer()
	var middle: CAShapeLayer! = CAShapeLayer()
	var bottom: CAShapeLayer! = CAShapeLayer()
	
	//DISCLAIMER: DO NOT CHANGE THIS VALUE
	//SUPER SECRET FORMULA
	let inset: CGFloat = 2.0
	
	//0.3 default value
	let duration: CFTimeInterval = 0.3
	
/*	let menuStrokeStart: CGFloat = 0.325
	let menuStrokeEnd: CGFloat = 0.9
	
	let hamburgerStrokeStart: CGFloat = 0.028
	let hamburgerStrokeEnd: CGFloat = 0.111*/
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		updateFrame(frame: frame)
	}
	
	override func updateFrame(frame: CGRect) {
		self.frame = frame
		
		self.top.path = shortStroke()
		self.middle.path = shortStroke()
		self.bottom.path = shortStroke()
		
		for layer in [self.top, self.middle, self.bottom] {
			
			layer?.fillColor = nil
			layer?.strokeColor = tintColor.cgColor
			layer?.lineWidth = 2
			layer?.miterLimit = 4
			layer?.lineCap = kCALineCapRound
			layer?.masksToBounds = true
			
			let strokingPath = CGPath(__byStroking: (layer?.path!)!, transform: nil, lineWidth: 4, lineCap: .round, lineJoin: .miter, miterLimit: 4)
			
			layer?.bounds = (strokingPath?.boundingBoxOfPath)!
			
			layer?.actions = [
				"strokeStart": NSNull(),
				"strokeEnd": NSNull(),
				"transform": NSNull()
			]
			
			self.layer.addSublayer(layer!)
		}
		
		let frameWidth = frame.size.width
		
		top.anchorPoint = CGPoint(x: (frameWidth - inset) / frameWidth, y: 0.5)
		top.position = CGPoint(x: (frameWidth - inset), y: (frameWidth / 2) - cathetus(hypotenuse: strokeLength() / 2))
		
		middle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		middle.position = CGPoint(x: frameWidth / 2, y: frameWidth / 2)
		
		bottom.anchorPoint = CGPoint(x: (frameWidth - inset) / frameWidth, y: 0.5)
		bottom.position = CGPoint(x: (frameWidth - inset), y: (frameWidth / 2) + cathetus(hypotenuse: strokeLength() / 2))
	}
	
	override func animate(animationType: CAnimationType) {
		let topTransform = CABasicAnimation(keyPath: "transform")
		topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.0, 0.3, 0.5, 1)
		
		//For the lolz
		//topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -30.8, 0.5, 1)
		
		topTransform.duration = duration
		topTransform.fillMode = kCAFillModeBackwards
		
		let middleTransform = topTransform.copy() as! CABasicAnimation
		middleTransform.keyPath = "transform.scale"
		
		let bottomTransform = topTransform.copy() as! CABasicAnimation
		
		switch animationType {
		case CAnimationType.Automatic:
			showsMenu = !showsMenu
			if showsMenu {
				
				let translation = CATransform3DMakeTranslation(-offset(), 0, 0)
				
				topTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, -0.7853975, 0, 0, 1))
				//topTransform.beginTime = CACurrentMediaTime() + 0.25
				
				middleTransform.toValue = 0
				
				bottomTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, 0.7853975, 0, 0, 1))
				//bottomTransform.beginTime = CACurrentMediaTime() + 0.25
				
				self.top.ocb_applyAnimation(topTransform)
				self.middle.ocb_applyAnimation(middleTransform)
				self.bottom.ocb_applyAnimation(bottomTransform)
			} else {
				topTransform.toValue = NSValue(caTransform3D: CATransform3DIdentity)
				//topTransform.beginTime = CACurrentMediaTime() + 0.05
				
				middleTransform.toValue = 1
				
				bottomTransform.toValue = NSValue(caTransform3D: CATransform3DIdentity)
				//bottomTransform.beginTime = CACurrentMediaTime() + 0.05
				
				self.top.ocb_applyAnimation(topTransform)
				self.middle.ocb_applyAnimation(middleTransform)
				self.bottom.ocb_applyAnimation(bottomTransform)
			}
		case CAnimationType.Force_Close:
			showsMenu = false
			let translation = CATransform3DMakeTranslation(-offset(), 0, 0)
			
			topTransform.toValue = NSValue(caTransform3D: CATransform3DIdentity)
			topTransform.fromValue = NSValue(caTransform3D: CATransform3DRotate(translation, CGFloat(-(Double.pi / 4)), 0, 0, 1))
			
			middleTransform.toValue = 1
			middleTransform.fromValue = 0
			
			bottomTransform.toValue = NSValue(caTransform3D: CATransform3DIdentity)
			bottomTransform.fromValue = NSValue(caTransform3D: CATransform3DRotate(translation, CGFloat(Double.pi / 4), 0, 0, 1))
			
			top.add(topTransform, forKey: topTransform.keyPath)
			middle.add(middleTransform, forKey: middleTransform.keyPath)
			bottom.add(bottomTransform, forKey: bottomTransform.keyPath)
			
		case CAnimationType.Force_Open:
			showsMenu = true
			
			let translation = CATransform3DMakeTranslation(-offset(), 0, 0)
			
			topTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, -0.7853975, 0, 0, 1))
			topTransform.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
			
			middleTransform.toValue = 0
			middleTransform.fromValue = 1
			
			bottomTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, 0.7853975, 0, 0, 1))
			bottomTransform.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
			
			top.add(topTransform, forKey: topTransform.keyPath)
			middle.add(middleTransform, forKey: middleTransform.keyPath)
			bottom.add(bottomTransform, forKey: bottomTransform.keyPath)
		}
	}
	
	func offset() -> CGFloat {
		let frameWidth = frame.size.width
		return (frameWidth / 2) - cathetus(hypotenuse: strokeLength() / 2) - inset
	}
	
	func strokeLength() -> CGFloat {
		let frameWidth = frame.size.width
		return frameWidth - 2 * inset
	}
	
	func cathetus(hypotenuse: CGFloat) -> CGFloat {
		return sqrt((pow(hypotenuse, 2) / 2))
	}
	
	func shortStroke() -> CGPath {
		let path = CGMutablePath()
		
		path.move(to: CGPoint(x: inset, y: inset))
		path.addLine(to: CGPoint(x: frame.size.width - inset, y: inset))
		
		return path
	}
}
