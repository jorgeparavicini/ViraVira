//
//  MenuButtonLayer.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/09/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
// Based on Online tutorial holko.pl/2014/07/15/hamburger-button-animation/


import UIKit

class MenuButtonArrow: UIButtonAnimation {
	let top: CAShapeLayer = CAShapeLayer()
	let middle: CAShapeLayer = CAShapeLayer()
	let bottom: CAShapeLayer = CAShapeLayer()
	
	let width: CGFloat = 18
	let height: CGFloat = 16
	let topYPosition:CGFloat = 2
	let middleYPosition: CGFloat = 7
	let bottomYPosition: CGFloat = 12
	
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
		
		let widthMiddle = width / 2
		top.position = CGPoint(x: widthMiddle, y: topYPosition)
		middle.position = CGPoint(x: widthMiddle, y: middleYPosition)
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
			CATransaction.setAnimationDuration(0.2)
			CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0))
			
			let strokeStartNewValue: CGFloat = showsMenu ? 0.0 : 0.3
			let positionPathControlPointY = bottomYPosition / 2
			let verticalOffsetInRotatedState: CGFloat = 0.75
			
			let topRotation = CAKeyframeAnimation(keyPath: "transform")
			topRotation.values = rotationValuesFromTransform(top.transform, endValue: showsMenu ? CGFloat(-Double.pi - (Double.pi / 4)) : CGFloat(Double.pi + (Double.pi / 4)))
			topRotation.calculationMode = kCAAnimationCubic
			topRotation.keyTimes = [0.0, 0.33, 0.73, 1.0]
			top.ahk_applyKeyframeValuesAnimation(topRotation)
			
			let topPosition = CAKeyframeAnimation(keyPath: "position")
			let topPositionEndPoint = CGPoint(x: width / 2, y: showsMenu ? topYPosition : bottomYPosition + verticalOffsetInRotatedState)
			topPosition.path = quadBezierCurveFromPoint(top.position, toPoint: topPositionEndPoint, controlPoint: CGPoint(x: width, y: positionPathControlPointY)).cgPath
			top.ahk_applyKeyframePathAnimation(topPosition, endValue: NSValue(cgPoint: topPositionEndPoint))
			
			top.strokeStart = strokeStartNewValue
			
			
			
			let middleRotation = CAKeyframeAnimation(keyPath: "transform")
			middleRotation.values = rotationValuesFromTransform(middle.transform, endValue: showsMenu ? -CGFloat.pi : CGFloat.pi)
			middle.ahk_applyKeyframeValuesAnimation(middleRotation)
			
			middle.strokeEnd = showsMenu ? 1.0 : 0.85
			
			
			
			
			let bottomRotation = CAKeyframeAnimation(keyPath: "transform")
			bottomRotation.values = rotationValuesFromTransform(bottom.transform, endValue: showsMenu ? -(CGFloat.pi / 2) - (CGFloat.pi / 4) : (CGFloat.pi / 2) + (CGFloat.pi / 4))
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
		return [top, middle, bottom]
	}
}

extension CALayer {
	func ahk_applyKeyframeValuesAnimation(_ animation: CAKeyframeAnimation) {
		guard	let copy = animation.copy() as? CAKeyframeAnimation,
				let values = copy.values , !values.isEmpty,
			let keyPath = copy.keyPath else { return }
		
		self.add(copy, forKey: keyPath)
		self.setValue(values[values.count - 1], forKey: keyPath)
	}
	
	func ahk_applyKeyframePathAnimation(_ animation: CAKeyframeAnimation, endValue: NSValue) {
		let copy = animation.copy() as! CAKeyframeAnimation
		
		self.add(copy, forKey: copy.keyPath)
		self.setValue(endValue, forKeyPath: copy.keyPath!)
	}
}

public func rotationValuesFromTransform(_ transform: CATransform3D, endValue: CGFloat) -> [NSValue] {
	let frames = 4
	
	return (0..<frames).map { num in
		NSValue(caTransform3D: CATransform3DRotate(transform, endValue / CGFloat(frames - 1) * CGFloat(num), 0, 0, 1))
	}
}

public func quadBezierCurveFromPoint(_ startPoint: CGPoint, toPoint: CGPoint, controlPoint: CGPoint) -> UIBezierPath {
	let quadPath = UIBezierPath()
	quadPath.move(to: startPoint)
	quadPath.addQuadCurve(to: toPoint, controlPoint: controlPoint)
	return quadPath
}
