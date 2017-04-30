//
//  MenuButtonCross.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 14/09/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit

class MenuButtonCross: UIButtonAnimation {
	let top: CAShapeLayer = CAShapeLayer()
	let bottom: CAShapeLayer = CAShapeLayer()
	
	let initialWidth: CGFloat = 18
	let height: CGFloat = 16
	let topYPosition:CGFloat = 6.5
	let bottomYPosition: CGFloat = 13.5
	
	let topXPosition: CGFloat = 9
	let bottomXPosition: CGFloat = 9
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = UIColor.red
		
		let anchorPoint = CGPoint(x: frame.origin.x + frame.size.width / 2, y: frame.origin.y + frame.size.height / 2)
		
		let path = UIBezierPath()
		
		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: initialWidth, y: 0))
		for shapeLayer in shapeLayers {
			shapeLayer.path = path.cgPath
			shapeLayer.lineWidth = 2
			shapeLayer.strokeColor = UIColor.viraviraGoldColor.cgColor
			shapeLayer.anchorPoint = anchorPoint
			
			shapeLayer.actions = [
				"transform": NSNull(),
				"position": NSNull()
			]
			
			let strokingPath = CGPath(__byStroking: shapeLayer.path!, transform: nil, lineWidth: shapeLayer.lineWidth, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.miter, miterLimit: shapeLayer.miterLimit)
			shapeLayer.bounds = (strokingPath?.boundingBox)!
			
			layer.addSublayer(shapeLayer)
		}
		
		let widthMiddle = initialWidth / 2
		top.position = CGPoint(x: widthMiddle, y: topYPosition)
		bottom.position = CGPoint(x: widthMiddle, y: bottomYPosition)
	}
	
	override internal var intrinsicContentSize : CGSize {
		return CGSize(width: initialWidth, height: height)
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
			let verticalOffsetInRotatedState: CGFloat = 2
			//-initialWidth / (bottomYPosition - topYPosition)
			let horizontalOffsetInRotatedState: CGFloat = 2
			
			let topRotation = CAKeyframeAnimation(keyPath: "transform")
			topRotation.values = rotationValuesFromTransform(top.transform, endValue: showsMenu ? CGFloat.pi / 4 : -CGFloat.pi / 4)
			topRotation.calculationMode = kCAAnimationCubic
			topRotation.keyTimes = [0.0, 0.33, 0.73, 1.0]
			top.ahk_applyKeyframeValuesAnimation(topRotation)
			
			let topPosition = CAKeyframeAnimation(keyPath: "position")
			//initialWidth / 2
			let topPositionEndPoint = CGPoint(x: showsMenu ? topXPosition : topXPosition + horizontalOffsetInRotatedState, y: showsMenu ? topYPosition : bottomYPosition + verticalOffsetInRotatedState)
			topPosition.path = quadBezierCurveFromPoint(top.position, toPoint: topPositionEndPoint, controlPoint: CGPoint(x: initialWidth, y: positionPathControlPointY)).cgPath
			top.ahk_applyKeyframePathAnimation(topPosition, endValue: NSValue(cgPoint: topPositionEndPoint))
			
			top.strokeStart = strokeStartNewValue
			
			
			let bottomRotation = CAKeyframeAnimation(keyPath: "transform")
			bottomRotation.values = rotationValuesFromTransform(bottom.transform, endValue: showsMenu ? -CGFloat.pi / 4 : CGFloat.pi / 4)
			bottomRotation.calculationMode = kCAAnimationCubic
			bottomRotation.keyTimes = [0.0, 0.33, 0.63, 1.0]
			bottom.ahk_applyKeyframeValuesAnimation(bottomRotation)
			
			let bottomPosition = CAKeyframeAnimation(keyPath: "position")
			let bottomPositionEndPoint = CGPoint(x: showsMenu ? bottomXPosition : bottomXPosition, y: showsMenu ? bottomYPosition : topYPosition - verticalOffsetInRotatedState)
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
