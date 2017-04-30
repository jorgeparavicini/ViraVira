//
//  MenuButtonLayer.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/09/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
// Based on Online tutorial holko.pl/2014/07/15/hamburger-button-animation/


import UIKit

class MenuButtonArrowNoStick: UIButtonAnimation {
	let top: CAShapeLayer = CAShapeLayer()
	let bottom: CAShapeLayer = CAShapeLayer()
	
	let width: CGFloat = 18
	let height: CGFloat = 16
	var topYPosition:CGFloat = 2
	var bottomYPosition: CGFloat = 12
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: width, y: 0))
		
		for shapeLayer in shapeLayers {
			shapeLayer.path = path.cgPath
			shapeLayer.lineWidth = 2
			shapeLayer.strokeColor = UIColor.viraviraGoldColor.cgColor
			
			shapeLayer.actions = [
				"transform": NSNull(),
				"position": NSNull()
			]
			
			let strokingPath = CGPath(__byStroking: shapeLayer.path!, transform: nil, lineWidth: shapeLayer.lineWidth, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.miter, miterLimit: shapeLayer.miterLimit)
			shapeLayer.bounds = (strokingPath?.boundingBox)!
			
			layer.addSublayer(shapeLayer)
		}
		
		self.topYPosition += frame.origin.y
		self.bottomYPosition += frame.origin.y
		
		
		let widthMiddle = width / 2
		top.position = CGPoint(x: widthMiddle, y: topYPosition)
		bottom.position = CGPoint(x: widthMiddle, y: bottomYPosition)
	}
	
	override internal var intrinsicContentSize : CGSize {
		return CGSize(width: width, height: height)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var showsMenu: Bool {
		didSet {
			CATransaction.begin()
			CATransaction.setAnimationDuration(0.4)
			CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0))
			
			let strokeStartNewValue: CGFloat = showsMenu ? 0.0 : 0.3
			let positionPathControlPointY = bottomYPosition / 2
			let verticalOffsetInRotatedState: CGFloat = 0.75
			
			let topRotation = CAKeyframeAnimation(keyPath: "transform")
			topRotation.values = rotationValuesFromTransform(top.transform, endValue: showsMenu ? -CGFloat.pi - (CGFloat.pi / 4) : CGFloat.pi + (CGFloat.pi / 4))
			topRotation.calculationMode = kCAAnimationCubic
			topRotation.keyTimes = [0.0, 0.33, 0.73, 1.0]
			top.ahk_applyKeyframeValuesAnimation(topRotation)
			
			let topPosition = CAKeyframeAnimation(keyPath: "position")
			let topPositionEndPoint = CGPoint(x: width / 2, y: showsMenu ? topYPosition : bottomYPosition + verticalOffsetInRotatedState)
			topPosition.path = quadBezierCurveFromPoint(top.position, toPoint: topPositionEndPoint, controlPoint: CGPoint(x: width, y: positionPathControlPointY)).cgPath
			top.ahk_applyKeyframePathAnimation(topPosition, endValue: NSValue(cgPoint: topPositionEndPoint))
			
			top.strokeStart = strokeStartNewValue
			
			
			let bottomRotation = CAKeyframeAnimation(keyPath: "transform")
			bottomRotation.values = rotationValuesFromTransform(bottom.transform, endValue: showsMenu ? -(CGFloat.pi / 2) - (CGFloat.pi / 4) : CGFloat.pi / 2 + CGFloat.pi / 4)
			bottomRotation.calculationMode = kCAAnimationCubic
			bottomRotation.keyTimes = [0.0, 0.33, 0.63, 1.0]
			bottom.ahk_applyKeyframeValuesAnimation(bottomRotation)
			
			let bottomPosition = CAKeyframeAnimation(keyPath: "position")
			let bottomPositionEndPoint = CGPoint(x: width / 2, y: showsMenu ? bottomYPosition : topYPosition - verticalOffsetInRotatedState)
			bottomPosition.path = quadBezierCurveFromPoint(bottom.position, toPoint: bottomPositionEndPoint, controlPoint: CGPoint(x: 0, y: positionPathControlPointY)).cgPath
			bottom.ahk_applyKeyframePathAnimation(bottomPosition, endValue: NSValue(cgPoint: bottomPositionEndPoint))
			
			bottom.strokeStart = strokeStartNewValue
			
			CATransaction.commit()
			
		}
	}
	
	fileprivate var shapeLayers: [CAShapeLayer] {
		return [top, bottom]
	}
}
