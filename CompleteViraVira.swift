//
//  ARImageView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 30/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class ARImageView: UIImageView {
	
	func resizeImage(size: CGSize) {
		DispatchQueue.global().async {
			let tempImage = self.image?.resizedImage(size, interpolationQuality: .default)
			
			DispatchQueue.main.async {
				self.image = tempImage
			}
		}
		
	}
}
//
//  Extensions.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 21/11/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

extension CALayer {
	func ocb_applyAnimation(_ animation: CABasicAnimation) {
		let copy = animation.copy() as! CABasicAnimation
		
		if copy.fromValue == nil {
			copy.fromValue = self.presentation()!.value(forKeyPath: copy.keyPath!)
		}
		
		self.add(copy, forKey: copy.keyPath)
		self.setValue(copy.toValue, forKeyPath:copy.keyPath!)
	}
}
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
//
//  HomeView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 8/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit

class HomeView: UIViewController, SWRevealViewControllerDelegate {
    //MARK: - Properties
	
	@IBOutlet weak var welcome: UILabel!
	@IBOutlet weak var welcomeLabel: UILabel!
	@IBOutlet weak var adventureLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	
	var menuButton: UIButtonAnimation! = nil
	
	var comesFromSegue: Bool = false
    
    @IBOutlet weak var navBar: UINavigationItem!
	
	@IBOutlet weak var footer: UIView!
	@IBOutlet weak var viravira: UILabel!
	@IBOutlet weak var date: UILabel!
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//MARK: Navbar setup
		
		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		
		(UIApplication.shared.delegate as! AppDelegate).currentViewController = self
		
		//Navbar setup end
		
		//NotificationCenter.default.addObserver(self, selector: #selector(HomeView.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
		
		//setTextSize()
	//	updateTextViewSize()
		
		setColors()
		date.text = formattedDate()
    }
	
	/*func setTextSize() {
		let font = textView.font
		switch UIScreen.main.bounds.width {
			//iPhone 4
		default:
			break
		}
	}*/
	
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
		welcome.textColor = UIColor.primary
		welcome.backgroundColor = UIColor.secondary
		welcomeLabel.textColor = UIColor.primary
		welcomeLabel.backgroundColor = UIColor.secondary
		adventureLabel.textColor = UIColor.primary
		imageView.backgroundColor = UIColor.secondary
		footer.backgroundColor = UIColor.secondary.withAlphaComponent(UIColor.transparency)
		viravira.textColor = UIColor.primary
		date.textColor = UIColor.primary
	}
	
	func formattedDate() -> String {
		let formatter = DateFormatter()
		let locale = NSLocale.current
		formatter.locale = locale
		let date = Date()
		formatter.timeStyle = .none
		formatter.dateStyle = .medium
		
		return formatter.string(from: date)
	}
	
	func rotate() {
		//The device rotated
	}
	
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
}
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
//
//  Menu.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 6/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

struct Menu{
    static func setup(_ target: AnyObject, menuButton: UIBarButtonItem) {
		if target.revealViewController() != nil {
			
            menuButton.target = target.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            target.view.addGestureRecognizer(target.revealViewController().panGestureRecognizer())
            target.revealViewController().rearViewRevealWidth = Constants.menuWidth
            target.revealViewController().rearViewRevealOverdraw = 0
		} else {
			print("No Menu target found: Menu unable to Initialize")
		}
    }
	
	static func setup(_ target: AnyObject, menuButton: UIButton) {
		if target.revealViewController() != nil {
			
			menuButton.addTarget(target.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
			
			//menuButton.target = target.revealViewController()
			//menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
			target.view.addGestureRecognizer(target.revealViewController().panGestureRecognizer())
			target.revealViewController().rearViewRevealWidth = Constants.menuWidth
			target.revealViewController().rearViewRevealOverdraw = 0
		} else {
			print("No Menu target found: Menu unable to Initialize")
		}
	}
	
	enum Animation {
		case Arrow
		case ArrowWithoutStick
		case Cross
		case HamburgerToCross
	}
	
	static func menuButton(_ target: AnyObject, animation: Animation?) -> UIButtonAnimation {
		var button: UIButtonAnimation! = nil
		if animation != nil {
			switch animation! {
			case Animation.Arrow:
				button = MenuButtonArrow(frame: Constants.navigationItemRect)
			case Animation.ArrowWithoutStick:
				button = MenuButtonArrowNoStick(frame: Constants.navigationItemRect)
			case Animation.Cross:
				button = MenuButtonCross(frame: Constants.navigationItemRect)
			case Animation.HamburgerToCross:
				button = HamburgerCrossAnimation(frame: Constants.navigationItemRect)
			}
		} else {
			button = UIButtonAnimation(frame: Constants.navigationItemRect)
		}
		
		button.tintColor = NavigationController.fontColor
		
		button.addTarget(target.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
		
		target.view?.addGestureRecognizer(target.revealViewController().panGestureRecognizer())
		target.revealViewController().rearViewRevealWidth = Constants.menuWidth
		target.revealViewController().rearViewRevealOverdraw = 0
		
		return button
	}
	
}
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
//
//  NSLayoutConstraint.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 3/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
	func constraintWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
	}
	class func reportAmbiguity ( v:UIView?) {
		var v = v
		if v == nil {
			v = UIApplication.shared.keyWindow
		}
		for vv in v!.subviews {
			print("\(vv) \(vv.hasAmbiguousLayout)")
			if vv.subviews.count > 0 {
				self.reportAmbiguity(v: vv)
			}
		}
	}
	class func listConstraints ( v:UIView?) {
		var v = v
		if v == nil {
			v = UIApplication.shared.keyWindow
		}
		for vv in v!.subviews {
			let arr1 = vv.constraintsAffectingLayout(for: .horizontal)
			let arr2 = vv.constraintsAffectingLayout(for: .vertical)
			NSLog("\n\n%@\nH: %@\nV:%@", vv, arr1, arr2);
			if vv.subviews.count > 0 {
				self.listConstraints(v: vv)
			}
		}
	}
}
//
//  Device.swift
//  DeviceKit
//
//  Created by Dennis Weissmann on 11/16/14.
//  Copyright (c) 2014 Hot Action Studios. All rights reserved.
//

import class UIKit.UIDevice
import class UIKit.UIScreen
import struct Darwin.utsname
import func Darwin.uname
import func Darwin.round
import func Darwin.getenv

// MARK: - Device

/// This enum is a value-type wrapper around and extension of
/// [`UIDevice`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDevice_Class/).
///
/// This port is not yet complete and will be extended as I need further functionality. Feel free to extend it and send a pull request. Thanks! :)
///
/// Usage:
///
///     let device = Device()
///
///     print(device)     // prints, for example, "iPhone 6 Plus"
///
///     if device == .iPhone6Plus {
///         // Do something
///     } else {
///         // Do something else
///     }
///
///     ...
///
///     if device.batteryState == .Full || device.batteryState >= .Charging(75) {
///         print("Your battery is happy! 😊")
///     }
///
///     ...
///
///     if device.batteryLevel >= 50 {
///         install_iOS()
///     } else {
///         showError()
///     }
///
public enum Device {
  #if os(iOS)
  /// Device is an [iPod Touch (5th generation)](https://support.apple.com/kb/SP657)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP657/sp657_ipod-touch_size.jpg)
  case iPodTouch5

  /// Device is an [iPod Touch (6th generation)](https://support.apple.com/kb/SP720)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP720/SP720-ipod-touch-specs-color-sg-2015.jpg)
  case iPodTouch6

  /// Device is an [iPhone 4](https://support.apple.com/kb/SP587)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP643/sp643_iphone4s_color_black.jpg)
  case iPhone4

  /// Device is an [iPhone 4s](https://support.apple.com/kb/SP643)
  ///
  /// ![Image](https://support.apple.com/library/content/dam/edam/applecare/images/en_US/iphone/iphone5s/iphone_4s.png)
  case iPhone4s

  /// Device is an [iPhone 5](https://support.apple.com/kb/SP655)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP655/sp655_iphone5_color.jpg)
  case iPhone5

  /// Device is an [iPhone 5c](https://support.apple.com/kb/SP684)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP684/SP684-color_yellow.jpg)
  case iPhone5c

  /// Device is an [iPhone 5s](https://support.apple.com/kb/SP685)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP685/SP685-color_black.jpg)
  case iPhone5s

  /// Device is an [iPhone 6](https://support.apple.com/kb/SP705)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP705/SP705-iphone_6-mul.png)
  case iPhone6

  /// Device is an [iPhone 6 Plus](https://support.apple.com/kb/SP706)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP706/SP706-iphone_6_plus-mul.png)
  case iPhone6Plus

  /// Device is an [iPhone 6s](https://support.apple.com/kb/SP726)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP726/SP726-iphone6s-gray-select-2015.png)
  case iPhone6s

  /// Device is an [iPhone 6s Plus](https://support.apple.com/kb/SP727)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP727/SP727-iphone6s-plus-gray-select-2015.png)
  case iPhone6sPlus

  /// Device is an [iPhone 7](https://support.apple.com/kb/SP) // TODO: Enter correct SP and image
  ///
  /// ![Image]
  case iPhone7

  /// Device is an [iPhone 7 Plus](https://support.apple.com/kb/SP)  // TODO: Enter correct SP and image
  ///
  /// ![Image]
  case iPhone7Plus

  /// Device is an [iPhone SE](https://support.apple.com/kb/SP738)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP738/SP738.png)
  case iPhoneSE

  /// Device is an [iPad 2](https://support.apple.com/kb/SP622)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP622/SP622_01-ipad2-mul.png)
  case iPad2

  /// Device is an [iPad (3rd generation)](https://support.apple.com/kb/SP647)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP662/sp662_ipad-4th-gen_color.jpg)
  case iPad3

  /// Device is an [iPad (4th generation)](https://support.apple.com/kb/SP662)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP662/sp662_ipad-4th-gen_color.jpg)
  case iPad4

  /// Device is an [iPad Air](https://support.apple.com/kb/SP692)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP692/SP692-specs_color-mul.png)
  case iPadAir

  /// Device is an [iPad Air 2](https://support.apple.com/kb/SP708)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP708/SP708-space_gray.jpeg)
  case iPadAir2

  /// Device is an [iPad Mini](https://support.apple.com/kb/SP661)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP661/sp661_ipad_mini_color.jpg)
  case iPadMini

  /// Device is an [iPad Mini 2](https://support.apple.com/kb/SP693)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP693/SP693-specs_color-mul.png)
  case iPadMini2

  /// Device is an [iPad Mini 3](https://support.apple.com/kb/SP709)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP709/SP709-space_gray.jpeg)
  case iPadMini3

  /// Device is an [iPad Mini 4](https://support.apple.com/kb/SP725)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP725/SP725ipad-mini-4.png)
  case iPadMini4

  /// Device is an [iPad Pro](http://www.apple.com/ipad-pro/)
  ///
  /// ![Image](http://images.apple.com/v/ipad-pro/c/images/shared/buystrip/ipad_pro_large_2x.png)
  case iPadPro9Inch
  case iPadPro12Inch

  #elseif os(tvOS)
  /// Device is an [Apple TV](http://www.apple.com/tv/)
  ///
  /// ![Image](http://images.apple.com/v/tv/c/images/overview/buy_tv_large_2x.jpg)
  case appleTV4
  #endif

  /// Device is [Simulator](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/iOS_Simulator_Guide/Introduction/Introduction.html)
  ///
  /// ![Image](https://developer.apple.com/assets/elements/icons/256x256/xcode-6.png)
  indirect case simulator(Device)

  /// Device is not yet known (implemented)
  /// You can still use this enum as before but the description equals the identifier (you can get multiple identifiers for the same product class
  /// (e.g. "iPhone6,1" or "iPhone 6,2" do both mean "iPhone 5s))
  case unknown(String)

  /// Initializes a `Device` representing the current device this software runs on.
  ///
  /// - returns: An initialized `Device`
  public init() {
    self = Device.mapToDevice(identifier: Device.identifier)
  }

  /// Gets the identifier from the system, such as "iPhone7,1".
  public static var identifier: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let mirror = Mirror(reflecting: systemInfo.machine)

    let identifier = mirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
  }

  /// Maps an identifier to a Device. If the identifier can not be mapped to an existing device, `UnknownDevice(identifier)` is returned.
  ///
  /// - parameter identifier: The device identifier, e.g. "iPhone7,1". Can be obtained from `Device.identifier`.
  ///
  /// - returns: An initialized `Device`.
  public static func mapToDevice(identifier: String) -> Device {  // swiftlint:disable:this cyclomatic_complexity
    #if os(iOS)
      switch identifier {
      case "iPod5,1":                                 return iPodTouch5
      case "iPod7,1":                                 return iPodTouch6
      case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return iPhone4
      case "iPhone4,1":                               return iPhone4s
      case "iPhone5,1", "iPhone5,2":                  return iPhone5
      case "iPhone5,3", "iPhone5,4":                  return iPhone5c
      case "iPhone6,1", "iPhone6,2":                  return iPhone5s
      case "iPhone7,2":                               return iPhone6
      case "iPhone7,1":                               return iPhone6Plus
      case "iPhone8,1":                               return iPhone6s
      case "iPhone8,2":                               return iPhone6sPlus
      case "iPhone9,1", "iPhone9,3":                  return iPhone7
      case "iPhone9,2", "iPhone9,4":                  return iPhone7Plus
      case "iPhone8,4":                               return iPhoneSE
      case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return iPad2
      case "iPad3,1", "iPad3,2", "iPad3,3":           return iPad3
      case "iPad3,4", "iPad3,5", "iPad3,6":           return iPad4
      case "iPad4,1", "iPad4,2", "iPad4,3":           return iPadAir
      case "iPad5,3", "iPad5,4":                      return iPadAir2
      case "iPad2,5", "iPad2,6", "iPad2,7":           return iPadMini
      case "iPad4,4", "iPad4,5", "iPad4,6":           return iPadMini2
      case "iPad4,7", "iPad4,8", "iPad4,9":           return iPadMini3
      case "iPad5,1", "iPad5,2":                      return iPadMini4
      case "iPad6,3", "iPad6,4":                      return iPadPro9Inch
      case "iPad6,7", "iPad6,8":                      return iPadPro12Inch
      // swiftlint:disable:next force_unwrapping
      case "i386", "x86_64":                          return simulator(mapToDevice(identifier: String(validatingUTF8: getenv("SIMULATOR_MODEL_IDENTIFIER"))!))
      default:                                        return unknown(identifier)
      }
    #elseif os(tvOS)
      switch identifier {
      case "AppleTV5,3":                              return appleTV4
      // swiftlint:disable:next force_unwrapping
      case "i386", "x86_64":                          return simulator(mapToDevice(identifier: String(validatingUTF8: getenv("SIMULATOR_MODEL_IDENTIFIER"))!))
      default:                                        return unknown(identifier)
      }
    #endif
  }

  #if os(iOS)
  public static var allPods: [Device] {
    return [.iPodTouch5, .iPodTouch6]
  }

  /// All iPhones
  public static var allPhones: [Device] {
    return [.iPhone4, iPhone4s, .iPhone5, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE]
  }

  /// All iPads
  public static var allPads: [Device] {
    return [.iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro9Inch, .iPadPro12Inch]
  }

  /// All simulator iPods
  public static var allSimulatorPods: [Device] {
    return allPods.map(Device.simulator)
  }

  /// All simulator iPhones
  public static var allSimulatorPhones: [Device] {
    return allPhones.map(Device.simulator)
  }

  /// All simulator iPads
  public static var allSimulatorPads: [Device] {
    return allPads.map(Device.simulator)
  }

  /// Returns whether the device is an iPod (real or simulator)
  public var isPod: Bool {
    return self.isOneOf(Device.allPods) || self.isOneOf(Device.allSimulatorPods)
  }

  /// Returns whether the device is an iPhone (real or simulator)
  public var isPhone: Bool {
    return self.isOneOf(Device.allPhones) || self.isOneOf(Device.allSimulatorPhones)
  }

  /// Returns whether the device is an iPad (real or simulator)
  public var isPad: Bool {
    return self.isOneOf(Device.allPads) || self.isOneOf(Device.allSimulatorPads)
  }

  /// Returns whether the device is any of the simulator
  /// Useful when there is a need to check and skip running a portion of code (location request or others)
  public var isSimulator: Bool {
    return self.isOneOf(Device.allSimulators)
  }

  public var isZoomed: Bool {
    return UIScreen.main.scale < UIScreen.main.nativeScale
  }

  #elseif os(tvOS)
  /// All TVs
  public static var allTVs: [Device] {
  return [.appleTV4]
  }

  /// All simulator TVs
  public static var allSimulatorTVs: [Device] {
  return allTVs.map(Device.simulator)
  }
  #endif

  /// All real devices (i.e. all devices except for all simulators)
  public static var allRealDevices: [Device] {
    #if os(iOS)
      return allPods + allPhones + allPads
    #elseif os(tvOS)
      return allTVs
    #endif
  }
  /// All simulators
  public static var allSimulators: [Device] {
    return allRealDevices.map(Device.simulator)
  }

  /**
   This method saves you in many cases from the need of updating your code with every new device.
   Most uses for an enum like this are the following:

   ```
   switch Device() {
   case .iPodTouch5, .iPodTouch6: callMethodOnIPods()
   case .iPhone4, iPhone4s, .iPhone5, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE: callMethodOnIPhones()
   case .iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro: callMethodOnIPads()
   default: break
   }
   ```
   This code can now be replaced with

   ```
   let device = Device()
   if device.isOneOf(Device.allPods) {
   callMethodOnIPods()
   } else if device.isOneOf(Device.allPhones) {
   callMethodOnIPhones()
   } else if device.isOneOf(Device.allPads) {
   callMethodOnIPads()
   }
   ```

   - parameter devices: An array of devices.

   - returns: Returns whether the current device is one of the passed in ones.
   */
  public func isOneOf(_ devices: [Device]) -> Bool {
    return devices.contains(self)
  }

  /// The style of interface to use on the current device.
  /// This is pretty useless right now since it does not add any further functionality to the existing
  /// [UIUserInterfaceIdiom](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDevice_Class/#//apple_ref/c/tdef/UIUserInterfaceIdiom) enum.
  public enum UserInterfaceIdiom {

    /// The user interface should be designed for iPhone and iPod touch.
    case phone
    /// The user interface should be designed for iPad.
    case pad
    /// The user interface should be designed for TV
    case tv
    /// The user interface should be designed for Car
    case carPlay
    /// Used when an object has a trait collection, but it is not in an environment yet. For example, a view that is created, but not put into a view hierarchy.
    case unspecified

    private init() {
      switch UIDevice.current.userInterfaceIdiom {
      case .pad:          self = .pad
      case .phone:        self = .phone
      case .tv:           self = .tv
      case .carPlay:      self = .carPlay
      default:            self = .unspecified
      }
    }

  }

  /// The name identifying the device (e.g. "Dennis' iPhone").
  public var name: String {
    return UIDevice.current.name
  }

  /// The name of the operating system running on the device represented by the receiver (e.g. "iPhone OS" or "tvOS").
  public var systemName: String {
    return UIDevice.current.systemName
  }

  /// The current version of the operating system (e.g. 8.4 or 9.2).
  public var systemVersion: String {
    return UIDevice.current.systemVersion
  }

  /// The model of the device (e.g. "iPhone" or "iPod Touch").
  public var model: String {
    return UIDevice.current.model
  }

  /// The model of the device as a localized string.
  public var localizedModel: String {
    return UIDevice.current.localizedModel
  }

}

// MARK: - CustomStringConvertible
extension Device: CustomStringConvertible {

  /// A textual representation of the device.
  public var description: String {
    #if os(iOS)
      switch self {
      case .iPodTouch5:                   return "iPod Touch 5"
      case .iPodTouch6:                   return "iPod Touch 6"
      case .iPhone4:                      return "iPhone 4"
      case .iPhone4s:                     return "iPhone 4s"
      case .iPhone5:                      return "iPhone 5"
      case .iPhone5c:                     return "iPhone 5c"
      case .iPhone5s:                     return "iPhone 5s"
      case .iPhone6:                      return "iPhone 6"
      case .iPhone6Plus:                  return "iPhone 6 Plus"
      case .iPhone6s:                     return "iPhone 6s"
      case .iPhone6sPlus:                 return "iPhone 6s Plus"
      case .iPhone7:                      return "iPhone 7"
      case .iPhone7Plus:                  return "iPhone 7 Plus"
      case .iPhoneSE:                     return "iPhone SE"
      case .iPad2:                        return "iPad 2"
      case .iPad3:                        return "iPad 3"
      case .iPad4:                        return "iPad 4"
      case .iPadAir:                      return "iPad Air"
      case .iPadAir2:                     return "iPad Air 2"
      case .iPadMini:                     return "iPad Mini"
      case .iPadMini2:                    return "iPad Mini 2"
      case .iPadMini3:                    return "iPad Mini 3"
      case .iPadMini4:                    return "iPad Mini 4"
      case .iPadPro9Inch:                 return "iPad Pro (9.7-inch)"
      case .iPadPro12Inch:                return "iPad Pro (12.9-inch)"
      case .simulator(let model):         return "Simulator (\(model))"
      case .unknown(let identifier):      return identifier
      }
    #elseif os(tvOS)
      switch self {
      case .appleTV4:                     return "Apple TV 4"
      case .simulator(let model):         return "Simulator (\(model))"
      case .unknown(let identifier):      return identifier
      }
    #endif
  }
}

// MARK: - Equatable
extension Device: Equatable {}

/// Compares two devices
///
/// - parameter lhs: A device.
/// - parameter rhs: Another device.
///
/// - returns: `true` iff the underlying identifier is the same.
public func == (lhs: Device, rhs: Device) -> Bool {
  return lhs.description == rhs.description
}

#if os(iOS)
  // MARK: - Battery
  extension Device {
    /**
     This enum describes the state of the battery.

     - Full:      The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
     - Charging:  The device is plugged into power and the battery is less than 100% charged.
     - Unplugged: The device is not plugged into power; the battery is discharging.
     */
    public enum BatteryState: CustomStringConvertible, Equatable {
      /// The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
      case full
      /// The device is plugged into power and the battery is less than 100% charged.
      /// The associated value is in percent (0-100).
      case charging(Int)
      /// The device is not plugged into power; the battery is discharging.
      /// The associated value is in percent (0-100).
      case unplugged(Int)

      fileprivate init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = Int(round(UIDevice.current.batteryLevel * 100))  // round() is actually not needed anymore since -[batteryLevel] seems to always return a two-digit precision number
        // but maybe that changes in the future.
        switch UIDevice.current.batteryState {
        case .charging: self = .charging(batteryLevel)
        case .full:     self = .full
        case .unplugged:self = .unplugged(batteryLevel)
        case .unknown:  self = .full    // Should never happen since `batteryMonitoring` is enabled.
        }
        UIDevice.current.isBatteryMonitoringEnabled = false
      }

      /// Provides a textual representation of the battery state.
      /// Examples:
      /// ```
      /// Battery level: 90%, device is plugged in.
      /// Battery level: 100 % (Full), device is plugged in.
      /// Battery level: \(batteryLevel)%, device is unplugged.
      /// ```
      public var description: String {
        switch self {
        case .charging(let batteryLevel):   return "Battery level: \(batteryLevel)%, device is plugged in."
        case .full:                         return "Battery level: 100 % (Full), device is plugged in."
        case .unplugged(let batteryLevel):  return "Battery level: \(batteryLevel)%, device is unplugged."
        }
      }

    }

    /// The state of the battery
    public var batteryState: BatteryState {
      return BatteryState()
    }

    /// Battery level ranges from 0 (fully discharged) to 100 (100% charged).
    public var batteryLevel: Int {
      switch BatteryState() {
      case .charging(let value):  return value
      case .full:                 return 100
      case .unplugged(let value): return value
      }
    }

  }

  // MARK: - Device.Batterystate: Comparable
  extension Device.BatteryState: Comparable {}

  /// Tells if two battery states are equal.
  ///
  /// - parameter lhs: A battery state.
  /// - parameter rhs: Another battery state.
  ///
  /// - returns: `true` iff they are equal, otherwise `false`
  public func == (lhs: Device.BatteryState, rhs: Device.BatteryState) -> Bool {
    return lhs.description == rhs.description
  }

  /// Compares two battery states.
  ///
  /// - parameter lhs: A battery state.
  /// - parameter rhs: Another battery state.
  ///
  /// - returns: `true` if rhs is `.Full`, `false` when lhs is `.Full` otherwise their battery level is compared.
  public func < (lhs: Device.BatteryState, rhs: Device.BatteryState) -> Bool {
    switch (lhs, rhs) {
    case (.full, _):                                            return false                // return false (even if both are `.Full` -> they are equal)
    case (_, .full):                                            return true                 // lhs is *not* `.Full`, rhs is
    case (.charging(let lhsLevel), .charging(let rhsLevel)):    return lhsLevel < rhsLevel
    case (.charging(let lhsLevel), .unplugged(let rhsLevel)):   return lhsLevel < rhsLevel
    case (.unplugged(let lhsLevel), .charging(let rhsLevel)):   return lhsLevel < rhsLevel
    case (.unplugged(let lhsLevel), .unplugged(let rhsLevel)):  return lhsLevel < rhsLevel
    default:                                                    return false                // compiler won't compile without it, though it cannot happen
    }
  }
#endif
//
//  SWXMLHash+TypeConversion.swift
//  SWXMLHash
//
//  Created by Maciek Grzybowski on 29.02.2016.
//
//

// swiftlint:disable line_length
// swiftlint:disable file_length

import Foundation

// MARK: - XMLIndexerDeserializable

/// Provides XMLIndexer deserialization / type transformation support
public protocol XMLIndexerDeserializable {
    /// Method for deserializing elements from XMLIndexer
    static func deserialize(_ element: XMLIndexer) throws -> Self
}

/// Provides XMLIndexer deserialization / type transformation support
public extension XMLIndexerDeserializable {
    /**
    A default implementation that will throw an error if it is called

    - parameters:
        - element: the XMLIndexer to be deserialized
    - throws: an XMLDeserializationError.ImplementationIsMissing if no implementation is found
    - returns: this won't ever return because of the error being thrown
    */
    static func deserialize(_ element: XMLIndexer) throws -> Self {
        throw XMLDeserializationError.ImplementationIsMissing(
            method: "XMLIndexerDeserializable.deserialize(element: XMLIndexer)")
    }
}


// MARK: - XMLElementDeserializable

/// Provides XMLElement deserialization / type transformation support
public protocol XMLElementDeserializable {
    /// Method for deserializing elements from XMLElement
    static func deserialize(_ element: XMLElement) throws -> Self
}

/// Provides XMLElement deserialization / type transformation support
public extension XMLElementDeserializable {
    /**
    A default implementation that will throw an error if it is called

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.ImplementationIsMissing if no implementation is found
    - returns: this won't ever return because of the error being thrown
    */
    static func deserialize(_ element: XMLElement) throws -> Self {
        throw XMLDeserializationError.ImplementationIsMissing(
            method: "XMLElementDeserializable.deserialize(element: XMLElement)")
    }
}

// MARK: - XMLAttributeDeserializable

/// Provides XMLAttribute deserialization / type transformation support
public protocol XMLAttributeDeserializable {
    static func deserialize(_ attribute: XMLAttribute) throws -> Self
}

/// Provides XMLAttribute deserialization / type transformation support
public extension XMLAttributeDeserializable {
    /**
     A default implementation that will throw an error if it is called

     - parameters:
         - attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.ImplementationIsMissing if no implementation is found
     - returns: this won't ever return because of the error being thrown
     */
    static func deserialize(attribute: XMLAttribute) throws -> Self {
        throw XMLDeserializationError.ImplementationIsMissing(
            method: "XMLAttributeDeserializable(element: XMLAttribute)")
    }
}

// MARK: - XMLIndexer Extensions

public extension XMLIndexer {

    // MARK: - XMLAttributeDeserializable

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `T`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `T` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> T {
        switch self {
        case .Element(let element):
            return try element.value(ofAttribute: attr)
        case .Stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `T?`

     - parameter attr: The attribute to deserialize
     - returns: The deserialized `T?` value, or nil if the attribute does not exist
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) -> T? {
        switch self {
        case .Element(let element):
            return element.value(ofAttribute: attr)
        case .Stream(let opStream):
            return opStream.findElements().value(ofAttribute: attr)
        default:
            return nil
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T]`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T]` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> [T] {
        switch self {
        case .List(let elements):
            return try elements.map { try $0.value(ofAttribute: attr) }
        case .Element(let element):
            return try [element].map { try $0.value(ofAttribute: attr) }
        case .Stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T]?`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T]?` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> [T]? {
        switch self {
        case .List(let elements):
            return try elements.map { try $0.value(ofAttribute: attr) }
        case .Element(let element):
            return try [element].map { try $0.value(ofAttribute: attr) }
        case .Stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        default:
            return nil
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T?]`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T?]` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> [T?] {
        switch self {
        case .List(let elements):
            return elements.map { $0.value(ofAttribute: attr) }
        case .Element(let element):
            return [element].map { $0.value(ofAttribute: attr) }
        case .Stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    // MARK: - XMLElementDeserializable

    /**
    Attempts to deserialize the current XMLElement element to `T`

    - throws: an XMLDeserializationError.NodeIsInvalid if the current indexed level isn't an Element
    - returns: the deserialized `T` value
    */
    func value<T: XMLElementDeserializable>() throws -> T {
        switch self {
        case .Element(let element):
            return try T.deserialize(element)
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `T?`

    - returns: the deserialized `T?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> T? {
        switch self {
        case .Element(let element):
            return try T.deserialize(element)
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            return nil
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `[T]`

    - returns: the deserialized `[T]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> [T] {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize($0) }
        case .Element(let element):
            return try [element].map { try T.deserialize($0) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            return []
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `[T]?`

    - returns: the deserialized `[T]?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> [T]? {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize($0) }
        case .Element(let element):
            return try [element].map { try T.deserialize($0) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            return nil
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `[T?]`

    - returns: the deserialized `[T?]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> [T?] {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize($0) }
        case .Element(let element):
            return try [element].map { try T.deserialize($0) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            return []
        }
    }


    // MARK: - XMLIndexerDeserializable

    /**
    Attempts to deserialize the current XMLIndexer element to `T`

    - returns: the deserialized `T` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> T {
        switch self {
        case .Element:
            return try T.deserialize(self)
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `T?`

    - returns: the deserialized `T?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> T? {
        switch self {
        case .Element:
            return try T.deserialize(self)
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            return nil
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T]`

    - returns: the deserialized `[T]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T>() throws -> [T] where T: XMLIndexerDeserializable {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T]?`

    - returns: the deserialized `[T]?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> [T]? {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T?]`

    - returns: the deserialized `[T?]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> [T?] {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        case .Stream(let opStream):
            return try opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }
}

// MARK: - XMLElement Extensions

extension XMLElement {

    /**
     Attempts to deserialize the specified attribute of the current XMLElement to `T`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `T` value
     */
    public func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> T {
        if let attr = self.attribute(by: attr) {
            return try T.deserialize(attr)
        } else {
            throw XMLDeserializationError.AttributeDoesNotExist(element: self, attribute: attr)
        }
    }

    /**
     Attempts to deserialize the specified attribute of the current XMLElement to `T?`

     - parameter attr: The attribute to deserialize
     - returns: The deserialized `T?` value, or nil if the attribute does not exist.
     */
    public func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) -> T? {
        if let attr = self.attribute(by: attr) {
            return try? T.deserialize(attr)
        } else {
            return nil
        }
    }

    /**
     Gets the text associated with this element, or throws an exception if the text is empty

     - throws: XMLDeserializationError.NodeHasNoValue if the element text is empty
     - returns: The element text
     */
    internal func nonEmptyTextOrThrow() throws -> String {
        if let textVal = text, !textVal.characters.isEmpty {
            return textVal
        }

        throw XMLDeserializationError.NodeHasNoValue
    }
}

// MARK: - XMLDeserializationError

/// The error that is thrown if there is a problem with deserialization
public enum XMLDeserializationError: Error, CustomStringConvertible {
    case ImplementationIsMissing(method: String)
    case NodeIsInvalid(node: XMLIndexer)
    case NodeHasNoValue
    case TypeConversionFailed(type: String, element: XMLElement)
    case AttributeDoesNotExist(element: XMLElement, attribute: String)
    case AttributeDeserializationFailed(type: String, attribute: XMLAttribute)

    /// The text description for the error thrown
    public var description: String {
        switch self {
        case .ImplementationIsMissing(let method):
            return "This deserialization method is not implemented: \(method)"
        case .NodeIsInvalid(let node):
            return "This node is invalid: \(node)"
        case .NodeHasNoValue:
            return "This node is empty"
        case .TypeConversionFailed(let type, let node):
            return "Can't convert node \(node) to value of type \(type)"
        case .AttributeDoesNotExist(let element, let attribute):
            return "Element \(element) does not contain attribute: \(attribute)"
        case .AttributeDeserializationFailed(let type, let attribute):
            return "Can't convert attribute \(attribute) to value of type \(type)"
        }
    }
}


// MARK: - Common types deserialization

extension String: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a String

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized String value
    */
    public static func deserialize(_ element: XMLElement) throws -> String {
        guard let text = element.text else {
            throw XMLDeserializationError.TypeConversionFailed(type: "String", element: element)
        }
        return text
    }

    /**
     Attempts to deserialize XML Attribute content to a String

     - parameter attribute: the XMLAttribute to be deserialized
     - returns: the deserialized String value
     */
    public static func deserialize(_ attribute: XMLAttribute) -> String {
        return attribute.text
    }
}

extension Int: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a Int

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Int value
    */
    public static func deserialize(_ element: XMLElement) throws -> Int {
        guard let value = Int(try element.nonEmptyTextOrThrow()) else {
            throw XMLDeserializationError.TypeConversionFailed(type: "Int", element: element)
        }
        return value
    }

    /**
     Attempts to deserialize XML attribute content to an Int

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.AttributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Int value
     */
    public static func deserialize(_ attribute: XMLAttribute) throws -> Int {
        guard let value = Int(attribute.text) else {
            throw XMLDeserializationError.AttributeDeserializationFailed(
                type: "Int", attribute: attribute)
        }
        return value
    }
}

extension Double: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a Double

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Double value
    */
    public static func deserialize(_ element: XMLElement) throws -> Double {
        guard let value = Double(try element.nonEmptyTextOrThrow()) else {
            throw XMLDeserializationError.TypeConversionFailed(type: "Double", element: element)
        }
        return value
    }

    /**
     Attempts to deserialize XML attribute content to a Double

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.AttributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Double value
     */
    public static func deserialize(_ attribute: XMLAttribute) throws -> Double {
        guard let value = Double(attribute.text) else {
            throw XMLDeserializationError.AttributeDeserializationFailed(
                type: "Double", attribute: attribute)
        }
        return value
    }
}

extension Float: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a Float

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Float value
    */
    public static func deserialize(_ element: XMLElement) throws -> Float {
        guard let value = Float(try element.nonEmptyTextOrThrow()) else {
            throw XMLDeserializationError.TypeConversionFailed(type: "Float", element: element)
        }
        return value
    }

    /**
     Attempts to deserialize XML attribute content to a Float

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.AttributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Float value
     */
    public static func deserialize(_ attribute: XMLAttribute) throws -> Float {
        guard let value = Float(attribute.text) else {
            throw XMLDeserializationError.AttributeDeserializationFailed(
                type: "Float", attribute: attribute)
        }
        return value
    }
}

extension Bool: XMLElementDeserializable, XMLAttributeDeserializable {
    // swiftlint:disable line_length
    /**
     Attempts to deserialize XML element content to a Bool. This uses NSString's 'boolValue'
     described [here](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/#//apple_ref/occ/instp/NSString/boolValue)

     - parameters:
        - element: the XMLElement to be deserialized
     - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
     - returns: the deserialized Bool value
     */
    public static func deserialize(_ element: XMLElement) throws -> Bool {
        let value = Bool(NSString(string: try element.nonEmptyTextOrThrow()).boolValue)
        return value
    }

    /**
     Attempts to deserialize XML attribute content to a Bool. This uses NSString's 'boolValue'
     described [here](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/#//apple_ref/occ/instp/NSString/boolValue)

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.AttributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Bool value
     */
    public static func deserialize(_ attribute: XMLAttribute) throws -> Bool {
        let value = Bool(NSString(string: attribute.text).boolValue)
        return value
    }
    // swiftlint:enable line_length
}
//
//  SWXMLHash.swift
//
//  Copyright (c) 2014 David Mohundro
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

// swiftlint exceptions:
// - Disabled file_length because there are a number of users that still pull the
//   source down as is and it makes pulling the code into a project easier.

// swiftlint:disable file_length

import Foundation

let rootElementName = "SWXMLHash_Root_Element"

/// Parser options
public class SWXMLHashOptions {
    internal init() {}

    /// determines whether to parse the XML with lazy parsing or not
    public var shouldProcessLazily = false

    /// determines whether to parse XML namespaces or not (forwards to
    /// `XMLParser.shouldProcessNamespaces`)
    public var shouldProcessNamespaces = false
}

/// Simple XML parser
public class SWXMLHash {
    let options: SWXMLHashOptions

    private init(_ options: SWXMLHashOptions = SWXMLHashOptions()) {
        self.options = options
    }

    /**
    Method to configure how parsing works.

    - parameters:
        - configAction: a block that passes in an `SWXMLHashOptions` object with
        options to be set
    - returns: an `SWXMLHash` instance
    */
    class public func config(_ configAction: (SWXMLHashOptions) -> ()) -> SWXMLHash {
        let opts = SWXMLHashOptions()
        configAction(opts)
        return SWXMLHash(opts)
    }

    /**
    Begins parsing the passed in XML string.

    - parameters:
        - xml: an XML string. __Note__ that this is not a URL but a
        string containing XML.
    - returns: an `XMLIndexer` instance that can be iterated over
    */
    public func parse(_ xml: String) -> XMLIndexer {
        return parse(xml.data(using: String.Encoding.utf8)!)
    }

    /**
    Begins parsing the passed in XML string.

    - parameters:
        - data: a `Data` instance containing XML
        - returns: an `XMLIndexer` instance that can be iterated over
    */
    public func parse(_ data: Data) -> XMLIndexer {
        let parser: SimpleXmlParser = options.shouldProcessLazily
            ? LazyXMLParser(options)
            : FullXMLParser(options)
        return parser.parse(data)
    }

    /**
    Method to parse XML passed in as a string.

    - parameter xml: The XML to be parsed
    - returns: An XMLIndexer instance that is used to look up elements in the XML
    */
    class public func parse(_ xml: String) -> XMLIndexer {
        return SWXMLHash().parse(xml)
    }

    /**
    Method to parse XML passed in as a Data instance.

    - parameter data: The XML to be parsed
    - returns: An XMLIndexer instance that is used to look up elements in the XML
    */
    class public func parse(_ data: Data) -> XMLIndexer {
        return SWXMLHash().parse(data)
    }

    /**
    Method to lazily parse XML passed in as a string.

    - parameter xml: The XML to be parsed
    - returns: An XMLIndexer instance that is used to look up elements in the XML
    */
    class public func lazy(_ xml: String) -> XMLIndexer {
        return config { conf in conf.shouldProcessLazily = true }.parse(xml)
    }

    /**
    Method to lazily parse XML passed in as a Data instance.

    - parameter data: The XML to be parsed
    - returns: An XMLIndexer instance that is used to look up elements in the XML
    */
    class public func lazy(_ data: Data) -> XMLIndexer {
        return config { conf in conf.shouldProcessLazily = true }.parse(data)
    }
}

struct Stack<T> {
    var items = [T]()
    mutating func push(_ item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
    mutating func drop() {
        let _ = pop()
    }
    mutating func removeAll() {
        items.removeAll(keepingCapacity: false)
    }
    func top() -> T {
        return items[items.count - 1]
    }
}

protocol SimpleXmlParser {
    init(_ options: SWXMLHashOptions)
    func parse(_ data: Data) -> XMLIndexer
}

#if os(Linux)

extension XMLParserDelegate {

    func parserDidStartDocument(_ parser: Foundation.XMLParser) { }
    func parserDidEndDocument(_ parser: Foundation.XMLParser) { }

    func parser(_ parser: Foundation.XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) { }

    func parser(_ parser: Foundation.XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) { }

    func parser(_ parser: Foundation.XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) { }

    func parser(_ parser: Foundation.XMLParser, foundElementDeclarationWithName elementName: String, model: String) { }

    func parser(_ parser: Foundation.XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) { }

    func parser(_ parser: Foundation.XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) { }

    func parser(_ parser: Foundation.XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) { }

    func parser(_ parser: Foundation.XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) { }

    func parser(_ parser: Foundation.XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) { }

    func parser(_ parser: Foundation.XMLParser, didEndMappingPrefix prefix: String) { }

    func parser(_ parser: Foundation.XMLParser, foundCharacters string: String) { }

    func parser(_ parser: Foundation.XMLParser, foundIgnorableWhitespace whitespaceString: String) { }

    func parser(_ parser: Foundation.XMLParser, foundProcessingInstructionWithTarget target: String, data: String?) { }

    func parser(_ parser: Foundation.XMLParser, foundComment comment: String) { }

    func parser(_ parser: Foundation.XMLParser, foundCDATA CDATABlock: Data) { }

    func parser(_ parser: Foundation.XMLParser, resolveExternalEntityName name: String, systemID: String?) -> Data? { return nil }

    func parser(_ parser: Foundation.XMLParser, parseErrorOccurred parseError: NSError) { }

    func parser(_ parser: Foundation.XMLParser, validationErrorOccurred validationError: NSError) { }
}

#endif

/// The implementation of XMLParserDelegate and where the lazy parsing actually happens.
class LazyXMLParser: NSObject, SimpleXmlParser, XMLParserDelegate {
    required init(_ options: SWXMLHashOptions) {
        self.options = options
        super.init()
    }

    var root = XMLElement(name: rootElementName)
    var parentStack = Stack<XMLElement>()
    var elementStack = Stack<String>()

    var data: Data?
    var ops: [IndexOp] = []
    let options: SWXMLHashOptions

    func parse(_ data: Data) -> XMLIndexer {
        self.data = data
        return XMLIndexer(self)
    }

    func startParsing(_ ops: [IndexOp]) {
        // clear any prior runs of parse... expected that this won't be necessary,
        // but you never know
        parentStack.removeAll()
        root = XMLElement(name: rootElementName)
        parentStack.push(root)

        self.ops = ops
        let parser = Foundation.XMLParser(data: data!)
        parser.shouldProcessNamespaces = options.shouldProcessNamespaces
        parser.delegate = self
        _ = parser.parse()
    }

    func parser(_ parser: Foundation.XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String]) {

        elementStack.push(elementName)

        if !onMatch() {
            return
        }
#if os(Linux)
        let attributeNSDict = NSDictionary(objects: attributeDict.values.flatMap({ $0 as? AnyObject }), forKeys: attributeDict.keys.map({ NSString(string: $0) as NSObject }))
        let currentNode = parentStack.top().addElement(elementName, withAttributes: attributeNSDict)
#else
        let currentNode = parentStack.top().addElement(elementName, withAttributes: attributeDict as NSDictionary)
#endif
        parentStack.push(currentNode)
    }

    func parser(_ parser: Foundation.XMLParser, foundCharacters string: String) {
        if !onMatch() {
            return
        }

        let current = parentStack.top()

        current.addText(string)
    }

    func parser(_ parser: Foundation.XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {

        let match = onMatch()

        elementStack.drop()

        if match {
            parentStack.drop()
        }
    }

    func onMatch() -> Bool {
        // we typically want to compare against the elementStack to see if it matches ops, *but*
        // if we're on the first element, we'll instead compare the other direction.
        if elementStack.items.count > ops.count {
            return elementStack.items.starts(with: ops.map { $0.key })
        } else {
            return ops.map { $0.key }.starts(with: elementStack.items)
        }
    }
}

/// The implementation of XMLParserDelegate and where the parsing actually happens.
class FullXMLParser: NSObject, SimpleXmlParser, XMLParserDelegate {
    required init(_ options: SWXMLHashOptions) {
        self.options = options
        super.init()
    }

    var root = XMLElement(name: rootElementName)
    var parentStack = Stack<XMLElement>()
    let options: SWXMLHashOptions

    func parse(_ data: Data) -> XMLIndexer {
        // clear any prior runs of parse... expected that this won't be necessary,
        // but you never know
        parentStack.removeAll()

        parentStack.push(root)

        let parser = Foundation.XMLParser(data: data)
        parser.shouldProcessNamespaces = options.shouldProcessNamespaces
        parser.delegate = self
        _ = parser.parse()

        return XMLIndexer(root)
    }

    func parser(_ parser: Foundation.XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String]) {
#if os(Linux)
        let attributeNSDict = NSDictionary(objects: attributeDict.values.flatMap({ $0 as? AnyObject }), forKeys: attributeDict.keys.map({ NSString(string: $0) as NSObject }))
        let currentNode = parentStack.top().addElement(elementName, withAttributes: attributeNSDict)
#else
        let currentNode = parentStack.top().addElement(elementName, withAttributes: attributeDict as NSDictionary)
#endif
        parentStack.push(currentNode)
    }

    func parser(_ parser: Foundation.XMLParser, foundCharacters string: String) {
        let current = parentStack.top()

        current.addText(string)
    }

    func parser(_ parser: Foundation.XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {

        parentStack.drop()
    }
}

/// Represents an indexed operation against a lazily parsed `XMLIndexer`
public class IndexOp {
    var index: Int
    let key: String

    init(_ key: String) {
        self.key = key
        self.index = -1
    }

    func toString() -> String {
        if index >= 0 {
            return key + " " + index.description
        }

        return key
    }
}

/// Represents a collection of `IndexOp` instances. Provides a means of iterating them
/// to find a match in a lazily parsed `XMLIndexer` instance.
public class IndexOps {
    var ops: [IndexOp] = []

    let parser: LazyXMLParser

    init(parser: LazyXMLParser) {
        self.parser = parser
    }

    func findElements() -> XMLIndexer {
        parser.startParsing(ops)
        let indexer = XMLIndexer(parser.root)
        var childIndex = indexer
        for op in ops {
            childIndex = childIndex[op.key]
            if op.index >= 0 {
                childIndex = childIndex[op.index]
            }
        }
        ops.removeAll(keepingCapacity: false)
        return childIndex
    }

    func stringify() -> String {
        var s = ""
        for op in ops {
            s += "[" + op.toString() + "]"
        }
        return s
    }
}

/// Error type that is thrown when an indexing or parsing operation fails.
public enum IndexingError: Error {
    case Attribute(attr: String)
    case AttributeValue(attr: String, value: String)
    case Key(key: String)
    case Index(idx: Int)
    case Init(instance: AnyObject)
    case Error
}

/// Returned from SWXMLHash, allows easy element lookup into XML data.
public enum XMLIndexer: Sequence {
    case Element(XMLElement)
    case List([XMLElement])
    case Stream(IndexOps)
    case XMLError(IndexingError)


    /// The underlying XMLElement at the currently indexed level of XML.
    public var element: XMLElement? {
        switch self {
        case .Element(let elem):
            return elem
        case .Stream(let ops):
            let list = ops.findElements()
            return list.element
        default:
            return nil
        }
    }

    /// All elements at the currently indexed level
    public var all: [XMLIndexer] {
        switch self {
        case .List(let list):
            var xmlList = [XMLIndexer]()
            for elem in list {
                xmlList.append(XMLIndexer(elem))
            }
            return xmlList
        case .Element(let elem):
            return [XMLIndexer(elem)]
        case .Stream(let ops):
            let list = ops.findElements()
            return list.all
        default:
            return []
        }
    }

    /// All child elements from the currently indexed level
    public var children: [XMLIndexer] {
        var list = [XMLIndexer]()
        for elem in all.map({ $0.element! }).flatMap({ $0 }) {
            for elem in elem.xmlChildren {
                list.append(XMLIndexer(elem))
            }
        }
        return list
    }

    /**
    Allows for element lookup by matching attribute values.

    - parameters:
        - attr: should the name of the attribute to match on
        - value: should be the value of the attribute to match on
    - throws: an XMLIndexer.XMLError if an element with the specified attribute isn't found
    - returns: instance of XMLIndexer
    */
    public func withAttr(_ attr: String, _ value: String) throws -> XMLIndexer {
        switch self {
        case .Stream(let opStream):
            let match = opStream.findElements()
            return try match.withAttr(attr, value)
        case .List(let list):
            if let elem = list.filter({$0.attribute(by: attr)?.text == value}).first {
                return .Element(elem)
            }
            throw IndexingError.AttributeValue(attr: attr, value: value)
        case .Element(let elem):
            if elem.attribute(by: attr)?.text == value {
                return .Element(elem)
            }
            throw IndexingError.AttributeValue(attr: attr, value: value)
        default:
            throw IndexingError.Attribute(attr: attr)
        }
    }

    /**
    Initializes the XMLIndexer

    - parameter _: should be an instance of XMLElement, but supports other values for error handling
    - throws: an Error if the object passed in isn't an XMLElement or LaxyXMLParser
    */
    public init(_ rawObject: AnyObject) throws {
        switch rawObject {
        case let value as XMLElement:
            self = .Element(value)
        case let value as LazyXMLParser:
            self = .Stream(IndexOps(parser: value))
        default:
            throw IndexingError.Init(instance: rawObject)
        }
    }

    /**
    Initializes the XMLIndexer

    - parameter _: an instance of XMLElement
    */
    public init(_ elem: XMLElement) {
        self = .Element(elem)
    }

    init(_ stream: LazyXMLParser) {
        self = .Stream(IndexOps(parser: stream))
    }

    /**
    Find an XML element at the current level by element name

    - parameter key: The element name to index by
    - returns: instance of XMLIndexer to match the element (or elements) found by key
    - throws: Throws an XMLIndexingError.Key if no element was found
    */
    public func byKey(_ key: String) throws -> XMLIndexer {
        switch self {
        case .Stream(let opStream):
            let op = IndexOp(key)
            opStream.ops.append(op)
            return .Stream(opStream)
        case .Element(let elem):
            let match = elem.xmlChildren.filter({ $0.name == key })
            if !match.isEmpty {
                if match.count == 1 {
                    return .Element(match[0])
                } else {
                    return .List(match)
                }
            }
            fallthrough
        default:
            throw IndexingError.Key(key: key)
        }
    }

    /**
    Find an XML element at the current level by element name

    - parameter key: The element name to index by
    - returns: instance of XMLIndexer to match the element (or elements) found by
    */
    public subscript(key: String) -> XMLIndexer {
        do {
           return try self.byKey(key)
        } catch let error as IndexingError {
            return .XMLError(error)
        } catch {
            return .XMLError(IndexingError.Key(key: key))
        }
    }

    /**
    Find an XML element by index within a list of XML Elements at the current level

    - parameter index: The 0-based index to index by
    - throws: XMLIndexer.XMLError if the index isn't found
    - returns: instance of XMLIndexer to match the element (or elements) found by index
    */
    public func byIndex(_ index: Int) throws -> XMLIndexer {
        switch self {
        case .Stream(let opStream):
            opStream.ops[opStream.ops.count - 1].index = index
            return .Stream(opStream)
        case .List(let list):
            if index <= list.count {
                return .Element(list[index])
            }
            return .XMLError(IndexingError.Index(idx: index))
        case .Element(let elem):
            if index == 0 {
                return .Element(elem)
            }
            fallthrough
        default:
            return .XMLError(IndexingError.Index(idx: index))
        }
    }

    /**
    Find an XML element by index

    - parameter index: The 0-based index to index by
    - returns: instance of XMLIndexer to match the element (or elements) found by index
    */
    public subscript(index: Int) -> XMLIndexer {
        do {
            return try byIndex(index)
        } catch let error as IndexingError {
            return .XMLError(error)
        } catch {
            return .XMLError(IndexingError.Index(idx: index))
        }
    }

    typealias GeneratorType = XMLIndexer

    /**
    Method to iterate (for-in) over the `all` collection

    - returns: an array of `XMLIndexer` instances
    */
    public func makeIterator() -> IndexingIterator<[XMLIndexer]> {
        return all.makeIterator()
    }
}

/// XMLIndexer extensions
/*
extension XMLIndexer: Boolean {
    /// True if a valid XMLIndexer, false if an error type
    public var boolValue: Bool {
        switch self {
        case .XMLError:
            return false
        default:
            return true
        }
    }
}
 */

extension XMLIndexer: CustomStringConvertible {
    /// The XML representation of the XMLIndexer at the current level
    public var description: String {
        switch self {
        case .List(let list):
            return list.map { $0.description }.joined(separator: "")
        case .Element(let elem):
            if elem.name == rootElementName {
                return elem.children.map { $0.description }.joined(separator: "")
            }

            return elem.description
        default:
            return ""
        }
    }
}

extension IndexingError: CustomStringConvertible {
    /// The description for the `IndexingError`.
    public var description: String {
        switch self {
        case .Attribute(let attr):
            return "XML Attribute Error: Missing attribute [\"\(attr)\"]"
        case .AttributeValue(let attr, let value):
            return "XML Attribute Error: Missing attribute [\"\(attr)\"] with value [\"\(value)\"]"
        case .Key(let key):
            return "XML Element Error: Incorrect key [\"\(key)\"]"
        case .Index(let index):
            return "XML Element Error: Incorrect index [\"\(index)\"]"
        case .Init(let instance):
            return "XML Indexer Error: initialization with Object [\"\(instance)\"]"
        case .Error:
            return "Unknown Error"
        }
    }
}

/// Models content for an XML doc, whether it is text or XML
public protocol XMLContent: CustomStringConvertible { }

/// Models a text element
public class TextElement: XMLContent {
    /// The underlying text value
    public let text: String
    init(text: String) {
        self.text = text
    }
}

public struct XMLAttribute {
    public let name: String
    public let text: String
    init(name: String, text: String) {
        self.name = name
        self.text = text
    }
}

/// Models an XML element, including name, text and attributes
public class XMLElement: XMLContent {
    /// The name of the element
    public let name: String

    /// The attributes of the element
    @available(*, deprecated, message: "See `allAttributes` instead, which introduces the XMLAttribute type over a simple String type")
    public var attributes: [String:String] {
        var attrMap = [String: String]()
        for (name, attr) in allAttributes {
            attrMap[name] = attr.text
        }
        return attrMap
    }

    public var allAttributes = [String:XMLAttribute]()

    public func attribute(by name: String) -> XMLAttribute? {
        return allAttributes[name]
    }

    /// The inner text of the element, if it exists
    public var text: String? {
        return children
            .map({ $0 as? TextElement })
            .flatMap({ $0 })
            .reduce("", { $0 + $1!.text })
    }

    /// All child elements (text or XML)
    public var children = [XMLContent]()
    var count: Int = 0
    var index: Int

    var xmlChildren: [XMLElement] {
        return children.map { $0 as? XMLElement }.flatMap { $0 }
    }

    /**
    Initialize an XMLElement instance

    - parameters:
        - name: The name of the element to be initialized
        - index: The index of the element to be initialized
    */
    init(name: String, index: Int = 0) {
        self.name = name
        self.index = index
    }

    /**
    Adds a new XMLElement underneath this instance of XMLElement

    - parameters:
        - name: The name of the new element to be added
        - withAttributes: The attributes dictionary for the element being added
    - returns: The XMLElement that has now been added
    */
    func addElement(_ name: String, withAttributes attributes: NSDictionary) -> XMLElement {
        let element = XMLElement(name: name, index: count)
        count += 1

        children.append(element)

        for (keyAny, valueAny) in attributes {
            if let key = keyAny as? String,
                let value = valueAny as? String {
                element.allAttributes[key] = XMLAttribute(name: key, text: value)
            }
        }

        return element
    }

    func addText(_ text: String) {
        let elem = TextElement(text: text)

        children.append(elem)
    }
}

extension TextElement: CustomStringConvertible {
    /// The text value for a `TextElement` instance.
    public var description: String {
        return text
    }
}

extension XMLAttribute: CustomStringConvertible {
    /// The textual representation of an `XMLAttribute` instance.
    public var description: String {
        return "\(name)=\"\(text)\""
    }
}

extension XMLElement: CustomStringConvertible {
    /// The tag, attributes and content for a `XMLElement` instance (<elem id="foo">content</elem>)
    public var description: String {
        var attributesString = allAttributes.map { $0.1.description }.joined(separator: " ")
        if !attributesString.isEmpty {
            attributesString = " " + attributesString
        }

        if !children.isEmpty {
            var xmlReturn = [String]()
            xmlReturn.append("<\(name)\(attributesString)>")
            for child in children {
                xmlReturn.append(child.description)
            }
            xmlReturn.append("</\(name)>")
            return xmlReturn.joined(separator: "")
        }

        if text != nil {
            return "<\(name)\(attributesString)>\(text!)</\(name)>"
        } else {
            return "<\(name)\(attributesString)/>"
        }
    }
}

// Workaround for "'XMLElement' is ambiguous for type lookup in this context" error on macOS.
//
// On macOS, `XMLElement` is defined in Foundation.
// So, the code referencing `XMLElement` generates above error.
// Following code allow to using `SWXMLhash.XMLElement` in client codes.
extension SWXMLHash {
    public typealias XMLElement = SWXMLHashXMLElement
}

public  typealias SWXMLHashXMLElement = XMLElement
//
//  TextAttachment.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 27/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class TextAttachment: NSTextAttachment {

	override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {

		if image == nil {
			return lineFrag
		}
		
		let height: CGFloat = lineFrag.size.height
		let imageSize = image!.size
		let scalingFactor: CGFloat = height / imageSize.height
		
		let rect = CGRect(x: 0, y: 0, width: imageSize.width * scalingFactor, height: imageSize.height * scalingFactor)
		return rect
	}
}
//
//  Time.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 8/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

extension Date {
    
    func timeName() -> String{
        let components = (Calendar.current as NSCalendar).components([.hour], from: self)
        let hour = components.hour!
        
        switch  hour {
		case 6..<12:
            return "Morning"
        case 12:
            return "Noon"
        case 13..<17:
            return "Afternoon"
        case 17..<22:
            return "Evening"
        default:
            return "Night"
        }
    }
}
//
//  UIButtonAnimation.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 21/11/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

class UIButtonAnimation: UIButton {
	var showsMenu: Bool = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func animate(animationType: CAnimationType) {}
	
	func updateFrame(frame: CGRect) {}
}

enum CAnimationType {
	case Automatic
	case Force_Open
	case Force_Close
}
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
//
//  UIImage+Alpha.swift
//
//  Created by Trevor Harmon on 09/20/09.
//  Swift 3 port by Giacomo Boccardo on 09/15/2016.
//
//  Free for personal or commercial use, with or without modification
//  No warranty is expressed or implied.
//
import UIKit

public extension UIImage {
    
    public func hasAlpha() -> Bool {
        let alpha: CGImageAlphaInfo = (self.cgImage)!.alphaInfo
        return
            alpha == CGImageAlphaInfo.first ||
            alpha == CGImageAlphaInfo.last ||
            alpha == CGImageAlphaInfo.premultipliedFirst ||
            alpha == CGImageAlphaInfo.premultipliedLast
    }
    
    public func imageWithAlpha() -> UIImage {
        if self.hasAlpha() {
            return self
        }
        
        let imageRef:CGImage = self.cgImage!
        let width  = imageRef.width
        let height = imageRef.height

        // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
        let offscreenContext: CGContext = CGContext(
            data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
            space: imageRef.colorSpace!,
            bitmapInfo: 0 /*CGImageByteOrderInfo.orderMask.rawValue*/ | CGImageAlphaInfo.premultipliedFirst.rawValue
        )!
        
        // Draw the image into the context and retrieve the new image, which will now have an alpha layer
        offscreenContext.draw(imageRef, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let imageRefWithAlpha:CGImage = offscreenContext.makeImage()!
        
        return UIImage(cgImage: imageRefWithAlpha)
    }
    
    public func transparentBorderImage(_ borderSize: Int) -> UIImage {
        let image = self.imageWithAlpha()
        
        let newRect = CGRect(
            x: 0, y: 0,
            width: image.size.width + CGFloat(borderSize) * 2,
            height: image.size.height + CGFloat(borderSize) * 2
        )
    
        
        // Build a context that's the same dimensions as the new size
        let bitmap: CGContext = CGContext(
            data: nil,
            width: Int(newRect.size.width), height: Int(newRect.size.height),
            bitsPerComponent: (self.cgImage)!.bitsPerComponent,
            bytesPerRow: 0,
            space: (self.cgImage)!.colorSpace!,
            bitmapInfo: (self.cgImage)!.bitmapInfo.rawValue
        )!
        
        // Draw the image in the center of the context, leaving a gap around the edges
        let imageLocation = CGRect(x: CGFloat(borderSize), y: CGFloat(borderSize), width: image.size.width, height: image.size.height)
        bitmap.draw(self.cgImage!, in: imageLocation)
        let borderImageRef: CGImage = bitmap.makeImage()!
        
        // Create a mask to make the border transparent, and combine it with the image
        let maskImageRef: CGImage = self.newBorderMask(borderSize, size: newRect.size)
        let transparentBorderImageRef: CGImage = borderImageRef.masking(maskImageRef)!
        return UIImage(cgImage:transparentBorderImageRef)
    }
    
    fileprivate func newBorderMask(_ borderSize: Int, size: CGSize) -> CGImage {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        
        // Build a context that's the same dimensions as the new size
        let maskContext: CGContext = CGContext(
            data: nil,
            width: Int(size.width), height: Int(size.height),
            bitsPerComponent: 8, // 8-bit grayscale
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo().rawValue | CGImageAlphaInfo.none.rawValue
        )!
        
        // Start with a mask that's entirely transparent
        maskContext.setFillColor(UIColor.black.cgColor)
        maskContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Make the inner part (within the border) opaque
        maskContext.setFillColor(UIColor.white.cgColor)
        maskContext.fill(CGRect(
            x: CGFloat(borderSize),
            y: CGFloat(borderSize),
            width: size.width - CGFloat(borderSize) * 2,
            height: size.height - CGFloat(borderSize) * 2)
        )
        
        // Get an image of the context
        return maskContext.makeImage()!
    }
}
//
//  UIImage+Resize.swift
//
//  Created by Trevor Harmon on 08/05/09.
//  Swift 3 port by Giacomo Boccardo on 09/15/2016.
//
//  Free for personal or commercial use, with or without modification
//  No warranty is expressed or implied.
//
import UIKit

public extension UIImage {
    
    // Returns a copy of this image that is cropped to the given bounds.
    // The bounds will be adjusted using CGRectIntegral.
    // This method ignores the image's imageOrientation setting.
    public func croppedImage(_ bounds: CGRect) -> UIImage {
        let imageRef: CGImage = (self.cgImage)!.cropping(to: bounds)!
        return UIImage(cgImage: imageRef)
    }
    
    public func thumbnailImage(_ thumbnailSize: Int, transparentBorder borderSize:Int, cornerRadius:Int, interpolationQuality quality:CGInterpolationQuality) -> UIImage {
        let resizedImage = self.resizedImageWithContentMode(.scaleAspectFill, bounds: CGSize(width: CGFloat(thumbnailSize), height: CGFloat(thumbnailSize)), interpolationQuality: quality)
 
        // Crop out any part of the image that's larger than the thumbnail size
        // The cropped rect must be centered on the resized image
        // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
        let cropRect = CGRect(
            x: round((resizedImage.size.width - CGFloat(thumbnailSize))/2),
            y: round((resizedImage.size.height - CGFloat(thumbnailSize))/2),
            width: CGFloat(thumbnailSize),
            height: CGFloat(thumbnailSize)
        )
        
        let croppedImage = resizedImage.croppedImage(cropRect)
        let transparentBorderImage = borderSize != 0 ? croppedImage.transparentBorderImage(borderSize) : croppedImage
        
        return transparentBorderImage.roundedCornerImage(cornerSize: cornerRadius, borderSize: borderSize)
    }
    
    // Returns a rescaled copy of the image, taking into account its orientation
    // The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
    public func resizedImage(_ newSize: CGSize, interpolationQuality quality: CGInterpolationQuality) -> UIImage {
        var drawTransposed: Bool
        
        switch(self.imageOrientation) {
            case .left, .leftMirrored, .right, .rightMirrored:
                drawTransposed = true
            default:
                drawTransposed = false
        }
        
        return self.resizedImage(
            newSize,
            transform: self.transformForOrientation(newSize),
            drawTransposed: drawTransposed,
            interpolationQuality: quality
        )
    }
    
    public func resizedImageWithContentMode(_ contentMode: UIViewContentMode, bounds: CGSize, interpolationQuality quality: CGInterpolationQuality) -> UIImage {
        let horizontalRatio = bounds.width / self.size.width
        let verticalRatio = bounds.height / self.size.height
        var ratio: CGFloat = 1

        switch(contentMode) {
            case .scaleAspectFill:
                ratio = max(horizontalRatio, verticalRatio)
            case .scaleAspectFit:
                ratio = min(horizontalRatio, verticalRatio)
            default:
                fatalError("Unsupported content mode \(contentMode)")
        }

        let newSize: CGSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        return self.resizedImage(newSize, interpolationQuality: quality)
    }
    
    fileprivate func normalizeBitmapInfo(_ bI: CGBitmapInfo) -> UInt32 {
        var alphaInfo: UInt32 = bI.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        if alphaInfo == CGImageAlphaInfo.last.rawValue {
            alphaInfo =  CGImageAlphaInfo.premultipliedLast.rawValue
        }

        if alphaInfo == CGImageAlphaInfo.first.rawValue {
            alphaInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        }

        var newBI: UInt32 = bI.rawValue & ~CGBitmapInfo.alphaInfoMask.rawValue;

        newBI |= alphaInfo;

        return newBI
    }
    
    fileprivate func resizedImage(_ newSize: CGSize, transform: CGAffineTransform, drawTransposed transpose: Bool, interpolationQuality quality: CGInterpolationQuality) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        let transposedRect = CGRect(x: 0, y: 0, width: newRect.size.height, height: newRect.size.width)
        let imageRef: CGImage = self.cgImage!

        // Build a context that's the same dimensions as the new size
        let bitmap: CGContext = CGContext(
            data: nil,
            width: Int(newRect.size.width),
            height: Int(newRect.size.height),
            bitsPerComponent: imageRef.bitsPerComponent,
            bytesPerRow: 0,
            space: imageRef.colorSpace!,
            bitmapInfo: normalizeBitmapInfo(imageRef.bitmapInfo)
        )!

        // Rotate and/or flip the image if required by its orientation
        bitmap.concatenate(transform)

        // Set the quality level to use when rescaling
        bitmap.interpolationQuality = quality

        // Draw into the context; this scales the image
        bitmap.draw(imageRef, in: transpose ? transposedRect: newRect)

        // Get the resized image from the context and a UIImage
        let newImageRef: CGImage = bitmap.makeImage()!
        return UIImage(cgImage: newImageRef)
    }
    
    fileprivate func transformForOrientation(_ newSize: CGSize) -> CGAffineTransform {
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch (self.imageOrientation) {
            case .down, .downMirrored:
                // EXIF = 3 / 4
                transform = transform.translatedBy(x: newSize.width, y: newSize.height)
                transform = transform.rotated(by: CGFloat(Double.pi))
            case .left, .leftMirrored:
                // EXIF = 6 / 5
                transform = transform.translatedBy(x: newSize.width, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi / 2))
            case .right, .rightMirrored:
                // EXIF = 8 / 7
                transform = transform.translatedBy(x: 0, y: newSize.height)
                transform = transform.rotated(by: -CGFloat(Double.pi / 2))
            default:
                break
        }
        
        switch(self.imageOrientation) {
            case .upMirrored, .downMirrored:
                // EXIF = 2 / 4
                transform = transform.translatedBy(x: newSize.width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            case .leftMirrored, .rightMirrored:
                // EXIF = 5 / 7
                transform = transform.translatedBy(x: newSize.height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            default:
                break
        }
        
        return transform
    }
}
//
//  UIImage+RoundedCorner.swift
//
//  Created by Trevor Harmon on 09/20/09.
//  Swift 3 port by Giacomo Boccardo on 09/15/2016.
//
//  Free for personal or commercial use, with or without modification
//  No warranty is expressed or implied.
//
import UIKit

public extension UIImage {
    
    // Creates a copy of this image with rounded corners
    // If borderSize is non-zero, a transparent border of the given size will also be added
    // Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
    public func roundedCornerImage(cornerSize:Int, borderSize:Int) -> UIImage
    {
        // If the image does not have an alpha layer, add one
        let image = self.imageWithAlpha()
        
        // Build a context that's the same dimensions as the new size
        let context: CGContext = CGContext(
            data: nil,
            width: Int(image.size.width),
            height: Int(image.size.height),
            bitsPerComponent: (image.cgImage)!.bitsPerComponent,
            bytesPerRow: 0,
            space: (image.cgImage)!.colorSpace!,
            bitmapInfo: (image.cgImage)!.bitmapInfo.rawValue
        )!
        
        // Create a clipping path with rounded corners
        context.beginPath()
        self.addRoundedRectToPath(
            CGRect(
                x: CGFloat(borderSize),
                y: CGFloat(borderSize),
                width: image.size.width - CGFloat(borderSize) * 2,
                height: image.size.height - CGFloat(borderSize) * 2),
            context:context,
            ovalWidth:CGFloat(cornerSize),
            ovalHeight:CGFloat(cornerSize)
        )
        context.closePath()
        context.clip()
        
        // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // Create a CGImage from the context
        let clippedImage: CGImage = context.makeImage()!
        
        // Create a UIImage from the CGImage
        return UIImage(cgImage: clippedImage)
    }
    
    // Adds a rectangular path to the given context and rounds its corners by the given extents
    // Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
    fileprivate func addRoundedRectToPath(_ rect: CGRect, context: CGContext, ovalWidth: CGFloat, ovalHeight: CGFloat)
    {
        if (ovalWidth == 0 || ovalHeight == 0) {
            context.addRect(rect)
            return
        }
        
        context.saveGState()
        context.translateBy(x: rect.minX, y: rect.minY)
        context.scaleBy(x: ovalWidth, y: ovalHeight)
        let fw = rect.width / ovalWidth
        let fh = rect.height / ovalHeight
        context.move(to: CGPoint(x: fw, y: fh/2))
        context.addArc(tangent1End: CGPoint(x: fw, y: fh), tangent2End: CGPoint(x: fw/2, y: fh), radius: 1)
        context.addArc(tangent1End: CGPoint(x: 0, y: fh), tangent2End: CGPoint(x: 0, y: fh/2), radius: 1)
        context.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: fw/2, y: 0), radius: 1)
        context.addArc(tangent1End: CGPoint(x: fw, y: 0), tangent2End: CGPoint(x: fw, y: fh/2), radius: 1)
        
        context.closePath();
        context.restoreGState()
    }
}

//
//  ImageViewExtension.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 11/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension UIImageView {
	func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
		contentMode = mode
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
				else { print("Failed to download image."); return }
			DispatchQueue.main.async() { () -> Void in
				self.image = image
			}
		}.resume()
	}
}

extension UIImage {
	
	func with(size: CGSize) -> UIImage? {
		UIGraphicsBeginImageContext(size)
		self.draw(in: CGRect(origin: CGPoint.zero, size: size))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}
//
//  UITextView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 1/03/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension UITextView {
	
	//MARK: - Sizing
	func setMaxFontSize(minSize: CGFloat = 10, maxSize: CGFloat = 28) {
		var maxSize = maxSize
		while (maxSize > minSize && self.sizeThatFits(CGSize(width: self.frame.size.width, height: CGFloat(Float.greatestFiniteMagnitude))).height >= self.frame.size.height) {
			maxSize -= 1.0;
			self.font = self.font?.withSize(maxSize)
		}
	}
	
	func centerVertically() {
		var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
		topCorrect = topCorrect > 0.0 ? topCorrect : 0
		print(topCorrect)
		self.contentOffset = CGPoint(x: 0, y: -topCorrect)
		self.contentInset = UIEdgeInsets(top: topCorrect, left: 0, bottom: 0, right: 0)
	}
}
//
//  UIView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 14/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension UIView {
	func rotate(toValue: CGFloat, duration: CFTimeInterval = 0.2) {
		let animation = CABasicAnimation(keyPath: "transform.rotation")
		
		animation.toValue = toValue
		animation.duration = duration
		animation.isRemovedOnCompletion = false
		animation.fillMode = kCAFillModeForwards
		
		self.layer.add(animation, forKey: nil)
	}
}
//
//  AppDelegate.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 6/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	
	var currentViewController: AnyObject? = nil
	
	var spaWebView: UIWebView?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().isTranslucent = true
		UIApplication.shared.isStatusBarHidden = false
		UIApplication.shared.statusBarStyle = .lightContent
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

//
//  Constants.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 6/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation
import MapKit

struct Constants {
    //MARK: - Sizes
    static let menuWidth: CGFloat = 150
    
    //MARK: - Fonts
    static let navigationFont = [ NSFontAttributeName: UIFont(name: "Verdana", size: 24)!, NSForegroundColorAttributeName: NavigationController.fontColor] as [String : Any]
    
    //MARK: - Locations
    static let hotelLocation = CLLocation(latitude: -39.2520306, longitude: -071.8415417)
	static let hotelRegion = MKMapRect(origin: MKMapPoint(x: Constants.hotelLocation.coordinate.longitude, y: Constants.hotelLocation.coordinate.latitude), size: MKMapSize(width: 1, height: 1))
    
    //MARK: - Helper Functions
    static func locationToMapPoint(_ location: CLLocation, regionRadius: CLLocationDistance) -> MKCoordinateRegion {
        return MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
    }
	
	//MARK: - Rects
	static let navigationItemRect = CGRect(x: 0, y: 0, width: 30, height: 30)
}
//
//  DynamicUITableView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 4/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class DynamicUITableView: UITableView {
	
}
//
//  ExcursionDataModel.swift
//  ExcursionCreator
//
//  Created by Jorge Paravicini on 10/10/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation
import MapKit

class ExcursionDataModel {
	
	var uuid: String?
	
    var title: String
	var images: [(URL, String)]?
    var thumbnailImage: URL?
	var thumbnailText: String?
	var m_description: String
    
	var difficulty: String?
	
	var duration: String?
	
	var isFavourite: Bool = false
	var type: String?
	
	var tableContent: [DetailTableContent]?
	
	var doesGPXExist: Bool {
		get {
			return (gpxFileURL != nil && location != nil && span != nil && maxSpan != nil)
		}
	}
	
	var gpxFileURL: URL?
	var location: CLLocationCoordinate2D?
	var span: MKCoordinateSpan?
	var maxSpan: MKCoordinateSpan?
	
	init() {
		self.title = "Excursion"
		self.m_description = ""
	}
	
	init (title: String?) {
		if title != nil {
			self.title = title!
		} else {
			self.title = "Excursion"
		}
		self.m_description = ""
	}
	
	init (title: String, images: [(URL, String)]?, thumbnailImage: URL?, thumbnailText: String, description: String?, isFavourite: Bool, type: String?, tableContent: [DetailTableContent], duration: String? , difficulty: String?, gpxFileURL: URL?, location: CLLocationCoordinate2D?, span: MKCoordinateSpan?, maxSpan: MKCoordinateSpan?) {
		
		self.title = title
		self.images = images
		if thumbnailImage == nil && images != nil && images!.count > 0{
			self.thumbnailImage = images![0].0
		} else {
			self.thumbnailImage = thumbnailImage
		}
		self.thumbnailText = thumbnailText
		self.m_description = ""
		
		self.m_description = description ?? ""
		
		self.difficulty = difficulty
		self.duration = duration
		self.isFavourite = isFavourite
		self.type = type
		
		self.tableContent = tableContent
		
		self.gpxFileURL = gpxFileURL
		self.location = location
		self.span = span
		self.maxSpan = maxSpan
	}
	
	var description: String {
		get {
			return "Title: \(title)\nImages: \(String(describing: images))\nThumbnail Image: \(String(describing: thumbnailImage))\nThumbnail Text: \(String(describing: thumbnailText))\nComplete Text: \(m_description)\nDifficulty: \(String(describing: difficulty))\nDuration: \(String(describing: duration))\nIs Favourite = \(isFavourite)\nType: \(String(describing: type))"
		}
	}
}

struct DetailTableContent {
	var icon: UIImage
	var text: String
}


//
//  ExcursionDetailTableViewCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 23/03/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class ExcursionDetailTableViewCell: UITableViewCell {

	@IBOutlet weak var icon: UIImageView!
	@IBOutlet weak var height: NSLayoutConstraint!
	@IBOutlet weak var descriptionText: UILabel!
	
	var template: Bool = true
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

	func setColors() {
		if template {
			icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
			icon.tintColor = UIColor.primary
		}
		
		self.backgroundColor = UIColor.secondary
		descriptionText.textColor = UIColor.primary
	}
}
//
//  ExcursionDetailView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 15/08/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit
import KVConstraintExtensionsMaster
import MapKit
import DeviceKit

class ExcursionDetailView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ImageGallaryCollectionViewDelegate {
    //MARK: - Properties
	var excursion: ExcursionDataModel! = nil {
		didSet {
			if self.isViewLoaded {
				//updateTableHeight()
			}
		}
	}
	
    @IBOutlet weak var excursionTitle: UINavigationItem!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var separator: UIView!
	
	@IBOutlet weak var mapButton: UIButton!
	
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var excursionImageDescriptionView: ExcursionImageDescription!
	//MARK: Collection View Layout
	var flowLayout = UICollectionViewFlowLayout()
	var imageGallaryFlowLayout = ImageGallaryFlowLayout()
	
	fileprivate var isStatusBarHidden: Bool = false
	
	fileprivate var detailViewDismisserButton: UIBarButtonItem?
	
	var imageGallary: UIView?
	
	var mapProperties: JPMapProperty?
	
	//table view
	@IBOutlet weak var tableView: DynamicUITableView!
	@IBOutlet weak var tableHeight: NSLayoutConstraint!
    
	let tableCellHeightRatio: CGFloat = 0.1
    let tableIconHeightRatio: CGFloat = 0.07
    
    let descriptionTextInset: CGFloat = 8
    
    var tableCells = [ExcursionDetailTableViewCell]()
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.automaticallyAdjustsScrollViewInsets = false
		
		excursionTitle.title = excursion.title
        descriptionText.text = excursion.m_description
		updateTextViewSize()
		
		//Creating the delegate links between the collection view and this class, so we can modify various aspects of the collectionview
        collectionView.delegate = self
        collectionView.dataSource = self
		
		
		//Collection View layout initialization
		flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
		imageGallaryFlowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
		
		detailViewDismisserButton = navigationController?.navigationBar.topItem?.leftBarButtonItem
		
		collectionView.isPagingEnabled = true
		collectionView.bounces = false
		collectionView.isScrollEnabled = true
		
		NotificationCenter.default.addObserver(self, selector: #selector(ExcursionDetailView.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
		
		let nib = UINib(nibName: "ImageGallaryCollectionViewCell", bundle: nil)
		collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
		
		if excursion.doesGPXExist {
			let parser = JPMapParser(xmlURL: excursion.gpxFileURL!, location: excursion.location!, span: excursion.span!, maxSpan: excursion.maxSpan!)
			parser.parse() { (mapProperties) in
				self.mapProperties = mapProperties
			}
		}
		
		mapButton.layer.cornerRadius = 5
		mapButton.layer.borderColor = UIColor.black.cgColor
		
		if !excursion.doesGPXExist {
			mapButton.setTitle("Map: Coming soon", for: .normal)
		}
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.isScrollEnabled = false
		
		
		setColors()
		selectText()
		
		/*tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 40*/
		//adjustTableViewHeight()
		//updateTableHeight()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateHeight()
	}
	
	//Updates all the views in the detail view to the according correct ones declared in UIColor
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
		
		collectionView.backgroundColor = UIColor.clear
		contentView.backgroundColor = UIColor.clear
		
		mapButton.backgroundColor = UIColor.primary
		mapButton.titleLabel?.textColor = UIColor.secondary
		
		separator.backgroundColor = UIColor.primary
		excursionImageDescriptionView.textColor = UIColor.primary
		
		//tableView
		tableView.backgroundColor = UIColor.clear
		tableView.separatorColor = UIColor.primary
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		let fixedWidth = descriptionText.frame.size.width
		let newSize = descriptionText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		var newFrame = descriptionText.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		descriptionText.frame = newFrame
	}
	
//	MARK: - Collection view setup
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let images = excursion.images {
            return images.count
        }
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageGallaryCollectionViewCell
		
		if let images = excursion.images {
			let imageURL = images[indexPath.item].0
			DispatchQueue.global().async {
				cell.imageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "PlaceHolder"))
			}
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "ImageNotFound")
        }
		
		cell.imageView.contentMode = .scaleAspectFit
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let size = CGSize(width: collectionView.frame.width - 8, height: collectionView.frame.height - 16)
		
		return size
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		selectText()
	}
	
	func selectText() {
		guard self.collectionView.indexPathsForVisibleItems.count > 0 else {
			/*excursionImageDescriptionView.isHidden = true
			self.view.setNeedsLayout()
			self.view.layoutIfNeeded()*/
			return
		}
		//excursionImageDescriptionView.isHidden = false
		//self.view.setNeedsLayout()
		//self.view.layoutIfNeeded()
		
		let indexes = self.collectionView.indexPathsForVisibleItems
		var index = 0
		index = indexes[0].item
		excursionImageDescriptionView.text = excursion.images![index].1
	}
	
	func selectedImageIndex() -> IndexPath? {
		guard collectionView.visibleCells.count > 0 else {return nil}
		
		let selectedCell = collectionView.visibleCells[0]
		let indexPath = collectionView.indexPath(for: selectedCell)
		return indexPath
	}
	
//	MARK: - Listeners
	
//	Handles any taps recognized by the gesturerexognizer on the Image Gallery
	@IBAction func handleTap(_ sender: UITapGestureRecognizer) {
//		Show/Hide the description for the image gallery
		//excursionImageDescriptionView.animate()
		showImageInspector()
	}
	
//	Listens to any device rotation
	func rotate() {
		if imageGallary != nil {
			imageGallary!.superview?.setNeedsLayout()
			imageGallary!.superview?.layoutIfNeeded()
			reloadImageInspectorData()
			imageInspectorSelectMostVisibleCell()
		}
		self.collectionView.reloadData()
		selectText()
		
		//updateTableHeight()
       // tableView.reloadData()
       // adjustTableViewHeight()
	}
	
//	MARK: - View translations
	
	func updateTextViewSize() {
		let fixedWidth = descriptionText.frame.size.width
		let newSize = descriptionText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		var newFrame = descriptionText.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		descriptionText.frame = newFrame
	}
	
//	MARK: - Image Inspector
	
	func showImageInspector() {
		//toggleNavigationDisplay()
		
		navigationBarImageInspectorDismisser()
		
		imageGallary = createImageGallery()
		(imageGallary!.subviews[0] as! UICollectionView).reloadData()
	}
	
	func createImageGallery() -> UIView {
		
//		The color scheme used by this gallery
		let color = UIColor.secondary
//		Frame for the parenting view
		let screenFrame = UIScreen.main.bounds
		
//		Create the superview with the screen frame
		let superView = UIView(frame: collectionView.frame)
		superView.translatesAutoresizingMaskIntoConstraints = false
		superView.backgroundColor = color
		superView.alpha = 0
		
//		Adding the parenting view on top to the current view and applying it's constraints
		view.addSubview(superView)
		//let keyView = UIApplication.shared.keyWindow
		//keyView?.addSubview(superView)
		superView.applyConstraintFitToSuperview()
		
//		The insets that the collection view will have. This is used to the limitation of the flow layout
		let collectionViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//		Here we create the frame for the collection view
		let insetedFrame = galleryViewRect(parentViewRect: screenFrame, collectionViewInsets: collectionViewInsets)
		
//		Creates the collection view that will contain all the images, adding it to the parenting view and applying the constraints
		let imageInspector = createImageInspector(with: insetedFrame)
		superView.addSubview(imageInspector)
		imageInspector.applyTopPinConstraint(toSuperview: collectionViewInsets.top)
		imageInspector.applyBottomPinConstraint(toSuperview: collectionViewInsets.bottom)
		imageInspector.applyLeadingPinConstraint(toSuperview: collectionViewInsets.left)
		imageInspector.applyTrailingPinConstraint(toSuperview: collectionViewInsets.right)
		
//		Animates the entrance of the view to fit the new frame
		
		UIView.animate(withDuration: 0.3, animations: {() -> Void in
			superView.frame = screenFrame
			superView.alpha = 1
			
		}, completion: {(Bool) -> Void in
			self.imageGallary?.setNeedsLayout()
			imageInspector.isUserInteractionEnabled = true
		})
		
		return superView
	}
	
	func galleryViewRect(parentViewRect rect: CGRect, collectionViewInsets: UIEdgeInsets) -> CGRect {
		var newRect = rect
		
		newRect.origin.x += collectionViewInsets.left
		newRect.size.width -= (collectionViewInsets.left + collectionViewInsets.right)
		newRect.origin.y += collectionViewInsets.top
		newRect.size.width -= (collectionViewInsets.top + collectionViewInsets.bottom)
		
		return newRect
	}
	
	func createImageInspector(with rect: CGRect) -> UICollectionView {
		
		let collectionView = ImageGallaryCollectionView(frame: rect, collectionViewLayout: flowLayout)
		
		collectionView.backgroundColor = UIColor.viraviraBrownColor
		collectionView.register(UINib(nibName: "ImageGallaryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
		collectionView.delegate = collectionView
		collectionView.dataSource = collectionView
		
		collectionView.imageGallaryDelegate = self
		
		if excursion.images != nil {
			var images = [URL]()
			for element in excursion.images! {
				images.append(element.0)
			}
			
			collectionView.imageURLS = images
		}
		
		let index = selectedImageIndex()
		
		collectionView.selectItem(at: index != nil ? index : IndexPath(), animated: false, scrollPosition: UICollectionViewScrollPosition.centeredVertically)
		
		collectionView.isUserInteractionEnabled = false
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
		collectionView.alwaysBounceHorizontal = true
		collectionView.alwaysBounceVertical = false
		collectionView.isPagingEnabled = true
		
		collectionView.isDirectionalLockEnabled = true
		
		collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
		//		The color scheme used by this gallery
		let color = UIColor.viraviraDarkBrownColor
		collectionView.backgroundColor = color
		
		//collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ExcursionDetailView.dismissImageInspector)))
		return collectionView
	}
	
	func reloadImageInspectorData() {
		guard
			self.imageGallary != nil,
			let collectionView = imageGallary?.subviews[0] as? UICollectionView
			else {return}
		collectionView.reloadData()
		collectionView.setNeedsLayout()
		collectionView.layoutIfNeeded()
	}
	
	func imageInspectorSelectMostVisibleCell() {
		guard
			self.imageGallary != nil,
			imageGallary?.subviews[0] as? UICollectionView != nil
			else {return}
		
		let paths = (imageGallary?.subviews[0] as! UICollectionView).indexPathsForVisibleItems
		if paths.count > 0 {
			(imageGallary!.subviews[0] as! UICollectionView).scrollToItem(at: paths[0], at: .centeredHorizontally, animated: false)
		}
	}
	
	func navigationBarImageInspectorDismisser() {
		let button = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(ExcursionDetailView.dismissImageInspector))
		button.tintColor = UIColor.secondary
		navigationController?.navigationBar.topItem?.leftBarButtonItem = button
	}
	
	func navigationBarDetailViewDismisser() {
		navigationController?.navigationBar.topItem?.leftBarButtonItem = detailViewDismisserButton
	/*	let button = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(ExcursionDetailView.unwindToTableView))
		button.tintColor = UIColor.viraviraGoldColor
		navigationController?.navigationBar.topItem?.leftBarButtonItem = button*/
	}
	
	func unwindToTableView() {
		self.shouldPerformSegue(withIdentifier: "unwind", sender: self)
	}
	
	func dismissImageInspector() {
		guard imageGallary != nil else {return}
		
		//toggleNavigationDisplay()
		
		UIView.animate(withDuration: 0.3, animations: {() -> Void in
			//self.imageGallary!.frame = self.collectionView.frame
			//self.imageGallary!.backgroundColor = self.imageGallary!.backgroundColor?.withAlphaComponent(0)
			self.imageGallary?.alpha = 0
		}, completion: {(Bool) -> Void in
			self.imageGallary!.removeFromSuperview()
			
		})
		
		navigationBarDetailViewDismisser()
	}
	
//	MARK: - Image Gallary delegate implementations
	func set(alpha: CGFloat) {
		self.imageGallary?.alpha = alpha
	}
	
	func dismissImageGallary() {
		dismissImageInspector()
	}
	
//	MARK: Navigation bar
	
	func toggleNavigationDisplay() {
		toggleNavigationBar()
		toggleStatusBar()
	}
	
	func toggleNavigationBar() {
		guard let navController = self.navigationController else {return}
		navController.setNavigationBarHidden(!navController.isNavigationBarHidden, animated: true)
	}
	
	func toggleStatusBar() {
		isStatusBarHidden = !isStatusBarHidden
		UIView.animate(withDuration: 0.2, animations: {() -> Void in
			self.setNeedsStatusBarAppearanceUpdate()
		})
	}
	
	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return UIStatusBarAnimation.slide
	}
	
	override var prefersStatusBarHidden: Bool {
		return isStatusBarHidden
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
//	MARK: - Map 
	
	@IBAction func mapButton(_ sender: Any) {
		guard excursion.doesGPXExist else {return}
		let mapController = ExcursionMapViewController(nibName: "ExcursionMapViewController", bundle: nil)
		self.navigationController?.pushViewController(mapController, animated: true)
		navigationController?.navigationBar.tintColor = UIColor.secondary
		
		if mapProperties != nil {
			mapController.mapProperties = mapProperties
		} else {
			mapController.parser = JPMapParser(xmlURL: excursion.gpxFileURL!, location: excursion.location!, span: excursion.span!, maxSpan: excursion.maxSpan!)
		}
	}
	
}

extension ExcursionDetailView: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return excursion.tableContent != nil ? excursion.tableContent!.count : 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExcursionDetailTableViewCell
		let currentTableData = excursion.tableContent![indexPath.row]
		
		cell.backgroundColor = UIColor.clear
		
		cell.icon.image = currentTableData.icon.withRenderingMode(.alwaysTemplate)
		cell.icon.tintColor = UIColor.primary
		
      //  cell.height.constant = UIScreen.main.bounds.height * tableIconHeightRatio
       // self.view.setNeedsLayout()
		
		cell.descriptionText.text = currentTableData.text
		cell.descriptionText.textColor = UIColor.primary
		//cell.descriptionText.adjustsFontSizeToFitWidth = true
		//cell.descriptionText.minimumScaleFactor = 0.2
		cell.descriptionText.font = cell.descriptionText.font.withSize(fontSize())
       // cell.descriptionText.setMaxFontSize(minSize: 7, maxSize: 21)
        
        if !tableCells.contains(cell) {
            tableCells.insert(cell, at: indexPath.row)
        }
		
        if (self.tableView(tableView, numberOfRowsInSection: 0) - 1) == indexPath.row {
           // updateTableHeight()
		}
		
		return cell
	}
	
	func fontSize() -> CGFloat {
		
		//let bounds = UIScreen.main.bounds
		//let width = bounds.width < bounds.height ? bounds.width : bounds.height
		
		//print(width)
		
		return 16
	}
	
	/*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}*/
	
	func updateHeight() {
		let height = tableViewHeight()
		tableHeight.constant = height
		self.view.updateConstraints()
	}
	
	func tableViewHeight() -> CGFloat {
		var height: CGFloat = 0
		for i in 0..<tableView(tableView, numberOfRowsInSection: 0) {
			height += tableView(tableView, heightForRowAt: IndexPath(row: i, section: 0))
		}
		return height
	}
    
 /*   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * tableCellHeightRatio
    }*/
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let minHeight = UIScreen.main.bounds.height * tableCellHeightRatio
        
        guard tableCells.count > indexPath.row else {return minHeight}
        let cell = tableCells[indexPath.row]
    
        //let cell = self.tableView(tableView, cellForRowAt: indexPath) as! ExcursionDetailTableViewCell
		
		let topBottomIndent: CGFloat = 16
		var contentHeight = self.labelHeight(cell.descriptionText)
		//if !UIDevice.current.orientation.isLandscape {
			contentHeight += 2 * descriptionTextInset
		//}
		//  print(contentHeight)
		
        let textViewHeight = contentHeight + topBottomIndent
        
        return textViewHeight > minHeight ? textViewHeight : minHeight
	}
	
	func labelHeight(_ label: UILabel) -> CGFloat {
		label.numberOfLines = 0
		let insets: CGFloat = 40
		let cellwidth: CGFloat = UIScreen.main.bounds.size.height * tableCellHeightRatio
		let fixedWidth = UIScreen.main.bounds.size.width - cellwidth - insets
		
		let sizeThatFits = label.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
		return sizeThatFits.height
	}
	
  /* func textViewHeight(_ textView: UITextView) -> CGFloat {
	/* CGFloat fixedWidth = textView.frame.size.width;
	CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
	CGRect newFrame = textView.frame;
	newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
	textView.frame = newFrame;
	*/
	let insets: CGFloat = 40
	
	
	let fixedWidth = textView.frame.size.width
	let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
	return newSize.height
    }*/
	
	/*func labelHeight(_ label: UILabel) -> CGFloat {
		label.numberOfLines = 0
		let sizeThatFits = label.sizeThatFits(CGSize(width: label.frame.width, height: CGFloat(MAXFLOAT)))
		return sizeThatFits.height
		
	}*/
	
	/*func updateTableHeight() {
        
		let rowCount = tableView(tableView, numberOfRowsInSection: 0)
        var height: CGFloat = 0
        for row in 0..<rowCount {
            height += tableView(tableView, heightForRowAt: IndexPath(row: row, section: 0))
        }
        
		tableViewHeight.constant = height
		self.view.setNeedsLayout()
	}*/
}
//
//  ExcursionHeader.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 28/12/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

class ExcursionHeader {

	var title: String
	var image: UIImage?
	
	
	init (title: String) {
		self.title = title
	}
	
	init (title: String, image: UIImage) {
		self.title = title
		self.image = image
	}
	
	
	//MARK: Prebuilt options

	static let floating = ExcursionHeader(title: "Floating", image: #imageLiteral(resourceName: "floating"))
	static let hiking = ExcursionHeader(title: "Hiking", image: #imageLiteral(resourceName: "Hiking"))
	static let biking = ExcursionHeader(title: "Bicycle", image: #imageLiteral(resourceName: "biking"))
	static let horseBack = ExcursionHeader(title: "Horseback Riding", image: #imageLiteral(resourceName: "Horse"))
	static let adventure = ExcursionHeader(title: "Adventure", image: #imageLiteral(resourceName: "adventure"))
	static let kayak = ExcursionHeader(title: "Kayak", image: #imageLiteral(resourceName: "kayak"))
	static let fishing = ExcursionHeader(title: "Fishing", image: #imageLiteral(resourceName: "fishing"))
	static let other = ExcursionHeader(title: "Others")
	
	
	//Modify
	static let headers: [String: ExcursionHeader] = ["Hiking": ExcursionHeader.hiking, "Bicycle": ExcursionHeader.biking, "Adventure": ExcursionHeader.adventure, "Horseback Riding": ExcursionHeader.horseBack, "Floating": ExcursionHeader.floating, "Kayak": ExcursionHeader.kayak, "Fishing": ExcursionHeader.fishing]
}
//
//  ExcursionImageDescription.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 20/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class ExcursionImageDescription: UITextView {
	
	var open = true
	var height: CGFloat?
	
	var gl: CAGradientLayer?
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if gl == nil {
			
			let colorTop = UIColor.secondary.withAlphaComponent(0.0).cgColor
			let colorBot = UIColor.secondary.withAlphaComponent(1.0).cgColor
			
			gl = CAGradientLayer()
			gl!.colors = [colorTop, colorBot, colorBot]
			gl!.locations = [0.0, 0.8, 1.0]
			
			gl!.zPosition = 0
			
			gl!.frame = self.bounds
			self.layer.addSublayer(gl!)
		} else {
			gl!.frame = self.bounds
		}
	}
	
	func animate() {
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
			var frame = self.frame
			if self.open {
				self.height = self.frame.height
				
				frame.size.height = 0
				//frame.origin.y += self.height!
			} else {
				frame.size.height = self.height!
				//frame.origin.y -= self.height!
			}
			
			self.open = !self.open
			
			self.frame = frame
		}, completion: nil)
	}
}
//
//  ExcursionMapViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 9/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit
import MapKit
import KVConstraintExtensionsMaster

class ExcursionMapViewController: UIViewController, MKMapViewDelegate {
	
	@IBOutlet weak var mapView: MKMapView!

	var mapProperties: JPMapProperty? {
		didSet {
			if initialized {
				setProperties()
			}
		}
	}
	
	var initialized: Bool = false
	
	var parser: JPMapParser?
	
	let annotationIdentifier = "AnnotationID"
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		mapView.delegate = self
		
		mapView.mapType = .satellite
		
		if mapProperties != nil {
			setProperties()
		} else {
			showAlert()
			
			parser?.parse {(properties) in
				self.mapProperties = properties
			}
		}
		
		initialized = true
    }
	
	func setProperties() {
		guard mapProperties != nil && mapView != nil else {dismissAlert(errorMessage: "Failed to download"); return}
		mapView.region = mapProperties!.region
		let mapOverlays = mapProperties!.mapOverlays
		for waypoint in mapOverlays.waypoints {
			mapView.addAnnotation(waypoint.annotation)
		}
		for track in mapOverlays.tracks {
			DispatchQueue.main.async {
				self.mapView.add(track.polyline)
			}
		}
		
		dismissAlert(errorMessage: nil)
	}
	
	func showAlert() {
		guard parser != nil else {return}
		let alert = UIAlertController(title: "Updating", message: "Please Wait", preferredStyle: .alert)
		//xalert.view.tintColor = UIColor.viraviraGoldColor
		
		let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = .white
		activityIndicator.startAnimating()
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
			self.parser!.downloader?.cancel()
		}))
		
		alert.view.addSubview(activityIndicator)
		DispatchQueue.main.async {
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func dismissAlert(errorMessage: String?) {
		DispatchQueue.main.async {
			if self.presentedViewController != nil {
				self.dismiss(animated: true, completion: errorMessage == nil ? nil : {
					self.displayErrorMessage(errorMessage: errorMessage!)
					})
			} else if errorMessage != nil {
				self.displayErrorMessage(errorMessage: errorMessage!)
			}
		}
	}
	
	func displayErrorMessage(errorMessage: String) {
		let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKPolyline {
			let polylineRenderer = MKPolylineRenderer(overlay: overlay)
			polylineRenderer.lineWidth = 3
			polylineRenderer.strokeColor = UIColor.red
			return polylineRenderer
		} else {
			return MKOverlayRenderer(overlay: overlay)
		}
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let jpAnnotation = annotation as? JPPointAnnotation else {return nil}
		
		var annotationView: MKAnnotationView?
		let fixedSize = CGSize(width: 35, height: 35)
		
		if jpAnnotation.image != nil {
			
			annotationView = MKAnnotationView(annotation: jpAnnotation, reuseIdentifier: annotationIdentifier)
			annotationView?.image = jpAnnotation.image
			annotationView?.frame = CGRect(x: -fixedSize.width / 2, y: -fixedSize.height / 2, width: fixedSize.width, height: fixedSize.height)
			
		} else {
			annotationView = MKPinAnnotationView(annotation: jpAnnotation, reuseIdentifier: annotationIdentifier)
		}
		
		if jpAnnotation.detailImageURL != nil {
			
			let customView = UIImageView()
			customView.contentMode = .scaleAspectFit
			
			let url = URL(string: jpAnnotation.detailImageURL!)
			customView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "PlaceHolder"))
			
			if #available(iOS 9.0, *) {
				annotationView?.detailCalloutAccessoryView = customView
			} else {
				// Fallback on earlier versions
			}
			if #available(iOS 9.0, *) {
				annotationView?.detailCalloutAccessoryView?.backgroundColor = UIColor.red
			} else {
				// Fallback on earlier versions
			}
		}
		
		
		
		annotationView?.canShowCallout = true
		
		return annotationView
	}
}
//
//  ExcursionTable.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 14/08/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit
import SDWebImage
import MapKit
import DeviceKit

struct Excursion {
	var excursionHeader: ExcursionHeader
	var excursions: [ExcursionDataModel]
}

class ExcursionTable: UITableViewController, SWRevealViewControllerDelegate {

	//MARK: - Properties
	
	let headerHeight: CGFloat = 50
	let headerTextHeight: CGFloat = 30
	let marginDistance: CGFloat = 8
	
	
	let cellHeightMultiplier: CGFloat = 0.2
	
	var currentSelectedCellIndexPath: IndexPath? = nil
	
	var comesFromSegue: Bool = false
	
	var menuButton: UIButtonAnimation!
	@IBOutlet weak var navBar: UINavigationItem!
	
	var excursionsToDisplay = [Excursion]() {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	var excursionModels = [ExcursionDataModel]()
	var download: URLSessionDataTask?
	var sortOrder: SortOrder = .TypeNameUp
	
	var alwaysUseBiggerRelation = true
	var tableCells = [ExcursionTableCell]()
	let tableCellHeightRatio: CGFloat = 0.1
	let tableIconHeightRatio: CGFloat = 0.08
	let cellExtraHeight: CGFloat = 48
	
	//MARK: - Initializing
	
	override func viewDidLoad() {
		super.viewDidLoad()
		clearsSelectionOnViewWillAppear = true
		
		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		
		(UIApplication.shared.delegate as! AppDelegate).currentViewController = self
		
		self.view.backgroundColor = UIColor.secondary
		self.tableView.separatorColor = UIColor.primary
		
		//defaultExcursions()
		parse()
		
		NotificationCenter.default.addObserver(self, selector: #selector(ExcursionTable.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
		
		//printFonts()
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
	}
	
	func defaultExcursions() {
		
		//Rafting Excursions
		let raftingHeader = ExcursionHeader(title: "Rafting", image: #imageLiteral(resourceName: "floating"))
		var raftingExcursions = [ExcursionDataModel]()
		raftingExcursions.append(ExcursionDataModel(title: "Liucura"))
		raftingExcursions.append(ExcursionDataModel(title: "Otro rio"))
		
		excursionsToDisplay.append(Excursion(excursionHeader: raftingHeader, excursions: raftingExcursions))
		
		//Hiking Excursions
		let hikingHeader = ExcursionHeader(title: "Hiking", image: #imageLiteral(resourceName: "hiking"))
		var hikingExcursions = [ExcursionDataModel]()
		hikingExcursions.append(ExcursionDataModel(title: "Volcano"))
		hikingExcursions.append(ExcursionDataModel(title: "Por el pastito"))
		hikingExcursions.append(ExcursionDataModel(title: "Villarica"))
		
		excursionsToDisplay.append(Excursion(excursionHeader: hikingHeader, excursions: hikingExcursions))
	}
	
	//MARK: Listeners
	
	func rotate() {
		//tableView.reloadData()
		
	}
	
	//MARK: - TableView Setup
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return excursionsToDisplay.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return excursionsToDisplay[section].excursions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ExcursionCell", for: indexPath) as! ExcursionTableCell
		
		let currentExcursion = self.excursionsToDisplay[indexPath.section].excursions[indexPath.item]
		
		cell.title.text = currentExcursion.title
		cell.descriptionText.text = currentExcursion.thumbnailText
		cell.descriptionText.font = cell.descriptionText.font.withSize(fontSize())
		cell.thumbnailImage.clipsToBounds = true
		//cell.descriptionText.setMaxFontSize()
		
		if currentExcursion.thumbnailImage != nil {
			DispatchQueue.global().async {
			cell.thumbnailImage.sd_setImage(with: currentExcursion.thumbnailImage, placeholderImage: #imageLiteral(resourceName: "PlaceHolder"), options: .avoidAutoSetImage, completed: {(image, error, cacheType, url) -> Void in
				let scale = UIScreen.main.scale
				let ar = image!.size.width / image!.size.height
				let size = CGSize(width: ar >= 1 ? cell.thumbnailImage.frame.width * scale : cell.thumbnailImage.frame.width * ar * scale, height: ar <= 1 ? cell.thumbnailImage.frame.height * scale : cell.thumbnailImage.frame.height / ar * scale)
				
				
				
				DispatchQueue.global().async {
					let tempImage = image?.resizedImage(size, interpolationQuality: .default)
					
					DispatchQueue.main.async {
						cell.thumbnailImage.image = tempImage
					}
				}
				
				//cell.arConstraint = cell.arConstraint.constraintWithMultiplier(multiplier: ar)
				//cell.layoutIfNeeded()
				//print("\(image!.size), \(size)")
				//cell.thumbnailImage.resizeImage(size: size)
				//cell.thumbnailImage.contentMode = .scaleAspectFit
			})
			}
		}
		
		//cell.height.constant = screenWidth() * tableIconHeightRatio
		
		
		setColor(selected: false, cell: cell)
		
		if !tableCells.contains(cell) {
			tableCells.insert(cell, at: indexPath.row)
		}
		
		return cell
	}
	
	func screenWidth() -> CGFloat {
		let screen = UIScreen.main.bounds
		if alwaysUseBiggerRelation {
			let ar = screen.width / screen.height
			if ar >= 1 {
				return screen.width
			} else {
				return screen.height
			}
		} else {
			return screen.height
		}
	}
	
	func fontSize() -> CGFloat {
		let bounds = UIScreen.main.bounds
		let width = bounds.width < bounds.height ? bounds.width : bounds.height
		
		let scaleFactor: CGFloat = 26.5
		
		return width / scaleFactor
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let imageLength: CGFloat = headerHeight - marginDistance * 2
		
		let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight))
		view.backgroundColor = UIColor.viraviraBrownColor
		
		let image = UIImageView(frame: CGRect(x: marginDistance, y: (headerHeight / 2) - (imageLength / 2), width: imageLength, height: imageLength))
		view.addSubview(image)
		
		let label = UILabel(frame: CGRect(x: image.frame.origin.x + image.frame.width + marginDistance, y: (headerHeight / 2) - (headerTextHeight / 2), width: view.frame.width - image.frame.origin.x - image.frame.width - marginDistance, height: headerTextHeight))
		
		label.textColor = UIColor.viraviraGoldColor
		label.textAlignment = NSTextAlignment.left
		label.font = UIFont(name: "Verdana", size: 27)
		view.addSubview(label)
		
		//Populating header
		label.text = excursionsToDisplay[section].excursionHeader.title
		image.image = excursionsToDisplay[section].excursionHeader.image
		
		image.image = image.image?.withRenderingMode(.alwaysTemplate)
		image.tintColor = UIColor.primary
		label.textColor = UIColor.primary
		view.backgroundColor = UIColor.tertiary
		
		
		return view
	}
	
	func descriptionFontSize() -> CGFloat {
		let screenWidth = UIScreen.main.bounds.width
		
		return CGFloat(Int(screenWidth / 27))
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return headerHeight
	}
	
	/*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let screen = UIScreen.main.bounds
		let ar = screen.width / screen.height
		return (ar > 1 ? screen.width : screen.height) * cellHeightMultiplier
	}*/
	
/*	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let minHeight = UIScreen.main.bounds.height * tableCellHeightRatio
		let startTime = CACurrentMediaTime()
		
		guard tableCells.count > indexPath.row else {return minHeight}
		let cell = tableCells[indexPath.row]
		
		//let cell = self.tableView(tableView, cellForRowAt: indexPath) as! ExcursionDetailTableViewCell
		
		let topBottomIndent: CGFloat = 16
		var contentHeight = self.labelHeight(cell.descriptionText)
		if !UIDevice.current.orientation.isLandscape {
			contentHeight += cellExtraHeight
		}
		//  print(contentHeight)
		
		let textViewHeight = contentHeight + topBottomIndent
		
		print("height calculation: \(CACurrentMediaTime() - startTime)")
		print(textViewHeight)
		
		let result = textViewHeight > minHeight ? textViewHeight : minHeight
		
		tableCells[indexPath.row].height.constant = result
		
		return result
	}
	
	func labelHeight(_ label: UILabel) -> CGFloat {
		label.numberOfLines = 0
		let insets: CGFloat = 32
		let cellwidth: CGFloat = UIScreen.main.bounds.size.height * tableCellHeightRatio
		let fixedWidth = UIScreen.main.bounds.size.width - cellwidth - insets
		
		let sizeThatFits = label.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
		return sizeThatFits.height
	}*/
	
	
	//MARK: Selection
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! ExcursionTableCell
		
		//deselectAllCells(tableView: tableView)
		if currentSelectedCellIndexPath != nil {
			self.tableView(tableView, didDeselectRowAt: currentSelectedCellIndexPath!)
		}
		
		currentSelectedCellIndexPath = indexPath
		
		setColor(selected: true, cell: cell)
	}
	
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? ExcursionTableCell else {return}
		
		setColor(selected: false, cell: cell)
	}
	
	/*func selectCell(cell: ExcursionTableCell) -> ExcursionTableCell {
		cell.backgroundColor = UIColor.viraviraGoldColor
		cell.content?.backgroundColor = UIColor.viraviraGoldColor
		cell.thumbnailText?.textColor = UIColor.viraviraDarkBrownColor
		cell.title?.textColor = UIColor.viraviraDarkBrownColor
		
		return cell
	}
	
	func deselectCell(cell: ExcursionTableCell?) -> ExcursionTableCell? {
		
		if cell != nil {
			cell!.backgroundColor = UIColor.viraviraDarkBrownColor
			cell!.content?.backgroundColor = UIColor.viraviraDarkBrownColor
			cell!.thumbnailText?.textColor = UIColor.viraviraGoldColor
			cell!.title?.textColor = UIColor.viraviraGoldColor
		}
		
		return cell
	}*/
	
	func setColor(selected: Bool, cell: ExcursionTableCell){
		
		if !selected {
			cell.descriptionText.textColor = UIColor.primary
			cell.title.textColor = UIColor.primary
			cell.backgroundColor = UIColor.secondary
			cell.content.backgroundColor = UIColor.secondary
		} else {
			cell.descriptionText.textColor = UIColor.primary
			cell.title.textColor = UIColor.primary
			cell.backgroundColor = UIColor.tertiary
			cell.content.backgroundColor = UIColor.tertiary
		}
		
		//return cell
	}
	
	//MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetails" {
			let navController = segue.destination as! UINavigationController
			let detailView = navController.topViewController as! ExcursionDetailView
			
			if let selectedExcursionCell = sender as? ExcursionTableCell {
				let indexPath = tableView.indexPath(for: selectedExcursionCell)
				
				detailView.excursion = excursionsToDisplay[indexPath!.section].excursions[indexPath!.row]
			}
		}
	}
	
	@IBAction func unwindToExcursionTable(segue: UIStoryboardSegue) {
		if currentSelectedCellIndexPath != nil {
			tableView(tableView, didDeselectRowAt: currentSelectedCellIndexPath!)
		}
	}
	
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
	
	//MARK: - DetailView Parse
	
	func parse() {
		let url = URL(string: "http://hotelviravira.com/app/excursionsAPI.json")
		
		var failed = false
		
		if url == nil {
			print("Api not found. This is a bug, please report to developers.")
			
			let alert = UIAlertController(title: "Invalid URL", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {(alert: UIAlertAction) in
				return
			}))
			present(alert, animated: true, completion: nil)
		} else {
			addOverlay()
			let configuration = URLSessionConfiguration.default
			configuration.requestCachePolicy = .reloadIgnoringCacheData
			let session = URLSession(configuration: configuration)
			download = session.dataTask(with:url!) { (data, response, error) in
				if error != nil {
					failed = true
					let urlError = error as! URLError
					print(urlError.localizedDescription)
					
					self.displayError(error: urlError.localizedDescription)
					
					
					
				} else {
					do {
						//self.refreshControl?.beginRefreshing()
						self.excursionModels.removeAll()
						
						let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
						
						let list = parsedData["list"] as! NSArray
						
						for index in 0..<list.count {
							let element = list[index] as? Dictionary<String, Any>
							if element == nil {
								return
							}
							let title = element!["title"] as? String
							let thumbnailImage = element!["thumbnailImage"] as? String
							let thumbnailDescription = element!["thumbnailDescription"] as? String
							
							/*var descriptionText = NSAttributedString()
							if let descriptionArray = element!["description"] as? NSArray {
								descriptionText = self.description(from: descriptionArray)
							}*/
							
							//MARK: Table
							var descriptionTable = [DetailTableContent]()
							var descriptionText = ""
							if let descriptionNode = element!["description"] as? [String:Any] {
								if let table = descriptionNode["table"] as? [String: Any] {
									//2: Car time
									if let carTime = table["car-duration"] as? String {
										let image = #imageLiteral(resourceName: "car-time")
										descriptionTable.append(DetailTableContent(icon: image, text: carTime))
									}
									//3: Car distance
									if let carDistance = table["car-distance"] as? String {
										let image = #imageLiteral(resourceName: "car-distance")
										descriptionTable.append(DetailTableContent(icon: image, text: carDistance))
									}
									//4: Excursion Distance
									if let excursionDistance = table["excursion-distance"] as? String {
										let image = #imageLiteral(resourceName: "excursion-distance")
										descriptionTable.append(DetailTableContent(icon: image, text: excursionDistance))
									}
									//5: Excursion time
									if let excursionTime = table["excursion-duration"] as? String {
										let image = #imageLiteral(resourceName: "excursion-time")
										descriptionTable.append(DetailTableContent(icon: image, text: excursionTime))
									}
									//1: Difficulty
									if let difficulty = table["difficulty"] as? String {
										let image = #imageLiteral(resourceName: "difficulty")
										descriptionTable.append(DetailTableContent(icon: image, text: difficulty))
									}
									//6: Elevation gain
									if let elevationGain = table["elevation-gain"] as? String {
										let image = #imageLiteral(resourceName: "elevation-gain")
										descriptionTable.append(DetailTableContent(icon: image, text: elevationGain))
									}
									//7: Season
									if let season = table["season"] as? String {
										let image = #imageLiteral(resourceName: "season")
										descriptionTable.append(DetailTableContent(icon: image, text: season))
									}
									//8: Equipment
									if let equipment = table["equipment"] as? String {
										let image = #imageLiteral(resourceName: "equipment")
										descriptionTable.append(DetailTableContent(icon: image, text: equipment))
									}
									//9: Price
									if let price = table["price"] as? String {
										let image = #imageLiteral(resourceName: "Dollar ")
										descriptionTable.append(DetailTableContent(icon: image, text: price))
									}
								}
								
								descriptionText = descriptionNode["text"] as? String ?? ""
							}
							//End table parsing
							
							let difficulty = element!["difficulty"] as? String
							let duration = element!["duration"] as? String
							let type = element!["type"] as? String
							
							let gpx = element!["gpx"] as? [String: Any]
							let gpxFile = gpx?["gpxFile"] as? String
							let gpxURL = gpxFile != nil ? URL(string: gpxFile!) : nil
							
							let locationTree = gpx?["location"] as? [String: Any]
							let location = locationTree == nil ? nil : CLLocationCoordinate2D(latitude: locationTree!["lat"] as! CLLocationDegrees, longitude: locationTree!["lon"] as! CLLocationDegrees)
							
							let spanTree = gpx?["span"] as? [String: Any]
							let span = spanTree == nil ? nil : MKCoordinateSpan(latitudeDelta: spanTree!["lat"] as! CLLocationDegrees, longitudeDelta: spanTree!["lon"] as! CLLocationDegrees)
							
							let maxSpanTree = gpx?["max span"] as? [String: Any]
							let maxSpan = maxSpanTree == nil ? nil : MKCoordinateSpan(latitudeDelta: maxSpanTree!["lat"] as! CLLocationDegrees, longitudeDelta: maxSpanTree!["lon"] as! CLLocationDegrees)
							
							let excursionModel = ExcursionDataModel(title: title)
							excursionModel.images = [(URL, String)]()
							
							let imagesDict = element!["images"] as? NSArray
							if imagesDict != nil {
								for index in 0..<imagesDict!.count {
									let image = imagesDict![index] as! Dictionary<String, Any>
									let touple: (URL, String) = (URL(string: (image["url"] as! String))!, (image["text"] as? String) ?? String())
									excursionModel.images?.append(touple)
								}
							}
							if thumbnailImage != nil {
								excursionModel.thumbnailImage = URL(string: thumbnailImage!)
							} else if excursionModel.images!.count > 0 {
								excursionModel.thumbnailImage = excursionModel.images!.first!.0
							}
							excursionModel.thumbnailText = thumbnailDescription
							excursionModel.m_description = descriptionText
							excursionModel.difficulty = difficulty
							excursionModel.duration = duration
							excursionModel.type = type
							
							excursionModel.gpxFileURL = gpxURL
							excursionModel.location = location
							excursionModel.span = span
							excursionModel.maxSpan = maxSpan
							
							excursionModel.tableContent = descriptionTable
							
							
							//print(excursionModel.description)
							self.excursionModels.append(excursionModel)
						
						
						}
						
					} catch let error as NSError {
						print(error)
						
						self.displayError(error: error.localizedDescription)
					}
				}
				if !failed {
					self.removeOverlay()
				}
				//self.inject(excursionModels: excursionModels)
				
				self.excursionsToDisplay = self.sort(order: self.sortOrder)
				
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
				}
			download?.resume()
		}
	}
	
	
	func addOverlay() {
		let alert = UIAlertController(title: "Updating", message: "Please Wait", preferredStyle: .alert)
		//xalert.view.tintColor = UIColor.viraviraGoldColor
		
		let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = .white
		activityIndicator.startAnimating()
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
			self.download?.cancel()
			//self.refreshControl?.endRefreshing()
		}))
		
		alert.view.addSubview(activityIndicator)
		DispatchQueue.main.async {
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func displayError(error: String) {
		let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
		DispatchQueue.main.async {
			self.dismiss(animated: true, completion:  ({
				self.present(alert, animated: true, completion: nil)
				print("displaying")
			}))
		}
	}



	func removeOverlay() {
		DispatchQueue.main.async {
			//self.refreshControl?.endRefreshing()
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	func description(from data: NSArray) -> NSAttributedString {
		let text = NSMutableAttributedString()
		
		for element in data {
			if let elementDict = element as? [String: Any] {
				text.append(node(from: elementDict))
			}
		}
		
		return text
	}
	
	func node(from data: [String : Any]) -> NSAttributedString {
		let attributedText = NSMutableAttributedString()
		
		
		if data["text"] == nil && data["image"] == nil {
			print("Unsupported tree found. Trees without text nor images are unsupported. Tree data: \(data)")
		} else if data["text"] != nil && data["image"] != nil {
			print("Unsupported tree found, it is not allowed to have text and an image in the same tree. Tree data: \(data)")
		} else if data["image"] != nil {
			
//			Implement image retrieval
			let imageName = data["image"] as! String
			let template = data["template"] as? Bool != nil ? data["template"] as! Bool : true
			var image = UIImage()
			
			switch imageName {
			case "Bike", "Bicycle":
				image = #imageLiteral(resourceName: "biking")
			case "Trekking", "Hiking":
				image = #imageLiteral(resourceName: "Hiking")
			case "Car":
				image = #imageLiteral(resourceName: "Car")
				
			default:
				image = #imageLiteral(resourceName: "PlaceHolder")
			}
			
			let imageSize = CGSize(width: 100, height: 100)
		
			let textAttachment = TextAttachment()
			textAttachment.bounds = CGRect(origin: CGPoint.zero, size: imageSize)
			image = image.with(size: imageSize)!
			if template {
				let templatedImage = image.withRenderingMode(.alwaysTemplate)
				textAttachment.image = templatedImage
			} else {
				textAttachment.image = image
			}
			
			//textAttachment.bounds = CGRect(origin: CGPoint.zero, size: imageSize)
			//textAttachment.image
			
			let imageAsText = NSAttributedString(attachment: textAttachment)
			attributedText.append(imageAsText)
			
		} else {
//			Implement text retrieval
			let text = data["text"] as? String
			if text == nil {
				return NSAttributedString()
			}
//			Initialize the attributed text with our downloaded text.
			attributedText.setAttributedString(NSAttributedString(string: text!))
			
			var fontSize: CGFloat = 17
			
			if let fontSizeString = data["FontSize"] {
				if let fontSizeFromJSON = fontSizeString as? Double {
					fontSize = CGFloat(fontSizeFromJSON)
				} else {
					print("Font size is not a number and cannot be converted to one. Please revise the API")
				}
			}
			
			var isBold = false
			
			if let isBoldStringFromJSON = data["isBold"] {
				if let isBoldFromJSON = isBoldStringFromJSON as? Bool {
					isBold = isBoldFromJSON
				} else {
					print("The is bold attribute does not contain a valid boolean and thus cannot be converted to one. Please revise the API")
				}
			}
			
			var isItalic = false
			
			if let isItalicStringFromJSON = data["isItalic"] {
				if let isItalicFromJSON = isItalicStringFromJSON as? Bool {
					isItalic = isItalicFromJSON
				} else {
					print("The is italic attribute does not contain a valid boolean and thus cannot be converted to one. Please revise the API")
				}
			}
			
			
//			Create the font with the downloaded properties like, bold italic etc.
			var font = UIFont()
			
			
			
			switch (isBold, isItalic) {
			case (false, false):
				font = UIFont(name: "Verdana", size: fontSize)!
				
			case (true, false):
				font = UIFont(name: "Verdana-Bold", size: fontSize)!
				
			case (false, true):
				font = UIFont(name: "Verdana-Italic", size: fontSize)!
				
			case (true, true):
				font = UIFont(name: "Verdana-BoldItalic", size: fontSize)!
			}
			
			var isUnderlined = false
			
			if let isUnderlinedStringFromJSON = data["isUnderlined"] {
				if let isUnderlinedFromJSON = isUnderlinedStringFromJSON as? Bool {
					isUnderlined = isUnderlinedFromJSON
				} else {
					print("The is underlined attribute does not contain a valid boolean and thus cannot be converted to one. Please revise the API")
				}
			}
			
			var color = UIColor.primary
			
			if let colorFromJSON = data["color"] {
				if let colorHexFromJSON = colorFromJSON as? Int {
					color = UIColor(netHex: colorHexFromJSON)
				} else if let colorStringFromJSON = colorFromJSON as? String {
					switch colorStringFromJSON {
					case "blue":
						color = UIColor.blue
					default:
						color = UIColor.viraviraGoldColor
					}
				}
			}
			
			
			//Adding the attributes to the attributed string
			let range = NSMakeRange(0, attributedText.length)
			//Adding the font
			attributedText.addAttribute(NSFontAttributeName, value: font, range: range)
			//Adding the underline
			if isUnderlined {
				attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
			}
			//Adding the color
			attributedText.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
		}
		
		return attributedText
	}
	
	
	//MARK: - Sorting
	
	func sort(order: SortOrder) -> [Excursion]{
		var tempExc = [Excursion]()
		
		var excursionCreator: ([ExcursionDataModel]) -> [Excursion]
		
		switch order {
		case .TypeNameUp, .TypeNameDown:
			excursionCreator = createExcursionByType
		}
		
		tempExc = excursionCreator(excursionModels)
		
		var excursionSorter: (Excursion, Excursion) -> Bool
		var excursionModelSorter: (ExcursionDataModel, ExcursionDataModel) -> Bool
		
		switch order {
		case .TypeNameUp:
			excursionSorter = sortExcursionHeaderByNameUp
			excursionModelSorter = sortExcursionModelsByNameUp
		case .TypeNameDown:
			excursionSorter = sortExcursionHeaderByNameDown
			excursionModelSorter = sortExcursionModelsByNameDown
		}
		
		tempExc.sort(by: excursionSorter)
		for index in 0..<tempExc.count {
			tempExc[index].excursions.sort(by: excursionModelSorter)
		}
		
		return tempExc
	}
	
	func createExcursionByType(excursions: [ExcursionDataModel]) -> [Excursion] {
		var tempExc = [Excursion]()
		for excursion in excursions {
			if let index = containsHeader(excursionModel: excursion, in: tempExc) {
				tempExc[index].excursions.append(excursion)
			} else {
				var title = excursion.title
				if excursion.type != nil {
					title = excursion.type!
				}
				let excursionHeader = header(from: title)
				tempExc.append(Excursion(excursionHeader: excursionHeader, excursions: [excursion]))
			}
		}
		return tempExc
	}
	
	func containsHeader(excursionModel: ExcursionDataModel, in excursions: [Excursion]) -> Int? {
		for (index, excursion) in excursions.enumerated() {
			if excursionModel.type == excursion.excursionHeader.title {
				return index
			}
		}
		return nil
	}
	
	func sortExcursionHeaderByNameUp(e1: Excursion, e2: Excursion) -> Bool {
		return e1.excursionHeader.title < e2.excursionHeader.title
	}
	
	func sortExcursionHeaderByNameDown(e1: Excursion, e2: Excursion) -> Bool {
		return e1.excursionHeader.title > e2.excursionHeader.title
	}
	
	func sortExcursionModelsByNameUp(e1: ExcursionDataModel, e2: ExcursionDataModel) -> Bool {
		return e1.title < e2.title
	}
	
	func sortExcursionModelsByNameDown(e1: ExcursionDataModel, e2: ExcursionDataModel) -> Bool {
		return e1.title > e2.title
	}
	
	
	/*func createExcursionHeader(title: String) -> ExcursionHeader {
		return ExcursionHeader(title: title)
	}
	*/
	func header(from title: String) -> ExcursionHeader {
		let excursionHeader = ExcursionHeader.headers[title]
		if excursionHeader != nil {
			return excursionHeader!
		} else {
			return ExcursionHeader(title: title)
		}
	}

	enum SortOrder {
		case TypeNameUp
		case TypeNameDown
	}
	
	func printFonts() {
		let fontFamilyNames = UIFont.familyNames
		for familyName in fontFamilyNames {
			print("------------------------------")
			print("Font Family Name = [\(familyName)]")
			let names = UIFont.fontNames(forFamilyName: familyName)
			print("Font Names = [\(names)]")
		}
	}
}

//
//  ExcursionTableCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 14/08/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit

class ExcursionTableCell: UITableViewCell {
	//MARK: -Properties\
    @IBOutlet weak var thumbnailImage: ARImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UIView!
	
    
    @IBOutlet weak var arConstraint: NSLayoutConstraint!
	
	override func awakeFromNib() {
		//self.contentView.translatesAutoresizingMaskIntoConstraints = false
	}
}
//
//  FacilityMapViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 22/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class FacilityMapViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

		scrollView.delegate = self
		
        self.view.backgroundColor = UIColor.secondary
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		updateMinZoomScale(for: view.bounds.size)
	}
	
	private func updateMinZoomScale(for size: CGSize) {
		let widthScale = size.width / imageView.bounds.width
		let heightScale = size.height / imageView.bounds.height
		let minScale = min(widthScale, heightScale)
		
		scrollView.minimumZoomScale = minScale
		scrollView.zoomScale = minScale
	}
	

}

extension FacilityMapViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		updateConstraints(for: view.bounds.size)
	}
	
	private func updateConstraints(for size: CGSize) {
		let yOffset = max(0, (size.height - imageView.frame.height) / 2)
		imageViewTopConstraint.constant = yOffset
		imageViewBottomConstraint.constant = yOffset
		
		view.layoutIfNeeded()
	}
}
//
//  FollowUsTableViewCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 27/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class FollowUsTableViewCell: UITableViewCell {
	
	@IBOutlet weak var content: UIView!
	@IBOutlet weak var icon: UIImageView!
	@IBOutlet weak var title: UILabel!
	
	var shouldTemplate = true
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		title.adjustsFontSizeToFitWidth = true
		title.minimumScaleFactor = 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setColors() {
		content.backgroundColor = UIColor.clear
		title.textColor = UIColor.primary
		icon.tintColor = UIColor.primary
		self.backgroundColor = UIColor.secondary
	}
	
	func templateImage() {
		guard shouldTemplate else {return}
		
		icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
	}
	
	func set(image: UIImage) {
		icon.image = image
		templateImage()
	}

}
//
//  FollowUsTableViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 16/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit

struct FollowUsItem {
	var icon: UIImage
	var title: String
	var url: URL
	
	var shouldTemplate: Bool = true
	
	static let viravira = FollowUsItem(icon: #imageLiteral(resourceName: "logo"), title: "Vira Vira", url: URL(string: "https://www.hotelviravira.com")!, shouldTemplate: true)
	static let facebook = FollowUsItem(icon: #imageLiteral(resourceName: "Facebook_Golden"), title: "Facebook", url: URL(string: "https://www.facebook.com/hotelviravira/")!, shouldTemplate: true)
	static let twitter = FollowUsItem(icon: #imageLiteral(resourceName: "Twitter_Golden"), title: "Twitter", url: URL(string: "https://twitter.com/hotelviravira")!, shouldTemplate: true)
	static let tripadvisor = FollowUsItem(icon: #imageLiteral(resourceName: "Tripadvisor"), title: "Tripadvisor", url: URL(string: "https://www.tripadvisor.com/Hotel_Review-g294297-d4605635-Reviews-Hotel_Vira_Vira_Relais_Chateaux-Pucon_Araucania_Region.html")!, shouldTemplate: true)
}

class FollowUsViewController: UIViewController, SWRevealViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Properties
	
	static let items: [FollowUsItem] = [.viravira, .facebook, .twitter, .tripadvisor]
	
	@IBOutlet weak var navBar: UINavigationItem!
	var menuButton: UIButtonAnimation! = nil
	var comesFromSegue: Bool = false
	
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iconLinkButton: UIButton!
	
	let cellHeightMultiplier: CGFloat = 0.125
    
	let identifier = "FollowUsCell"
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
		menuButton = Menu.menuButton(self, animation: .HamburgerToCross)
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		
		(UIApplication.shared.delegate as! AppDelegate).currentViewController = self
		
		
		
		var attrs: [String: Any] = [
			NSFontAttributeName : UIFont.init(name: "Verdana", size: 14)!,
			NSForegroundColorAttributeName : UIColor.primary]
		
		let attributedString = NSMutableAttributedString(string: "All icons provided by ", attributes: attrs)
		
		attrs[NSUnderlineStyleAttributeName] = 1
		
		attributedString.append(NSAttributedString(string: "Icons8", attributes: attrs))
		
		iconLinkButton.setAttributedTitle(attributedString, for: .normal)
		
		
		tableView.delegate = self
		tableView.dataSource = self
		
		
		setColors()
    }
	
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
		self.tableView.separatorColor = UIColor.primary
		self.tableView.backgroundColor = UIColor.secondary
	}

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return FollowUsViewController.items.count
	}
	
    func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if #available(iOS 10.0, *) {
			UIApplication.shared.open(FollowUsViewController.items[indexPath.row].url, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(FollowUsViewController.items[indexPath.row].url)
		}
	}
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FollowUsTableViewCell
		let item = FollowUsViewController.items[indexPath.row]
		
		cell.content.backgroundColor = UIColor.clear
		cell.set(image: item.icon)
		cell.title.text = item.title
		
		cell.setColors()
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let bounds = UIScreen.main.bounds
		let height = bounds.width > bounds.height ? bounds.width : bounds.height
		return height * cellHeightMultiplier
	}
	
	//MARK: - Menu view data source
	
	func toggle(_ sender: AnyObject) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
    
    //MARK: - Action
    
    @IBAction func openLink(_ sender: Any) {
		let url = URL(string: "https://de.icons8.com/")!
		if #available(iOS 10.0, *) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(url)
		}
    }
    
}
//
//  imageGallaryCollectionView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 2/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class ImageGallaryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	var imageURLS: [URL]?
	var reuseIdentifier = "Cell"
	
	var imageGallaryDelegate: ImageGallaryCollectionViewDelegate?

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let cells = imageURLS else {return 0}
		return cells.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
		guard let imageCell = cell as? ImageGallaryCollectionViewCell else {return cell}
		
		if imageURLS?[indexPath.item] != nil {
			imageCell.imageView.sd_setImage(with: imageURLS![indexPath.item], placeholderImage: #imageLiteral(resourceName: "PlaceHolder"))
		} else {
			imageCell.imageView.image = #imageLiteral(resourceName: "ImageNotFound")
		}
		
		imageCell.collectionView = self
		
		imageCell.imageView.contentMode = .scaleAspectFit
		
		return imageCell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
		return size
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func selectedCell() -> ImageGallaryCollectionViewCell? {
		let visibleCellsIndexes = self.indexPathsForVisibleItems
		guard visibleCellsIndexes.count > 0 else {return nil}
		
		return self.cellForItem(at: visibleCellsIndexes[0]) as? ImageGallaryCollectionViewCell
	}
}
//
//  ImageGallaryCollectionViewCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 1/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

protocol ImageGallaryCollectionViewDelegate {
	func set(alpha: CGFloat) -> Void
	func dismissImageGallary() -> Void
}

class ImageGallaryCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

	@IBOutlet weak var imageView: ARImageView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var collectionView: ImageGallaryCollectionView?
	
	//	This value is used to determine how far the user will have to scroll until the collection view will be dismissed
	let offsetNeededToRemove: CGFloat = 80
	//	This value is used to determine at what point from the center the view will be completely opaque
	let fullOpacityPosition: CGFloat = 200
	
	fileprivate var willClose = false
	
	override func awakeFromNib() {
		super.awakeFromNib()
		scrollView.minimumZoomScale = 1.0
		scrollView.maximumZoomScale = 5.0
		scrollView.delegate = self
		scrollView.alwaysBounceVertical = true
		scrollView.alwaysBounceHorizontal = false
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard !willClose && scrollView.zoomScale == 1 else {return}
		var offset = abs(scrollView.contentOffset.y)
		offset -= abs(zoomOffset().y)
		/*print("offset 1: \(offset)")
		print("imageOffset: \(abs(imageOffset().y))")
//		offset = abs(offset)
		offset -= abs(imageOffset().y)
		if offset < 0 {
			offset = 0
		}
		print("offset 2: \(offset)")
//		if offset < 0 {
//			offset = 0
//		}
//		print(offset)*/
		
		
		
		//let alpha = 1 - 1 / fullOpacityPosition * offset
		let alpha = 1 - pow(offset, 2) / pow(fullOpacityPosition, 2)
		collectionView?.imageGallaryDelegate?.set(alpha: alpha)
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		guard scrollView.zoomScale == 1 else {return}
		var offset = abs(scrollView.contentOffset.y)
		offset -= zoomOffset().y
		if offset >= offsetNeededToRemove {
			willClose = true
			collectionView?.imageGallaryDelegate?.dismissImageGallary()
		}
	}
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	func zoomOffset() -> CGPoint {
		let width = scrollView.frame.width/2 * (scrollView.zoomScale - 1)
		let height = scrollView.frame.height/2 * (scrollView.zoomScale - 1)
		return CGPoint(x: width, y: height)
	}
	
	func imageOffset() -> CGPoint {
		let width = imageSize().width / 2 * scrollView.zoomScale
		let height = imageSize().height / 2 * scrollView.zoomScale
		return CGPoint(x: width, y: height)
	}

	
	func imageSize() -> CGSize {
		let width = imageView.image!.size.width * scrollView.zoomScale / UIScreen.main.scale
		let height = imageView.image!.size.height * scrollView.zoomScale / UIScreen.main.scale
		return CGSize(width: width, height: height)
	}
}

//
//  ImageGalleryFlowLayout.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 3/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class ImageGallaryFlowLayout: UICollectionViewFlowLayout {

	
	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
		print("Wurking")
		var offsetAdjustment = CGFloat(MAXFLOAT)
		let spacing: CGFloat = 8
		let horizontalOffset: CGFloat = proposedContentOffset.x + spacing
		
		let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: self.collectionView!.bounds.width, height: self.collectionView!.bounds.height)
		
		let attributesArray = super.layoutAttributesForElements(in: targetRect)
		
		for layoutAttribute in attributesArray! {
			let itemOffset = layoutAttribute.frame.origin.x
			if abs(itemOffset - horizontalOffset) < abs(offsetAdjustment) {
				offsetAdjustment = itemOffset - horizontalOffset
			}
		}
		
		return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
	}
	
	
}
//
//  InfoTableViewCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 9/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
	
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var icon: UIImageView!
	@IBOutlet weak var arrow: UILabel!
	
	@IBOutlet weak var widthConstraint: NSLayoutConstraint!
}
//
//  InformationController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 19/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit

struct InfoMenuItem {
	var title: String
	var icon: UIImage?
	var viewController: String
	
	static let wellness = InfoMenuItem(title: "Wellness", icon: nil, viewController: "WellnessViewController")
	static let usefullInformation = InfoMenuItem(title: "Useful Information", icon: nil, viewController: "UsefullInformationViewController")
	static let facilityMap = InfoMenuItem(title: "Facility Map", icon: nil, viewController: "FacilityMapViewController")
	static let roomService = InfoMenuItem(title: "Room Service", icon: nil, viewController: "RoomServiceViewController")
	static let minibar = InfoMenuItem(title: "Minibar", icon: nil, viewController: "MinibarViewController")
	static let pillowMenu = InfoMenuItem(title: "Pillow Menu", icon: nil, viewController: "PillowMenuViewController")
}

class InformationController: UITableViewController, SWRevealViewControllerDelegate {
    //MARK: - Properties
	
	@IBOutlet weak var navBar: UINavigationItem!
	var menuButton: UIButtonAnimation! = nil
	var comesFromSegue: Bool = false
	
	var menuItems: [InfoMenuItem] = [.wellness, .usefullInformation, .roomService, .minibar, .pillowMenu, .facilityMap]
	
	let identifier = "cell"
	let iconWidthMultiplier: CGFloat = 0.1
	let cellHeightMultiplier: CGFloat = 0.1
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		navBar?.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		
		
		
		(UIApplication.shared.delegate as! AppDelegate).currentViewController = self
		
		setColors()
	}
	
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
		self.tableView.separatorColor = UIColor.primary
		
	}
	
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
	
	
	
//	MARK: - Tableview data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! InfoTableViewCell
		
		guard menuItems.count > indexPath.row else {return cell}
		let item = menuItems[indexPath.row]
		
		cell.title.text = item.title
		cell.title.adjustsFontSizeToFitWidth = true
		//cell.title.font = cell.title.font.withSize(fontSize())
		cell.arrow.textColor = UIColor.primary
		cell.backgroundColor = UIColor.secondary
		if item.icon != nil {
			cell.icon.image = item.icon!
			cell.widthConstraint.constant = UIScreen.main.bounds.rectWidth() * iconWidthMultiplier
		} else {
			cell.widthConstraint.constant = 0
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch (self.traitCollection.horizontalSizeClass, self.traitCollection.verticalSizeClass) {
		case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular):
			return 64
		default:
			return 32
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = menuItems[indexPath.row]
		guard let viewController = destinationViewController(item: item) else {print("Failed to initialize info item. Item: \(item)"); return}
		
		viewController.title = item.title
		self.navigationController!.pushViewController(viewController, animated: true)
	}
	
	func destinationViewController(item: InfoMenuItem) -> UIViewController? {
		
		switch item.title.lowercased() {
		case "wellness".lowercased():
			return WellnessViewController(nibName: item.viewController, bundle: nil)
		case "useful information".lowercased():
			return UsefullInformationViewController(nibName: item.viewController, bundle: nil)
		case "facility map".lowercased():
			return FacilityMapViewController(nibName: item.viewController, bundle: nil)
		case "room service".lowercased():
			return RoomServiceViewController(nibName: item.viewController, bundle: nil)
		case "minibar":
			return MinibarViewController(nibName: item.viewController, bundle: nil)
		case "pillow menu":
			return PillowMenuViewController(nibName: item.viewController, bundle: nil)
		default:
			return nil
		}
	}
}
//
//  JPMap.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 12/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation
import MapKit
import SWXMLHash

struct JPMapProperty {
	var location: CLLocationCoordinate2D
	var span: MKCoordinateSpan
	var maxSpan: MKCoordinateSpan
	var mapOverlays: JPMapOverlay
	
	var region: MKCoordinateRegion {
		return MKCoordinateRegion(center: location, span: span)
	}
}

struct JPMapOverlay {
	var waypoints: [JPMapWaypoint]
	var tracks: [JPMapTrack]
}

struct JPMapWaypoint: XMLIndexerDeserializable {
	var location: CLLocationCoordinate2D
	var name: String?
	var subtitle: String?
	var iconName: String?
	var imageURL: String?
	
	var icon: UIImage? {
		guard iconName != nil else {return nil}
		return JPMapWaypoint.icons[iconName!]
	}
	static let icons: [String: UIImage] = ["Start": #imageLiteral(resourceName: "Start")]
	
	var annotation: JPPointAnnotation {
		return JPPointAnnotation(coordinate: location, title: name, subtitle: subtitle, image: icon, detailImageURL: imageURL)
	}
	
	static func deserialize(_ node: XMLIndexer) throws -> JPMapWaypoint {
		return try JPMapWaypoint(
			location: CLLocationCoordinate2D.deserialize(node),
			name: node["name"].value(),
			subtitle: node["subtitle"].value(),
			iconName: node["sym"].value(),
			imageURL: node["image"].value())
	}
}

class JPPointAnnotation: MKPointAnnotation {
	var image: UIImage?
	
	var detailImageURL: String?
	
	init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil, image: UIImage? = nil, detailImageURL: String? = nil) {
		super.init()
		self.coordinate = coordinate
		self.title = title
		self.subtitle = subtitle
		self.image = image
		self.detailImageURL = detailImageURL
	}
}

struct JPMapTrack: XMLIndexerDeserializable {
	var name: String
	var trackPoints: [CLLocationCoordinate2D]
	
	var polyline: MKPolyline {
		return MKPolyline(coordinates: trackPoints, count: trackPoints.count)
	}
	
	var polylineRenderer: MKPolylineRenderer {
		let renderer = MKPolylineRenderer(polyline: polyline)
		return renderer
	}
	
	init (name: String, trackPoints: [CLLocationCoordinate2D]) {
		self.name = name
		self.trackPoints = trackPoints
	}
	
	static func deserialize(_ node: XMLIndexer) throws -> JPMapTrack {
		return try JPMapTrack(name: node["name"].value(), trackPoints: node["trkseg"]["trkpt"].value())
	}
}

extension CLLocationCoordinate2D: XMLIndexerDeserializable {
	public static func deserialize(_ node: XMLIndexer) throws -> CLLocationCoordinate2D {
		return try CLLocationCoordinate2DMake(node.value(ofAttribute: "lat"), node.value(ofAttribute: "lon"))
	}
}
//
//  MapParser.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 9/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation
import SWXMLHash
import MapKit

class JPMapParser {
	var xmlURL: URL
	var location: CLLocationCoordinate2D
	var span: MKCoordinateSpan
	var maxSpan: MKCoordinateSpan
	
	var downloader: URLSessionDataTask?
	
	init (xmlURL: URL, location: CLLocationCoordinate2D, span: MKCoordinateSpan, maxSpan: MKCoordinateSpan) {
		self.xmlURL = xmlURL
		self.location = location
		self.span = span
		self.maxSpan = maxSpan
	}
	
	func parse(completion: @escaping (JPMapProperty) -> Void) {
		let configuration = URLSessionConfiguration.default
		configuration.requestCachePolicy = .reloadIgnoringCacheData
		let session = URLSession(configuration: configuration)
		downloader = session.dataTask(with: xmlURL) {(data, response, error) in
			guard
				data != nil
				else {fatalError("Data not found")}
			
			let xml = SWXMLHash.parse(data!)
			let gpx = xml["gpx"]
			var waypoints = [JPMapWaypoint]()
			
			for element in gpx["wpt"].all {
				var waypoint: JPMapWaypoint?
				do {
					waypoint = try JPMapWaypoint.deserialize(element)
				} catch {
					waypoint = nil
				}
				if waypoint != nil {
					waypoints.append(waypoint!)
				}
			}
			
			var tracks = [JPMapTrack]()
			for element in gpx["trk"].all {
				var track: JPMapTrack?
				do {
					track = try JPMapTrack.deserialize(element)
				} catch {
					print("Failed to load track")
					track = nil
				}
				if track != nil {
					tracks.append(track!)
				}
			}
			let overlays: JPMapOverlay = JPMapOverlay(waypoints: waypoints, tracks: tracks)
			let properties = JPMapProperty(location: self.location, span: self.span, maxSpan: self.maxSpan, mapOverlays: overlays)
			
			completion(properties)
			
		}
		self.downloader?.resume()
	}
}
//
//  MassageView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 20/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class MassageView: UIView {
    
    override func awakeFromNib() {
		setColors()
    }
    
	func setColors() {
		for view in subviews {
			if let label = view as? UILabel {
				label.textColor = UIColor.primary
			}
		}
	}
	
}
//
//  MenuTableViewCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 7/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

	
	@IBOutlet var imageCell: UIImageView!
	@IBOutlet var title: UILabel!
	@IBOutlet var selector: UIView!

	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		selector?.isHidden = true
    }
    
}
//
//  MenuTableViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit
import MapKit

struct JPMenuItem: Equatable {
	var title: String
	var image: UIImage
	var segueIdentifier: String
	
	static let home = JPMenuItem(title: "Home", image: #imageLiteral(resourceName: "home"), segueIdentifier: "HomeSegue")
	static let info = JPMenuItem(title: "Info", image: #imageLiteral(resourceName: "info"), segueIdentifier: "InfoSegue")
	static let weather = JPMenuItem(title: "Weather", image: #imageLiteral(resourceName: "Weather"), segueIdentifier: "WeatherSegue")
	static let excursion = JPMenuItem(title: "Excursion", image: #imageLiteral(resourceName: "excursion"), segueIdentifier: "ExcursionSegue")
	static let massage = JPMenuItem(title: "Massage", image: #imageLiteral(resourceName: "massage"), segueIdentifier: "SpaSegue")
	static let followUs = JPMenuItem(title: "Follow Us", image: #imageLiteral(resourceName: "follow_us"), segueIdentifier: "FollowUsSegue")
	static let settings = JPMenuItem(title: "Settings", image: #imageLiteral(resourceName: "Settings"), segueIdentifier: "SettingsSegue")
}

func ==(lhsItem: JPMenuItem, rhsItem: JPMenuItem) -> Bool {
	return (lhsItem.title == rhsItem.title && lhsItem.image.isEqual(rhsItem.image) && lhsItem.segueIdentifier == rhsItem.segueIdentifier)
}

class MenuTableViewController: UITableViewController, SWRevealViewControllerDelegate, CLLocationManagerDelegate {
	
	var menuItems: [JPMenuItem] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	
	static var currentItem: JPMenuItem = .home
	
	static var backGroundColor: UIColor = UIColor.secondary
	static var fontColor: UIColor = UIColor.primary

	
	let locationManager = CLLocationManager()

	let identifier = "MenuCell"
	
	var userLocation: CLLocation? {
		didSet {
			createMenu()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: identifier)
		
		self.view.backgroundColor = MenuTableViewController.backGroundColor
		self.tableView.separatorColor = MenuTableViewController.fontColor
		
		self.revealViewController().frontViewShadowColor = UIColor.primary
		
		self.revealViewController().delegate = self
		
		createMenu()
		
		locationManager.requestWhenInUseAuthorization()
		locationManager.delegate = self
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			if #available(iOS 9.0, *) {
				locationManager.requestLocation()
			}
		}
    }
	
	func createMenu() {
		var items = [JPMenuItem]()
		items.append(.home)
		items.append(.info)
		items.append(.weather)
		items.append(.excursion)
		if userInHotel() {
			items.append(.massage)
		}
		items.append(.followUs)
		
		menuItems = items
	}
	
	func userInHotel() -> Bool {
		guard userLocation != nil else {return false}
		let mapPoint = MKMapPointForCoordinate(userLocation!.coordinate)
		if MKMapRectContainsPoint(Constants.hotelRegion, mapPoint) {
			return true
		} else {
			return false
		}
	}
	
	//MARK: - Location Services
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			userLocation = location
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		let alert = UIAlertController(title: "Could not get user position", message: error.localizedDescription, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MenuTableViewCell else {fatalError("Could not dequeue cell with identifier: \(identifier)")}
		
		cell.imageCell?.image = menuItems[indexPath.row].image
		cell.imageCell.image = cell.imageCell.image?.withRenderingMode(.alwaysTemplate)
		cell.imageCell.tintAdjustmentMode = .normal
		cell.imageCell.tintColor = MenuTableViewController.fontColor
		cell.imageCell.backgroundColor = UIColor.clear
		
		cell.title?.text = menuItems[indexPath.row].title
		cell.title.textColor = MenuTableViewController.fontColor
		cell.title.backgroundColor = UIColor.clear
		
		cell.backgroundColor = MenuTableViewController.backGroundColor
		
		cell.selector.backgroundColor = MenuTableViewController.fontColor
		
		if MenuTableViewController.currentItem == menuItems[indexPath.row] {
			cell.selector?.isHidden = false
		} else {
			cell.selector?.isHidden = true
		}
		
		return cell
	}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let lastItem = MenuTableViewController.currentItem
		MenuTableViewController.currentItem = menuItems[indexPath.row]
		tableView.reloadData()
		if shouldPerformSegue(withIdentifier: lastItem.segueIdentifier, sender: self) {
			performSegue(withIdentifier: MenuTableViewController.currentItem.segueIdentifier, sender: self)
		} else {
			let revealViewController = (UIApplication.shared.delegate as! AppDelegate).currentViewController?.revealViewController()
			revealViewController?.revealToggle(animated: true)
		}
	}
	
	
	
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		
		if identifier != MenuTableViewController.currentItem.segueIdentifier {
			return true
		} else {
			return false
		}
	}
}
//
//  MinibarViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 22/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class MinibarViewController: UIViewController {

	@IBOutlet weak var contentView: UIView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.secondary
		
		for subview in contentView.subviews {
			guard let view = subview as? UILabel else {continue}
			view.textColor = UIColor.primary
		}
	}
}
//
//  NavigationController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 7/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
	
	static var backgroundColor = UIColor.primary
	static var fontColor = UIColor.secondary

	override func viewDidLoad() {
		
		super.viewDidLoad()
		
        let nav = self.navigationBar
		nav.tintColor = NavigationController.fontColor
        nav.barTintColor = NavigationController.backgroundColor
        nav.titleTextAttributes = Constants.navigationFont
		
		//nav.topItem?.leftBarButtonItem?.image = nav.topItem?.leftBarButtonItem?.image?.withRenderingMode(.alwaysTemplate)
		//nav.topItem?.leftBarButtonItem?.tintColor = NavigationController.fontColor
		
		/*nav.layer.masksToBounds = false
		nav.layer.shadowColor = NavigationController.fontColor.cgColor
		nav.layer.shadowRadius = 5
		nav.layer.opacity = 0.5
		nav.layer.shadowOffset.height = 2*/
		
		setItemsColor()
		
		self.edgesForExtendedLayout = .bottom
    }
	
	//Loops through all the items present in the navigation bar, and if they have an image it will be set to the font color
	func setItemsColor() {
		let nav = self.navigationBar
		guard nav.items != nil else {return}
		for item in nav.items! {
			if item.rightBarButtonItems != nil {
				for rightItem in item.rightBarButtonItems! {
					setItemColor(item: rightItem)
				}
			}
			if item.leftBarButtonItems != nil {
				for leftItem in item.leftBarButtonItems! {
					setItemColor(item: leftItem)
				}
			}
		}
	}
	
	func setItemColor(item: UIBarButtonItem) {
		item.image = item.image?.withRenderingMode(.alwaysTemplate)
		item.tintColor = NavigationController.fontColor
	}
	
	override func viewWillLayoutSubviews() {
		let buttonHeightRatio: CGFloat = 0.7
		
		let customView = self.navigationBar.topItem?.leftBarButtonItem?.customView as? UIButtonAnimation
		let navBarHeight = self.navigationBar.frame.height
		
		customView?.frame.size = CGSize(width: navBarHeight * buttonHeightRatio, height: navBarHeight * buttonHeightRatio)
		
		if customView != nil {
			
			customView?.updateFrame(frame: customView!.frame)
			
		}
		
		self.navigationBar.setNeedsLayout()
	}
}
//
//  PillowMenuViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 22/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class PillowMenuViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
	@IBOutlet weak var duvetImageView: UIImageView!
	@IBOutlet weak var microFiberImageView: UIImageView!
	@IBOutlet weak var tecnogelImageView: UIImageView!
	@IBOutlet weak var viscoFiberImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.backgroundColor = UIColor.secondary
		
		for subview in contentView.subviews {
			if let view = subview as? UILabel {
				view.textColor = UIColor.primary
			}
		}
		
		let scale = UIScreen.main.scale
		
		let duvetSize = duvetImageView.frame.size
		let scaledSize = CGSize(width: duvetSize.width * scale, height: duvetSize.height * scale)
		duvetImageView.image = duvetImageView.image?.resizedImage(scaledSize, interpolationQuality: .default)
		microFiberImageView.image = microFiberImageView.image?.resizedImage(scaledSize, interpolationQuality: .default)
		tecnogelImageView.image = tecnogelImageView.image?.resizedImage(scaledSize, interpolationQuality: .default)
		viscoFiberImageView.image = viscoFiberImageView.image?.resizedImage(scaledSize, interpolationQuality: .default)
    }

}
//
//  RoomServiceViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 22/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class RoomServiceViewController: UIViewController {
	
    @IBOutlet weak var contentView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.secondary
		
		for subview in contentView.subviews {
			guard let view = subview as? UILabel else {continue}
			view.textColor = UIColor.primary
		}
	}

}
//
//  SettingsTableViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 11/03/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, SWRevealViewControllerDelegate {
	
//	MARK: - Properties
//	MARK: Navigation Bar
	@IBOutlet weak var navBar: UINavigationItem!
	var menuButton: UIButtonAnimation! = nil
	var comesFromSegue: Bool = false
	
//	MARK: Other properties

    override func viewDidLoad() {
        super.viewDidLoad()

		
		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		self.revealViewController().delegate = self
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		(UIApplication.shared.delegate as! AppDelegate).currentViewController = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
}
//
//  SpaController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 18/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit
import KVConstraintExtensionsMaster

class SpaController: UIViewController, SWRevealViewControllerDelegate {
    //MARK: - Properties
	
   // @IBOutlet weak var webView: UIWebView!
	@IBOutlet weak var navBar: UINavigationItem!
	
	var webView: UIWebView? {
		for subView in self.view.subviews {
			if let webView = subView as? UIWebView {
				return webView
			}
		}
		return nil
	}
	
	var menuButton: UIButtonAnimation! = nil
	
	var comesFromSegue: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		menuButton = Menu.menuButton(self, animation: .HamburgerToCross)
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		appDelegate.currentViewController = self
		
		setColors()
		
		
		//WebView initialization
		
		let url = URL(string: "http://viraviraspa.appointy.com/")
		
		if appDelegate.spaWebView == nil {
			appDelegate.spaWebView = UIWebView()
			self.automaticallyAdjustsScrollViewInsets = true
			DispatchQueue.global().async {
				let requestObj = URLRequest(url: url!)
				appDelegate.spaWebView!.loadRequest(requestObj)
			}
		} else {
			self.automaticallyAdjustsScrollViewInsets = false
		}
		appDelegate.spaWebView?.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(appDelegate.spaWebView!)
		print(view.subviews.count)
		
		
		if let webView = webView {
			print(webView.translatesAutoresizingMaskIntoConstraints)
			webView.applyTopAndBottomPinConstraint(toSuperview: 0)
			//webView.applyTopPinConstraint(toSuperview: 44)
//			webView.applyBottomPinConstraint(toSuperview: 0)
			
			webView.applyLeadingAndTrailingPinConstraint(toSuperview: 0)
			
		}
		
		/*for subview in view.subviews {
			if let webView = subview as? UIWebView {
				webView.frame = self.view.frame
				webView.applyTopAndBottomPinConstraint(toSuperview: 0)
				webView.applyLeadingAndTrailingPinConstraint(toSuperview: 0)
				self.view.setNeedsUpdateConstraints()
			}
		}*/
		
		if let webView = self.view.subviews[0] as? UIWebView {
			webView.applyTopAndBottomPinConstraint(toSuperview: 0)
			webView.applyLeadingAndTrailingPinConstraint(toSuperview: 0)
		}
		
		
		//webView = appDelegate.spaWebView!
		
	}
	
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
	}
	
	func toggle(_ sender: AnyObject) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
}
//
//  TextFormatter.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

func applyKeywordsMeaning(_ text: String) -> String{
    let string: NSMutableAttributedString = NSMutableAttributedString(string: text)
    let words: [String] = text.components(separatedBy: " ")
    
    let nonAlphanumericCharacterSet: NSMutableCharacterSet = NSMutableCharacterSet.alphanumeric()
    nonAlphanumericCharacterSet.formUnion(with: NSMutableCharacterSet(charactersIn: "*") as CharacterSet)
    nonAlphanumericCharacterSet.invert()
    
    for var word in words {

        word = word.trimmingCharacters(in: nonAlphanumericCharacterSet as CharacterSet)
        let range: NSRange = (string.string as NSString).range(of: word)
        
        if(word.hasPrefix("*") && word.hasSuffix("*")) {
            
            switch word {
            case "*NAME*":
                string.replaceCharacters(in: range, with: "Paravicini")
                
            case "*TIME_NAME*":
                string.replaceCharacters(in: range, with: Date().timeName())
                
            
            case "*DATE*", "*LONG_DATE*":
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                string.replaceCharacters(in: range, with: formatter.string(from: Date()))
                
            case "*SHORT_DATE*":
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                string.replaceCharacters(in: range, with: formatter.string(from: Date()))
                
            case "*MEDIUM_DATE*":
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                string .replaceCharacters(in: range, with: formatter.string(from: Date()))
                
            case "*FULL_DATE*":
                let formatter = DateFormatter()
                formatter.dateStyle = .full
                string.replaceCharacters(in: range, with: formatter.string(from: Date()))
                
                
            default:
                string.replaceCharacters(in: range, with: "")
            }
        }
    }
    
    return string.string
}
//
//  UsefullInformationViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 21/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit
import KVConstraintExtensionsMaster

class UsefullInformationViewController: UIViewController {

    @IBOutlet weak var tableView: ExpandableTableView!
	
	var labelFontSize: CGFloat {
		get {
			switch (self.view.traitCollection.horizontalSizeClass, self.view.traitCollection.verticalSizeClass) {
			case (.regular, .regular):
				return 24
			case (.compact, .compact):
				return 17
				
			default:
				return 17
			}
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.backgroundColor = UIColor.secondary
		tableView.separatorStyle = .none
		tableView.showsVerticalScrollIndicator = false
		tableView.showsHorizontalScrollIndicator = false
		tableView.sections = populate()
    }
	
	func populate() -> [ExpandableTableViewSection] {
		var sections = [ExpandableTableViewSection]()
		sections.append(ExpandableTableViewSection(name: "Hotel", content: [hotelView()]))
		sections.append(ExpandableTableViewSection(name: "Location", content: [locationView()]))
		sections.append(ExpandableTableViewSection(name: "Climate", content: [climateView()]))
		sections.append(ExpandableTableViewSection(name: "Recommended Clothing", content: [recommendedClothingView()]))
		sections.append(ExpandableTableViewSection(name: "Electricity", content: [electricityView()]))
		sections.append(ExpandableTableViewSection(name: "Language", content: [languageView()]))
		sections.append(ExpandableTableViewSection(name: "Internet", content: [internetView()]))
		sections.append(ExpandableTableViewSection(name: "Currency", content: [currencyView()]))
		sections.append(ExpandableTableViewSection(name: "Room Amenities", content: [roomAmenitiesView()]))
		sections.append(ExpandableTableViewSection(name: "All Inclusive Package", content: [allInclusivePackageView()]))
		sections.append(ExpandableTableViewSection(name: "Excursions", content: [excursionView()]))
		sections.append(ExpandableTableViewSection(name: "Restaurant", content: [restaurantView()]))
		sections.append(ExpandableTableViewSection(name: "Tipping", content: [tippingView()]))
		sections.append(ExpandableTableViewSection(name: "Families", content: [familiesView()]))
		sections.append(ExpandableTableViewSection(name: "Medical Facilities", content: [medicalFacilitiesView()]))
		
		return sections
	}
	
	func hotelView() -> UIView {
		return lableView(with: "Our Hacienda Hotel Vira Vira is set in a beautiful and unique location close to Pucón, Chile. It features a 23ha native park along the shores of the Liucura River and offers an oasis of peace and recreation. The Vira Vira Hotel brings a new concept of vacation to life – we call it “The Elegance of Adventure” which means that a large range of exclusive activities and excursions are part of your “all inclusive” stay with the Hotel. We look forward to welcoming you at our Hacienda Hotel.")
	}
	
	func locationView() -> UIView {
		return lableView(with: "Pucón – also called the “Entrance of the Cordillera” by local Mapuche – is the ideal starting point for your adventures. This picturesque city turns in a melting point for numerous tourists and offers an unrivaled number of excursions and activities surrounded by breathless views and landscapes. The village is situated along the shores of the Villarrica Lake at the foot of the active Volcano Villarrica and its rather stable weather (especially in the summer) make it the secret destination of the Chilean experienced traveler. \n Pucón – situated roughly 780 Km south of Santiago or 100 Km southeast of Temuco – can easily be reached by plane to Temuco or by Bus or car. We recommend the Premium bus service from Turbus that offers an overnight passage with 180° seats – a great way to start your vacation. The city is at a height of 220m above sea and has about 25.000 inhabitants.")
	}
	
	func climateView() -> UIView {
		return lableView(with: "Pucón’s climate tends to be Mediterranean, with temperate, short summers and cold humid winters. The summer period (October to March) is usually characterized by moderate to warm weather with relatively plenty of sunshine and moderate rains. It is the ideal travel period for horseback riding, hiking, and all kind of water activities and for ascents to the Volcano. The winter in Pucón is usually quite cold and offers unusual and interesting winter activities such as skiing on the Volcano, snowshoeing in Natural Parks, horseback riding or pure relaxation in one of the many natural hot springs or to enjoy a great Yoga class or other in-house activities of the Hotel.")
	}
	
	func recommendedClothingView() -> UIView {
		return lableView(with: "We recommend layered clothing with a good warm jacket or fleece for the colder times of day and for the winter season. Suggested packing list includes walking or hiking shoes, shorts, warmer trousers, sweaters or polar fleece, sun cream (high protection), sun hat and sunglasses. If possible, we recommend a small daypack to carry your personal items during the excursions. Dress code is neat casual for dinner and casual at all other times (no jackets required).")
	}
	
	func electricityView() -> UIView {
		return lableView(with: "Electricity in Chile and Vira Vira is 220V 50Hz and most of the plugs are European two pin round. However, most of the suites also have a couple of US and other wall plugs for the convenience of our guests.")
	}
	
	func languageView() -> UIView {
		return lableView(with: "All of our staff speak Spanish and most of them speak English or some other language. Our guides speak English, Spanish, German or French and if required we can provide excursions also in other languages (on advance notice only).")
	}

	func internetView() -> UIView {
		return lableView(with: "We have installed our own dedicated fiber optics all the way from Pucón to Vira Vira and we can thus offer a reliable and ultra-fast internet (100MB). All public areas and all suites are equipped with LAN and WiFi connections. All have IP telephony with direct international dialing capability.")
	}
	
	func currencyView() -> UIView {
		return lableView(with: "The Chilean currency is the peso however all charges for non-residents are made in USD. Non-residents with proper documentation (immigration slip and passport) are exempt of VAT. We accept Visa, MasterCard, American Express and Diners Club credit cards. ATM’s and currency exchange facilities are available in the village.")
	}
	
	func roomAmenitiesView() -> UIView {
		return lableView(with: "All Suites and Rooms are equipped with:\n- WiFi high-speed internet access (free of charge) - Central heating and air-conditioning\n- Direct international Telephone dialing\n- Hair dryer\n- Safe\nWe do not have television set in our rooms but if required we can provide a PC with fast internet to watch live programs.")
	}
	
	func allInclusivePackageView() -> UIView {
		return lableView(with: "We would like you to fully enjoy your stay with Vira Vira and thus our All Inclusive package is very comprehensive and includes:\n- all transfers from/to Temuco\n- all meals; we provide a daily four course menu and a vegetarian choice. Please advise us ahead of time of any dietary restriction you may have)\n- soft drinks, mineral water, house wine and house beer\n- all offered excursions\n- use of all facilities of the hotel and we are delighted to give you a tour of the Hacienda including a visit to our own cheese and milk diary\nThe All Inclusive package does NOT include:\n- private excursions\n- premium wines and liquors - laundry service\n- telephone calls\n- Spa treatments (massages) - tips")
	}
	
	func excursionView() -> UIView {
		return lableView(with: "We would like to encourage you to explore a new adventure or experience every day and to feel the mystic ambiance of these ancient Mapuche territories. Our guides are passionate about their work, the excursions we offer and are truly excited to share their experience with you.\nEvery day you will meet with our excursion manager to discuss and arrange your next day activities or excursion. Pucón simply offers the best in adventure - be it to explore the many untouched natural parks by horse, to climb with our experienced guide on top of the Volcano, to fight the lively water with your kayak or enjoy a fun day river rafting in the Trancura river - it will always be a fun and unforgettable experience.")
	}
	
	func restaurantView() -> UIView {
		return lableView(with: "Our gourmet cuisine offers a blend of local, ancient indigenous recipes coupled with the best and truly fresh ingredients to serve you that extra dish... Everyday our Chef prepares a four- course menu, carefully composed, lovingly arranged, and accompanied by that special wine to seduce your tastes and senses. For our meat lovers we will gladly grill your favorite steak and for our vegetarians we always have a delicious pasta or a full vegetarian menu to choose from.\nWe offer free seating in our Restaurant (except at full capacity where we will arrange your table) and you are welcome to join your friends or the hotel owner at his or her table.")
	}
	
	func tippingView() -> UIView {
		return lableView(with: "Tips are at the discretion of our guests. We suggest USD 70 – 100 per day to be shared amongst all our team although if you prefer to give a specific amount to your guide or restaurant staff or other individual please do so. Our receptionist will gladly provide you with an envelope.")
	}
	
	func familiesView() -> UIView {
		return lableView(with: "Vira Vira is an ideal place to spend your holiday with your family and children. We offer a broad range of exciting adventures and excursions tailored to families and children. Please note however that lagoons, creeks and a large river surround Vira Vira and we do not have a lifeguard on duty. Most areas are unprotected and we kindly ask you to closely watch your smaller children. We gladly arrange for you on advance notice a babysitter.")
	}
	
	func medicalFacilitiesView() -> UIView {
		return lableView(with: "There is an emergency first aid clinic in the village of Pucón but we recommend using the advanced and modern facilities of the Clinica Alemana in Temuco (1.5 hours away). We advise all our guests to travel with a comprehensive illness and accident insurance policy.")
	}
	
	func lableView(with text: String) -> UIView {
		let view = UIView()
		let label = UILabel()
		
		view.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.textColor = UIColor.primary
		label.textAlignment = .justified
		label.numberOfLines = 0
		label.font = label.font.withSize(labelFontSize)
		
		view.addSubview(label)
		label.applyTopAndBottomPinConstraint(toSuperview: 16)
		label.applyCenterXPinConstraint(toSuperview: 0)
		NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
		
		label.text = text
		
		return view
	}

}
//
//  WeatherCollectionReusableView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class WeatherCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
	static let cellIdentifier = "WeatherCell"
	var weatherDay: WeatherDay? {
		didSet {
			self.reloadData()
		}
	}
	
	var controllerView: WeatherController?
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let forecasts = weatherDay?.weatherModels {
			return forecasts.count
		} else {
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = dequeueReusableCell(withReuseIdentifier: WeatherCollectionView.cellIdentifier, for: indexPath) as! WeatherCollectionViewCell
		
		let weatherModel = weatherDay!.weatherModels[indexPath.item]
		
		cell.timeStamp.text = weatherModel.timeStamp()
		
		var tempUnit = Weather.TemperatureUnits.Celsius
		if controllerView != nil {
			tempUnit = controllerView!.tempUnit
		}
		cell.temperature.text = "\(weatherModel.temp(unit: tempUnit, roundToDecimal: 1))"
		cell.icon.image = weatherModel.icon
		
		setColors(for: cell)
		
		return cell
	}
	
	func setColors(for cell: WeatherCollectionViewCell) {
		cell.timeStamp.textColor = UIColor.primary
		cell.temperature.textColor = UIColor.primary
		cell.icon.image = cell.icon.image?.withRenderingMode(.alwaysTemplate)
		cell.icon.tintColor = UIColor.primary
		
		self.backgroundColor = UIColor.clear
	}
}
//
//  WeatherCollectionViewCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var timeStamp: UILabel!
	@IBOutlet weak var temperature: UILabel!
	@IBOutlet weak var icon: UIImageView!
}
//
//  WeatherController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 4/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class WeatherController: UIViewController, SWRevealViewControllerDelegate {
	@IBOutlet weak var cityLabel: UILabel!
	
	@IBOutlet weak var navBar: UINavigationItem!
	var comesFromSegue: Bool = false
	var menuButton: UIButtonAnimation! = nil
	
	@IBOutlet weak var currentTemp: UILabel!
	
	var weatherMaps: [WeatherModel] = [WeatherModel]()
	var currentWeatherMap: WeatherModel?
	
	var weatherDays: [WeatherDay]? {
		didSet {
			//pickerView.reloadData()
		}
	}
	
	@IBOutlet weak var scrollView: UIScrollView!
	var refreshControl: UIRefreshControl!
	
	
	@IBOutlet weak var condition: UILabel!
	@IBOutlet weak var iconView: UIImageView!
	
	@IBOutlet weak var tableView: WeatherTableView!
	
	@IBOutlet weak var openWeatherMapLink: UIButton!
	
	var tempUnit: Weather.TemperatureUnits = .Celsius
	
	var download: URLSessionDataTask?
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		
		updateWeather()
		
		(UIApplication.shared.delegate as! AppDelegate).currentViewController = self
		
		self.refreshControl = UIRefreshControl()
		let refreshView = UIView(frame: CGRect(x: 0, y: 10, width: 0, height: 0))
		self.scrollView.addSubview(refreshView)
		refreshView.addSubview(refreshControl)
		refreshControl.addTarget(self, action: #selector(WeatherController.updateWeather), for: UIControlEvents.allEvents)
		
		//Picker view initialization
		//picker = AKPickerView(frame: pickerView.frame)
		
		//picker.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin]
		
		tableView.delegate = tableView
		tableView.dataSource = tableView
		
		let attrs: [String: Any] = [
			NSFontAttributeName : UIFont(name: "Verdana", size: 12)!,
			NSForegroundColorAttributeName : UIColor.primary,
			NSUnderlineStyleAttributeName : 1]
		let attributedString = NSAttributedString(string: "Open Weather Map", attributes: attrs)
		openWeatherMapLink.setAttributedTitle(attributedString, for: .normal)
		
		setColors()
    }
	
	func setColors() {
		cityLabel.textColor = UIColor.primary
		condition.textColor = UIColor.primary
		iconView.tintColor = UIColor.primary
		currentTemp.textColor = UIColor.primary
		
		self.view.backgroundColor = UIColor.secondary
		tableView.backgroundColor = UIColor.clear
		tableView.separatorColor = UIColor.primary
	}

	
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
	
	
	func updateWeather(){
		let urlString = "http://api.openweathermap.org/data/2.5/forecast?id=3875070&APPID=e4a17bba974001fa1f0138645553c559"
		let url = URL(string: urlString)
		
		//Creates an alert telling to please wait for the update
		addOverlay()
		
		var failed = false
		
		download = URLSession.shared.dataTask(with:url!) { (data, response, error) in
			if error != nil {
				failed = true
				//self.removeOverlay()
				//print(error as! URLError)
				let urlError = error as! URLError
				
				DispatchQueue.main.async {
					self.dismiss(animated: true, completion:  ({
						self.displayError(error: urlError)
						}))
				}
				
			} else {
				do {
					self.weatherMaps.removeAll()
					
					let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
					
					let list = parsedData["list"] as! NSArray
					
					for index in 0..<list.count {
						let element = list[index] as! Dictionary<String, Any>
						let timeStamp = element["dt"] as! Int
						let main = element["main"] as! Dictionary<String, Any>
						let temp = main["temp"] as! Double
						let pressure = main["pressure"] as! Double
						let humidity = main["humidity"] as! Double
						
						let weatherArray = element["weather"] as! NSArray
						let weather = weatherArray[0] as! Dictionary<String, Any>
						
						let weatherMain = weather["main"] as! String
						let weatherDescription = weather["description"] as! String
						let weatherIconID = weather["icon"] as! String
						
						let clouds = (element["clouds"] as! Dictionary<String, Any>)["all"] as! Float
						
						let wind = element["wind"] as! Dictionary<String, Any>
						let windSpeed = wind["speed"] as! Double
						let windDirection = wind["deg"] as! Float
						
						let rain = element["rain"] as? Dictionary<String, Any>
						let rainAmount = rain?["3h"] as? Double
						
						let weatherModel = WeatherModel(time: timeStamp, temp: temp, pressure: pressure, humidity: humidity, weatherMain: weatherMain, weatherDescription: weatherDescription, iconID: weatherIconID, clouds: clouds, windSpeed: windSpeed, windDir: windDirection, rain: rainAmount)
						
						//print(weatherModel.description())
						
						self.weatherMaps.append(weatherModel)
					}
					
				} catch let error as NSError {
					print(error)
				}
			}
			let days = self.weatherMaps.createWeatherDays()
			self.weatherDays = days
			
			//Remove the overlay since the weather has been updated
			if !failed {
				self.removeOverlay()
			}
			self.updateDisplay()
			}
		self.download?.resume()
	}
	
	func updateDisplay() {
		
		DispatchQueue.main.async {
			if self.weatherMaps.count <= 0 {
				return
			}
			self.currentWeatherMap = self.weatherMaps[0]
			self.condition.text = self.currentWeatherMap?.weatherDescription
			self.iconView.image = self.currentWeatherMap?.icon?.withRenderingMode(.alwaysTemplate)
			//iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
			if let temperature = self.currentWeatherMap?.temp(unit: self.tempUnit) {
				let convertedTemp = Double(round(temperature*10)/10)
				
				self.currentTemp.text = "\(convertedTemp)°"
				
				switch self.tempUnit {
				case .Celsius:
					self.currentTemp.text = self.currentTemp.text?.appending("C")
				case .Fahrenheit:
					self.currentTemp.text = self.currentTemp.text?.appending("F")
				case .Kelvin:
					self.currentTemp.text = self.currentTemp.text?.appending("K")
					
				}
			} else {
				self.currentTemp.text = "--"
			}
			
			self.tableView.weatherDays = self.weatherDays
		}
	}
	
	func addOverlay() {
		let alert = UIAlertController(title: "Updating", message: "Please Wait", preferredStyle: .alert)
		//xalert.view.tintColor = UIColor.viraviraGoldColor
		
		let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = .white
		activityIndicator.startAnimating()
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
			self.download?.cancel()
			self.refreshControl.endRefreshing()
		}))
		
		alert.view.addSubview(activityIndicator)
		DispatchQueue.main.async {
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func displayError(error: URLError) {
		let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
		DispatchQueue.main.async {
			self.refreshControl.endRefreshing()
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func removeOverlay() {
		DispatchQueue.main.async {
			self.refreshControl.endRefreshing()
			self.dismiss(animated: true, completion: nil)
		}
	}
	@IBAction func openLink(_ sender: Any) {
		let url = URL(string: "https://openweathermap.org/")!
		if #available(iOS 10.0, *) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(url)
		}
	}
}

/*extension WeatherController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
	
}
*/

//
//  WeatherDay.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 6/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

class WeatherDay {
	
	var weatherModels: [WeatherModel]
	
	init() {
		self.weatherModels = [WeatherModel]()
	}
	
	init(weatherModels: [WeatherModel]) {
		self.weatherModels = weatherModels
	}
	
	func peakTemp() -> Double {
		var peak: Double = 0
		for timeStamp in weatherModels {
			if timeStamp.temp(unit: .Kelvin) > peak {
				peak = timeStamp.temp(unit: .Kelvin)
			}
		}
		
		return peak
	}
	
	func day() -> String? {
		if weatherModels.count == 0 {
			return nil
		}
		return weatherModels[0].day()
		
	}
	
	func description() -> String {
		return "UTC Time from: \(weatherModels[0].time) to: \(weatherModels[weatherModels.count - 1].time)"
	}
}
//
//  WeatherDescriptionLabel.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 14/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class WeatherDescriptionLabel: UILabel {

	override var text: String? {
		didSet {
			self.sizeToFit()
			super.text = text
		}
	}
}
//
//  WeatherModel.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 5/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

class WeatherModel {
	var time: NSDate
	//This has to be in KELVIN ALWAYS
	private var temp: Double
	var pressure: Double
	var humidity: Double
	
	var weatherMain: String
	var weatherDescription: String
	var iconID: String
	var icon: UIImage? {
		return WeatherModel.icons[iconID]
	}
	
	//Clouds in percentage
	var clouds: Float
	var windSpeed: Double
	//Wind direction in degrees
	var windDir: Float
	
	//Amount of rain in the past 3 hours
	var rain: Double
	
	static let icons: [String : UIImage] = ["01d": #imageLiteral(resourceName: "01d"), "01n": #imageLiteral(resourceName: "01n"), "02d": #imageLiteral(resourceName: "02d"), "02n": #imageLiteral(resourceName: "02n"), "03d": #imageLiteral(resourceName: "03d"), "03n": #imageLiteral(resourceName: "03n"), "04d": #imageLiteral(resourceName: "04d"), "04n": #imageLiteral(resourceName: "04n"), "09d": #imageLiteral(resourceName: "09d"), "09n": #imageLiteral(resourceName: "09n"), "10d": #imageLiteral(resourceName: "10d"), "10n": #imageLiteral(resourceName: "10n"), "11d": #imageLiteral(resourceName: "11d"), "11n": #imageLiteral(resourceName: "11n"), "13d": #imageLiteral(resourceName: "13d"), "13n": #imageLiteral(resourceName: "13n"), "50d": #imageLiteral(resourceName: "50d"), "50n": #imageLiteral(resourceName: "50n")]
	
	init(time: Int, temp: Double, pressure: Double, humidity: Double, weatherMain: String, weatherDescription: String, iconID: String, clouds: Float, windSpeed: Double, windDir: Float, rain: Double?) {
		self.time = NSDate(timeIntervalSince1970: TimeInterval(time))
		self.temp = temp
		self.pressure = pressure
		self.humidity = humidity
		self.weatherMain = weatherMain
		self.weatherDescription = weatherDescription
		self.iconID = iconID
		
		self.clouds = clouds
		self.windSpeed = windSpeed
		self.windDir = windDir
		
		if let rainAmount = rain {
			self.rain = rainAmount
		} else {
			self.rain = 0
		}
	}
	
	func description() -> String {
		return "At \(time) the temperature will be at \(temp) degrees kelvin, \(pressure) hPa, \(humidity) % Humid. weather main: \(weatherMain), weather description: \(weatherDescription), iconID: \(iconID), clouds %: \(clouds), windSpeed: \(windSpeed), windDirection: \(windDir), rain int the last 3 hours: \(rain) mm."
	}
	
	func temp(unit: Weather.TemperatureUnits) -> Double{
		switch unit {
		case .Celsius:
			return temp - 273.15
			
		case .Kelvin:
			return temp
			
		case .Fahrenheit:
			return (9/5)*(temp - 273.15)+32
		}
	}
	
	func temp(unit: Weather.TemperatureUnits, roundToDecimal: Int) -> Double {
		var roundFactor = 1
		for _ in 0..<roundToDecimal {
			roundFactor *= 10
		}
		
		return Double(round(temp(unit: unit)*Double(roundFactor))/Double(roundFactor))
	}
	
	func day() -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE"
		
		return dateFormatter.string(from: time as Date)
		
	}
	
	func timeStamp() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH"
		
		return dateFormatter.string(from: time as Date)
	}
}

extension Array where Element:WeatherModel {
	func createWeatherDays() -> [WeatherDay] {
		var weatherDays = [WeatherDay]()
		var currentWeatherDay: WeatherDay?
		for weather in self {
			if currentWeatherDay == nil {
				currentWeatherDay = WeatherDay()
				currentWeatherDay?.weatherModels.append(weather)
				continue
			} else if currentWeatherDay?.day() == weather.day() {
				currentWeatherDay?.weatherModels.append(weather)
			} else if currentWeatherDay?.day() != weather.day() {
				weatherDays.append(currentWeatherDay!)
				currentWeatherDay = WeatherDay()
				currentWeatherDay?.weatherModels.append(weather)
			}
		}
		if currentWeatherDay != nil {
			weatherDays.append(currentWeatherDay!)
		}
		return weatherDays
	}
}

class Weather {
	enum TemperatureUnits {
		case Kelvin
		case Celsius
		case Fahrenheit
	}
}
//
//  WeatherTableView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class WeatherTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
	let cellIdentifier = "WeatherTableCell"
	
	/*let requiredInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
	
	override var separatorInset: UIEdgeInsets {
		didSet {
			print(separatorInset)
			if separatorInset != requiredInset {
				separatorInset = requiredInset
			}
		}
	}*/
	
	var weatherDays: [WeatherDay]? {
		didSet {
			self.reloadData()
		}
	}
	var viewController: WeatherController?
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let days = weatherDays {
			return days.count
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WeatherTableViewCell
		
		cell.dayTag.text = weatherDays?[indexPath.item].day()
		cell.collectionView.weatherDay = weatherDays![indexPath.item]
		cell.collectionView.delegate = cell.collectionView
		cell.collectionView.dataSource = cell.collectionView
		
		//tableView.separatorColor = UIColor.primary
		
		cell = setColor(for: cell)
		
		return cell
	}
	
	func setColor(for cell: WeatherTableViewCell) -> WeatherTableViewCell{
		cell.dayTag.textColor = UIColor.primary
		cell.collectionView.backgroundColor = UIColor.clear
		cell.backgroundColor = UIColor.clear
		
		return cell
	}
}
//
//  WeatherTableViewCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 9/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

	@IBOutlet weak var collectionView: WeatherCollectionView!
	@IBOutlet weak var dayTag: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//
//  WellnessHeaderView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 14/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit
import KVConstraintExtensionsMaster

protocol WellnessTableViewHeaderDelegate {
	func toggleSection(header: WellnessHeaderView, section: Int)
}

class WellnessHeaderView: UIView {
	
	
	
	var delegate: WellnessTableViewHeaderDelegate?
	var section: Int = 0
	
	let iconView = UIImageView()
	let titleLabel = UILabel()
	let arrowLabel = UILabel()
	
	let heightRatio: CGFloat = 0.8
	
	/*override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		
		
		
	//	self.translatesAutoresizingMaskIntoConstraints = false
		contentView.translatesAutoresizingMaskIntoConstraints = false
		iconView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		arrowLabel.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.applyTopAndBottomPinConstraint(toSuperview: 0)
		contentView.applyCenterYPinConstraint(toSuperview: 0)
		contentView.applyLeadingAndTrailingPinConstraint(toSuperview: 0)
		
		
		self.contentView.addSubview(iconView)
		self.contentView.addSubview(titleLabel)
		self.addSubview(arrowLabel)
		
		arrowLabel.textAlignment = .center
		
		
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(WellnessHeaderView.tapHeader(gestureRecognizer:))))
	}
	*/
	override init(frame: CGRect) {
		super.init(frame: frame)
		
	//	self.reuseIdentifier = "header"
		
		iconView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		arrowLabel.translatesAutoresizingMaskIntoConstraints = false
		
		
		self.addSubview(iconView)
		self.addSubview(titleLabel)
		self.addSubview(arrowLabel)
		
		arrowLabel.textAlignment = .center
		
		
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(WellnessHeaderView.tapHeader(gestureRecognizer:))))
		
	}
	
	override func layoutSubviews() {
		super.layoutIfNeeded()
		
	/*	let height = self.frame.height
		if #available(iOS 9.0, *) {
			if iconView.image != nil {
				iconView.widthAnchor.constraint(equalToConstant: height * heightRatio).isActive = true
			} else {
				iconView.widthAnchor.constraint(equalToConstant: 0).isActive = true
			}
		} else {
			// Fallback on earlier versions
		}
		if #available(iOS 9.0, *) {
			if iconView.image != nil {
				iconView.heightAnchor.constraint(equalToConstant: height * heightRatio).isActive = true
			} else {
				iconView.heightAnchor.constraint(equalToConstant: 0).isActive = true
			}
		} else {
			// Fallback on earlier versions
		}
		
		if #available(iOS 9.0, *) {
			arrowLabel.widthAnchor.constraint(equalToConstant: height * heightRatio).isActive = true
		} else {
			// Fallback on earlier versions
		}
		if #available(iOS 9.0, *) {
			arrowLabel.heightAnchor.constraint(equalToConstant: height * heightRatio).isActive = true
		} else {
			// Fallback on earlier versions
		}*/

		
		let views = [
			"iconView" : iconView,
			"titleLabel" : titleLabel,
			"arrowLabel" : arrowLabel
		]
		
		var metrics: [String: Any] = [:]
		if iconView.image != nil {
			metrics["imageWidth"] = self.frame.height * heightRatio
		} else {
			metrics["imageWidth"] = 0
		}
		
		self.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-8-[iconView(imageWidth)]-16-[titleLabel]-16-[arrowLabel]-8-|",
			options: [],
			metrics: metrics,
			views: views
		))
		
		self.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-[iconView]-|",
			options: [],
			metrics: nil,
			views: views
		))
		
		self.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-[titleLabel]-|",
			options: [],
			metrics: nil,
			views: views
		))
		
		self.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-[arrowLabel]-|",
			options: [],
			metrics: nil,
			views: views
		))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
		guard let cell = gestureRecognizer.view as? WellnessHeaderView else {return}
		delegate?.toggleSection(header: self, section: cell.section)
	}
	
	func setCollapsed(collapsed: Bool) {
		arrowLabel.rotate(toValue: collapsed ? 0.0 : (CGFloat.pi / 2))
	}
}
//
//  WellnessStruct.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 13/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

struct WellnessSection {
	var name: String!
	var icon: UIImage?
	var content: UIView!
	var collapsed: Bool!
	
	 init(name: String, icon: UIImage?, content: UIView, collapsed: Bool) {
		self.name = name
		self.icon = icon
		self.content = content
		self.collapsed = collapsed
		
		content.tag = ViewType.wellness.rawValue
	}
	
	init(name: String, icon: UIImage?, content: UIView) {
		self.init(name: name, icon: icon, content: content, collapsed: true)
	}
	
	init(name: String, content: UIView, collapsed: Bool) {
		self.init(name: name, icon: nil, content: content, collapsed: collapsed)
	}
	
	init(name: String, content: UIView) {
		self.init(name: name, icon: nil, content: content, collapsed: true)
	}
}
//
//  WellnessTableViewCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 18/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit
import KVConstraintExtensionsMaster

class WellnessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var content: UIView!
    
    
	var section: WellnessSection! {
		didSet {
			var sectionContent = section.content
			
			
			content.addSubview(sectionContent!)
			sectionContent = content.subviews[0]
			content.subviews[0].applyConstraintFitToSuperview()
			
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		setColors()
	}
	
	func setColors() {
		self.backgroundColor = UIColor.secondary
		self.contentView.backgroundColor = UIColor.clear
		self.content.backgroundColor = UIColor.clear
		
	}
	
}
//
//  WellnessViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 9/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit
import KVConstraintExtensionsMaster

class WellnessViewController: UIViewController {
	
//	MARK: - Outlets
	//@IBOutlet weak var tableView: UITableView!
	
    @IBOutlet weak var tableView: UITableView!
	
	
//	MARK: - Properties
	let estiamtedTableViewRowHeight: CGFloat = 100
	var headerHeight: CGFloat {
		return 66
	}
	
	var sections: [WellnessSection] = []
	
	var identifier: String = "cell"
	
	var labelFontSize: CGFloat {
		get {
			switch (self.view.traitCollection.horizontalSizeClass, self.view.traitCollection.verticalSizeClass) {
			case (.regular, .regular):
				return 24
			case (.compact, .compact):
				return 17
				
			default:
				return 17
			}
		}
	}
	
//	MARK: - System functions
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//Link the tableView to this class
		tableView.delegate = self
		tableView.dataSource = self
		//Set the tableview cells to use auto layout to determine height
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = estiamtedTableViewRowHeight
		
		tableView.separatorStyle = .none
		let cell = UINib(nibName: "WellnessTableViewCell", bundle: nil)
		tableView.register(cell, forCellReuseIdentifier: identifier)
		
		
		sections = sectionItems()
		setColors()
    }
	
//	MARK: - Setup
	
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
		tableView.backgroundColor = UIColor.secondary
		
	}
	
//	MARK: - Populating
	
	func sectionItems() -> [WellnessSection] {
		var sections = [WellnessSection]()
		let massage = massageView()
		sections.append(WellnessSection(name: "Massage", content: massage))
		let hotTub = hotTubView()
		sections.append(WellnessSection(name: "Hot Tubs", content: hotTub))
		
		return sections
	}
	
	func massageView() -> UIView {
		let massageView = Bundle.main.loadNibNamed("Massage", owner: MassageView(), options: nil)?[0] as! MassageView
		massageView.translatesAutoresizingMaskIntoConstraints = false
		return massageView
	}
	
	func hotTubView() -> UIView {
		let view = UIView()
		let label = UILabel()
		
		view.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.textColor = UIColor.primary
		label.textAlignment = .justified
		label.font = label.font.withSize(labelFontSize)
		view.addSubview(label)
		label.applyTopAndBottomPinConstraint(toSuperview: 16)
		label.applyCenterXPinConstraint(toSuperview: 0)
		label.numberOfLines = 0
		NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
		
		label.text = "We have 4 hot tubs in different spots of the hacienda. If you wish to use any of them, please let us know 6 hours in advance, so we can pre- pare it on time and you can enjoy it at the perfect temperature (40oC)."
		
		return view
	}
}

//MARK: -

extension WellnessViewController: UITableViewDelegate, UITableViewDataSource {
	//	MARK: - Table View Data source and Delegate
	func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].collapsed! ? 0 : 1
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let width = tableView.frame.width
		
		let header = WellnessHeaderView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: headerHeight)))
		
		
		
		header.iconView.image = sections[section].icon
		header.titleLabel.text = sections[section].name
		header.titleLabel.font = header.titleLabel.font.withSize(headerFontSize())
		header.arrowLabel.text = ">"
		
		
		header.backgroundColor = UIColor.tertiary
		header.iconView.backgroundColor = UIColor.clear
		header.iconView.image = header.iconView.image?.withRenderingMode(.alwaysTemplate)
		header.iconView.tintColor = UIColor.primary
		header.titleLabel.backgroundColor = UIColor.clear
		header.titleLabel.textColor = UIColor.primary
		header.arrowLabel.backgroundColor = UIColor.clear
		header.arrowLabel.textColor = UIColor.primary
		
		header.section = section
		header.delegate = self
		
		
		let separator = UIView()
		separator.translatesAutoresizingMaskIntoConstraints = false
		separator.backgroundColor = UIColor.primary
		header.addSubview(separator)
		separator.applyHeightConstraint(0.75)
		separator.applyEqualWidthPinConstrainToSuperview()
		separator.applyBottomPinConstraint(toSuperview: 0)
		
		return header
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = (UINib(nibName: "WellnessTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? WellnessTableViewCell) else {return UITableViewCell()}
		let item = sections[indexPath.section]
		
		cell.section = item
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return headerHeight
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func headerFontSize() -> CGFloat {
		switch (self.view.traitCollection.horizontalSizeClass, self.view.traitCollection.verticalSizeClass) {
		case(.regular, .regular):
			return 24
		case(.compact, .compact):
			return 21
			
		default:
			return 17
		}
	}
}

//MARK: -
extension WellnessViewController: WellnessTableViewHeaderDelegate {
//	MARK: - Table view collapsing delegate
	
	func toggleSection(header: WellnessHeaderView, section: Int) {
		let collapsed = !sections[section].collapsed
		
		sections[section].collapsed = collapsed
		header.setCollapsed(collapsed: collapsed)
		
		tableView.beginUpdates()
		let indexPaths = [IndexPath(row: 0, section: section)]
		if collapsed {
			tableView.deleteRows(at: indexPaths, with: .automatic)
		} else {
			tableView.insertRows(at: indexPaths, with: .automatic)
		}
		//tableView.reloadRows(at: indexPaths, with: .automatic)
		tableView.endUpdates()
	}
}


//MARK: - Custom view identifier enum
enum ViewType: Int {
	case defaultView = 0
	case wellness = 1
}
//
//  ViraVira_InfoTests.swift
//  ViraVira-InfoTests
//
//  Created by Jorge Paravicini on 6/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

/*import XCTest
@testable import ViraVira_Info

class ViraVira_InfoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
*/
