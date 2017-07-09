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
	
    @IBOutlet weak var welcomeTitle: UILabel!
	@IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var adventureTitle: UILabel!
	@IBOutlet weak var adventureLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collage: UIImageView!
	
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
		
		print(UIFont.printFonts())
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		
		(UIApplication.shared.delegate as! AppDelegate).currentViewController = self
		
		//Navbar setup end
		
		//NotificationCenter.default.addObserver(self, selector: #selector(HomeView.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
		
		//setTextSize()
	//	updateTextViewSize()
		
		setAttributes()
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
		welcomeTitle.textColor = UIColor.primary
		welcomeTitle.backgroundColor = UIColor.secondary
		welcomeLabel.textColor = UIColor.primary
		welcomeLabel.backgroundColor = UIColor.secondary
		adventureLabel.textColor = UIColor.primary
		imageView.backgroundColor = UIColor.secondary
		footer.backgroundColor = UIColor.secondary.withAlphaComponent(UIColor.transparency)
		viravira.textColor = UIColor.primary
		date.textColor = UIColor.primary
	}
	
	func setAttributes() {
		welcomeTitle.attributedText = NSAttributedString(string: welcomeTitle.text!, attributes: ViraViraFontAttributes.title)
		adventureTitle.attributedText = NSAttributedString(string: adventureTitle.text!, attributes: ViraViraFontAttributes.title)
		welcomeLabel.attributedText = NSAttributedString(string: welcomeLabel.text!, attributes: ViraViraFontAttributes.description)
		adventureLabel.attributedText = NSAttributedString(string: adventureLabel.text!, attributes: ViraViraFontAttributes.description)
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
		switch UIScreen.traits {
		case (.regular, .regular):
			print("r.r")
		case (.regular, .compact):
			print("r.c")
		case (.compact, .regular):
			print("c.r")
		case(.compact, .compact):
			print("c.c")
		default:
			print("wat")
		}
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
//  AFError.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// `AFError` is the error type returned by Alamofire. It encompasses a few different types of errors, each with
/// their own associated reasons.
///
/// - invalidURL:                  Returned when a `URLConvertible` type fails to create a valid `URL`.
/// - parameterEncodingFailed:     Returned when a parameter encoding object throws an error during the encoding process.
/// - multipartEncodingFailed:     Returned when some step in the multipart encoding process fails.
/// - responseValidationFailed:    Returned when a `validate()` call fails.
/// - responseSerializationFailed: Returned when a response serializer encounters an error in the serialization process.
public enum AFError: Error {
    /// The underlying reason the parameter encoding error occurred.
    ///
    /// - missingURL:                 The URL request did not have a URL to encode.
    /// - jsonEncodingFailed:         JSON serialization failed with an underlying system error during the
    ///                               encoding process.
    /// - propertyListEncodingFailed: Property list serialization failed with an underlying system error during
    ///                               encoding process.
    public enum ParameterEncodingFailureReason {
        case missingURL
        case jsonEncodingFailed(error: Error)
        case propertyListEncodingFailed(error: Error)
    }

    /// The underlying reason the multipart encoding error occurred.
    ///
    /// - bodyPartURLInvalid:                   The `fileURL` provided for reading an encodable body part isn't a
    ///                                         file URL.
    /// - bodyPartFilenameInvalid:              The filename of the `fileURL` provided has either an empty
    ///                                         `lastPathComponent` or `pathExtension.
    /// - bodyPartFileNotReachable:             The file at the `fileURL` provided was not reachable.
    /// - bodyPartFileNotReachableWithError:    Attempting to check the reachability of the `fileURL` provided threw
    ///                                         an error.
    /// - bodyPartFileIsDirectory:              The file at the `fileURL` provided is actually a directory.
    /// - bodyPartFileSizeNotAvailable:         The size of the file at the `fileURL` provided was not returned by
    ///                                         the system.
    /// - bodyPartFileSizeQueryFailedWithError: The attempt to find the size of the file at the `fileURL` provided
    ///                                         threw an error.
    /// - bodyPartInputStreamCreationFailed:    An `InputStream` could not be created for the provided `fileURL`.
    /// - outputStreamCreationFailed:           An `OutputStream` could not be created when attempting to write the
    ///                                         encoded data to disk.
    /// - outputStreamFileAlreadyExists:        The encoded body data could not be writtent disk because a file
    ///                                         already exists at the provided `fileURL`.
    /// - outputStreamURLInvalid:               The `fileURL` provided for writing the encoded body data to disk is
    ///                                         not a file URL.
    /// - outputStreamWriteFailed:              The attempt to write the encoded body data to disk failed with an
    ///                                         underlying error.
    /// - inputStreamReadFailed:                The attempt to read an encoded body part `InputStream` failed with
    ///                                         underlying system error.
    public enum MultipartEncodingFailureReason {
        case bodyPartURLInvalid(url: URL)
        case bodyPartFilenameInvalid(in: URL)
        case bodyPartFileNotReachable(at: URL)
        case bodyPartFileNotReachableWithError(atURL: URL, error: Error)
        case bodyPartFileIsDirectory(at: URL)
        case bodyPartFileSizeNotAvailable(at: URL)
        case bodyPartFileSizeQueryFailedWithError(forURL: URL, error: Error)
        case bodyPartInputStreamCreationFailed(for: URL)

        case outputStreamCreationFailed(for: URL)
        case outputStreamFileAlreadyExists(at: URL)
        case outputStreamURLInvalid(url: URL)
        case outputStreamWriteFailed(error: Error)

        case inputStreamReadFailed(error: Error)
    }

    /// The underlying reason the response validation error occurred.
    ///
    /// - dataFileNil:             The data file containing the server response did not exist.
    /// - dataFileReadFailed:      The data file containing the server response could not be read.
    /// - missingContentType:      The response did not contain a `Content-Type` and the `acceptableContentTypes`
    ///                            provided did not contain wildcard type.
    /// - unacceptableContentType: The response `Content-Type` did not match any type in the provided
    ///                            `acceptableContentTypes`.
    /// - unacceptableStatusCode:  The response status code was not acceptable.
    public enum ResponseValidationFailureReason {
        case dataFileNil
        case dataFileReadFailed(at: URL)
        case missingContentType(acceptableContentTypes: [String])
        case unacceptableContentType(acceptableContentTypes: [String], responseContentType: String)
        case unacceptableStatusCode(code: Int)
    }

    /// The underlying reason the response serialization error occurred.
    ///
    /// - inputDataNil:                    The server response contained no data.
    /// - inputDataNilOrZeroLength:        The server response contained no data or the data was zero length.
    /// - inputFileNil:                    The file containing the server response did not exist.
    /// - inputFileReadFailed:             The file containing the server response could not be read.
    /// - stringSerializationFailed:       String serialization failed using the provided `String.Encoding`.
    /// - jsonSerializationFailed:         JSON serialization failed with an underlying system error.
    /// - propertyListSerializationFailed: Property list serialization failed with an underlying system error.
    public enum ResponseSerializationFailureReason {
        case inputDataNil
        case inputDataNilOrZeroLength
        case inputFileNil
        case inputFileReadFailed(at: URL)
        case stringSerializationFailed(encoding: String.Encoding)
        case jsonSerializationFailed(error: Error)
        case propertyListSerializationFailed(error: Error)
    }

    case invalidURL(url: URLConvertible)
    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
    case multipartEncodingFailed(reason: MultipartEncodingFailureReason)
    case responseValidationFailed(reason: ResponseValidationFailureReason)
    case responseSerializationFailed(reason: ResponseSerializationFailureReason)
}

// MARK: - Adapt Error

struct AdaptError: Error {
    let error: Error
}

extension Error {
    var underlyingAdaptError: Error? { return (self as? AdaptError)?.error }
}

// MARK: - Error Booleans

extension AFError {
    /// Returns whether the AFError is an invalid URL error.
    public var isInvalidURLError: Bool {
        if case .invalidURL = self { return true }
        return false
    }

    /// Returns whether the AFError is a parameter encoding error. When `true`, the `underlyingError` property will
    /// contain the associated value.
    public var isParameterEncodingError: Bool {
        if case .parameterEncodingFailed = self { return true }
        return false
    }

    /// Returns whether the AFError is a multipart encoding error. When `true`, the `url` and `underlyingError` properties
    /// will contain the associated values.
    public var isMultipartEncodingError: Bool {
        if case .multipartEncodingFailed = self { return true }
        return false
    }

    /// Returns whether the `AFError` is a response validation error. When `true`, the `acceptableContentTypes`,
    /// `responseContentType`, and `responseCode` properties will contain the associated values.
    public var isResponseValidationError: Bool {
        if case .responseValidationFailed = self { return true }
        return false
    }

    /// Returns whether the `AFError` is a response serialization error. When `true`, the `failedStringEncoding` and
    /// `underlyingError` properties will contain the associated values.
    public var isResponseSerializationError: Bool {
        if case .responseSerializationFailed = self { return true }
        return false
    }
}

// MARK: - Convenience Properties

extension AFError {
    /// The `URLConvertible` associated with the error.
    public var urlConvertible: URLConvertible? {
        switch self {
        case .invalidURL(let url):
            return url
        default:
            return nil
        }
    }

    /// The `URL` associated with the error.
    public var url: URL? {
        switch self {
        case .multipartEncodingFailed(let reason):
            return reason.url
        default:
            return nil
        }
    }

    /// The `Error` returned by a system framework associated with a `.parameterEncodingFailed`,
    /// `.multipartEncodingFailed` or `.responseSerializationFailed` error.
    public var underlyingError: Error? {
        switch self {
        case .parameterEncodingFailed(let reason):
            return reason.underlyingError
        case .multipartEncodingFailed(let reason):
            return reason.underlyingError
        case .responseSerializationFailed(let reason):
            return reason.underlyingError
        default:
            return nil
        }
    }

    /// The acceptable `Content-Type`s of a `.responseValidationFailed` error.
    public var acceptableContentTypes: [String]? {
        switch self {
        case .responseValidationFailed(let reason):
            return reason.acceptableContentTypes
        default:
            return nil
        }
    }

    /// The response `Content-Type` of a `.responseValidationFailed` error.
    public var responseContentType: String? {
        switch self {
        case .responseValidationFailed(let reason):
            return reason.responseContentType
        default:
            return nil
        }
    }

    /// The response code of a `.responseValidationFailed` error.
    public var responseCode: Int? {
        switch self {
        case .responseValidationFailed(let reason):
            return reason.responseCode
        default:
            return nil
        }
    }

    /// The `String.Encoding` associated with a failed `.stringResponse()` call.
    public var failedStringEncoding: String.Encoding? {
        switch self {
        case .responseSerializationFailed(let reason):
            return reason.failedStringEncoding
        default:
            return nil
        }
    }
}

extension AFError.ParameterEncodingFailureReason {
    var underlyingError: Error? {
        switch self {
        case .jsonEncodingFailed(let error), .propertyListEncodingFailed(let error):
            return error
        default:
            return nil
        }
    }
}

extension AFError.MultipartEncodingFailureReason {
    var url: URL? {
        switch self {
        case .bodyPartURLInvalid(let url), .bodyPartFilenameInvalid(let url), .bodyPartFileNotReachable(let url),
             .bodyPartFileIsDirectory(let url), .bodyPartFileSizeNotAvailable(let url),
             .bodyPartInputStreamCreationFailed(let url), .outputStreamCreationFailed(let url),
             .outputStreamFileAlreadyExists(let url), .outputStreamURLInvalid(let url),
             .bodyPartFileNotReachableWithError(let url, _), .bodyPartFileSizeQueryFailedWithError(let url, _):
            return url
        default:
            return nil
        }
    }

    var underlyingError: Error? {
        switch self {
        case .bodyPartFileNotReachableWithError(_, let error), .bodyPartFileSizeQueryFailedWithError(_, let error),
             .outputStreamWriteFailed(let error), .inputStreamReadFailed(let error):
            return error
        default:
            return nil
        }
    }
}

extension AFError.ResponseValidationFailureReason {
    var acceptableContentTypes: [String]? {
        switch self {
        case .missingContentType(let types), .unacceptableContentType(let types, _):
            return types
        default:
            return nil
        }
    }

    var responseContentType: String? {
        switch self {
        case .unacceptableContentType(_, let responseType):
            return responseType
        default:
            return nil
        }
    }

    var responseCode: Int? {
        switch self {
        case .unacceptableStatusCode(let code):
            return code
        default:
            return nil
        }
    }
}

extension AFError.ResponseSerializationFailureReason {
    var failedStringEncoding: String.Encoding? {
        switch self {
        case .stringSerializationFailed(let encoding):
            return encoding
        default:
            return nil
        }
    }

    var underlyingError: Error? {
        switch self {
        case .jsonSerializationFailed(let error), .propertyListSerializationFailed(let error):
            return error
        default:
            return nil
        }
    }
}

// MARK: - Error Descriptions

extension AFError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "URL is not valid: \(url)"
        case .parameterEncodingFailed(let reason):
            return reason.localizedDescription
        case .multipartEncodingFailed(let reason):
            return reason.localizedDescription
        case .responseValidationFailed(let reason):
            return reason.localizedDescription
        case .responseSerializationFailed(let reason):
            return reason.localizedDescription
        }
    }
}

extension AFError.ParameterEncodingFailureReason {
    var localizedDescription: String {
        switch self {
        case .missingURL:
            return "URL request to encode was missing a URL"
        case .jsonEncodingFailed(let error):
            return "JSON could not be encoded because of error:\n\(error.localizedDescription)"
        case .propertyListEncodingFailed(let error):
            return "PropertyList could not be encoded because of error:\n\(error.localizedDescription)"
        }
    }
}

extension AFError.MultipartEncodingFailureReason {
    var localizedDescription: String {
        switch self {
        case .bodyPartURLInvalid(let url):
            return "The URL provided is not a file URL: \(url)"
        case .bodyPartFilenameInvalid(let url):
            return "The URL provided does not have a valid filename: \(url)"
        case .bodyPartFileNotReachable(let url):
            return "The URL provided is not reachable: \(url)"
        case .bodyPartFileNotReachableWithError(let url, let error):
            return (
                "The system returned an error while checking the provided URL for " +
                "reachability.\nURL: \(url)\nError: \(error)"
            )
        case .bodyPartFileIsDirectory(let url):
            return "The URL provided is a directory: \(url)"
        case .bodyPartFileSizeNotAvailable(let url):
            return "Could not fetch the file size from the provided URL: \(url)"
        case .bodyPartFileSizeQueryFailedWithError(let url, let error):
            return (
                "The system returned an error while attempting to fetch the file size from the " +
                "provided URL.\nURL: \(url)\nError: \(error)"
            )
        case .bodyPartInputStreamCreationFailed(let url):
            return "Failed to create an InputStream for the provided URL: \(url)"
        case .outputStreamCreationFailed(let url):
            return "Failed to create an OutputStream for URL: \(url)"
        case .outputStreamFileAlreadyExists(let url):
            return "A file already exists at the provided URL: \(url)"
        case .outputStreamURLInvalid(let url):
            return "The provided OutputStream URL is invalid: \(url)"
        case .outputStreamWriteFailed(let error):
            return "OutputStream write failed with error: \(error)"
        case .inputStreamReadFailed(let error):
            return "InputStream read failed with error: \(error)"
        }
    }
}

extension AFError.ResponseSerializationFailureReason {
    var localizedDescription: String {
        switch self {
        case .inputDataNil:
            return "Response could not be serialized, input data was nil."
        case .inputDataNilOrZeroLength:
            return "Response could not be serialized, input data was nil or zero length."
        case .inputFileNil:
            return "Response could not be serialized, input file was nil."
        case .inputFileReadFailed(let url):
            return "Response could not be serialized, input file could not be read: \(url)."
        case .stringSerializationFailed(let encoding):
            return "String could not be serialized with encoding: \(encoding)."
        case .jsonSerializationFailed(let error):
            return "JSON could not be serialized because of error:\n\(error.localizedDescription)"
        case .propertyListSerializationFailed(let error):
            return "PropertyList could not be serialized because of error:\n\(error.localizedDescription)"
        }
    }
}

extension AFError.ResponseValidationFailureReason {
    var localizedDescription: String {
        switch self {
        case .dataFileNil:
            return "Response could not be validated, data file was nil."
        case .dataFileReadFailed(let url):
            return "Response could not be validated, data file could not be read: \(url)."
        case .missingContentType(let types):
            return (
                "Response Content-Type was missing and acceptable content types " +
                "(\(types.joined(separator: ","))) do not match \"*/*\"."
            )
        case .unacceptableContentType(let acceptableTypes, let responseType):
            return (
                "Response Content-Type \"\(responseType)\" does not match any acceptable types: " +
                "\(acceptableTypes.joined(separator: ","))."
            )
        case .unacceptableStatusCode(let code):
            return "Response status code was unacceptable: \(code)."
        }
    }
}
//
//  Alamofire.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// Types adopting the `URLConvertible` protocol can be used to construct URLs, which are then used to construct
/// URL requests.
public protocol URLConvertible {
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    func asURL() throws -> URL
}

extension String: URLConvertible {
    /// Returns a URL if `self` represents a valid URL string that conforms to RFC 2396 or throws an `AFError`.
    ///
    /// - throws: An `AFError.invalidURL` if `self` is not a valid URL string.
    ///
    /// - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw AFError.invalidURL(url: self) }
        return url
    }
}

extension URL: URLConvertible {
    /// Returns self.
    public func asURL() throws -> URL { return self }
}

extension URLComponents: URLConvertible {
    /// Returns a URL if `url` is not nil, otherise throws an `Error`.
    ///
    /// - throws: An `AFError.invalidURL` if `url` is `nil`.
    ///
    /// - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = url else { throw AFError.invalidURL(url: self) }
        return url
    }
}

// MARK: -

/// Types adopting the `URLRequestConvertible` protocol can be used to construct URL requests.
public protocol URLRequestConvertible {
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    /// The URL request.
    public var urlRequest: URLRequest? { return try? asURLRequest() }
}

extension URLRequest: URLRequestConvertible {
    /// Returns a URL request or throws if an `Error` was encountered.
    public func asURLRequest() throws -> URLRequest { return self }
}

// MARK: -

extension URLRequest {
    /// Creates an instance with the specified `method`, `urlString` and `headers`.
    ///
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The new `URLRequest` instance.
    public init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil) throws {
        let url = try url.asURL()

        self.init(url: url)

        httpMethod = method.rawValue

        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }

    func adapt(using adapter: RequestAdapter?) throws -> URLRequest {
        guard let adapter = adapter else { return self }
        return try adapter.adapt(self)
    }
}

// MARK: - Data Request

/// Creates a `DataRequest` using the default `SessionManager` to retrieve the contents of the specified `url`,
/// `method`, `parameters`, `encoding` and `headers`.
///
/// - parameter url:        The URL.
/// - parameter method:     The HTTP method. `.get` by default.
/// - parameter parameters: The parameters. `nil` by default.
/// - parameter encoding:   The parameter encoding. `URLEncoding.default` by default.
/// - parameter headers:    The HTTP headers. `nil` by default.
///
/// - returns: The created `DataRequest`.
@discardableResult
public func request(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil)
    -> DataRequest
{
    return SessionManager.default.request(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}

/// Creates a `DataRequest` using the default `SessionManager` to retrieve the contents of a URL based on the
/// specified `urlRequest`.
///
/// - parameter urlRequest: The URL request
///
/// - returns: The created `DataRequest`.
@discardableResult
public func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
    return SessionManager.default.request(urlRequest)
}

// MARK: - Download Request

// MARK: URL Request

/// Creates a `DownloadRequest` using the default `SessionManager` to retrieve the contents of the specified `url`,
/// `method`, `parameters`, `encoding`, `headers` and save them to the `destination`.
///
/// If `destination` is not specified, the contents will remain in the temporary location determined by the
/// underlying URL session.
///
/// - parameter url:         The URL.
/// - parameter method:      The HTTP method. `.get` by default.
/// - parameter parameters:  The parameters. `nil` by default.
/// - parameter encoding:    The parameter encoding. `URLEncoding.default` by default.
/// - parameter headers:     The HTTP headers. `nil` by default.
/// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
///
/// - returns: The created `DownloadRequest`.
@discardableResult
public func download(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    to destination: DownloadRequest.DownloadFileDestination? = nil)
    -> DownloadRequest
{
    return SessionManager.default.download(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers,
        to: destination
    )
}

/// Creates a `DownloadRequest` using the default `SessionManager` to retrieve the contents of a URL based on the
/// specified `urlRequest` and save them to the `destination`.
///
/// If `destination` is not specified, the contents will remain in the temporary location determined by the
/// underlying URL session.
///
/// - parameter urlRequest:  The URL request.
/// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
///
/// - returns: The created `DownloadRequest`.
@discardableResult
public func download(
    _ urlRequest: URLRequestConvertible,
    to destination: DownloadRequest.DownloadFileDestination? = nil)
    -> DownloadRequest
{
    return SessionManager.default.download(urlRequest, to: destination)
}

// MARK: Resume Data

/// Creates a `DownloadRequest` using the default `SessionManager` from the `resumeData` produced from a
/// previous request cancellation to retrieve the contents of the original request and save them to the `destination`.
///
/// If `destination` is not specified, the contents will remain in the temporary location determined by the
/// underlying URL session.
///
/// On the latest release of all the Apple platforms (iOS 10, macOS 10.12, tvOS 10, watchOS 3), `resumeData` is broken
/// on background URL session configurations. There's an underlying bug in the `resumeData` generation logic where the
/// data is written incorrectly and will always fail to resume the download. For more information about the bug and
/// possible workarounds, please refer to the following Stack Overflow post:
///
///    - http://stackoverflow.com/a/39347461/1342462
///
/// - parameter resumeData:  The resume data. This is an opaque data blob produced by `URLSessionDownloadTask`
///                          when a task is cancelled. See `URLSession -downloadTask(withResumeData:)` for additional
///                          information.
/// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
///
/// - returns: The created `DownloadRequest`.
@discardableResult
public func download(
    resumingWith resumeData: Data,
    to destination: DownloadRequest.DownloadFileDestination? = nil)
    -> DownloadRequest
{
    return SessionManager.default.download(resumingWith: resumeData, to: destination)
}

// MARK: - Upload Request

// MARK: File

/// Creates an `UploadRequest` using the default `SessionManager` from the specified `url`, `method` and `headers`
/// for uploading the `file`.
///
/// - parameter file:    The file to upload.
/// - parameter url:     The URL.
/// - parameter method:  The HTTP method. `.post` by default.
/// - parameter headers: The HTTP headers. `nil` by default.
///
/// - returns: The created `UploadRequest`.
@discardableResult
public func upload(
    _ fileURL: URL,
    to url: URLConvertible,
    method: HTTPMethod = .post,
    headers: HTTPHeaders? = nil)
    -> UploadRequest
{
    return SessionManager.default.upload(fileURL, to: url, method: method, headers: headers)
}

/// Creates a `UploadRequest` using the default `SessionManager` from the specified `urlRequest` for
/// uploading the `file`.
///
/// - parameter file:       The file to upload.
/// - parameter urlRequest: The URL request.
///
/// - returns: The created `UploadRequest`.
@discardableResult
public func upload(_ fileURL: URL, with urlRequest: URLRequestConvertible) -> UploadRequest {
    return SessionManager.default.upload(fileURL, with: urlRequest)
}

// MARK: Data

/// Creates an `UploadRequest` using the default `SessionManager` from the specified `url`, `method` and `headers`
/// for uploading the `data`.
///
/// - parameter data:    The data to upload.
/// - parameter url:     The URL.
/// - parameter method:  The HTTP method. `.post` by default.
/// - parameter headers: The HTTP headers. `nil` by default.
///
/// - returns: The created `UploadRequest`.
@discardableResult
public func upload(
    _ data: Data,
    to url: URLConvertible,
    method: HTTPMethod = .post,
    headers: HTTPHeaders? = nil)
    -> UploadRequest
{
    return SessionManager.default.upload(data, to: url, method: method, headers: headers)
}

/// Creates an `UploadRequest` using the default `SessionManager` from the specified `urlRequest` for
/// uploading the `data`.
///
/// - parameter data:       The data to upload.
/// - parameter urlRequest: The URL request.
///
/// - returns: The created `UploadRequest`.
@discardableResult
public func upload(_ data: Data, with urlRequest: URLRequestConvertible) -> UploadRequest {
    return SessionManager.default.upload(data, with: urlRequest)
}

// MARK: InputStream

/// Creates an `UploadRequest` using the default `SessionManager` from the specified `url`, `method` and `headers`
/// for uploading the `stream`.
///
/// - parameter stream:  The stream to upload.
/// - parameter url:     The URL.
/// - parameter method:  The HTTP method. `.post` by default.
/// - parameter headers: The HTTP headers. `nil` by default.
///
/// - returns: The created `UploadRequest`.
@discardableResult
public func upload(
    _ stream: InputStream,
    to url: URLConvertible,
    method: HTTPMethod = .post,
    headers: HTTPHeaders? = nil)
    -> UploadRequest
{
    return SessionManager.default.upload(stream, to: url, method: method, headers: headers)
}

/// Creates an `UploadRequest` using the default `SessionManager` from the specified `urlRequest` for
/// uploading the `stream`.
///
/// - parameter urlRequest: The URL request.
/// - parameter stream:     The stream to upload.
///
/// - returns: The created `UploadRequest`.
@discardableResult
public func upload(_ stream: InputStream, with urlRequest: URLRequestConvertible) -> UploadRequest {
    return SessionManager.default.upload(stream, with: urlRequest)
}

// MARK: MultipartFormData

/// Encodes `multipartFormData` using `encodingMemoryThreshold` with the default `SessionManager` and calls
/// `encodingCompletion` with new `UploadRequest` using the `url`, `method` and `headers`.
///
/// It is important to understand the memory implications of uploading `MultipartFormData`. If the cummulative
/// payload is small, encoding the data in-memory and directly uploading to a server is the by far the most
/// efficient approach. However, if the payload is too large, encoding the data in-memory could cause your app to
/// be terminated. Larger payloads must first be written to disk using input and output streams to keep the memory
/// footprint low, then the data can be uploaded as a stream from the resulting file. Streaming from disk MUST be
/// used for larger payloads such as video content.
///
/// The `encodingMemoryThreshold` parameter allows Alamofire to automatically determine whether to encode in-memory
/// or stream from disk. If the content length of the `MultipartFormData` is below the `encodingMemoryThreshold`,
/// encoding takes place in-memory. If the content length exceeds the threshold, the data is streamed to disk
/// during the encoding process. Then the result is uploaded as data or as a stream depending on which encoding
/// technique was used.
///
/// - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
/// - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
///                                      `multipartFormDataEncodingMemoryThreshold` by default.
/// - parameter url:                     The URL.
/// - parameter method:                  The HTTP method. `.post` by default.
/// - parameter headers:                 The HTTP headers. `nil` by default.
/// - parameter encodingCompletion:      The closure called when the `MultipartFormData` encoding is complete.
public func upload(
    multipartFormData: @escaping (MultipartFormData) -> Void,
    usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
    to url: URLConvertible,
    method: HTTPMethod = .post,
    headers: HTTPHeaders? = nil,
    encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?)
{
    return SessionManager.default.upload(
        multipartFormData: multipartFormData,
        usingThreshold: encodingMemoryThreshold,
        to: url,
        method: method,
        headers: headers,
        encodingCompletion: encodingCompletion
    )
}

/// Encodes `multipartFormData` using `encodingMemoryThreshold` and the default `SessionManager` and
/// calls `encodingCompletion` with new `UploadRequest` using the `urlRequest`.
///
/// It is important to understand the memory implications of uploading `MultipartFormData`. If the cummulative
/// payload is small, encoding the data in-memory and directly uploading to a server is the by far the most
/// efficient approach. However, if the payload is too large, encoding the data in-memory could cause your app to
/// be terminated. Larger payloads must first be written to disk using input and output streams to keep the memory
/// footprint low, then the data can be uploaded as a stream from the resulting file. Streaming from disk MUST be
/// used for larger payloads such as video content.
///
/// The `encodingMemoryThreshold` parameter allows Alamofire to automatically determine whether to encode in-memory
/// or stream from disk. If the content length of the `MultipartFormData` is below the `encodingMemoryThreshold`,
/// encoding takes place in-memory. If the content length exceeds the threshold, the data is streamed to disk
/// during the encoding process. Then the result is uploaded as data or as a stream depending on which encoding
/// technique was used.
///
/// - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
/// - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
///                                      `multipartFormDataEncodingMemoryThreshold` by default.
/// - parameter urlRequest:              The URL request.
/// - parameter encodingCompletion:      The closure called when the `MultipartFormData` encoding is complete.
public func upload(
    multipartFormData: @escaping (MultipartFormData) -> Void,
    usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
    with urlRequest: URLRequestConvertible,
    encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?)
{
    return SessionManager.default.upload(
        multipartFormData: multipartFormData,
        usingThreshold: encodingMemoryThreshold,
        with: urlRequest,
        encodingCompletion: encodingCompletion
    )
}

#if !os(watchOS)

// MARK: - Stream Request

// MARK: Hostname and Port

/// Creates a `StreamRequest` using the default `SessionManager` for bidirectional streaming with the `hostname`
/// and `port`.
///
/// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
///
/// - parameter hostName: The hostname of the server to connect to.
/// - parameter port:     The port of the server to connect to.
///
/// - returns: The created `StreamRequest`.
@discardableResult
@available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
public func stream(withHostName hostName: String, port: Int) -> StreamRequest {
    return SessionManager.default.stream(withHostName: hostName, port: port)
}

// MARK: NetService

/// Creates a `StreamRequest` using the default `SessionManager` for bidirectional streaming with the `netService`.
///
/// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
///
/// - parameter netService: The net service used to identify the endpoint.
///
/// - returns: The created `StreamRequest`.
@discardableResult
@available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
public func stream(with netService: NetService) -> StreamRequest {
    return SessionManager.default.stream(with: netService)
}

#endif
//
//  DispatchQueue+Alamofire.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Dispatch
import Foundation

extension DispatchQueue {
    static var userInteractive: DispatchQueue { return DispatchQueue.global(qos: .userInteractive) }
    static var userInitiated: DispatchQueue { return DispatchQueue.global(qos: .userInitiated) }
    static var utility: DispatchQueue { return DispatchQueue.global(qos: .utility) }
    static var background: DispatchQueue { return DispatchQueue.global(qos: .background) }

    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: closure)
    }

    func syncResult<T>(_ closure: () -> T) -> T {
        var result: T!
        sync { result = closure() }
        return result
    }
}
//
//  MultipartFormData.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)
import MobileCoreServices
#elseif os(macOS)
import CoreServices
#endif

/// Constructs `multipart/form-data` for uploads within an HTTP or HTTPS body. There are currently two ways to encode
/// multipart form data. The first way is to encode the data directly in memory. This is very efficient, but can lead
/// to memory issues if the dataset is too large. The second way is designed for larger datasets and will write all the
/// data to a single file on disk with all the proper boundary segmentation. The second approach MUST be used for
/// larger datasets such as video content, otherwise your app may run out of memory when trying to encode the dataset.
///
/// For more information on `multipart/form-data` in general, please refer to the RFC-2388 and RFC-2045 specs as well
/// and the w3 form documentation.
///
/// - https://www.ietf.org/rfc/rfc2388.txt
/// - https://www.ietf.org/rfc/rfc2045.txt
/// - https://www.w3.org/TR/html401/interact/forms.html#h-17.13
open class MultipartFormData {

    // MARK: - Helper Types

    struct EncodingCharacters {
        static let crlf = "\r\n"
    }

    struct BoundaryGenerator {
        enum BoundaryType {
            case initial, encapsulated, final
        }

        static func randomBoundary() -> String {
            return String(format: "alamofire.boundary.%08x%08x", arc4random(), arc4random())
        }

        static func boundaryData(forBoundaryType boundaryType: BoundaryType, boundary: String) -> Data {
            let boundaryText: String

            switch boundaryType {
            case .initial:
                boundaryText = "--\(boundary)\(EncodingCharacters.crlf)"
            case .encapsulated:
                boundaryText = "\(EncodingCharacters.crlf)--\(boundary)\(EncodingCharacters.crlf)"
            case .final:
                boundaryText = "\(EncodingCharacters.crlf)--\(boundary)--\(EncodingCharacters.crlf)"
            }

            return boundaryText.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        }
    }

    class BodyPart {
        let headers: HTTPHeaders
        let bodyStream: InputStream
        let bodyContentLength: UInt64
        var hasInitialBoundary = false
        var hasFinalBoundary = false

        init(headers: HTTPHeaders, bodyStream: InputStream, bodyContentLength: UInt64) {
            self.headers = headers
            self.bodyStream = bodyStream
            self.bodyContentLength = bodyContentLength
        }
    }

    // MARK: - Properties

    /// The `Content-Type` header value containing the boundary used to generate the `multipart/form-data`.
    open var contentType: String { return "multipart/form-data; boundary=\(boundary)" }

    /// The content length of all body parts used to generate the `multipart/form-data` not including the boundaries.
    public var contentLength: UInt64 { return bodyParts.reduce(0) { $0 + $1.bodyContentLength } }

    /// The boundary used to separate the body parts in the encoded form data.
    public let boundary: String

    private var bodyParts: [BodyPart]
    private var bodyPartError: AFError?
    private let streamBufferSize: Int

    // MARK: - Lifecycle

    /// Creates a multipart form data object.
    ///
    /// - returns: The multipart form data object.
    public init() {
        self.boundary = BoundaryGenerator.randomBoundary()
        self.bodyParts = []

        ///
        /// The optimal read/write buffer size in bytes for input and output streams is 1024 (1KB). For more
        /// information, please refer to the following article:
        ///   - https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Streams/Articles/ReadingInputStreams.html
        ///

        self.streamBufferSize = 1024
    }

    // MARK: - Body Parts

    /// Creates a body part from the data and appends it to the multipart form data object.
    ///
    /// The body part data will be encoded using the following format:
    ///
    /// - `Content-Disposition: form-data; name=#{name}` (HTTP Header)
    /// - Encoded data
    /// - Multipart form boundary
    ///
    /// - parameter data: The data to encode into the multipart form data.
    /// - parameter name: The name to associate with the data in the `Content-Disposition` HTTP header.
    public func append(_ data: Data, withName name: String) {
        let headers = contentHeaders(withName: name)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)

        append(stream, withLength: length, headers: headers)
    }

    /// Creates a body part from the data and appends it to the multipart form data object.
    ///
    /// The body part data will be encoded using the following format:
    ///
    /// - `Content-Disposition: form-data; name=#{name}` (HTTP Header)
    /// - `Content-Type: #{generated mimeType}` (HTTP Header)
    /// - Encoded data
    /// - Multipart form boundary
    ///
    /// - parameter data:     The data to encode into the multipart form data.
    /// - parameter name:     The name to associate with the data in the `Content-Disposition` HTTP header.
    /// - parameter mimeType: The MIME type to associate with the data content type in the `Content-Type` HTTP header.
    public func append(_ data: Data, withName name: String, mimeType: String) {
        let headers = contentHeaders(withName: name, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)

        append(stream, withLength: length, headers: headers)
    }

    /// Creates a body part from the data and appends it to the multipart form data object.
    ///
    /// The body part data will be encoded using the following format:
    ///
    /// - `Content-Disposition: form-data; name=#{name}; filename=#{filename}` (HTTP Header)
    /// - `Content-Type: #{mimeType}` (HTTP Header)
    /// - Encoded file data
    /// - Multipart form boundary
    ///
    /// - parameter data:     The data to encode into the multipart form data.
    /// - parameter name:     The name to associate with the data in the `Content-Disposition` HTTP header.
    /// - parameter fileName: The filename to associate with the data in the `Content-Disposition` HTTP header.
    /// - parameter mimeType: The MIME type to associate with the data in the `Content-Type` HTTP header.
    public func append(_ data: Data, withName name: String, fileName: String, mimeType: String) {
        let headers = contentHeaders(withName: name, fileName: fileName, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)

        append(stream, withLength: length, headers: headers)
    }

    /// Creates a body part from the file and appends it to the multipart form data object.
    ///
    /// The body part data will be encoded using the following format:
    ///
    /// - `Content-Disposition: form-data; name=#{name}; filename=#{generated filename}` (HTTP Header)
    /// - `Content-Type: #{generated mimeType}` (HTTP Header)
    /// - Encoded file data
    /// - Multipart form boundary
    ///
    /// The filename in the `Content-Disposition` HTTP header is generated from the last path component of the
    /// `fileURL`. The `Content-Type` HTTP header MIME type is generated by mapping the `fileURL` extension to the
    /// system associated MIME type.
    ///
    /// - parameter fileURL: The URL of the file whose content will be encoded into the multipart form data.
    /// - parameter name:    The name to associate with the file content in the `Content-Disposition` HTTP header.
    public func append(_ fileURL: URL, withName name: String) {
        let fileName = fileURL.lastPathComponent
        let pathExtension = fileURL.pathExtension

        if !fileName.isEmpty && !pathExtension.isEmpty {
            let mime = mimeType(forPathExtension: pathExtension)
            append(fileURL, withName: name, fileName: fileName, mimeType: mime)
        } else {
            setBodyPartError(withReason: .bodyPartFilenameInvalid(in: fileURL))
        }
    }

    /// Creates a body part from the file and appends it to the multipart form data object.
    ///
    /// The body part data will be encoded using the following format:
    ///
    /// - Content-Disposition: form-data; name=#{name}; filename=#{filename} (HTTP Header)
    /// - Content-Type: #{mimeType} (HTTP Header)
    /// - Encoded file data
    /// - Multipart form boundary
    ///
    /// - parameter fileURL:  The URL of the file whose content will be encoded into the multipart form data.
    /// - parameter name:     The name to associate with the file content in the `Content-Disposition` HTTP header.
    /// - parameter fileName: The filename to associate with the file content in the `Content-Disposition` HTTP header.
    /// - parameter mimeType: The MIME type to associate with the file content in the `Content-Type` HTTP header.
    public func append(_ fileURL: URL, withName name: String, fileName: String, mimeType: String) {
        let headers = contentHeaders(withName: name, fileName: fileName, mimeType: mimeType)

        //============================================================
        //                 Check 1 - is file URL?
        //============================================================

        guard fileURL.isFileURL else {
            setBodyPartError(withReason: .bodyPartURLInvalid(url: fileURL))
            return
        }

        //============================================================
        //              Check 2 - is file URL reachable?
        //============================================================

        do {
            let isReachable = try fileURL.checkPromisedItemIsReachable()
            guard isReachable else {
                setBodyPartError(withReason: .bodyPartFileNotReachable(at: fileURL))
                return
            }
        } catch {
            setBodyPartError(withReason: .bodyPartFileNotReachableWithError(atURL: fileURL, error: error))
            return
        }

        //============================================================
        //            Check 3 - is file URL a directory?
        //============================================================

        var isDirectory: ObjCBool = false
        let path = fileURL.path

        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) && !isDirectory.boolValue else
        {
            setBodyPartError(withReason: .bodyPartFileIsDirectory(at: fileURL))
            return
        }

        //============================================================
        //          Check 4 - can the file size be extracted?
        //============================================================

        let bodyContentLength: UInt64

        do {
            guard let fileSize = try FileManager.default.attributesOfItem(atPath: path)[.size] as? NSNumber else {
                setBodyPartError(withReason: .bodyPartFileSizeNotAvailable(at: fileURL))
                return
            }

            bodyContentLength = fileSize.uint64Value
        }
        catch {
            setBodyPartError(withReason: .bodyPartFileSizeQueryFailedWithError(forURL: fileURL, error: error))
            return
        }

        //============================================================
        //       Check 5 - can a stream be created from file URL?
        //============================================================

        guard let stream = InputStream(url: fileURL) else {
            setBodyPartError(withReason: .bodyPartInputStreamCreationFailed(for: fileURL))
            return
        }

        append(stream, withLength: bodyContentLength, headers: headers)
    }

    /// Creates a body part from the stream and appends it to the multipart form data object.
    ///
    /// The body part data will be encoded using the following format:
    ///
    /// - `Content-Disposition: form-data; name=#{name}; filename=#{filename}` (HTTP Header)
    /// - `Content-Type: #{mimeType}` (HTTP Header)
    /// - Encoded stream data
    /// - Multipart form boundary
    ///
    /// - parameter stream:   The input stream to encode in the multipart form data.
    /// - parameter length:   The content length of the stream.
    /// - parameter name:     The name to associate with the stream content in the `Content-Disposition` HTTP header.
    /// - parameter fileName: The filename to associate with the stream content in the `Content-Disposition` HTTP header.
    /// - parameter mimeType: The MIME type to associate with the stream content in the `Content-Type` HTTP header.
    public func append(
        _ stream: InputStream,
        withLength length: UInt64,
        name: String,
        fileName: String,
        mimeType: String)
    {
        let headers = contentHeaders(withName: name, fileName: fileName, mimeType: mimeType)
        append(stream, withLength: length, headers: headers)
    }

    /// Creates a body part with the headers, stream and length and appends it to the multipart form data object.
    ///
    /// The body part data will be encoded using the following format:
    ///
    /// - HTTP headers
    /// - Encoded stream data
    /// - Multipart form boundary
    ///
    /// - parameter stream:  The input stream to encode in the multipart form data.
    /// - parameter length:  The content length of the stream.
    /// - parameter headers: The HTTP headers for the body part.
    public func append(_ stream: InputStream, withLength length: UInt64, headers: HTTPHeaders) {
        let bodyPart = BodyPart(headers: headers, bodyStream: stream, bodyContentLength: length)
        bodyParts.append(bodyPart)
    }

    // MARK: - Data Encoding

    /// Encodes all the appended body parts into a single `Data` value.
    ///
    /// It is important to note that this method will load all the appended body parts into memory all at the same
    /// time. This method should only be used when the encoded data will have a small memory footprint. For large data
    /// cases, please use the `writeEncodedDataToDisk(fileURL:completionHandler:)` method.
    ///
    /// - throws: An `AFError` if encoding encounters an error.
    ///
    /// - returns: The encoded `Data` if encoding is successful.
    public func encode() throws -> Data {
        if let bodyPartError = bodyPartError {
            throw bodyPartError
        }

        var encoded = Data()

        bodyParts.first?.hasInitialBoundary = true
        bodyParts.last?.hasFinalBoundary = true

        for bodyPart in bodyParts {
            let encodedData = try encode(bodyPart)
            encoded.append(encodedData)
        }

        return encoded
    }

    /// Writes the appended body parts into the given file URL.
    ///
    /// This process is facilitated by reading and writing with input and output streams, respectively. Thus,
    /// this approach is very memory efficient and should be used for large body part data.
    ///
    /// - parameter fileURL: The file URL to write the multipart form data into.
    ///
    /// - throws: An `AFError` if encoding encounters an error.
    public func writeEncodedData(to fileURL: URL) throws {
        if let bodyPartError = bodyPartError {
            throw bodyPartError
        }

        if FileManager.default.fileExists(atPath: fileURL.path) {
            throw AFError.multipartEncodingFailed(reason: .outputStreamFileAlreadyExists(at: fileURL))
        } else if !fileURL.isFileURL {
            throw AFError.multipartEncodingFailed(reason: .outputStreamURLInvalid(url: fileURL))
        }

        guard let outputStream = OutputStream(url: fileURL, append: false) else {
            throw AFError.multipartEncodingFailed(reason: .outputStreamCreationFailed(for: fileURL))
        }

        outputStream.open()
        defer { outputStream.close() }

        self.bodyParts.first?.hasInitialBoundary = true
        self.bodyParts.last?.hasFinalBoundary = true

        for bodyPart in self.bodyParts {
            try write(bodyPart, to: outputStream)
        }
    }

    // MARK: - Private - Body Part Encoding

    private func encode(_ bodyPart: BodyPart) throws -> Data {
        var encoded = Data()

        let initialData = bodyPart.hasInitialBoundary ? initialBoundaryData() : encapsulatedBoundaryData()
        encoded.append(initialData)

        let headerData = encodeHeaders(for: bodyPart)
        encoded.append(headerData)

        let bodyStreamData = try encodeBodyStream(for: bodyPart)
        encoded.append(bodyStreamData)

        if bodyPart.hasFinalBoundary {
            encoded.append(finalBoundaryData())
        }

        return encoded
    }

    private func encodeHeaders(for bodyPart: BodyPart) -> Data {
        var headerText = ""

        for (key, value) in bodyPart.headers {
            headerText += "\(key): \(value)\(EncodingCharacters.crlf)"
        }
        headerText += EncodingCharacters.crlf

        return headerText.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }

    private func encodeBodyStream(for bodyPart: BodyPart) throws -> Data {
        let inputStream = bodyPart.bodyStream
        inputStream.open()
        defer { inputStream.close() }

        var encoded = Data()

        while inputStream.hasBytesAvailable {
            var buffer = [UInt8](repeating: 0, count: streamBufferSize)
            let bytesRead = inputStream.read(&buffer, maxLength: streamBufferSize)

            if let error = inputStream.streamError {
                throw AFError.multipartEncodingFailed(reason: .inputStreamReadFailed(error: error))
            }

            if bytesRead > 0 {
                encoded.append(buffer, count: bytesRead)
            } else {
                break
            }
        }

        return encoded
    }

    // MARK: - Private - Writing Body Part to Output Stream

    private func write(_ bodyPart: BodyPart, to outputStream: OutputStream) throws {
        try writeInitialBoundaryData(for: bodyPart, to: outputStream)
        try writeHeaderData(for: bodyPart, to: outputStream)
        try writeBodyStream(for: bodyPart, to: outputStream)
        try writeFinalBoundaryData(for: bodyPart, to: outputStream)
    }

    private func writeInitialBoundaryData(for bodyPart: BodyPart, to outputStream: OutputStream) throws {
        let initialData = bodyPart.hasInitialBoundary ? initialBoundaryData() : encapsulatedBoundaryData()
        return try write(initialData, to: outputStream)
    }

    private func writeHeaderData(for bodyPart: BodyPart, to outputStream: OutputStream) throws {
        let headerData = encodeHeaders(for: bodyPart)
        return try write(headerData, to: outputStream)
    }

    private func writeBodyStream(for bodyPart: BodyPart, to outputStream: OutputStream) throws {
        let inputStream = bodyPart.bodyStream

        inputStream.open()
        defer { inputStream.close() }

        while inputStream.hasBytesAvailable {
            var buffer = [UInt8](repeating: 0, count: streamBufferSize)
            let bytesRead = inputStream.read(&buffer, maxLength: streamBufferSize)

            if let streamError = inputStream.streamError {
                throw AFError.multipartEncodingFailed(reason: .inputStreamReadFailed(error: streamError))
            }

            if bytesRead > 0 {
                if buffer.count != bytesRead {
                    buffer = Array(buffer[0..<bytesRead])
                }

                try write(&buffer, to: outputStream)
            } else {
                break
            }
        }
    }

    private func writeFinalBoundaryData(for bodyPart: BodyPart, to outputStream: OutputStream) throws {
        if bodyPart.hasFinalBoundary {
            return try write(finalBoundaryData(), to: outputStream)
        }
    }

    // MARK: - Private - Writing Buffered Data to Output Stream

    private func write(_ data: Data, to outputStream: OutputStream) throws {
        var buffer = [UInt8](repeating: 0, count: data.count)
        data.copyBytes(to: &buffer, count: data.count)

        return try write(&buffer, to: outputStream)
    }

    private func write(_ buffer: inout [UInt8], to outputStream: OutputStream) throws {
        var bytesToWrite = buffer.count

        while bytesToWrite > 0, outputStream.hasSpaceAvailable {
            let bytesWritten = outputStream.write(buffer, maxLength: bytesToWrite)

            if let error = outputStream.streamError {
                throw AFError.multipartEncodingFailed(reason: .outputStreamWriteFailed(error: error))
            }

            bytesToWrite -= bytesWritten

            if bytesToWrite > 0 {
                buffer = Array(buffer[bytesWritten..<buffer.count])
            }
        }
    }

    // MARK: - Private - Mime Type

    private func mimeType(forPathExtension pathExtension: String) -> String {
        if
            let id = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
            let contentType = UTTypeCopyPreferredTagWithClass(id, kUTTagClassMIMEType)?.takeRetainedValue()
        {
            return contentType as String
        }

        return "application/octet-stream"
    }

    // MARK: - Private - Content Headers

    private func contentHeaders(withName name: String, fileName: String? = nil, mimeType: String? = nil) -> [String: String] {
        var disposition = "form-data; name=\"\(name)\""
        if let fileName = fileName { disposition += "; filename=\"\(fileName)\"" }

        var headers = ["Content-Disposition": disposition]
        if let mimeType = mimeType { headers["Content-Type"] = mimeType }

        return headers
    }

    // MARK: - Private - Boundary Encoding

    private func initialBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .initial, boundary: boundary)
    }

    private func encapsulatedBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .encapsulated, boundary: boundary)
    }

    private func finalBoundaryData() -> Data {
        return BoundaryGenerator.boundaryData(forBoundaryType: .final, boundary: boundary)
    }

    // MARK: - Private - Errors

    private func setBodyPartError(withReason reason: AFError.MultipartEncodingFailureReason) {
        guard bodyPartError == nil else { return }
        bodyPartError = AFError.multipartEncodingFailed(reason: reason)
    }
}
//
//  NetworkReachabilityManager.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

#if !os(watchOS)

import Foundation
import SystemConfiguration

/// The `NetworkReachabilityManager` class listens for reachability changes of hosts and addresses for both WWAN and
/// WiFi network interfaces.
///
/// Reachability can be used to determine background information about why a network operation failed, or to retry
/// network requests when a connection is established. It should not be used to prevent a user from initiating a network
/// request, as it's possible that an initial request may be required to establish reachability.
open class NetworkReachabilityManager {
    /**
        Defines the various states of network reachability.

        - Unknown:         It is unknown whether the network is reachable.
        - NotReachable:    The network is not reachable.
        - ReachableOnWWAN: The network is reachable over the WWAN connection.
        - ReachableOnWiFi: The network is reachable over the WiFi connection.
    */


    /// Defines the various states of network reachability.
    ///
    /// - unknown:      It is unknown whether the network is reachable.
    /// - notReachable: The network is not reachable.
    /// - reachable:    The network is reachable.
    public enum NetworkReachabilityStatus {
        case unknown
        case notReachable
        case reachable(ConnectionType)
    }

    /// Defines the various connection types detected by reachability flags.
    ///
    /// - ethernetOrWiFi: The connection type is either over Ethernet or WiFi.
    /// - wwan:           The connection type is a WWAN connection.
    public enum ConnectionType {
        case ethernetOrWiFi
        case wwan
    }

    /// A closure executed when the network reachability status changes. The closure takes a single argument: the
    /// network reachability status.
    public typealias Listener = (NetworkReachabilityStatus) -> Void

    // MARK: - Properties

    /// Whether the network is currently reachable.
    open var isReachable: Bool { return isReachableOnWWAN || isReachableOnEthernetOrWiFi }

    /// Whether the network is currently reachable over the WWAN interface.
    open var isReachableOnWWAN: Bool { return networkReachabilityStatus == .reachable(.wwan) }

    /// Whether the network is currently reachable over Ethernet or WiFi interface.
    open var isReachableOnEthernetOrWiFi: Bool { return networkReachabilityStatus == .reachable(.ethernetOrWiFi) }

    /// The current network reachability status.
    open var networkReachabilityStatus: NetworkReachabilityStatus {
        guard let flags = self.flags else { return .unknown }
        return networkReachabilityStatusForFlags(flags)
    }

    /// The dispatch queue to execute the `listener` closure on.
    open var listenerQueue: DispatchQueue = DispatchQueue.main

    /// A closure executed when the network reachability status changes.
    open var listener: Listener?

    private var flags: SCNetworkReachabilityFlags? {
        var flags = SCNetworkReachabilityFlags()

        if SCNetworkReachabilityGetFlags(reachability, &flags) {
            return flags
        }

        return nil
    }

    private let reachability: SCNetworkReachability
    private var previousFlags: SCNetworkReachabilityFlags

    // MARK: - Initialization

    /// Creates a `NetworkReachabilityManager` instance with the specified host.
    ///
    /// - parameter host: The host used to evaluate network reachability.
    ///
    /// - returns: The new `NetworkReachabilityManager` instance.
    public convenience init?(host: String) {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else { return nil }
        self.init(reachability: reachability)
    }

    /// Creates a `NetworkReachabilityManager` instance that monitors the address 0.0.0.0.
    ///
    /// Reachability treats the 0.0.0.0 address as a special token that causes it to monitor the general routing
    /// status of the device, both IPv4 and IPv6.
    ///
    /// - returns: The new `NetworkReachabilityManager` instance.
    public convenience init?() {
        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)

        guard let reachability = withUnsafePointer(to: &address, { pointer in
            return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {
                return SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else { return nil }

        self.init(reachability: reachability)
    }

    private init(reachability: SCNetworkReachability) {
        self.reachability = reachability
        self.previousFlags = SCNetworkReachabilityFlags()
    }

    deinit {
        stopListening()
    }

    // MARK: - Listening

    /// Starts listening for changes in network reachability status.
    ///
    /// - returns: `true` if listening was started successfully, `false` otherwise.
    @discardableResult
    open func startListening() -> Bool {
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged.passUnretained(self).toOpaque()

        let callbackEnabled = SCNetworkReachabilitySetCallback(
            reachability,
            { (_, flags, info) in
                let reachability = Unmanaged<NetworkReachabilityManager>.fromOpaque(info!).takeUnretainedValue()
                reachability.notifyListener(flags)
            },
            &context
        )

        let queueEnabled = SCNetworkReachabilitySetDispatchQueue(reachability, listenerQueue)

        listenerQueue.async {
            self.previousFlags = SCNetworkReachabilityFlags()
            self.notifyListener(self.flags ?? SCNetworkReachabilityFlags())
        }

        return callbackEnabled && queueEnabled
    }

    /// Stops listening for changes in network reachability status.
    open func stopListening() {
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
    }

    // MARK: - Internal - Listener Notification

    func notifyListener(_ flags: SCNetworkReachabilityFlags) {
        guard previousFlags != flags else { return }
        previousFlags = flags

        listener?(networkReachabilityStatusForFlags(flags))
    }

    // MARK: - Internal - Network Reachability Status

    func networkReachabilityStatusForFlags(_ flags: SCNetworkReachabilityFlags) -> NetworkReachabilityStatus {
        guard flags.contains(.reachable) else { return .notReachable }

        var networkStatus: NetworkReachabilityStatus = .notReachable

        if !flags.contains(.connectionRequired) { networkStatus = .reachable(.ethernetOrWiFi) }

        if flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic) {
            if !flags.contains(.interventionRequired) { networkStatus = .reachable(.ethernetOrWiFi) }
        }

        #if os(iOS)
            if flags.contains(.isWWAN) { networkStatus = .reachable(.wwan) }
        #endif

        return networkStatus
    }
}

// MARK: -

extension NetworkReachabilityManager.NetworkReachabilityStatus: Equatable {}

/// Returns whether the two network reachability status values are equal.
///
/// - parameter lhs: The left-hand side value to compare.
/// - parameter rhs: The right-hand side value to compare.
///
/// - returns: `true` if the two values are equal, `false` otherwise.
public func ==(
    lhs: NetworkReachabilityManager.NetworkReachabilityStatus,
    rhs: NetworkReachabilityManager.NetworkReachabilityStatus)
    -> Bool
{
    switch (lhs, rhs) {
    case (.unknown, .unknown):
        return true
    case (.notReachable, .notReachable):
        return true
    case let (.reachable(lhsConnectionType), .reachable(rhsConnectionType)):
        return lhsConnectionType == rhsConnectionType
    default:
        return false
    }
}

#endif
//
//  Notifications.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

extension Notification.Name {
    /// Used as a namespace for all `URLSessionTask` related notifications.
    public struct Task {
        /// Posted when a `URLSessionTask` is resumed. The notification `object` contains the resumed `URLSessionTask`.
        public static let DidResume = Notification.Name(rawValue: "org.alamofire.notification.name.task.didResume")

        /// Posted when a `URLSessionTask` is suspended. The notification `object` contains the suspended `URLSessionTask`.
        public static let DidSuspend = Notification.Name(rawValue: "org.alamofire.notification.name.task.didSuspend")

        /// Posted when a `URLSessionTask` is cancelled. The notification `object` contains the cancelled `URLSessionTask`.
        public static let DidCancel = Notification.Name(rawValue: "org.alamofire.notification.name.task.didCancel")

        /// Posted when a `URLSessionTask` is completed. The notification `object` contains the completed `URLSessionTask`.
        public static let DidComplete = Notification.Name(rawValue: "org.alamofire.notification.name.task.didComplete")
    }
}

// MARK: -

extension Notification {
    /// Used as a namespace for all `Notification` user info dictionary keys.
    public struct Key {
        /// User info dictionary key representing the `URLSessionTask` associated with the notification.
        public static let Task = "org.alamofire.notification.key.task"
    }
}
//
//  ParameterEncoding.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// HTTP method definitions.
///
/// See https://tools.ietf.org/html/rfc7231#section-4.3
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

// MARK: -

/// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]

/// A type used to define how a set of parameters are applied to a `URLRequest`.
public protocol ParameterEncoding {
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest
}

// MARK: -

/// Creates a url-encoded query string to be set as or appended to any existing URL query string or set as the HTTP
/// body of the URL request. Whether the query string is set or appended to any existing URL query string or set as
/// the HTTP body depends on the destination of the encoding.
///
/// The `Content-Type` HTTP header field of an encoded request with HTTP body is set to
/// `application/x-www-form-urlencoded; charset=utf-8`. Since there is no published specification for how to encode
/// collection types, the convention of appending `[]` to the key for array values (`foo[]=1&foo[]=2`), and appending
/// the key surrounded by square brackets for nested dictionary values (`foo[bar]=baz`).
public struct URLEncoding: ParameterEncoding {

    // MARK: Helper Types

    /// Defines whether the url-encoded query string is applied to the existing query string or HTTP body of the
    /// resulting URL request.
    ///
    /// - methodDependent: Applies encoded query string result to existing query string for `GET`, `HEAD` and `DELETE`
    ///                    requests and sets as the HTTP body for requests with any other HTTP method.
    /// - queryString:     Sets or appends encoded query string result to existing query string.
    /// - httpBody:        Sets encoded query string result as the HTTP body of the URL request.
    public enum Destination {
        case methodDependent, queryString, httpBody
    }

    // MARK: Properties

    /// Returns a default `URLEncoding` instance.
    public static var `default`: URLEncoding { return URLEncoding() }

    /// Returns a `URLEncoding` instance with a `.methodDependent` destination.
    public static var methodDependent: URLEncoding { return URLEncoding() }

    /// Returns a `URLEncoding` instance with a `.queryString` destination.
    public static var queryString: URLEncoding { return URLEncoding(destination: .queryString) }

    /// Returns a `URLEncoding` instance with an `.httpBody` destination.
    public static var httpBody: URLEncoding { return URLEncoding(destination: .httpBody) }

    /// The destination defining where the encoded query string is to be applied to the URL request.
    public let destination: Destination

    // MARK: Initialization

    /// Creates a `URLEncoding` instance using the specified destination.
    ///
    /// - parameter destination: The destination defining where the encoded query string is to be applied.
    ///
    /// - returns: The new `URLEncoding` instance.
    public init(destination: Destination = .methodDependent) {
        self.destination = destination
    }

    // MARK: Encoding

    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `Error` if the encoding process encounters an error.
    ///
    /// - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

        if let method = HTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), encodesParametersInURL(with: method) {
            guard let url = urlRequest.url else {
                throw AFError.parameterEncodingFailed(reason: .missingURL)
            }

            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
        } else {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        }

        return urlRequest
    }

    /// Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
    ///
    /// - parameter key:   The key of the query component.
    /// - parameter value: The value of the query component.
    ///
    /// - returns: The percent-escaped, URL encoded query string components.
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }

        return components
    }

    /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - parameter string: The string to be percent-escaped.
    ///
    /// - returns: The percent-escaped string.
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        var escaped = ""

        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================

        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex

            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex

                let substring = string.substring(with: range)

                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring

                index = endIndex
            }
        }

        return escaped
    }

    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }

        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }

    private func encodesParametersInURL(with method: HTTPMethod) -> Bool {
        switch destination {
        case .queryString:
            return true
        case .httpBody:
            return false
        default:
            break
        }

        switch method {
        case .get, .head, .delete:
            return true
        default:
            return false
        }
    }
}

// MARK: -

/// Uses `JSONSerialization` to create a JSON representation of the parameters object, which is set as the body of the
/// request. The `Content-Type` HTTP header field of an encoded request is set to `application/json`.
public struct JSONEncoding: ParameterEncoding {

    // MARK: Properties

    /// Returns a `JSONEncoding` instance with default writing options.
    public static var `default`: JSONEncoding { return JSONEncoding() }

    /// Returns a `JSONEncoding` instance with `.prettyPrinted` writing options.
    public static var prettyPrinted: JSONEncoding { return JSONEncoding(options: .prettyPrinted) }

    /// The options for writing the parameters as JSON data.
    public let options: JSONSerialization.WritingOptions

    // MARK: Initialization

    /// Creates a `JSONEncoding` instance using the specified options.
    ///
    /// - parameter options: The options for writing the parameters as JSON data.
    ///
    /// - returns: The new `JSONEncoding` instance.
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }

    // MARK: Encoding

    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `Error` if the encoding process encounters an error.
    ///
    /// - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: options)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }

    /// Creates a URL request by encoding the JSON object and setting the resulting data on the HTTP body.
    ///
    /// - parameter urlRequest: The request to apply the JSON object to.
    /// - parameter jsonObject: The JSON object to apply to the request.
    ///
    /// - throws: An `Error` if the encoding process encounters an error.
    ///
    /// - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, withJSONObject jsonObject: Any? = nil) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let jsonObject = jsonObject else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }
}

// MARK: -

/// Uses `PropertyListSerialization` to create a plist representation of the parameters object, according to the
/// associated format and write options values, which is set as the body of the request. The `Content-Type` HTTP header
/// field of an encoded request is set to `application/x-plist`.
public struct PropertyListEncoding: ParameterEncoding {

    // MARK: Properties

    /// Returns a default `PropertyListEncoding` instance.
    public static var `default`: PropertyListEncoding { return PropertyListEncoding() }

    /// Returns a `PropertyListEncoding` instance with xml formatting and default writing options.
    public static var xml: PropertyListEncoding { return PropertyListEncoding(format: .xml) }

    /// Returns a `PropertyListEncoding` instance with binary formatting and default writing options.
    public static var binary: PropertyListEncoding { return PropertyListEncoding(format: .binary) }

    /// The property list serialization format.
    public let format: PropertyListSerialization.PropertyListFormat

    /// The options for writing the parameters as plist data.
    public let options: PropertyListSerialization.WriteOptions

    // MARK: Initialization

    /// Creates a `PropertyListEncoding` instance using the specified format and options.
    ///
    /// - parameter format:  The property list serialization format.
    /// - parameter options: The options for writing the parameters as plist data.
    ///
    /// - returns: The new `PropertyListEncoding` instance.
    public init(
        format: PropertyListSerialization.PropertyListFormat = .xml,
        options: PropertyListSerialization.WriteOptions = 0)
    {
        self.format = format
        self.options = options
    }

    // MARK: Encoding

    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `Error` if the encoding process encounters an error.
    ///
    /// - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try PropertyListSerialization.data(
                fromPropertyList: parameters,
                format: format,
                options: options
            )

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw AFError.parameterEncodingFailed(reason: .propertyListEncodingFailed(error: error))
        }

        return urlRequest
    }
}

// MARK: -

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
//
//  Request.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// A type that can inspect and optionally adapt a `URLRequest` in some manner if necessary.
public protocol RequestAdapter {
    /// Inspects and adapts the specified `URLRequest` in some manner if necessary and returns the result.
    ///
    /// - parameter urlRequest: The URL request to adapt.
    ///
    /// - throws: An `Error` if the adaptation encounters an error.
    ///
    /// - returns: The adapted `URLRequest`.
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest
}

// MARK: -

/// A closure executed when the `RequestRetrier` determines whether a `Request` should be retried or not.
public typealias RequestRetryCompletion = (_ shouldRetry: Bool, _ timeDelay: TimeInterval) -> Void

/// A type that determines whether a request should be retried after being executed by the specified session manager
/// and encountering an error.
public protocol RequestRetrier {
    /// Determines whether the `Request` should be retried by calling the `completion` closure.
    ///
    /// This operation is fully asychronous. Any amount of time can be taken to determine whether the request needs
    /// to be retried. The one requirement is that the completion closure is called to ensure the request is properly
    /// cleaned up after.
    ///
    /// - parameter manager:    The session manager the request was executed on.
    /// - parameter request:    The request that failed due to the encountered error.
    /// - parameter error:      The error encountered when executing the request.
    /// - parameter completion: The completion closure to be executed when retry decision has been determined.
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion)
}

// MARK: -

protocol TaskConvertible {
    func task(session: URLSession, adapter: RequestAdapter?, queue: DispatchQueue) throws -> URLSessionTask
}

/// A dictionary of headers to apply to a `URLRequest`.
public typealias HTTPHeaders = [String: String]

// MARK: -

/// Responsible for sending a request and receiving the response and associated data from the server, as well as
/// managing its underlying `URLSessionTask`.
open class Request {

    // MARK: Helper Types

    /// A closure executed when monitoring upload or download progress of a request.
    public typealias ProgressHandler = (Progress) -> Void

    enum RequestTask {
        case data(TaskConvertible?, URLSessionTask?)
        case download(TaskConvertible?, URLSessionTask?)
        case upload(TaskConvertible?, URLSessionTask?)
        case stream(TaskConvertible?, URLSessionTask?)
    }

    // MARK: Properties

    /// The delegate for the underlying task.
    open internal(set) var delegate: TaskDelegate {
        get {
            taskDelegateLock.lock() ; defer { taskDelegateLock.unlock() }
            return taskDelegate
        }
        set {
            taskDelegateLock.lock() ; defer { taskDelegateLock.unlock() }
            taskDelegate = newValue
        }
    }

    /// The underlying task.
    open var task: URLSessionTask? { return delegate.task }

    /// The session belonging to the underlying task.
    open let session: URLSession

    /// The request sent or to be sent to the server.
    open var request: URLRequest? { return task?.originalRequest }

    /// The response received from the server, if any.
    open var response: HTTPURLResponse? { return task?.response as? HTTPURLResponse }

    /// The number of times the request has been retried.
    open internal(set) var retryCount: UInt = 0

    let originalTask: TaskConvertible?

    var startTime: CFAbsoluteTime?
    var endTime: CFAbsoluteTime?

    var validations: [() -> Void] = []

    private var taskDelegate: TaskDelegate
    private var taskDelegateLock = NSLock()

    // MARK: Lifecycle

    init(session: URLSession, requestTask: RequestTask, error: Error? = nil) {
        self.session = session

        switch requestTask {
        case .data(let originalTask, let task):
            taskDelegate = DataTaskDelegate(task: task)
            self.originalTask = originalTask
        case .download(let originalTask, let task):
            taskDelegate = DownloadTaskDelegate(task: task)
            self.originalTask = originalTask
        case .upload(let originalTask, let task):
            taskDelegate = UploadTaskDelegate(task: task)
            self.originalTask = originalTask
        case .stream(let originalTask, let task):
            taskDelegate = TaskDelegate(task: task)
            self.originalTask = originalTask
        }

        delegate.error = error
        delegate.queue.addOperation { self.endTime = CFAbsoluteTimeGetCurrent() }
    }

    // MARK: Authentication

    /// Associates an HTTP Basic credential with the request.
    ///
    /// - parameter user:        The user.
    /// - parameter password:    The password.
    /// - parameter persistence: The URL credential persistence. `.ForSession` by default.
    ///
    /// - returns: The request.
    @discardableResult
    open func authenticate(
        user: String,
        password: String,
        persistence: URLCredential.Persistence = .forSession)
        -> Self
    {
        let credential = URLCredential(user: user, password: password, persistence: persistence)
        return authenticate(usingCredential: credential)
    }

    /// Associates a specified credential with the request.
    ///
    /// - parameter credential: The credential.
    ///
    /// - returns: The request.
    @discardableResult
    open func authenticate(usingCredential credential: URLCredential) -> Self {
        delegate.credential = credential
        return self
    }

    /// Returns a base64 encoded basic authentication credential as an authorization header tuple.
    ///
    /// - parameter user:     The user.
    /// - parameter password: The password.
    ///
    /// - returns: A tuple with Authorization header and credential value if encoding succeeds, `nil` otherwise.
    open static func authorizationHeader(user: String, password: String) -> (key: String, value: String)? {
        guard let data = "\(user):\(password)".data(using: .utf8) else { return nil }

        let credential = data.base64EncodedString(options: [])

        return (key: "Authorization", value: "Basic \(credential)")
    }

    // MARK: State

    /// Resumes the request.
    open func resume() {
        guard let task = task else { delegate.queue.isSuspended = false ; return }

        if startTime == nil { startTime = CFAbsoluteTimeGetCurrent() }

        task.resume()

        NotificationCenter.default.post(
            name: Notification.Name.Task.DidResume,
            object: self,
            userInfo: [Notification.Key.Task: task]
        )
    }

    /// Suspends the request.
    open func suspend() {
        guard let task = task else { return }

        task.suspend()

        NotificationCenter.default.post(
            name: Notification.Name.Task.DidSuspend,
            object: self,
            userInfo: [Notification.Key.Task: task]
        )
    }

    /// Cancels the request.
    open func cancel() {
        guard let task = task else { return }

        task.cancel()

        NotificationCenter.default.post(
            name: Notification.Name.Task.DidCancel,
            object: self,
            userInfo: [Notification.Key.Task: task]
        )
    }
}

// MARK: - CustomStringConvertible

extension Request: CustomStringConvertible {
    /// The textual representation used when written to an output stream, which includes the HTTP method and URL, as
    /// well as the response status code if a response has been received.
    open var description: String {
        var components: [String] = []

        if let HTTPMethod = request?.httpMethod {
            components.append(HTTPMethod)
        }

        if let urlString = request?.url?.absoluteString {
            components.append(urlString)
        }

        if let response = response {
            components.append("(\(response.statusCode))")
        }

        return components.joined(separator: " ")
    }
}

// MARK: - CustomDebugStringConvertible

extension Request: CustomDebugStringConvertible {
    /// The textual representation used when written to an output stream, in the form of a cURL command.
    open var debugDescription: String {
        return cURLRepresentation()
    }

    func cURLRepresentation() -> String {
        var components = ["$ curl -i"]

        guard let request = self.request,
              let url = request.url,
              let host = url.host
        else {
            return "$ curl command could not be created"
        }

        if let httpMethod = request.httpMethod, httpMethod != "GET" {
            components.append("-X \(httpMethod)")
        }

        if let credentialStorage = self.session.configuration.urlCredentialStorage {
            let protectionSpace = URLProtectionSpace(
                host: host,
                port: url.port ?? 0,
                protocol: url.scheme,
                realm: host,
                authenticationMethod: NSURLAuthenticationMethodHTTPBasic
            )

            if let credentials = credentialStorage.credentials(for: protectionSpace)?.values {
                for credential in credentials {
                    components.append("-u \(credential.user!):\(credential.password!)")
                }
            } else {
                if let credential = delegate.credential {
                    components.append("-u \(credential.user!):\(credential.password!)")
                }
            }
        }

        if session.configuration.httpShouldSetCookies {
            if
                let cookieStorage = session.configuration.httpCookieStorage,
                let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty
            {
                let string = cookies.reduce("") { $0 + "\($1.name)=\($1.value);" }
                components.append("-b \"\(string.substring(to: string.characters.index(before: string.endIndex)))\"")
            }
        }

        var headers: [AnyHashable: Any] = [:]

        if let additionalHeaders = session.configuration.httpAdditionalHeaders {
            for (field, value) in additionalHeaders where field != AnyHashable("Cookie") {
                headers[field] = value
            }
        }

        if let headerFields = request.allHTTPHeaderFields {
            for (field, value) in headerFields where field != "Cookie" {
                headers[field] = value
            }
        }

        for (field, value) in headers {
            components.append("-H \"\(field): \(value)\"")
        }

        if let httpBodyData = request.httpBody, let httpBody = String(data: httpBodyData, encoding: .utf8) {
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")

            components.append("-d \"\(escapedBody)\"")
        }

        components.append("\"\(url.absoluteString)\"")

        return components.joined(separator: " \\\n\t")
    }
}

// MARK: -

/// Specific type of `Request` that manages an underlying `URLSessionDataTask`.
open class DataRequest: Request {

    // MARK: Helper Types

    struct Requestable: TaskConvertible {
        let urlRequest: URLRequest

        func task(session: URLSession, adapter: RequestAdapter?, queue: DispatchQueue) throws -> URLSessionTask {
            do {
                let urlRequest = try self.urlRequest.adapt(using: adapter)
                return queue.syncResult { session.dataTask(with: urlRequest) }
            } catch {
                throw AdaptError(error: error)
            }
        }
    }

    // MARK: Properties

    /// The request sent or to be sent to the server.
    open override var request: URLRequest? {
        if let request = super.request { return request }
        if let requestable = originalTask as? Requestable { return requestable.urlRequest }

        return nil
    }

    /// The progress of fetching the response data from the server for the request.
    open var progress: Progress { return dataDelegate.progress }

    var dataDelegate: DataTaskDelegate { return delegate as! DataTaskDelegate }

    // MARK: Stream

    /// Sets a closure to be called periodically during the lifecycle of the request as data is read from the server.
    ///
    /// This closure returns the bytes most recently received from the server, not including data from previous calls.
    /// If this closure is set, data will only be available within this closure, and will not be saved elsewhere. It is
    /// also important to note that the server data in any `Response` object will be `nil`.
    ///
    /// - parameter closure: The code to be executed periodically during the lifecycle of the request.
    ///
    /// - returns: The request.
    @discardableResult
    open func stream(closure: ((Data) -> Void)? = nil) -> Self {
        dataDelegate.dataStream = closure
        return self
    }

    // MARK: Progress

    /// Sets a closure to be called periodically during the lifecycle of the `Request` as data is read from the server.
    ///
    /// - parameter queue:   The dispatch queue to execute the closure on.
    /// - parameter closure: The code to be executed periodically as data is read from the server.
    ///
    /// - returns: The request.
    @discardableResult
    open func downloadProgress(queue: DispatchQueue = DispatchQueue.main, closure: @escaping ProgressHandler) -> Self {
        dataDelegate.progressHandler = (closure, queue)
        return self
    }
}

// MARK: -

/// Specific type of `Request` that manages an underlying `URLSessionDownloadTask`.
open class DownloadRequest: Request {

    // MARK: Helper Types

    /// A collection of options to be executed prior to moving a downloaded file from the temporary URL to the
    /// destination URL.
    public struct DownloadOptions: OptionSet {
        /// Returns the raw bitmask value of the option and satisfies the `RawRepresentable` protocol.
        public let rawValue: UInt

        /// A `DownloadOptions` flag that creates intermediate directories for the destination URL if specified.
        public static let createIntermediateDirectories = DownloadOptions(rawValue: 1 << 0)

        /// A `DownloadOptions` flag that removes a previous file from the destination URL if specified.
        public static let removePreviousFile = DownloadOptions(rawValue: 1 << 1)

        /// Creates a `DownloadFileDestinationOptions` instance with the specified raw value.
        ///
        /// - parameter rawValue: The raw bitmask value for the option.
        ///
        /// - returns: A new log level instance.
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }

    /// A closure executed once a download request has successfully completed in order to determine where to move the
    /// temporary file written to during the download process. The closure takes two arguments: the temporary file URL
    /// and the URL response, and returns a two arguments: the file URL where the temporary file should be moved and
    /// the options defining how the file should be moved.
    public typealias DownloadFileDestination = (
        _ temporaryURL: URL,
        _ response: HTTPURLResponse)
        -> (destinationURL: URL, options: DownloadOptions)

    enum Downloadable: TaskConvertible {
        case request(URLRequest)
        case resumeData(Data)

        func task(session: URLSession, adapter: RequestAdapter?, queue: DispatchQueue) throws -> URLSessionTask {
            do {
                let task: URLSessionTask

                switch self {
                case let .request(urlRequest):
                    let urlRequest = try urlRequest.adapt(using: adapter)
                    task = queue.syncResult { session.downloadTask(with: urlRequest) }
                case let .resumeData(resumeData):
                    task = queue.syncResult { session.downloadTask(withResumeData: resumeData) }
                }

                return task
            } catch {
                throw AdaptError(error: error)
            }
        }
    }

    // MARK: Properties

    /// The request sent or to be sent to the server.
    open override var request: URLRequest? {
        if let request = super.request { return request }

        if let downloadable = originalTask as? Downloadable, case let .request(urlRequest) = downloadable {
            return urlRequest
        }

        return nil
    }

    /// The resume data of the underlying download task if available after a failure.
    open var resumeData: Data? { return downloadDelegate.resumeData }

    /// The progress of downloading the response data from the server for the request.
    open var progress: Progress { return downloadDelegate.progress }

    var downloadDelegate: DownloadTaskDelegate { return delegate as! DownloadTaskDelegate }

    // MARK: State

    /// Cancels the request.
    open override func cancel() {
        downloadDelegate.downloadTask.cancel { self.downloadDelegate.resumeData = $0 }

        NotificationCenter.default.post(
            name: Notification.Name.Task.DidCancel,
            object: self,
            userInfo: [Notification.Key.Task: task as Any]
        )
    }

    // MARK: Progress

    /// Sets a closure to be called periodically during the lifecycle of the `Request` as data is read from the server.
    ///
    /// - parameter queue:   The dispatch queue to execute the closure on.
    /// - parameter closure: The code to be executed periodically as data is read from the server.
    ///
    /// - returns: The request.
    @discardableResult
    open func downloadProgress(queue: DispatchQueue = DispatchQueue.main, closure: @escaping ProgressHandler) -> Self {
        downloadDelegate.progressHandler = (closure, queue)
        return self
    }

    // MARK: Destination

    /// Creates a download file destination closure which uses the default file manager to move the temporary file to a
    /// file URL in the first available directory with the specified search path directory and search path domain mask.
    ///
    /// - parameter directory: The search path directory. `.DocumentDirectory` by default.
    /// - parameter domain:    The search path domain mask. `.UserDomainMask` by default.
    ///
    /// - returns: A download file destination closure.
    open class func suggestedDownloadDestination(
        for directory: FileManager.SearchPathDirectory = .documentDirectory,
        in domain: FileManager.SearchPathDomainMask = .userDomainMask)
        -> DownloadFileDestination
    {
        return { temporaryURL, response in
            let directoryURLs = FileManager.default.urls(for: directory, in: domain)

            if !directoryURLs.isEmpty {
                return (directoryURLs[0].appendingPathComponent(response.suggestedFilename!), [])
            }

            return (temporaryURL, [])
        }
    }
}

// MARK: -

/// Specific type of `Request` that manages an underlying `URLSessionUploadTask`.
open class UploadRequest: DataRequest {

    // MARK: Helper Types

    enum Uploadable: TaskConvertible {
        case data(Data, URLRequest)
        case file(URL, URLRequest)
        case stream(InputStream, URLRequest)

        func task(session: URLSession, adapter: RequestAdapter?, queue: DispatchQueue) throws -> URLSessionTask {
            do {
                let task: URLSessionTask

                switch self {
                case let .data(data, urlRequest):
                    let urlRequest = try urlRequest.adapt(using: adapter)
                    task = queue.syncResult { session.uploadTask(with: urlRequest, from: data) }
                case let .file(url, urlRequest):
                    let urlRequest = try urlRequest.adapt(using: adapter)
                    task = queue.syncResult { session.uploadTask(with: urlRequest, fromFile: url) }
                case let .stream(_, urlRequest):
                    let urlRequest = try urlRequest.adapt(using: adapter)
                    task = queue.syncResult { session.uploadTask(withStreamedRequest: urlRequest) }
                }

                return task
            } catch {
                throw AdaptError(error: error)
            }
        }
    }

    // MARK: Properties

    /// The request sent or to be sent to the server.
    open override var request: URLRequest? {
        if let request = super.request { return request }

        guard let uploadable = originalTask as? Uploadable else { return nil }

        switch uploadable {
        case .data(_, let urlRequest), .file(_, let urlRequest), .stream(_, let urlRequest):
            return urlRequest
        }
    }

    /// The progress of uploading the payload to the server for the upload request.
    open var uploadProgress: Progress { return uploadDelegate.uploadProgress }

    var uploadDelegate: UploadTaskDelegate { return delegate as! UploadTaskDelegate }

    // MARK: Upload Progress

    /// Sets a closure to be called periodically during the lifecycle of the `UploadRequest` as data is sent to
    /// the server.
    ///
    /// After the data is sent to the server, the `progress(queue:closure:)` APIs can be used to monitor the progress
    /// of data being read from the server.
    ///
    /// - parameter queue:   The dispatch queue to execute the closure on.
    /// - parameter closure: The code to be executed periodically as data is sent to the server.
    ///
    /// - returns: The request.
    @discardableResult
    open func uploadProgress(queue: DispatchQueue = DispatchQueue.main, closure: @escaping ProgressHandler) -> Self {
        uploadDelegate.uploadProgressHandler = (closure, queue)
        return self
    }
}

// MARK: -

#if !os(watchOS)

/// Specific type of `Request` that manages an underlying `URLSessionStreamTask`.
@available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
open class StreamRequest: Request {
    enum Streamable: TaskConvertible {
        case stream(hostName: String, port: Int)
        case netService(NetService)

        func task(session: URLSession, adapter: RequestAdapter?, queue: DispatchQueue) throws -> URLSessionTask {
            let task: URLSessionTask

            switch self {
            case let .stream(hostName, port):
                task = queue.syncResult { session.streamTask(withHostName: hostName, port: port) }
            case let .netService(netService):
                task = queue.syncResult { session.streamTask(with: netService) }
            }

            return task
        }
    }
}

#endif
//
//  Response.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// Used to store all data associated with an non-serialized response of a data or upload request.
public struct DefaultDataResponse {
    /// The URL request sent to the server.
    public let request: URLRequest?

    /// The server's response to the URL request.
    public let response: HTTPURLResponse?

    /// The data returned by the server.
    public let data: Data?

    /// The error encountered while executing or validating the request.
    public let error: Error?

    /// The timeline of the complete lifecycle of the request.
    public let timeline: Timeline

    var _metrics: AnyObject?

    init(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?, timeline: Timeline = Timeline()) {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
        self.timeline = timeline
    }
}

// MARK: -

/// Used to store all data associated with a serialized response of a data or upload request.
public struct DataResponse<Value> {
    /// The URL request sent to the server.
    public let request: URLRequest?

    /// The server's response to the URL request.
    public let response: HTTPURLResponse?

    /// The data returned by the server.
    public let data: Data?

    /// The result of response serialization.
    public let result: Result<Value>

    /// The timeline of the complete lifecycle of the request.
    public let timeline: Timeline

    var _metrics: AnyObject?

    /// Creates a `DataResponse` instance with the specified parameters derived from response serialization.
    ///
    /// - parameter request:  The URL request sent to the server.
    /// - parameter response: The server's response to the URL request.
    /// - parameter data:     The data returned by the server.
    /// - parameter result:   The result of response serialization.
    /// - parameter timeline: The timeline of the complete lifecycle of the `Request`. Defaults to `Timeline()`.
    ///
    /// - returns: The new `DataResponse` instance.
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        result: Result<Value>,
        timeline: Timeline = Timeline())
    {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
        self.timeline = timeline
    }
}

// MARK: -

extension DataResponse: CustomStringConvertible, CustomDebugStringConvertible {
    /// The textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure.
    public var description: String {
        return result.debugDescription
    }

    /// The debug textual representation used when written to an output stream, which includes the URL request, the URL
    /// response, the server data, the response serialization result and the timeline.
    public var debugDescription: String {
        var output: [String] = []

        output.append(request != nil ? "[Request]: \(request!)" : "[Request]: nil")
        output.append(response != nil ? "[Response]: \(response!)" : "[Response]: nil")
        output.append("[Data]: \(data?.count ?? 0) bytes")
        output.append("[Result]: \(result.debugDescription)")
        output.append("[Timeline]: \(timeline.debugDescription)")

        return output.joined(separator: "\n")
    }
}

// MARK: -

/// Used to store all data associated with an non-serialized response of a download request.
public struct DefaultDownloadResponse {
    /// The URL request sent to the server.
    public let request: URLRequest?

    /// The server's response to the URL request.
    public let response: HTTPURLResponse?

    /// The temporary destination URL of the data returned from the server.
    public let temporaryURL: URL?

    /// The final destination URL of the data returned from the server if it was moved.
    public let destinationURL: URL?

    /// The resume data generated if the request was cancelled.
    public let resumeData: Data?

    /// The error encountered while executing or validating the request.
    public let error: Error?

    /// The timeline of the complete lifecycle of the request.
    public let timeline: Timeline

    var _metrics: AnyObject?

    init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        temporaryURL: URL?,
        destinationURL: URL?,
        resumeData: Data?,
        error: Error?,
        timeline: Timeline = Timeline())
    {
        self.request = request
        self.response = response
        self.temporaryURL = temporaryURL
        self.destinationURL = destinationURL
        self.resumeData = resumeData
        self.error = error
        self.timeline = timeline
    }
}

// MARK: -

/// Used to store all data associated with a serialized response of a download request.
public struct DownloadResponse<Value> {
    /// The URL request sent to the server.
    public let request: URLRequest?

    /// The server's response to the URL request.
    public let response: HTTPURLResponse?

    /// The temporary destination URL of the data returned from the server.
    public let temporaryURL: URL?

    /// The final destination URL of the data returned from the server if it was moved.
    public let destinationURL: URL?

    /// The resume data generated if the request was cancelled.
    public let resumeData: Data?

    /// The result of response serialization.
    public let result: Result<Value>

    /// The timeline of the complete lifecycle of the request.
    public let timeline: Timeline

    var _metrics: AnyObject?

    /// Creates a `DownloadResponse` instance with the specified parameters derived from response serialization.
    ///
    /// - parameter request:        The URL request sent to the server.
    /// - parameter response:       The server's response to the URL request.
    /// - parameter temporaryURL:   The temporary destination URL of the data returned from the server.
    /// - parameter destinationURL: The final destination URL of the data returned from the server if it was moved.
    /// - parameter resumeData:     The resume data generated if the request was cancelled.
    /// - parameter result:         The result of response serialization.
    /// - parameter timeline:       The timeline of the complete lifecycle of the `Request`. Defaults to `Timeline()`.
    ///
    /// - returns: The new `DownloadResponse` instance.
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        temporaryURL: URL?,
        destinationURL: URL?,
        resumeData: Data?,
        result: Result<Value>,
        timeline: Timeline = Timeline())
    {
        self.request = request
        self.response = response
        self.temporaryURL = temporaryURL
        self.destinationURL = destinationURL
        self.resumeData = resumeData
        self.result = result
        self.timeline = timeline
    }
}

// MARK: -

extension DownloadResponse: CustomStringConvertible, CustomDebugStringConvertible {
    /// The textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure.
    public var description: String {
        return result.debugDescription
    }

    /// The debug textual representation used when written to an output stream, which includes the URL request, the URL
    /// response, the temporary and destination URLs, the resume data, the response serialization result and the
    /// timeline.
    public var debugDescription: String {
        var output: [String] = []

        output.append(request != nil ? "[Request]: \(request!)" : "[Request]: nil")
        output.append(response != nil ? "[Response]: \(response!)" : "[Response]: nil")
        output.append("[TemporaryURL]: \(temporaryURL?.path ?? "nil")")
        output.append("[DestinationURL]: \(destinationURL?.path ?? "nil")")
        output.append("[ResumeData]: \(resumeData?.count ?? 0) bytes")
        output.append("[Result]: \(result.debugDescription)")
        output.append("[Timeline]: \(timeline.debugDescription)")

        return output.joined(separator: "\n")
    }
}

// MARK: -

protocol Response {
    /// The task metrics containing the request / response statistics.
    var _metrics: AnyObject? { get set }
    mutating func add(_ metrics: AnyObject?)
}

extension Response {
    mutating func add(_ metrics: AnyObject?) {
        #if !os(watchOS)
            guard #available(iOS 10.0, macOS 10.12, tvOS 10.0, *) else { return }
            guard let metrics = metrics as? URLSessionTaskMetrics else { return }

            _metrics = metrics
        #endif
    }
}

// MARK: -

@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DefaultDataResponse: Response {
#if !os(watchOS)
    /// The task metrics containing the request / response statistics.
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}

@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DataResponse: Response {
#if !os(watchOS)
    /// The task metrics containing the request / response statistics.
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}

@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DefaultDownloadResponse: Response {
#if !os(watchOS)
    /// The task metrics containing the request / response statistics.
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}

@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DownloadResponse: Response {
#if !os(watchOS)
    /// The task metrics containing the request / response statistics.
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}
//
//  ResponseSerialization.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// The type in which all data response serializers must conform to in order to serialize a response.
public protocol DataResponseSerializerProtocol {
    /// The type of serialized object to be created by this `DataResponseSerializerType`.
    associatedtype SerializedObject

    /// A closure used by response handlers that takes a request, response, data and error and returns a result.
    var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<SerializedObject> { get }
}

// MARK: -

/// A generic `DataResponseSerializerType` used to serialize a request, response, and data into a serialized object.
public struct DataResponseSerializer<Value>: DataResponseSerializerProtocol {
    /// The type of serialized object to be created by this `DataResponseSerializer`.
    public typealias SerializedObject = Value

    /// A closure used by response handlers that takes a request, response, data and error and returns a result.
    public var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<Value>

    /// Initializes the `ResponseSerializer` instance with the given serialize response closure.
    ///
    /// - parameter serializeResponse: The closure used to serialize the response.
    ///
    /// - returns: The new generic response serializer instance.
    public init(serializeResponse: @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<Value>) {
        self.serializeResponse = serializeResponse
    }
}

// MARK: -

/// The type in which all download response serializers must conform to in order to serialize a response.
public protocol DownloadResponseSerializerProtocol {
    /// The type of serialized object to be created by this `DownloadResponseSerializerType`.
    associatedtype SerializedObject

    /// A closure used by response handlers that takes a request, response, url and error and returns a result.
    var serializeResponse: (URLRequest?, HTTPURLResponse?, URL?, Error?) -> Result<SerializedObject> { get }
}

// MARK: -

/// A generic `DownloadResponseSerializerType` used to serialize a request, response, and data into a serialized object.
public struct DownloadResponseSerializer<Value>: DownloadResponseSerializerProtocol {
    /// The type of serialized object to be created by this `DownloadResponseSerializer`.
    public typealias SerializedObject = Value

    /// A closure used by response handlers that takes a request, response, url and error and returns a result.
    public var serializeResponse: (URLRequest?, HTTPURLResponse?, URL?, Error?) -> Result<Value>

    /// Initializes the `ResponseSerializer` instance with the given serialize response closure.
    ///
    /// - parameter serializeResponse: The closure used to serialize the response.
    ///
    /// - returns: The new generic response serializer instance.
    public init(serializeResponse: @escaping (URLRequest?, HTTPURLResponse?, URL?, Error?) -> Result<Value>) {
        self.serializeResponse = serializeResponse
    }
}

// MARK: - Timeline

extension Request {
    var timeline: Timeline {
        let requestCompletedTime = self.endTime ?? CFAbsoluteTimeGetCurrent()
        let initialResponseTime = self.delegate.initialResponseTime ?? requestCompletedTime

        return Timeline(
            requestStartTime: self.startTime ?? CFAbsoluteTimeGetCurrent(),
            initialResponseTime: initialResponseTime,
            requestCompletedTime: requestCompletedTime,
            serializationCompletedTime: CFAbsoluteTimeGetCurrent()
        )
    }
}

// MARK: - Default

extension DataRequest {
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func response(queue: DispatchQueue? = nil, completionHandler: @escaping (DefaultDataResponse) -> Void) -> Self {
        delegate.queue.addOperation {
            (queue ?? DispatchQueue.main).async {
                var dataResponse = DefaultDataResponse(
                    request: self.request,
                    response: self.response,
                    data: self.delegate.data,
                    error: self.delegate.error,
                    timeline: self.timeline
                )

                dataResponse.add(self.delegate.metrics)

                completionHandler(dataResponse)
            }
        }

        return self
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:              The queue on which the completion handler is dispatched.
    /// - parameter responseSerializer: The response serializer responsible for serializing the request, response,
    ///                                 and data.
    /// - parameter completionHandler:  The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func response<T: DataResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T,
        completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void)
        -> Self
    {
        delegate.queue.addOperation {
            let result = responseSerializer.serializeResponse(
                self.request,
                self.response,
                self.delegate.data,
                self.delegate.error
            )

            var dataResponse = DataResponse<T.SerializedObject>(
                request: self.request,
                response: self.response,
                data: self.delegate.data,
                result: result,
                timeline: self.timeline
            )

            dataResponse.add(self.delegate.metrics)

            (queue ?? DispatchQueue.main).async { completionHandler(dataResponse) }
        }

        return self
    }
}

extension DownloadRequest {
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func response(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DefaultDownloadResponse) -> Void)
        -> Self
    {
        delegate.queue.addOperation {
            (queue ?? DispatchQueue.main).async {
                var downloadResponse = DefaultDownloadResponse(
                    request: self.request,
                    response: self.response,
                    temporaryURL: self.downloadDelegate.temporaryURL,
                    destinationURL: self.downloadDelegate.destinationURL,
                    resumeData: self.downloadDelegate.resumeData,
                    error: self.downloadDelegate.error,
                    timeline: self.timeline
                )

                downloadResponse.add(self.delegate.metrics)

                completionHandler(downloadResponse)
            }
        }

        return self
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:              The queue on which the completion handler is dispatched.
    /// - parameter responseSerializer: The response serializer responsible for serializing the request, response,
    ///                                 and data contained in the destination url.
    /// - parameter completionHandler:  The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func response<T: DownloadResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T,
        completionHandler: @escaping (DownloadResponse<T.SerializedObject>) -> Void)
        -> Self
    {
        delegate.queue.addOperation {
            let result = responseSerializer.serializeResponse(
                self.request,
                self.response,
                self.downloadDelegate.fileURL,
                self.downloadDelegate.error
            )

            var downloadResponse = DownloadResponse<T.SerializedObject>(
                request: self.request,
                response: self.response,
                temporaryURL: self.downloadDelegate.temporaryURL,
                destinationURL: self.downloadDelegate.destinationURL,
                resumeData: self.downloadDelegate.resumeData,
                result: result,
                timeline: self.timeline
            )

            downloadResponse.add(self.delegate.metrics)

            (queue ?? DispatchQueue.main).async { completionHandler(downloadResponse) }
        }

        return self
    }
}

// MARK: - Data

extension Request {
    /// Returns a result data type that contains the response data as-is.
    ///
    /// - parameter response: The response from the server.
    /// - parameter data:     The data returned from the server.
    /// - parameter error:    The error already encountered if it exists.
    ///
    /// - returns: The result data type.
    public static func serializeResponseData(response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<Data> {
        guard error == nil else { return .failure(error!) }

        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(Data()) }

        guard let validData = data else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
        }

        return .success(validData)
    }
}

extension DataRequest {
    /// Creates a response serializer that returns the associated data as-is.
    ///
    /// - returns: A data response serializer.
    public static func dataResponseSerializer() -> DataResponseSerializer<Data> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseData(response: response, data: data, error: error)
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseData(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<Data>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.dataResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    /// Creates a response serializer that returns the associated data as-is.
    ///
    /// - returns: A data response serializer.
    public static func dataResponseSerializer() -> DownloadResponseSerializer<Data> {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }

            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }

            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseData(response: response, data: data, error: error)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseData(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DownloadResponse<Data>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.dataResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}

// MARK: - String

extension Request {
    /// Returns a result string type initialized from the response data with the specified string encoding.
    ///
    /// - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server
    ///                       response, falling back to the default HTTP default character set, ISO-8859-1.
    /// - parameter response: The response from the server.
    /// - parameter data:     The data returned from the server.
    /// - parameter error:    The error already encountered if it exists.
    ///
    /// - returns: The result data type.
    public static func serializeResponseString(
        encoding: String.Encoding?,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<String>
    {
        guard error == nil else { return .failure(error!) }

        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success("") }

        guard let validData = data else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
        }

        var convertedEncoding = encoding

        if let encodingName = response?.textEncodingName as CFString!, convertedEncoding == nil {
            convertedEncoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(
                CFStringConvertIANACharSetNameToEncoding(encodingName))
            )
        }

        let actualEncoding = convertedEncoding ?? String.Encoding.isoLatin1

        if let string = String(data: validData, encoding: actualEncoding) {
            return .success(string)
        } else {
            return .failure(AFError.responseSerializationFailed(reason: .stringSerializationFailed(encoding: actualEncoding)))
        }
    }
}

extension DataRequest {
    /// Creates a response serializer that returns a result string type initialized from the response data with
    /// the specified string encoding.
    ///
    /// - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server
    ///                       response, falling back to the default HTTP default character set, ISO-8859-1.
    ///
    /// - returns: A string response serializer.
    public static func stringResponseSerializer(encoding: String.Encoding? = nil) -> DataResponseSerializer<String> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseString(encoding: encoding, response: response, data: data, error: error)
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter encoding:          The string encoding. If `nil`, the string encoding will be determined from the
    ///                                server response, falling back to the default HTTP default character set,
    ///                                ISO-8859-1.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseString(
        queue: DispatchQueue? = nil,
        encoding: String.Encoding? = nil,
        completionHandler: @escaping (DataResponse<String>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.stringResponseSerializer(encoding: encoding),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    /// Creates a response serializer that returns a result string type initialized from the response data with
    /// the specified string encoding.
    ///
    /// - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server
    ///                       response, falling back to the default HTTP default character set, ISO-8859-1.
    ///
    /// - returns: A string response serializer.
    public static func stringResponseSerializer(encoding: String.Encoding? = nil) -> DownloadResponseSerializer<String> {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }

            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }

            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseString(encoding: encoding, response: response, data: data, error: error)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter encoding:          The string encoding. If `nil`, the string encoding will be determined from the
    ///                                server response, falling back to the default HTTP default character set,
    ///                                ISO-8859-1.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseString(
        queue: DispatchQueue? = nil,
        encoding: String.Encoding? = nil,
        completionHandler: @escaping (DownloadResponse<String>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.stringResponseSerializer(encoding: encoding),
            completionHandler: completionHandler
        )
    }
}

// MARK: - JSON

extension Request {
    /// Returns a JSON object contained in a result type constructed from the response data using `JSONSerialization`
    /// with the specified reading options.
    ///
    /// - parameter options:  The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter response: The response from the server.
    /// - parameter data:     The data returned from the server.
    /// - parameter error:    The error already encountered if it exists.
    ///
    /// - returns: The result data type.
    public static func serializeResponseJSON(
        options: JSONSerialization.ReadingOptions,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<Any>
    {
        guard error == nil else { return .failure(error!) }

        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(NSNull()) }

        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }

        do {
            let json = try JSONSerialization.jsonObject(with: validData, options: options)
            return .success(json)
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

extension DataRequest {
    /// Creates a response serializer that returns a JSON object result type constructed from the response data using
    /// `JSONSerialization` with the specified reading options.
    ///
    /// - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
    ///
    /// - returns: A JSON object response serializer.
    public static func jsonResponseSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DataResponseSerializer<Any>
    {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseJSON(options: options, response: response, data: data, error: error)
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.jsonResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    /// Creates a response serializer that returns a JSON object result type constructed from the response data using
    /// `JSONSerialization` with the specified reading options.
    ///
    /// - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
    ///
    /// - returns: A JSON object response serializer.
    public static func jsonResponseSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DownloadResponseSerializer<Any>
    {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }

            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }

            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseJSON(options: options, response: response, data: data, error: error)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DownloadResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.jsonResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

// MARK: - Property List

extension Request {
    /// Returns a plist object contained in a result type constructed from the response data using
    /// `PropertyListSerialization` with the specified reading options.
    ///
    /// - parameter options:  The property list reading options. Defaults to `[]`.
    /// - parameter response: The response from the server.
    /// - parameter data:     The data returned from the server.
    /// - parameter error:    The error already encountered if it exists.
    ///
    /// - returns: The result data type.
    public static func serializeResponsePropertyList(
        options: PropertyListSerialization.ReadOptions,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<Any>
    {
        guard error == nil else { return .failure(error!) }

        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(NSNull()) }

        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }

        do {
            let plist = try PropertyListSerialization.propertyList(from: validData, options: options, format: nil)
            return .success(plist)
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .propertyListSerializationFailed(error: error)))
        }
    }
}

extension DataRequest {
    /// Creates a response serializer that returns an object constructed from the response data using
    /// `PropertyListSerialization` with the specified reading options.
    ///
    /// - parameter options: The property list reading options. Defaults to `[]`.
    ///
    /// - returns: A property list object response serializer.
    public static func propertyListResponseSerializer(
        options: PropertyListSerialization.ReadOptions = [])
        -> DataResponseSerializer<Any>
    {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponsePropertyList(options: options, response: response, data: data, error: error)
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The property list reading options. Defaults to `[]`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responsePropertyList(
        queue: DispatchQueue? = nil,
        options: PropertyListSerialization.ReadOptions = [],
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.propertyListResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    /// Creates a response serializer that returns an object constructed from the response data using
    /// `PropertyListSerialization` with the specified reading options.
    ///
    /// - parameter options: The property list reading options. Defaults to `[]`.
    ///
    /// - returns: A property list object response serializer.
    public static func propertyListResponseSerializer(
        options: PropertyListSerialization.ReadOptions = [])
        -> DownloadResponseSerializer<Any>
    {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }

            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }

            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponsePropertyList(options: options, response: response, data: data, error: error)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The property list reading options. Defaults to `[]`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responsePropertyList(
        queue: DispatchQueue? = nil,
        options: PropertyListSerialization.ReadOptions = [],
        completionHandler: @escaping (DownloadResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.propertyListResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

/// A set of HTTP response status code that do not contain response data.
private let emptyDataStatusCodes: Set<Int> = [204, 205]
//
//  Result.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// Used to represent whether a request was successful or encountered an error.
///
/// - success: The request and all post processing operations were successful resulting in the serialization of the
///            provided associated value.
///
/// - failure: The request encountered an error resulting in a failure. The associated values are the original data
///            provided by the server as well as the error that caused the failure.
public enum Result<Value> {
    case success(Value)
    case failure(Error)

    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

// MARK: - CustomStringConvertible

extension Result: CustomStringConvertible {
    /// The textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure.
    public var description: String {
        switch self {
        case .success:
            return "SUCCESS"
        case .failure:
            return "FAILURE"
        }
    }
}

// MARK: - CustomDebugStringConvertible

extension Result: CustomDebugStringConvertible {
    /// The debug textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure in addition to the value or error.
    public var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}
//
//  ServerTrustPolicy.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// Responsible for managing the mapping of `ServerTrustPolicy` objects to a given host.
open class ServerTrustPolicyManager {
    /// The dictionary of policies mapped to a particular host.
    open let policies: [String: ServerTrustPolicy]

    /// Initializes the `ServerTrustPolicyManager` instance with the given policies.
    ///
    /// Since different servers and web services can have different leaf certificates, intermediate and even root
    /// certficates, it is important to have the flexibility to specify evaluation policies on a per host basis. This
    /// allows for scenarios such as using default evaluation for host1, certificate pinning for host2, public key
    /// pinning for host3 and disabling evaluation for host4.
    ///
    /// - parameter policies: A dictionary of all policies mapped to a particular host.
    ///
    /// - returns: The new `ServerTrustPolicyManager` instance.
    public init(policies: [String: ServerTrustPolicy]) {
        self.policies = policies
    }

    /// Returns the `ServerTrustPolicy` for the given host if applicable.
    ///
    /// By default, this method will return the policy that perfectly matches the given host. Subclasses could override
    /// this method and implement more complex mapping implementations such as wildcards.
    ///
    /// - parameter host: The host to use when searching for a matching policy.
    ///
    /// - returns: The server trust policy for the given host if found.
    open func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return policies[host]
    }
}

// MARK: -

extension URLSession {
    private struct AssociatedKeys {
        static var managerKey = "URLSession.ServerTrustPolicyManager"
    }

    var serverTrustPolicyManager: ServerTrustPolicyManager? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.managerKey) as? ServerTrustPolicyManager
        }
        set (manager) {
            objc_setAssociatedObject(self, &AssociatedKeys.managerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - ServerTrustPolicy

/// The `ServerTrustPolicy` evaluates the server trust generally provided by an `NSURLAuthenticationChallenge` when
/// connecting to a server over a secure HTTPS connection. The policy configuration then evaluates the server trust
/// with a given set of criteria to determine whether the server trust is valid and the connection should be made.
///
/// Using pinned certificates or public keys for evaluation helps prevent man-in-the-middle (MITM) attacks and other
/// vulnerabilities. Applications dealing with sensitive customer data or financial information are strongly encouraged
/// to route all communication over an HTTPS connection with pinning enabled.
///
/// - performDefaultEvaluation: Uses the default server trust evaluation while allowing you to control whether to
///                             validate the host provided by the challenge. Applications are encouraged to always
///                             validate the host in production environments to guarantee the validity of the server's
///                             certificate chain.
///
/// - pinCertificates:          Uses the pinned certificates to validate the server trust. The server trust is
///                             considered valid if one of the pinned certificates match one of the server certificates.
///                             By validating both the certificate chain and host, certificate pinning provides a very
///                             secure form of server trust validation mitigating most, if not all, MITM attacks.
///                             Applications are encouraged to always validate the host and require a valid certificate
///                             chain in production environments.
///
/// - pinPublicKeys:            Uses the pinned public keys to validate the server trust. The server trust is considered
///                             valid if one of the pinned public keys match one of the server certificate public keys.
///                             By validating both the certificate chain and host, public key pinning provides a very
///                             secure form of server trust validation mitigating most, if not all, MITM attacks.
///                             Applications are encouraged to always validate the host and require a valid certificate
///                             chain in production environments.
///
/// - disableEvaluation:        Disables all evaluation which in turn will always consider any server trust as valid.
///
/// - customEvaluation:         Uses the associated closure to evaluate the validity of the server trust.
public enum ServerTrustPolicy {
    case performDefaultEvaluation(validateHost: Bool)
    case pinCertificates(certificates: [SecCertificate], validateCertificateChain: Bool, validateHost: Bool)
    case pinPublicKeys(publicKeys: [SecKey], validateCertificateChain: Bool, validateHost: Bool)
    case disableEvaluation
    case customEvaluation((_ serverTrust: SecTrust, _ host: String) -> Bool)

    // MARK: - Bundle Location

    /// Returns all certificates within the given bundle with a `.cer` file extension.
    ///
    /// - parameter bundle: The bundle to search for all `.cer` files.
    ///
    /// - returns: All certificates within the given bundle.
    public static func certificates(in bundle: Bundle = Bundle.main) -> [SecCertificate] {
        var certificates: [SecCertificate] = []

        let paths = Set([".cer", ".CER", ".crt", ".CRT", ".der", ".DER"].map { fileExtension in
            bundle.paths(forResourcesOfType: fileExtension, inDirectory: nil)
        }.joined())

        for path in paths {
            if
                let certificateData = try? Data(contentsOf: URL(fileURLWithPath: path)) as CFData,
                let certificate = SecCertificateCreateWithData(nil, certificateData)
            {
                certificates.append(certificate)
            }
        }

        return certificates
    }

    /// Returns all public keys within the given bundle with a `.cer` file extension.
    ///
    /// - parameter bundle: The bundle to search for all `*.cer` files.
    ///
    /// - returns: All public keys within the given bundle.
    public static func publicKeys(in bundle: Bundle = Bundle.main) -> [SecKey] {
        var publicKeys: [SecKey] = []

        for certificate in certificates(in: bundle) {
            if let publicKey = publicKey(for: certificate) {
                publicKeys.append(publicKey)
            }
        }

        return publicKeys
    }

    // MARK: - Evaluation

    /// Evaluates whether the server trust is valid for the given host.
    ///
    /// - parameter serverTrust: The server trust to evaluate.
    /// - parameter host:        The host of the challenge protection space.
    ///
    /// - returns: Whether the server trust is valid.
    public func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        var serverTrustIsValid = false

        switch self {
        case let .performDefaultEvaluation(validateHost):
            let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
            SecTrustSetPolicies(serverTrust, policy)

            serverTrustIsValid = trustIsValid(serverTrust)
        case let .pinCertificates(pinnedCertificates, validateCertificateChain, validateHost):
            if validateCertificateChain {
                let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
                SecTrustSetPolicies(serverTrust, policy)

                SecTrustSetAnchorCertificates(serverTrust, pinnedCertificates as CFArray)
                SecTrustSetAnchorCertificatesOnly(serverTrust, true)

                serverTrustIsValid = trustIsValid(serverTrust)
            } else {
                let serverCertificatesDataArray = certificateData(for: serverTrust)
                let pinnedCertificatesDataArray = certificateData(for: pinnedCertificates)

                outerLoop: for serverCertificateData in serverCertificatesDataArray {
                    for pinnedCertificateData in pinnedCertificatesDataArray {
                        if serverCertificateData == pinnedCertificateData {
                            serverTrustIsValid = true
                            break outerLoop
                        }
                    }
                }
            }
        case let .pinPublicKeys(pinnedPublicKeys, validateCertificateChain, validateHost):
            var certificateChainEvaluationPassed = true

            if validateCertificateChain {
                let policy = SecPolicyCreateSSL(true, validateHost ? host as CFString : nil)
                SecTrustSetPolicies(serverTrust, policy)

                certificateChainEvaluationPassed = trustIsValid(serverTrust)
            }

            if certificateChainEvaluationPassed {
                outerLoop: for serverPublicKey in ServerTrustPolicy.publicKeys(for: serverTrust) as [AnyObject] {
                    for pinnedPublicKey in pinnedPublicKeys as [AnyObject] {
                        if serverPublicKey.isEqual(pinnedPublicKey) {
                            serverTrustIsValid = true
                            break outerLoop
                        }
                    }
                }
            }
        case .disableEvaluation:
            serverTrustIsValid = true
        case let .customEvaluation(closure):
            serverTrustIsValid = closure(serverTrust, host)
        }

        return serverTrustIsValid
    }

    // MARK: - Private - Trust Validation

    private func trustIsValid(_ trust: SecTrust) -> Bool {
        var isValid = false

        var result = SecTrustResultType.invalid
        let status = SecTrustEvaluate(trust, &result)

        if status == errSecSuccess {
            let unspecified = SecTrustResultType.unspecified
            let proceed = SecTrustResultType.proceed


            isValid = result == unspecified || result == proceed
        }

        return isValid
    }

    // MARK: - Private - Certificate Data

    private func certificateData(for trust: SecTrust) -> [Data] {
        var certificates: [SecCertificate] = []

        for index in 0..<SecTrustGetCertificateCount(trust) {
            if let certificate = SecTrustGetCertificateAtIndex(trust, index) {
                certificates.append(certificate)
            }
        }

        return certificateData(for: certificates)
    }

    private func certificateData(for certificates: [SecCertificate]) -> [Data] {
        return certificates.map { SecCertificateCopyData($0) as Data }
    }

    // MARK: - Private - Public Key Extraction

    private static func publicKeys(for trust: SecTrust) -> [SecKey] {
        var publicKeys: [SecKey] = []

        for index in 0..<SecTrustGetCertificateCount(trust) {
            if
                let certificate = SecTrustGetCertificateAtIndex(trust, index),
                let publicKey = publicKey(for: certificate)
            {
                publicKeys.append(publicKey)
            }
        }

        return publicKeys
    }

    private static func publicKey(for certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?

        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)

        if let trust = trust, trustCreationStatus == errSecSuccess {
            publicKey = SecTrustCopyPublicKey(trust)
        }

        return publicKey
    }
}
//
//  SessionDelegate.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// Responsible for handling all delegate callbacks for the underlying session.
open class SessionDelegate: NSObject {

    // MARK: URLSessionDelegate Overrides

    /// Overrides default behavior for URLSessionDelegate method `urlSession(_:didBecomeInvalidWithError:)`.
    open var sessionDidBecomeInvalidWithError: ((URLSession, Error?) -> Void)?

    /// Overrides default behavior for URLSessionDelegate method `urlSession(_:didReceive:completionHandler:)`.
    open var sessionDidReceiveChallenge: ((URLSession, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?

    /// Overrides all behavior for URLSessionDelegate method `urlSession(_:didReceive:completionHandler:)` and requires the caller to call the `completionHandler`.
    open var sessionDidReceiveChallengeWithCompletion: ((URLSession, URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?

    /// Overrides default behavior for URLSessionDelegate method `urlSessionDidFinishEvents(forBackgroundURLSession:)`.
    open var sessionDidFinishEventsForBackgroundURLSession: ((URLSession) -> Void)?

    // MARK: URLSessionTaskDelegate Overrides

    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)`.
    open var taskWillPerformHTTPRedirection: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest) -> URLRequest?)?

    /// Overrides all behavior for URLSessionTaskDelegate method `urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)` and
    /// requires the caller to call the `completionHandler`.
    open var taskWillPerformHTTPRedirectionWithCompletion: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest, (URLRequest?) -> Void) -> Void)?

    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:didReceive:completionHandler:)`.
    open var taskDidReceiveChallenge: ((URLSession, URLSessionTask, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?

    /// Overrides all behavior for URLSessionTaskDelegate method `urlSession(_:task:didReceive:completionHandler:)` and
    /// requires the caller to call the `completionHandler`.
    open var taskDidReceiveChallengeWithCompletion: ((URLSession, URLSessionTask, URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?

    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:needNewBodyStream:)`.
    open var taskNeedNewBodyStream: ((URLSession, URLSessionTask) -> InputStream?)?

    /// Overrides all behavior for URLSessionTaskDelegate method `urlSession(_:task:needNewBodyStream:)` and
    /// requires the caller to call the `completionHandler`.
    open var taskNeedNewBodyStreamWithCompletion: ((URLSession, URLSessionTask, (InputStream?) -> Void) -> Void)?

    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)`.
    open var taskDidSendBodyData: ((URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?

    /// Overrides default behavior for URLSessionTaskDelegate method `urlSession(_:task:didCompleteWithError:)`.
    open var taskDidComplete: ((URLSession, URLSessionTask, Error?) -> Void)?

    // MARK: URLSessionDataDelegate Overrides

    /// Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:completionHandler:)`.
    open var dataTaskDidReceiveResponse: ((URLSession, URLSessionDataTask, URLResponse) -> URLSession.ResponseDisposition)?

    /// Overrides all behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:completionHandler:)` and
    /// requires caller to call the `completionHandler`.
    open var dataTaskDidReceiveResponseWithCompletion: ((URLSession, URLSessionDataTask, URLResponse, (URLSession.ResponseDisposition) -> Void) -> Void)?

    /// Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didBecome:)`.
    open var dataTaskDidBecomeDownloadTask: ((URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?

    /// Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:didReceive:)`.
    open var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?

    /// Overrides default behavior for URLSessionDataDelegate method `urlSession(_:dataTask:willCacheResponse:completionHandler:)`.
    open var dataTaskWillCacheResponse: ((URLSession, URLSessionDataTask, CachedURLResponse) -> CachedURLResponse?)?

    /// Overrides all behavior for URLSessionDataDelegate method `urlSession(_:dataTask:willCacheResponse:completionHandler:)` and
    /// requires caller to call the `completionHandler`.
    open var dataTaskWillCacheResponseWithCompletion: ((URLSession, URLSessionDataTask, CachedURLResponse, (CachedURLResponse?) -> Void) -> Void)?

    // MARK: URLSessionDownloadDelegate Overrides

    /// Overrides default behavior for URLSessionDownloadDelegate method `urlSession(_:downloadTask:didFinishDownloadingTo:)`.
    open var downloadTaskDidFinishDownloadingToURL: ((URLSession, URLSessionDownloadTask, URL) -> Void)?

    /// Overrides default behavior for URLSessionDownloadDelegate method `urlSession(_:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)`.
    open var downloadTaskDidWriteData: ((URLSession, URLSessionDownloadTask, Int64, Int64, Int64) -> Void)?

    /// Overrides default behavior for URLSessionDownloadDelegate method `urlSession(_:downloadTask:didResumeAtOffset:expectedTotalBytes:)`.
    open var downloadTaskDidResumeAtOffset: ((URLSession, URLSessionDownloadTask, Int64, Int64) -> Void)?

    // MARK: URLSessionStreamDelegate Overrides

#if !os(watchOS)

    /// Overrides default behavior for URLSessionStreamDelegate method `urlSession(_:readClosedFor:)`.
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskReadClosed: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskReadClosed as? (URLSession, URLSessionStreamTask) -> Void
        }
        set {
            _streamTaskReadClosed = newValue
        }
    }

    /// Overrides default behavior for URLSessionStreamDelegate method `urlSession(_:writeClosedFor:)`.
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskWriteClosed: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskWriteClosed as? (URLSession, URLSessionStreamTask) -> Void
        }
        set {
            _streamTaskWriteClosed = newValue
        }
    }

    /// Overrides default behavior for URLSessionStreamDelegate method `urlSession(_:betterRouteDiscoveredFor:)`.
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskBetterRouteDiscovered: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskBetterRouteDiscovered as? (URLSession, URLSessionStreamTask) -> Void
        }
        set {
            _streamTaskBetterRouteDiscovered = newValue
        }
    }

    /// Overrides default behavior for URLSessionStreamDelegate method `urlSession(_:streamTask:didBecome:outputStream:)`.
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskDidBecomeInputAndOutputStreams: ((URLSession, URLSessionStreamTask, InputStream, OutputStream) -> Void)? {
        get {
            return _streamTaskDidBecomeInputStream as? (URLSession, URLSessionStreamTask, InputStream, OutputStream) -> Void
        }
        set {
            _streamTaskDidBecomeInputStream = newValue
        }
    }

    var _streamTaskReadClosed: Any?
    var _streamTaskWriteClosed: Any?
    var _streamTaskBetterRouteDiscovered: Any?
    var _streamTaskDidBecomeInputStream: Any?

#endif

    // MARK: Properties

    var retrier: RequestRetrier?
    weak var sessionManager: SessionManager?

    private var requests: [Int: Request] = [:]
    private let lock = NSLock()

    /// Access the task delegate for the specified task in a thread-safe manner.
    open subscript(task: URLSessionTask) -> Request? {
        get {
            lock.lock() ; defer { lock.unlock() }
            return requests[task.taskIdentifier]
        }
        set {
            lock.lock() ; defer { lock.unlock() }
            requests[task.taskIdentifier] = newValue
        }
    }

    // MARK: Lifecycle

    /// Initializes the `SessionDelegate` instance.
    ///
    /// - returns: The new `SessionDelegate` instance.
    public override init() {
        super.init()
    }

    // MARK: NSObject Overrides

    /// Returns a `Bool` indicating whether the `SessionDelegate` implements or inherits a method that can respond
    /// to a specified message.
    ///
    /// - parameter selector: A selector that identifies a message.
    ///
    /// - returns: `true` if the receiver implements or inherits a method that can respond to selector, otherwise `false`.
    open override func responds(to selector: Selector) -> Bool {
        #if !os(macOS)
            if selector == #selector(URLSessionDelegate.urlSessionDidFinishEvents(forBackgroundURLSession:)) {
                return sessionDidFinishEventsForBackgroundURLSession != nil
            }
        #endif

        #if !os(watchOS)
            if #available(iOS 9.0, macOS 10.11, tvOS 9.0, *) {
                switch selector {
                case #selector(URLSessionStreamDelegate.urlSession(_:readClosedFor:)):
                    return streamTaskReadClosed != nil
                case #selector(URLSessionStreamDelegate.urlSession(_:writeClosedFor:)):
                    return streamTaskWriteClosed != nil
                case #selector(URLSessionStreamDelegate.urlSession(_:betterRouteDiscoveredFor:)):
                    return streamTaskBetterRouteDiscovered != nil
                case #selector(URLSessionStreamDelegate.urlSession(_:streamTask:didBecome:outputStream:)):
                    return streamTaskDidBecomeInputAndOutputStreams != nil
                default:
                    break
                }
            }
        #endif

        switch selector {
        case #selector(URLSessionDelegate.urlSession(_:didBecomeInvalidWithError:)):
            return sessionDidBecomeInvalidWithError != nil
        case #selector(URLSessionDelegate.urlSession(_:didReceive:completionHandler:)):
            return (sessionDidReceiveChallenge != nil  || sessionDidReceiveChallengeWithCompletion != nil)
        case #selector(URLSessionTaskDelegate.urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)):
            return (taskWillPerformHTTPRedirection != nil || taskWillPerformHTTPRedirectionWithCompletion != nil)
        case #selector(URLSessionDataDelegate.urlSession(_:dataTask:didReceive:completionHandler:)):
            return (dataTaskDidReceiveResponse != nil || dataTaskDidReceiveResponseWithCompletion != nil)
        default:
            return type(of: self).instancesRespond(to: selector)
        }
    }
}

// MARK: - URLSessionDelegate

extension SessionDelegate: URLSessionDelegate {
    /// Tells the delegate that the session has been invalidated.
    ///
    /// - parameter session: The session object that was invalidated.
    /// - parameter error:   The error that caused invalidation, or nil if the invalidation was explicit.
    open func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        sessionDidBecomeInvalidWithError?(session, error)
    }

    /// Requests credentials from the delegate in response to a session-level authentication request from the
    /// remote server.
    ///
    /// - parameter session:           The session containing the task that requested authentication.
    /// - parameter challenge:         An object that contains the request for authentication.
    /// - parameter completionHandler: A handler that your delegate method must call providing the disposition
    ///                                and credential.
    open func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        guard sessionDidReceiveChallengeWithCompletion == nil else {
            sessionDidReceiveChallengeWithCompletion?(session, challenge, completionHandler)
            return
        }

        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?

        if let sessionDidReceiveChallenge = sessionDidReceiveChallenge {
            (disposition, credential) = sessionDidReceiveChallenge(session, challenge)
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let host = challenge.protectionSpace.host

            if
                let serverTrustPolicy = session.serverTrustPolicyManager?.serverTrustPolicy(forHost: host),
                let serverTrust = challenge.protectionSpace.serverTrust
            {
                if serverTrustPolicy.evaluate(serverTrust, forHost: host) {
                    disposition = .useCredential
                    credential = URLCredential(trust: serverTrust)
                } else {
                    disposition = .cancelAuthenticationChallenge
                }
            }
        }

        completionHandler(disposition, credential)
    }

#if !os(macOS)

    /// Tells the delegate that all messages enqueued for a session have been delivered.
    ///
    /// - parameter session: The session that no longer has any outstanding requests.
    open func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        sessionDidFinishEventsForBackgroundURLSession?(session)
    }

#endif
}

// MARK: - URLSessionTaskDelegate

extension SessionDelegate: URLSessionTaskDelegate {
    /// Tells the delegate that the remote server requested an HTTP redirect.
    ///
    /// - parameter session:           The session containing the task whose request resulted in a redirect.
    /// - parameter task:              The task whose request resulted in a redirect.
    /// - parameter response:          An object containing the server’s response to the original request.
    /// - parameter request:           A URL request object filled out with the new location.
    /// - parameter completionHandler: A closure that your handler should call with either the value of the request
    ///                                parameter, a modified URL request object, or NULL to refuse the redirect and
    ///                                return the body of the redirect response.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void)
    {
        guard taskWillPerformHTTPRedirectionWithCompletion == nil else {
            taskWillPerformHTTPRedirectionWithCompletion?(session, task, response, request, completionHandler)
            return
        }

        var redirectRequest: URLRequest? = request

        if let taskWillPerformHTTPRedirection = taskWillPerformHTTPRedirection {
            redirectRequest = taskWillPerformHTTPRedirection(session, task, response, request)
        }

        completionHandler(redirectRequest)
    }

    /// Requests credentials from the delegate in response to an authentication request from the remote server.
    ///
    /// - parameter session:           The session containing the task whose request requires authentication.
    /// - parameter task:              The task whose request requires authentication.
    /// - parameter challenge:         An object that contains the request for authentication.
    /// - parameter completionHandler: A handler that your delegate method must call providing the disposition
    ///                                and credential.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        guard taskDidReceiveChallengeWithCompletion == nil else {
            taskDidReceiveChallengeWithCompletion?(session, task, challenge, completionHandler)
            return
        }

        if let taskDidReceiveChallenge = taskDidReceiveChallenge {
            let result = taskDidReceiveChallenge(session, task, challenge)
            completionHandler(result.0, result.1)
        } else if let delegate = self[task]?.delegate {
            delegate.urlSession(
                session,
                task: task,
                didReceive: challenge,
                completionHandler: completionHandler
            )
        } else {
            urlSession(session, didReceive: challenge, completionHandler: completionHandler)
        }
    }

    /// Tells the delegate when a task requires a new request body stream to send to the remote server.
    ///
    /// - parameter session:           The session containing the task that needs a new body stream.
    /// - parameter task:              The task that needs a new body stream.
    /// - parameter completionHandler: A completion handler that your delegate method should call with the new body stream.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        needNewBodyStream completionHandler: @escaping (InputStream?) -> Void)
    {
        guard taskNeedNewBodyStreamWithCompletion == nil else {
            taskNeedNewBodyStreamWithCompletion?(session, task, completionHandler)
            return
        }

        if let taskNeedNewBodyStream = taskNeedNewBodyStream {
            completionHandler(taskNeedNewBodyStream(session, task))
        } else if let delegate = self[task]?.delegate {
            delegate.urlSession(session, task: task, needNewBodyStream: completionHandler)
        }
    }

    /// Periodically informs the delegate of the progress of sending body content to the server.
    ///
    /// - parameter session:                  The session containing the data task.
    /// - parameter task:                     The data task.
    /// - parameter bytesSent:                The number of bytes sent since the last time this delegate method was called.
    /// - parameter totalBytesSent:           The total number of bytes sent so far.
    /// - parameter totalBytesExpectedToSend: The expected length of the body data.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64)
    {
        if let taskDidSendBodyData = taskDidSendBodyData {
            taskDidSendBodyData(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
        } else if let delegate = self[task]?.delegate as? UploadTaskDelegate {
            delegate.URLSession(
                session,
                task: task,
                didSendBodyData: bytesSent,
                totalBytesSent: totalBytesSent,
                totalBytesExpectedToSend: totalBytesExpectedToSend
            )
        }
    }

#if !os(watchOS)

    /// Tells the delegate that the session finished collecting metrics for the task.
    ///
    /// - parameter session: The session collecting the metrics.
    /// - parameter task:    The task whose metrics have been collected.
    /// - parameter metrics: The collected metrics.
    @available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
    @objc(URLSession:task:didFinishCollectingMetrics:)
    open func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        self[task]?.delegate.metrics = metrics
    }

#endif

    /// Tells the delegate that the task finished transferring data.
    ///
    /// - parameter session: The session containing the task whose request finished transferring data.
    /// - parameter task:    The task whose request finished transferring data.
    /// - parameter error:   If an error occurred, an error object indicating how the transfer failed, otherwise nil.
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        /// Executed after it is determined that the request is not going to be retried
        let completeTask: (URLSession, URLSessionTask, Error?) -> Void = { [weak self] session, task, error in
            guard let strongSelf = self else { return }

            if let taskDidComplete = strongSelf.taskDidComplete {
                taskDidComplete(session, task, error)
            } else if let delegate = strongSelf[task]?.delegate {
                delegate.urlSession(session, task: task, didCompleteWithError: error)
            }

            NotificationCenter.default.post(
                name: Notification.Name.Task.DidComplete,
                object: strongSelf,
                userInfo: [Notification.Key.Task: task]
            )

            strongSelf[task] = nil
        }

        guard let request = self[task], let sessionManager = sessionManager else {
            completeTask(session, task, error)
            return
        }

        // Run all validations on the request before checking if an error occurred
        request.validations.forEach { $0() }

        // Determine whether an error has occurred
        var error: Error? = error

        if let taskDelegate = self[task]?.delegate, taskDelegate.error != nil {
            error = taskDelegate.error
        }

        /// If an error occurred and the retrier is set, asynchronously ask the retrier if the request
        /// should be retried. Otherwise, complete the task by notifying the task delegate.
        if let retrier = retrier, let error = error {
            retrier.should(sessionManager, retry: request, with: error) { [weak self] shouldRetry, delay in
                guard shouldRetry else { completeTask(session, task, error) ; return }

                DispatchQueue.utility.after(delay) { [weak self] in
                    guard let strongSelf = self else { return }

                    let retrySucceeded = strongSelf.sessionManager?.retry(request) ?? false

                    if retrySucceeded, let task = request.task {
                        strongSelf[task] = request
                        return
                    } else {
                        completeTask(session, task, error)
                    }
                }
            }
        } else {
            completeTask(session, task, error)
        }
    }
}

// MARK: - URLSessionDataDelegate

extension SessionDelegate: URLSessionDataDelegate {
    /// Tells the delegate that the data task received the initial reply (headers) from the server.
    ///
    /// - parameter session:           The session containing the data task that received an initial reply.
    /// - parameter dataTask:          The data task that received an initial reply.
    /// - parameter response:          A URL response object populated with headers.
    /// - parameter completionHandler: A completion handler that your code calls to continue the transfer, passing a
    ///                                constant to indicate whether the transfer should continue as a data task or
    ///                                should become a download task.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        guard dataTaskDidReceiveResponseWithCompletion == nil else {
            dataTaskDidReceiveResponseWithCompletion?(session, dataTask, response, completionHandler)
            return
        }

        var disposition: URLSession.ResponseDisposition = .allow

        if let dataTaskDidReceiveResponse = dataTaskDidReceiveResponse {
            disposition = dataTaskDidReceiveResponse(session, dataTask, response)
        }

        completionHandler(disposition)
    }

    /// Tells the delegate that the data task was changed to a download task.
    ///
    /// - parameter session:      The session containing the task that was replaced by a download task.
    /// - parameter dataTask:     The data task that was replaced by a download task.
    /// - parameter downloadTask: The new download task that replaced the data task.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask)
    {
        if let dataTaskDidBecomeDownloadTask = dataTaskDidBecomeDownloadTask {
            dataTaskDidBecomeDownloadTask(session, dataTask, downloadTask)
        } else {
            self[downloadTask]?.delegate = DownloadTaskDelegate(task: downloadTask)
        }
    }

    /// Tells the delegate that the data task has received some of the expected data.
    ///
    /// - parameter session:  The session containing the data task that provided data.
    /// - parameter dataTask: The data task that provided data.
    /// - parameter data:     A data object containing the transferred data.
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let dataTaskDidReceiveData = dataTaskDidReceiveData {
            dataTaskDidReceiveData(session, dataTask, data)
        } else if let delegate = self[dataTask]?.delegate as? DataTaskDelegate {
            delegate.urlSession(session, dataTask: dataTask, didReceive: data)
        }
    }

    /// Asks the delegate whether the data (or upload) task should store the response in the cache.
    ///
    /// - parameter session:           The session containing the data (or upload) task.
    /// - parameter dataTask:          The data (or upload) task.
    /// - parameter proposedResponse:  The default caching behavior. This behavior is determined based on the current
    ///                                caching policy and the values of certain received headers, such as the Pragma
    ///                                and Cache-Control headers.
    /// - parameter completionHandler: A block that your handler must call, providing either the original proposed
    ///                                response, a modified version of that response, or NULL to prevent caching the
    ///                                response. If your delegate implements this method, it must call this completion
    ///                                handler; otherwise, your app leaks memory.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        willCacheResponse proposedResponse: CachedURLResponse,
        completionHandler: @escaping (CachedURLResponse?) -> Void)
    {
        guard dataTaskWillCacheResponseWithCompletion == nil else {
            dataTaskWillCacheResponseWithCompletion?(session, dataTask, proposedResponse, completionHandler)
            return
        }

        if let dataTaskWillCacheResponse = dataTaskWillCacheResponse {
            completionHandler(dataTaskWillCacheResponse(session, dataTask, proposedResponse))
        } else if let delegate = self[dataTask]?.delegate as? DataTaskDelegate {
            delegate.urlSession(
                session,
                dataTask: dataTask,
                willCacheResponse: proposedResponse,
                completionHandler: completionHandler
            )
        } else {
            completionHandler(proposedResponse)
        }
    }
}

// MARK: - URLSessionDownloadDelegate

extension SessionDelegate: URLSessionDownloadDelegate {
    /// Tells the delegate that a download task has finished downloading.
    ///
    /// - parameter session:      The session containing the download task that finished.
    /// - parameter downloadTask: The download task that finished.
    /// - parameter location:     A file URL for the temporary file. Because the file is temporary, you must either
    ///                           open the file for reading or move it to a permanent location in your app’s sandbox
    ///                           container directory before returning from this delegate method.
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL)
    {
        if let downloadTaskDidFinishDownloadingToURL = downloadTaskDidFinishDownloadingToURL {
            downloadTaskDidFinishDownloadingToURL(session, downloadTask, location)
        } else if let delegate = self[downloadTask]?.delegate as? DownloadTaskDelegate {
            delegate.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
        }
    }

    /// Periodically informs the delegate about the download’s progress.
    ///
    /// - parameter session:                   The session containing the download task.
    /// - parameter downloadTask:              The download task.
    /// - parameter bytesWritten:              The number of bytes transferred since the last time this delegate
    ///                                        method was called.
    /// - parameter totalBytesWritten:         The total number of bytes transferred so far.
    /// - parameter totalBytesExpectedToWrite: The expected length of the file, as provided by the Content-Length
    ///                                        header. If this header was not provided, the value is
    ///                                        `NSURLSessionTransferSizeUnknown`.
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64)
    {
        if let downloadTaskDidWriteData = downloadTaskDidWriteData {
            downloadTaskDidWriteData(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
        } else if let delegate = self[downloadTask]?.delegate as? DownloadTaskDelegate {
            delegate.urlSession(
                session,
                downloadTask: downloadTask,
                didWriteData: bytesWritten,
                totalBytesWritten: totalBytesWritten,
                totalBytesExpectedToWrite: totalBytesExpectedToWrite
            )
        }
    }

    /// Tells the delegate that the download task has resumed downloading.
    ///
    /// - parameter session:            The session containing the download task that finished.
    /// - parameter downloadTask:       The download task that resumed. See explanation in the discussion.
    /// - parameter fileOffset:         If the file's cache policy or last modified date prevents reuse of the
    ///                                 existing content, then this value is zero. Otherwise, this value is an
    ///                                 integer representing the number of bytes on disk that do not need to be
    ///                                 retrieved again.
    /// - parameter expectedTotalBytes: The expected length of the file, as provided by the Content-Length header.
    ///                                 If this header was not provided, the value is NSURLSessionTransferSizeUnknown.
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64)
    {
        if let downloadTaskDidResumeAtOffset = downloadTaskDidResumeAtOffset {
            downloadTaskDidResumeAtOffset(session, downloadTask, fileOffset, expectedTotalBytes)
        } else if let delegate = self[downloadTask]?.delegate as? DownloadTaskDelegate {
            delegate.urlSession(
                session,
                downloadTask: downloadTask,
                didResumeAtOffset: fileOffset,
                expectedTotalBytes: expectedTotalBytes
            )
        }
    }
}

// MARK: - URLSessionStreamDelegate

#if !os(watchOS)

@available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
extension SessionDelegate: URLSessionStreamDelegate {
    /// Tells the delegate that the read side of the connection has been closed.
    ///
    /// - parameter session:    The session.
    /// - parameter streamTask: The stream task.
    open func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        streamTaskReadClosed?(session, streamTask)
    }

    /// Tells the delegate that the write side of the connection has been closed.
    ///
    /// - parameter session:    The session.
    /// - parameter streamTask: The stream task.
    open func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        streamTaskWriteClosed?(session, streamTask)
    }

    /// Tells the delegate that the system has determined that a better route to the host is available.
    ///
    /// - parameter session:    The session.
    /// - parameter streamTask: The stream task.
    open func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        streamTaskBetterRouteDiscovered?(session, streamTask)
    }

    /// Tells the delegate that the stream task has been completed and provides the unopened stream objects.
    ///
    /// - parameter session:      The session.
    /// - parameter streamTask:   The stream task.
    /// - parameter inputStream:  The new input stream.
    /// - parameter outputStream: The new output stream.
    open func urlSession(
        _ session: URLSession,
        streamTask: URLSessionStreamTask,
        didBecome inputStream: InputStream,
        outputStream: OutputStream)
    {
        streamTaskDidBecomeInputAndOutputStreams?(session, streamTask, inputStream, outputStream)
    }
}

#endif
//
//  SessionManager.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// Responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.
open class SessionManager {

    // MARK: - Helper Types

    /// Defines whether the `MultipartFormData` encoding was successful and contains result of the encoding as
    /// associated values.
    ///
    /// - Success: Represents a successful `MultipartFormData` encoding and contains the new `UploadRequest` along with
    ///            streaming information.
    /// - Failure: Used to represent a failure in the `MultipartFormData` encoding and also contains the encoding
    ///            error.
    public enum MultipartFormDataEncodingResult {
        case success(request: UploadRequest, streamingFromDisk: Bool, streamFileURL: URL?)
        case failure(Error)
    }

    // MARK: - Properties

    /// A default instance of `SessionManager`, used by top-level Alamofire request methods, and suitable for use
    /// directly for any ad hoc requests.
    open static let `default`: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        return SessionManager(configuration: configuration)
    }()

    /// Creates default values for the "Accept-Encoding", "Accept-Language" and "User-Agent" headers.
    open static let defaultHTTPHeaders: HTTPHeaders = {
        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"

        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
        }.joined(separator: ", ")

        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        // Example: `iOS Example/1.0 (org.alamofire.iOS-Example; build:1; iOS 10.0.0) Alamofire/4.0.0`
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #elseif os(watchOS)
                            return "watchOS"
                        #elseif os(tvOS)
                            return "tvOS"
                        #elseif os(macOS)
                            return "OS X"
                        #elseif os(Linux)
                            return "Linux"
                        #else
                            return "Unknown"
                        #endif
                    }()

                    return "\(osName) \(versionString)"
                }()

                let alamofireVersion: String = {
                    guard
                        let afInfo = Bundle(for: SessionManager.self).infoDictionary,
                        let build = afInfo["CFBundleShortVersionString"]
                    else { return "Unknown" }

                    return "Alamofire/\(build)"
                }()

                return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(alamofireVersion)"
            }

            return "Alamofire"
        }()

        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }()

    /// Default memory threshold used when encoding `MultipartFormData` in bytes.
    open static let multipartFormDataEncodingMemoryThreshold: UInt64 = 10_000_000

    /// The underlying session.
    open let session: URLSession

    /// The session delegate handling all the task and session delegate callbacks.
    open let delegate: SessionDelegate

    /// Whether to start requests immediately after being constructed. `true` by default.
    open var startRequestsImmediately: Bool = true

    /// The request adapter called each time a new request is created.
    open var adapter: RequestAdapter?

    /// The request retrier called each time a request encounters an error to determine whether to retry the request.
    open var retrier: RequestRetrier? {
        get { return delegate.retrier }
        set { delegate.retrier = newValue }
    }

    /// The background completion handler closure provided by the UIApplicationDelegate
    /// `application:handleEventsForBackgroundURLSession:completionHandler:` method. By setting the background
    /// completion handler, the SessionDelegate `sessionDidFinishEventsForBackgroundURLSession` closure implementation
    /// will automatically call the handler.
    ///
    /// If you need to handle your own events before the handler is called, then you need to override the
    /// SessionDelegate `sessionDidFinishEventsForBackgroundURLSession` and manually call the handler when finished.
    ///
    /// `nil` by default.
    open var backgroundCompletionHandler: (() -> Void)?

    let queue = DispatchQueue(label: "org.alamofire.session-manager." + UUID().uuidString)

    // MARK: - Lifecycle

    /// Creates an instance with the specified `configuration`, `delegate` and `serverTrustPolicyManager`.
    ///
    /// - parameter configuration:            The configuration used to construct the managed session.
    ///                                       `URLSessionConfiguration.default` by default.
    /// - parameter delegate:                 The delegate used when initializing the session. `SessionDelegate()` by
    ///                                       default.
    /// - parameter serverTrustPolicyManager: The server trust policy manager to use for evaluating all server trust
    ///                                       challenges. `nil` by default.
    ///
    /// - returns: The new `SessionManager` instance.
    public init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default,
        delegate: SessionDelegate = SessionDelegate(),
        serverTrustPolicyManager: ServerTrustPolicyManager? = nil)
    {
        self.delegate = delegate
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)

        commonInit(serverTrustPolicyManager: serverTrustPolicyManager)
    }

    /// Creates an instance with the specified `session`, `delegate` and `serverTrustPolicyManager`.
    ///
    /// - parameter session:                  The URL session.
    /// - parameter delegate:                 The delegate of the URL session. Must equal the URL session's delegate.
    /// - parameter serverTrustPolicyManager: The server trust policy manager to use for evaluating all server trust
    ///                                       challenges. `nil` by default.
    ///
    /// - returns: The new `SessionManager` instance if the URL session's delegate matches; `nil` otherwise.
    public init?(
        session: URLSession,
        delegate: SessionDelegate,
        serverTrustPolicyManager: ServerTrustPolicyManager? = nil)
    {
        guard delegate === session.delegate else { return nil }

        self.delegate = delegate
        self.session = session

        commonInit(serverTrustPolicyManager: serverTrustPolicyManager)
    }

    private func commonInit(serverTrustPolicyManager: ServerTrustPolicyManager?) {
        session.serverTrustPolicyManager = serverTrustPolicyManager

        delegate.sessionManager = self

        delegate.sessionDidFinishEventsForBackgroundURLSession = { [weak self] session in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async { strongSelf.backgroundCompletionHandler?() }
        }
    }

    deinit {
        session.invalidateAndCancel()
    }

    // MARK: - Data Request

    /// Creates a `DataRequest` to retrieve the contents of the specified `url`, `method`, `parameters`, `encoding`
    /// and `headers`.
    ///
    /// - parameter url:        The URL.
    /// - parameter method:     The HTTP method. `.get` by default.
    /// - parameter parameters: The parameters. `nil` by default.
    /// - parameter encoding:   The parameter encoding. `URLEncoding.default` by default.
    /// - parameter headers:    The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `DataRequest`.
    @discardableResult
    open func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        var originalRequest: URLRequest?

        do {
            originalRequest = try URLRequest(url: url, method: method, headers: headers)
            let encodedURLRequest = try encoding.encode(originalRequest!, with: parameters)
            return request(encodedURLRequest)
        } catch {
            return request(originalRequest, failedWith: error)
        }
    }

    /// Creates a `DataRequest` to retrieve the contents of a URL based on the specified `urlRequest`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `DataRequest`.
    open func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        var originalRequest: URLRequest?

        do {
            originalRequest = try urlRequest.asURLRequest()
            let originalTask = DataRequest.Requestable(urlRequest: originalRequest!)

            let task = try originalTask.task(session: session, adapter: adapter, queue: queue)
            let request = DataRequest(session: session, requestTask: .data(originalTask, task))

            delegate[task] = request

            if startRequestsImmediately { request.resume() }

            return request
        } catch {
            return request(originalRequest, failedWith: error)
        }
    }

    // MARK: Private - Request Implementation

    private func request(_ urlRequest: URLRequest?, failedWith error: Error) -> DataRequest {
        var requestTask: Request.RequestTask = .data(nil, nil)

        if let urlRequest = urlRequest {
            let originalTask = DataRequest.Requestable(urlRequest: urlRequest)
            requestTask = .data(originalTask, nil)
        }

        let underlyingError = error.underlyingAdaptError ?? error
        let request = DataRequest(session: session, requestTask: requestTask, error: underlyingError)

        if let retrier = retrier, error is AdaptError {
            allowRetrier(retrier, toRetry: request, with: underlyingError)
        } else {
            if startRequestsImmediately { request.resume() }
        }

        return request
    }

    // MARK: - Download Request

    // MARK: URL Request

    /// Creates a `DownloadRequest` to retrieve the contents the specified `url`, `method`, `parameters`, `encoding`,
    /// `headers` and save them to the `destination`.
    ///
    /// If `destination` is not specified, the contents will remain in the temporary location determined by the
    /// underlying URL session.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter url:         The URL.
    /// - parameter method:      The HTTP method. `.get` by default.
    /// - parameter parameters:  The parameters. `nil` by default.
    /// - parameter encoding:    The parameter encoding. `URLEncoding.default` by default.
    /// - parameter headers:     The HTTP headers. `nil` by default.
    /// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
    ///
    /// - returns: The created `DownloadRequest`.
    @discardableResult
    open func download(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        to destination: DownloadRequest.DownloadFileDestination? = nil)
        -> DownloadRequest
    {
        do {
            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return download(encodedURLRequest, to: destination)
        } catch {
            return download(nil, to: destination, failedWith: error)
        }
    }

    /// Creates a `DownloadRequest` to retrieve the contents of a URL based on the specified `urlRequest` and save
    /// them to the `destination`.
    ///
    /// If `destination` is not specified, the contents will remain in the temporary location determined by the
    /// underlying URL session.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter urlRequest:  The URL request
    /// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
    ///
    /// - returns: The created `DownloadRequest`.
    @discardableResult
    open func download(
        _ urlRequest: URLRequestConvertible,
        to destination: DownloadRequest.DownloadFileDestination? = nil)
        -> DownloadRequest
    {
        do {
            let urlRequest = try urlRequest.asURLRequest()
            return download(.request(urlRequest), to: destination)
        } catch {
            return download(nil, to: destination, failedWith: error)
        }
    }

    // MARK: Resume Data

    /// Creates a `DownloadRequest` from the `resumeData` produced from a previous request cancellation to retrieve
    /// the contents of the original request and save them to the `destination`.
    ///
    /// If `destination` is not specified, the contents will remain in the temporary location determined by the
    /// underlying URL session.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// On the latest release of all the Apple platforms (iOS 10, macOS 10.12, tvOS 10, watchOS 3), `resumeData` is broken
    /// on background URL session configurations. There's an underlying bug in the `resumeData` generation logic where the
    /// data is written incorrectly and will always fail to resume the download. For more information about the bug and
    /// possible workarounds, please refer to the following Stack Overflow post:
    ///
    ///    - http://stackoverflow.com/a/39347461/1342462
    ///
    /// - parameter resumeData:  The resume data. This is an opaque data blob produced by `URLSessionDownloadTask`
    ///                          when a task is cancelled. See `URLSession -downloadTask(withResumeData:)` for
    ///                          additional information.
    /// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
    ///
    /// - returns: The created `DownloadRequest`.
    @discardableResult
    open func download(
        resumingWith resumeData: Data,
        to destination: DownloadRequest.DownloadFileDestination? = nil)
        -> DownloadRequest
    {
        return download(.resumeData(resumeData), to: destination)
    }

    // MARK: Private - Download Implementation

    private func download(
        _ downloadable: DownloadRequest.Downloadable,
        to destination: DownloadRequest.DownloadFileDestination?)
        -> DownloadRequest
    {
        do {
            let task = try downloadable.task(session: session, adapter: adapter, queue: queue)
            let download = DownloadRequest(session: session, requestTask: .download(downloadable, task))

            download.downloadDelegate.destination = destination

            delegate[task] = download

            if startRequestsImmediately { download.resume() }

            return download
        } catch {
            return download(downloadable, to: destination, failedWith: error)
        }
    }

    private func download(
        _ downloadable: DownloadRequest.Downloadable?,
        to destination: DownloadRequest.DownloadFileDestination?,
        failedWith error: Error)
        -> DownloadRequest
    {
        var downloadTask: Request.RequestTask = .download(nil, nil)

        if let downloadable = downloadable {
            downloadTask = .download(downloadable, nil)
        }

        let underlyingError = error.underlyingAdaptError ?? error

        let download = DownloadRequest(session: session, requestTask: downloadTask, error: underlyingError)
        download.downloadDelegate.destination = destination

        if let retrier = retrier, error is AdaptError {
            allowRetrier(retrier, toRetry: download, with: underlyingError)
        } else {
            if startRequestsImmediately { download.resume() }
        }

        return download
    }

    // MARK: - Upload Request

    // MARK: File

    /// Creates an `UploadRequest` from the specified `url`, `method` and `headers` for uploading the `file`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter file:    The file to upload.
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method. `.post` by default.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    open func upload(
        _ fileURL: URL,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil)
        -> UploadRequest
    {
        do {
            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
            return upload(fileURL, with: urlRequest)
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    /// Creates a `UploadRequest` from the specified `urlRequest` for uploading the `file`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter file:       The file to upload.
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    open func upload(_ fileURL: URL, with urlRequest: URLRequestConvertible) -> UploadRequest {
        do {
            let urlRequest = try urlRequest.asURLRequest()
            return upload(.file(fileURL, urlRequest))
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    // MARK: Data

    /// Creates an `UploadRequest` from the specified `url`, `method` and `headers` for uploading the `data`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter data:    The data to upload.
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method. `.post` by default.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    open func upload(
        _ data: Data,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil)
        -> UploadRequest
    {
        do {
            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
            return upload(data, with: urlRequest)
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    /// Creates an `UploadRequest` from the specified `urlRequest` for uploading the `data`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter data:       The data to upload.
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    open func upload(_ data: Data, with urlRequest: URLRequestConvertible) -> UploadRequest {
        do {
            let urlRequest = try urlRequest.asURLRequest()
            return upload(.data(data, urlRequest))
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    // MARK: InputStream

    /// Creates an `UploadRequest` from the specified `url`, `method` and `headers` for uploading the `stream`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter stream:  The stream to upload.
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method. `.post` by default.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    open func upload(
        _ stream: InputStream,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil)
        -> UploadRequest
    {
        do {
            let urlRequest = try URLRequest(url: url, method: method, headers: headers)
            return upload(stream, with: urlRequest)
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    /// Creates an `UploadRequest` from the specified `urlRequest` for uploading the `stream`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter stream:     The stream to upload.
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    open func upload(_ stream: InputStream, with urlRequest: URLRequestConvertible) -> UploadRequest {
        do {
            let urlRequest = try urlRequest.asURLRequest()
            return upload(.stream(stream, urlRequest))
        } catch {
            return upload(nil, failedWith: error)
        }
    }

    // MARK: MultipartFormData

    /// Encodes `multipartFormData` using `encodingMemoryThreshold` and calls `encodingCompletion` with new
    /// `UploadRequest` using the `url`, `method` and `headers`.
    ///
    /// It is important to understand the memory implications of uploading `MultipartFormData`. If the cummulative
    /// payload is small, encoding the data in-memory and directly uploading to a server is the by far the most
    /// efficient approach. However, if the payload is too large, encoding the data in-memory could cause your app to
    /// be terminated. Larger payloads must first be written to disk using input and output streams to keep the memory
    /// footprint low, then the data can be uploaded as a stream from the resulting file. Streaming from disk MUST be
    /// used for larger payloads such as video content.
    ///
    /// The `encodingMemoryThreshold` parameter allows Alamofire to automatically determine whether to encode in-memory
    /// or stream from disk. If the content length of the `MultipartFormData` is below the `encodingMemoryThreshold`,
    /// encoding takes place in-memory. If the content length exceeds the threshold, the data is streamed to disk
    /// during the encoding process. Then the result is uploaded as data or as a stream depending on which encoding
    /// technique was used.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
    /// - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
    ///                                      `multipartFormDataEncodingMemoryThreshold` by default.
    /// - parameter url:                     The URL.
    /// - parameter method:                  The HTTP method. `.post` by default.
    /// - parameter headers:                 The HTTP headers. `nil` by default.
    /// - parameter encodingCompletion:      The closure called when the `MultipartFormData` encoding is complete.
    open func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil,
        encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)?)
    {
        do {
            let urlRequest = try URLRequest(url: url, method: method, headers: headers)

            return upload(
                multipartFormData: multipartFormData,
                usingThreshold: encodingMemoryThreshold,
                with: urlRequest,
                encodingCompletion: encodingCompletion
            )
        } catch {
            DispatchQueue.main.async { encodingCompletion?(.failure(error)) }
        }
    }

    /// Encodes `multipartFormData` using `encodingMemoryThreshold` and calls `encodingCompletion` with new
    /// `UploadRequest` using the `urlRequest`.
    ///
    /// It is important to understand the memory implications of uploading `MultipartFormData`. If the cummulative
    /// payload is small, encoding the data in-memory and directly uploading to a server is the by far the most
    /// efficient approach. However, if the payload is too large, encoding the data in-memory could cause your app to
    /// be terminated. Larger payloads must first be written to disk using input and output streams to keep the memory
    /// footprint low, then the data can be uploaded as a stream from the resulting file. Streaming from disk MUST be
    /// used for larger payloads such as video content.
    ///
    /// The `encodingMemoryThreshold` parameter allows Alamofire to automatically determine whether to encode in-memory
    /// or stream from disk. If the content length of the `MultipartFormData` is below the `encodingMemoryThreshold`,
    /// encoding takes place in-memory. If the content length exceeds the threshold, the data is streamed to disk
    /// during the encoding process. Then the result is uploaded as data or as a stream depending on which encoding
    /// technique was used.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
    /// - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
    ///                                      `multipartFormDataEncodingMemoryThreshold` by default.
    /// - parameter urlRequest:              The URL request.
    /// - parameter encodingCompletion:      The closure called when the `MultipartFormData` encoding is complete.
    open func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
        with urlRequest: URLRequestConvertible,
        encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)?)
    {
        DispatchQueue.global(qos: .utility).async {
            let formData = MultipartFormData()
            multipartFormData(formData)

            var tempFileURL: URL?

            do {
                var urlRequestWithContentType = try urlRequest.asURLRequest()
                urlRequestWithContentType.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")

                let isBackgroundSession = self.session.configuration.identifier != nil

                if formData.contentLength < encodingMemoryThreshold && !isBackgroundSession {
                    let data = try formData.encode()

                    let encodingResult = MultipartFormDataEncodingResult.success(
                        request: self.upload(data, with: urlRequestWithContentType),
                        streamingFromDisk: false,
                        streamFileURL: nil
                    )

                    DispatchQueue.main.async { encodingCompletion?(encodingResult) }
                } else {
                    let fileManager = FileManager.default
                    let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
                    let directoryURL = tempDirectoryURL.appendingPathComponent("org.alamofire.manager/multipart.form.data")
                    let fileName = UUID().uuidString
                    let fileURL = directoryURL.appendingPathComponent(fileName)

                    tempFileURL = fileURL

                    var directoryError: Error?

                    // Create directory inside serial queue to ensure two threads don't do this in parallel
                    self.queue.sync {
                        do {
                            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                        } catch {
                            directoryError = error
                        }
                    }

                    if let directoryError = directoryError { throw directoryError }

                    try formData.writeEncodedData(to: fileURL)

                    let upload = self.upload(fileURL, with: urlRequestWithContentType)

                    // Cleanup the temp file once the upload is complete
                    upload.delegate.queue.addOperation {
                        do {
                            try FileManager.default.removeItem(at: fileURL)
                        } catch {
                            // No-op
                        }
                    }

                    DispatchQueue.main.async {
                        let encodingResult = MultipartFormDataEncodingResult.success(
                            request: upload,
                            streamingFromDisk: true,
                            streamFileURL: fileURL
                        )

                        encodingCompletion?(encodingResult)
                    }
                }
            } catch {
                // Cleanup the temp file in the event that the multipart form data encoding failed
                if let tempFileURL = tempFileURL {
                    do {
                        try FileManager.default.removeItem(at: tempFileURL)
                    } catch {
                        // No-op
                    }
                }

                DispatchQueue.main.async { encodingCompletion?(.failure(error)) }
            }
        }
    }

    // MARK: Private - Upload Implementation

    private func upload(_ uploadable: UploadRequest.Uploadable) -> UploadRequest {
        do {
            let task = try uploadable.task(session: session, adapter: adapter, queue: queue)
            let upload = UploadRequest(session: session, requestTask: .upload(uploadable, task))

            if case let .stream(inputStream, _) = uploadable {
                upload.delegate.taskNeedNewBodyStream = { _, _ in inputStream }
            }

            delegate[task] = upload

            if startRequestsImmediately { upload.resume() }

            return upload
        } catch {
            return upload(uploadable, failedWith: error)
        }
    }

    private func upload(_ uploadable: UploadRequest.Uploadable?, failedWith error: Error) -> UploadRequest {
        var uploadTask: Request.RequestTask = .upload(nil, nil)

        if let uploadable = uploadable {
            uploadTask = .upload(uploadable, nil)
        }

        let underlyingError = error.underlyingAdaptError ?? error
        let upload = UploadRequest(session: session, requestTask: uploadTask, error: underlyingError)

        if let retrier = retrier, error is AdaptError {
            allowRetrier(retrier, toRetry: upload, with: underlyingError)
        } else {
            if startRequestsImmediately { upload.resume() }
        }

        return upload
    }

#if !os(watchOS)

    // MARK: - Stream Request

    // MARK: Hostname and Port

    /// Creates a `StreamRequest` for bidirectional streaming using the `hostname` and `port`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter hostName: The hostname of the server to connect to.
    /// - parameter port:     The port of the server to connect to.
    ///
    /// - returns: The created `StreamRequest`.
    @discardableResult
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open func stream(withHostName hostName: String, port: Int) -> StreamRequest {
        return stream(.stream(hostName: hostName, port: port))
    }

    // MARK: NetService

    /// Creates a `StreamRequest` for bidirectional streaming using the `netService`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter netService: The net service used to identify the endpoint.
    ///
    /// - returns: The created `StreamRequest`.
    @discardableResult
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open func stream(with netService: NetService) -> StreamRequest {
        return stream(.netService(netService))
    }

    // MARK: Private - Stream Implementation

    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    private func stream(_ streamable: StreamRequest.Streamable) -> StreamRequest {
        do {
            let task = try streamable.task(session: session, adapter: adapter, queue: queue)
            let request = StreamRequest(session: session, requestTask: .stream(streamable, task))

            delegate[task] = request

            if startRequestsImmediately { request.resume() }

            return request
        } catch {
            return stream(failedWith: error)
        }
    }

    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    private func stream(failedWith error: Error) -> StreamRequest {
        let stream = StreamRequest(session: session, requestTask: .stream(nil, nil), error: error)
        if startRequestsImmediately { stream.resume() }
        return stream
    }

#endif

    // MARK: - Internal - Retry Request

    func retry(_ request: Request) -> Bool {
        guard let originalTask = request.originalTask else { return false }

        do {
            let task = try originalTask.task(session: session, adapter: adapter, queue: queue)

            request.delegate.task = task // resets all task delegate data

            request.retryCount += 1
            request.startTime = CFAbsoluteTimeGetCurrent()
            request.endTime = nil

            task.resume()

            return true
        } catch {
            request.delegate.error = error.underlyingAdaptError ?? error
            return false
        }
    }

    private func allowRetrier(_ retrier: RequestRetrier, toRetry request: Request, with error: Error) {
        DispatchQueue.utility.async { [weak self] in
            guard let strongSelf = self else { return }

            retrier.should(strongSelf, retry: request, with: error) { shouldRetry, timeDelay in
                guard let strongSelf = self else { return }

                guard shouldRetry else {
                    if strongSelf.startRequestsImmediately { request.resume() }
                    return
                }

                let retrySucceeded = strongSelf.retry(request)

                if retrySucceeded, let task = request.task {
                    strongSelf.delegate[task] = request
                } else {
                    if strongSelf.startRequestsImmediately { request.resume() }
                }
            }
        }
    }
}
//
//  TaskDelegate.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// The task delegate is responsible for handling all delegate callbacks for the underlying task as well as
/// executing all operations attached to the serial operation queue upon task completion.
open class TaskDelegate: NSObject {

    // MARK: Properties

    /// The serial operation queue used to execute all operations after the task completes.
    open let queue: OperationQueue

    /// The data returned by the server.
    public var data: Data? { return nil }

    /// The error generated throughout the lifecyle of the task.
    public var error: Error?

    var task: URLSessionTask? {
        didSet { reset() }
    }

    var initialResponseTime: CFAbsoluteTime?
    var credential: URLCredential?
    var metrics: AnyObject? // URLSessionTaskMetrics

    // MARK: Lifecycle

    init(task: URLSessionTask?) {
        self.task = task

        self.queue = {
            let operationQueue = OperationQueue()

            operationQueue.maxConcurrentOperationCount = 1
            operationQueue.isSuspended = true
            operationQueue.qualityOfService = .utility

            return operationQueue
        }()
    }

    func reset() {
        error = nil
        initialResponseTime = nil
    }

    // MARK: URLSessionTaskDelegate

    var taskWillPerformHTTPRedirection: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest) -> URLRequest?)?
    var taskDidReceiveChallenge: ((URLSession, URLSessionTask, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?
    var taskNeedNewBodyStream: ((URLSession, URLSessionTask) -> InputStream?)?
    var taskDidCompleteWithError: ((URLSession, URLSessionTask, Error?) -> Void)?

    @objc(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:)
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void)
    {
        var redirectRequest: URLRequest? = request

        if let taskWillPerformHTTPRedirection = taskWillPerformHTTPRedirection {
            redirectRequest = taskWillPerformHTTPRedirection(session, task, response, request)
        }

        completionHandler(redirectRequest)
    }

    @objc(URLSession:task:didReceiveChallenge:completionHandler:)
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?

        if let taskDidReceiveChallenge = taskDidReceiveChallenge {
            (disposition, credential) = taskDidReceiveChallenge(session, task, challenge)
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let host = challenge.protectionSpace.host

            if
                let serverTrustPolicy = session.serverTrustPolicyManager?.serverTrustPolicy(forHost: host),
                let serverTrust = challenge.protectionSpace.serverTrust
            {
                if serverTrustPolicy.evaluate(serverTrust, forHost: host) {
                    disposition = .useCredential
                    credential = URLCredential(trust: serverTrust)
                } else {
                    disposition = .cancelAuthenticationChallenge
                }
            }
        } else {
            if challenge.previousFailureCount > 0 {
                disposition = .rejectProtectionSpace
            } else {
                credential = self.credential ?? session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)

                if credential != nil {
                    disposition = .useCredential
                }
            }
        }

        completionHandler(disposition, credential)
    }

    @objc(URLSession:task:needNewBodyStream:)
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        needNewBodyStream completionHandler: @escaping (InputStream?) -> Void)
    {
        var bodyStream: InputStream?

        if let taskNeedNewBodyStream = taskNeedNewBodyStream {
            bodyStream = taskNeedNewBodyStream(session, task)
        }

        completionHandler(bodyStream)
    }

    @objc(URLSession:task:didCompleteWithError:)
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let taskDidCompleteWithError = taskDidCompleteWithError {
            taskDidCompleteWithError(session, task, error)
        } else {
            if let error = error {
                if self.error == nil { self.error = error }

                if
                    let downloadDelegate = self as? DownloadTaskDelegate,
                    let resumeData = (error as NSError).userInfo[NSURLSessionDownloadTaskResumeData] as? Data
                {
                    downloadDelegate.resumeData = resumeData
                }
            }

            queue.isSuspended = false
        }
    }
}

// MARK: -

class DataTaskDelegate: TaskDelegate, URLSessionDataDelegate {

    // MARK: Properties

    var dataTask: URLSessionDataTask { return task as! URLSessionDataTask }

    override var data: Data? {
        if dataStream != nil {
            return nil
        } else {
            return mutableData
        }
    }

    var progress: Progress
    var progressHandler: (closure: Request.ProgressHandler, queue: DispatchQueue)?

    var dataStream: ((_ data: Data) -> Void)?

    private var totalBytesReceived: Int64 = 0
    private var mutableData: Data

    private var expectedContentLength: Int64?

    // MARK: Lifecycle

    override init(task: URLSessionTask?) {
        mutableData = Data()
        progress = Progress(totalUnitCount: 0)

        super.init(task: task)
    }

    override func reset() {
        super.reset()

        progress = Progress(totalUnitCount: 0)
        totalBytesReceived = 0
        mutableData = Data()
        expectedContentLength = nil
    }

    // MARK: URLSessionDataDelegate

    var dataTaskDidReceiveResponse: ((URLSession, URLSessionDataTask, URLResponse) -> URLSession.ResponseDisposition)?
    var dataTaskDidBecomeDownloadTask: ((URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?
    var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?
    var dataTaskWillCacheResponse: ((URLSession, URLSessionDataTask, CachedURLResponse) -> CachedURLResponse?)?

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        var disposition: URLSession.ResponseDisposition = .allow

        expectedContentLength = response.expectedContentLength

        if let dataTaskDidReceiveResponse = dataTaskDidReceiveResponse {
            disposition = dataTaskDidReceiveResponse(session, dataTask, response)
        }

        completionHandler(disposition)
    }

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask)
    {
        dataTaskDidBecomeDownloadTask?(session, dataTask, downloadTask)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if initialResponseTime == nil { initialResponseTime = CFAbsoluteTimeGetCurrent() }

        if let dataTaskDidReceiveData = dataTaskDidReceiveData {
            dataTaskDidReceiveData(session, dataTask, data)
        } else {
            if let dataStream = dataStream {
                dataStream(data)
            } else {
                mutableData.append(data)
            }

            let bytesReceived = Int64(data.count)
            totalBytesReceived += bytesReceived
            let totalBytesExpected = dataTask.response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown

            progress.totalUnitCount = totalBytesExpected
            progress.completedUnitCount = totalBytesReceived

            if let progressHandler = progressHandler {
                progressHandler.queue.async { progressHandler.closure(self.progress) }
            }
        }
    }

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        willCacheResponse proposedResponse: CachedURLResponse,
        completionHandler: @escaping (CachedURLResponse?) -> Void)
    {
        var cachedResponse: CachedURLResponse? = proposedResponse

        if let dataTaskWillCacheResponse = dataTaskWillCacheResponse {
            cachedResponse = dataTaskWillCacheResponse(session, dataTask, proposedResponse)
        }

        completionHandler(cachedResponse)
    }
}

// MARK: -

class DownloadTaskDelegate: TaskDelegate, URLSessionDownloadDelegate {

    // MARK: Properties

    var downloadTask: URLSessionDownloadTask { return task as! URLSessionDownloadTask }

    var progress: Progress
    var progressHandler: (closure: Request.ProgressHandler, queue: DispatchQueue)?

    var resumeData: Data?
    override var data: Data? { return resumeData }

    var destination: DownloadRequest.DownloadFileDestination?

    var temporaryURL: URL?
    var destinationURL: URL?

    var fileURL: URL? { return destination != nil ? destinationURL : temporaryURL }

    // MARK: Lifecycle

    override init(task: URLSessionTask?) {
        progress = Progress(totalUnitCount: 0)
        super.init(task: task)
    }

    override func reset() {
        super.reset()

        progress = Progress(totalUnitCount: 0)
        resumeData = nil
    }

    // MARK: URLSessionDownloadDelegate

    var downloadTaskDidFinishDownloadingToURL: ((URLSession, URLSessionDownloadTask, URL) -> URL)?
    var downloadTaskDidWriteData: ((URLSession, URLSessionDownloadTask, Int64, Int64, Int64) -> Void)?
    var downloadTaskDidResumeAtOffset: ((URLSession, URLSessionDownloadTask, Int64, Int64) -> Void)?

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL)
    {
        temporaryURL = location

        guard
            let destination = destination,
            let response = downloadTask.response as? HTTPURLResponse
        else { return }

        let result = destination(location, response)
        let destinationURL = result.destinationURL
        let options = result.options

        self.destinationURL = destinationURL

        do {
            if options.contains(.removePreviousFile), FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }

            if options.contains(.createIntermediateDirectories) {
                let directory = destinationURL.deletingLastPathComponent()
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            }

            try FileManager.default.moveItem(at: location, to: destinationURL)
        } catch {
            self.error = error
        }
    }

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64)
    {
        if initialResponseTime == nil { initialResponseTime = CFAbsoluteTimeGetCurrent() }

        if let downloadTaskDidWriteData = downloadTaskDidWriteData {
            downloadTaskDidWriteData(
                session,
                downloadTask,
                bytesWritten,
                totalBytesWritten,
                totalBytesExpectedToWrite
            )
        } else {
            progress.totalUnitCount = totalBytesExpectedToWrite
            progress.completedUnitCount = totalBytesWritten

            if let progressHandler = progressHandler {
                progressHandler.queue.async { progressHandler.closure(self.progress) }
            }
        }
    }

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64)
    {
        if let downloadTaskDidResumeAtOffset = downloadTaskDidResumeAtOffset {
            downloadTaskDidResumeAtOffset(session, downloadTask, fileOffset, expectedTotalBytes)
        } else {
            progress.totalUnitCount = expectedTotalBytes
            progress.completedUnitCount = fileOffset
        }
    }
}

// MARK: -

class UploadTaskDelegate: DataTaskDelegate {

    // MARK: Properties

    var uploadTask: URLSessionUploadTask { return task as! URLSessionUploadTask }

    var uploadProgress: Progress
    var uploadProgressHandler: (closure: Request.ProgressHandler, queue: DispatchQueue)?

    // MARK: Lifecycle

    override init(task: URLSessionTask?) {
        uploadProgress = Progress(totalUnitCount: 0)
        super.init(task: task)
    }

    override func reset() {
        super.reset()
        uploadProgress = Progress(totalUnitCount: 0)
    }

    // MARK: URLSessionTaskDelegate

    var taskDidSendBodyData: ((URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?

    func URLSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64)
    {
        if initialResponseTime == nil { initialResponseTime = CFAbsoluteTimeGetCurrent() }

        if let taskDidSendBodyData = taskDidSendBodyData {
            taskDidSendBodyData(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
        } else {
            uploadProgress.totalUnitCount = totalBytesExpectedToSend
            uploadProgress.completedUnitCount = totalBytesSent

            if let uploadProgressHandler = uploadProgressHandler {
                uploadProgressHandler.queue.async { uploadProgressHandler.closure(self.uploadProgress) }
            }
        }
    }
}
//
//  Timeline.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// Responsible for computing the timing metrics for the complete lifecycle of a `Request`.
public struct Timeline {
    /// The time the request was initialized.
    public let requestStartTime: CFAbsoluteTime

    /// The time the first bytes were received from or sent to the server.
    public let initialResponseTime: CFAbsoluteTime

    /// The time when the request was completed.
    public let requestCompletedTime: CFAbsoluteTime

    /// The time when the response serialization was completed.
    public let serializationCompletedTime: CFAbsoluteTime

    /// The time interval in seconds from the time the request started to the initial response from the server.
    public let latency: TimeInterval

    /// The time interval in seconds from the time the request started to the time the request completed.
    public let requestDuration: TimeInterval

    /// The time interval in seconds from the time the request completed to the time response serialization completed.
    public let serializationDuration: TimeInterval

    /// The time interval in seconds from the time the request started to the time response serialization completed.
    public let totalDuration: TimeInterval

    /// Creates a new `Timeline` instance with the specified request times.
    ///
    /// - parameter requestStartTime:           The time the request was initialized. Defaults to `0.0`.
    /// - parameter initialResponseTime:        The time the first bytes were received from or sent to the server.
    ///                                         Defaults to `0.0`.
    /// - parameter requestCompletedTime:       The time when the request was completed. Defaults to `0.0`.
    /// - parameter serializationCompletedTime: The time when the response serialization was completed. Defaults
    ///                                         to `0.0`.
    ///
    /// - returns: The new `Timeline` instance.
    public init(
        requestStartTime: CFAbsoluteTime = 0.0,
        initialResponseTime: CFAbsoluteTime = 0.0,
        requestCompletedTime: CFAbsoluteTime = 0.0,
        serializationCompletedTime: CFAbsoluteTime = 0.0)
    {
        self.requestStartTime = requestStartTime
        self.initialResponseTime = initialResponseTime
        self.requestCompletedTime = requestCompletedTime
        self.serializationCompletedTime = serializationCompletedTime

        self.latency = initialResponseTime - requestStartTime
        self.requestDuration = requestCompletedTime - requestStartTime
        self.serializationDuration = serializationCompletedTime - requestCompletedTime
        self.totalDuration = serializationCompletedTime - requestStartTime
    }
}

// MARK: - CustomStringConvertible

extension Timeline: CustomStringConvertible {
    /// The textual representation used when written to an output stream, which includes the latency, the request
    /// duration and the total duration.
    public var description: String {
        let latency = String(format: "%.3f", self.latency)
        let requestDuration = String(format: "%.3f", self.requestDuration)
        let serializationDuration = String(format: "%.3f", self.serializationDuration)
        let totalDuration = String(format: "%.3f", self.totalDuration)

        // NOTE: Had to move to string concatenation due to memory leak filed as rdar://26761490. Once memory leak is
        // fixed, we should move back to string interpolation by reverting commit 7d4a43b1.
        let timings = [
            "\"Latency\": " + latency + " secs",
            "\"Request Duration\": " + requestDuration + " secs",
            "\"Serialization Duration\": " + serializationDuration + " secs",
            "\"Total Duration\": " + totalDuration + " secs"
        ]

        return "Timeline: { " + timings.joined(separator: ", ") + " }"
    }
}

// MARK: - CustomDebugStringConvertible

extension Timeline: CustomDebugStringConvertible {
    /// The textual representation used when written to an output stream, which includes the request start time, the
    /// initial response time, the request completed time, the serialization completed time, the latency, the request
    /// duration and the total duration.
    public var debugDescription: String {
        let requestStartTime = String(format: "%.3f", self.requestStartTime)
        let initialResponseTime = String(format: "%.3f", self.initialResponseTime)
        let requestCompletedTime = String(format: "%.3f", self.requestCompletedTime)
        let serializationCompletedTime = String(format: "%.3f", self.serializationCompletedTime)
        let latency = String(format: "%.3f", self.latency)
        let requestDuration = String(format: "%.3f", self.requestDuration)
        let serializationDuration = String(format: "%.3f", self.serializationDuration)
        let totalDuration = String(format: "%.3f", self.totalDuration)

        // NOTE: Had to move to string concatenation due to memory leak filed as rdar://26761490. Once memory leak is
        // fixed, we should move back to string interpolation by reverting commit 7d4a43b1.
        let timings = [
            "\"Request Start Time\": " + requestStartTime,
            "\"Initial Response Time\": " + initialResponseTime,
            "\"Request Completed Time\": " + requestCompletedTime,
            "\"Serialization Completed Time\": " + serializationCompletedTime,
            "\"Latency\": " + latency + " secs",
            "\"Request Duration\": " + requestDuration + " secs",
            "\"Serialization Duration\": " + serializationDuration + " secs",
            "\"Total Duration\": " + totalDuration + " secs"
        ]

        return "Timeline: { " + timings.joined(separator: ", ") + " }"
    }
}
//
//  Validation.swift
//
//  Copyright (c) 2014-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

extension Request {

    // MARK: Helper Types

    fileprivate typealias ErrorReason = AFError.ResponseValidationFailureReason

    /// Used to represent whether validation was successful or encountered an error resulting in a failure.
    ///
    /// - success: The validation was successful.
    /// - failure: The validation failed encountering the provided error.
    public enum ValidationResult {
        case success
        case failure(Error)
    }

    fileprivate struct MIMEType {
        let type: String
        let subtype: String

        var isWildcard: Bool { return type == "*" && subtype == "*" }

        init?(_ string: String) {
            let components: [String] = {
                let stripped = string.trimmingCharacters(in: .whitespacesAndNewlines)
                let split = stripped.substring(to: stripped.range(of: ";")?.lowerBound ?? stripped.endIndex)
                return split.components(separatedBy: "/")
            }()

            if let type = components.first, let subtype = components.last {
                self.type = type
                self.subtype = subtype
            } else {
                return nil
            }
        }

        func matches(_ mime: MIMEType) -> Bool {
            switch (type, subtype) {
            case (mime.type, mime.subtype), (mime.type, "*"), ("*", mime.subtype), ("*", "*"):
                return true
            default:
                return false
            }
        }
    }

    // MARK: Properties

    fileprivate var acceptableStatusCodes: [Int] { return Array(200..<300) }

    fileprivate var acceptableContentTypes: [String] {
        if let accept = request?.value(forHTTPHeaderField: "Accept") {
            return accept.components(separatedBy: ",")
        }

        return ["*/*"]
    }

    // MARK: Status Code

    fileprivate func validate<S: Sequence>(
        statusCode acceptableStatusCodes: S,
        response: HTTPURLResponse)
        -> ValidationResult
        where S.Iterator.Element == Int
    {
        if acceptableStatusCodes.contains(response.statusCode) {
            return .success
        } else {
            let reason: ErrorReason = .unacceptableStatusCode(code: response.statusCode)
            return .failure(AFError.responseValidationFailed(reason: reason))
        }
    }

    // MARK: Content Type

    fileprivate func validate<S: Sequence>(
        contentType acceptableContentTypes: S,
        response: HTTPURLResponse,
        data: Data?)
        -> ValidationResult
        where S.Iterator.Element == String
    {
        guard let data = data, data.count > 0 else { return .success }

        guard
            let responseContentType = response.mimeType,
            let responseMIMEType = MIMEType(responseContentType)
        else {
            for contentType in acceptableContentTypes {
                if let mimeType = MIMEType(contentType), mimeType.isWildcard {
                    return .success
                }
            }

            let error: AFError = {
                let reason: ErrorReason = .missingContentType(acceptableContentTypes: Array(acceptableContentTypes))
                return AFError.responseValidationFailed(reason: reason)
            }()

            return .failure(error)
        }

        for contentType in acceptableContentTypes {
            if let acceptableMIMEType = MIMEType(contentType), acceptableMIMEType.matches(responseMIMEType) {
                return .success
            }
        }

        let error: AFError = {
            let reason: ErrorReason = .unacceptableContentType(
                acceptableContentTypes: Array(acceptableContentTypes),
                responseContentType: responseContentType
            )

            return AFError.responseValidationFailed(reason: reason)
        }()

        return .failure(error)
    }
}

// MARK: -

extension DataRequest {
    /// A closure used to validate a request that takes a URL request, a URL response and data, and returns whether the
    /// request was valid.
    public typealias Validation = (URLRequest?, HTTPURLResponse, Data?) -> ValidationResult

    /// Validates the request, using the specified closure.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter validation: A closure to validate the request.
    ///
    /// - returns: The request.
    @discardableResult
    public func validate(_ validation: @escaping Validation) -> Self {
        let validationExecution: () -> Void = { [unowned self] in
            if
                let response = self.response,
                self.delegate.error == nil,
                case let .failure(error) = validation(self.request, response, self.delegate.data)
            {
                self.delegate.error = error
            }
        }

        validations.append(validationExecution)

        return self
    }

    /// Validates that the response has a status code in the specified sequence.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter range: The range of acceptable status codes.
    ///
    /// - returns: The request.
    @discardableResult
    public func validate<S: Sequence>(statusCode acceptableStatusCodes: S) -> Self where S.Iterator.Element == Int {
        return validate { [unowned self] _, response, _ in
            return self.validate(statusCode: acceptableStatusCodes, response: response)
        }
    }

    /// Validates that the response has a content type in the specified sequence.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter contentType: The acceptable content types, which may specify wildcard types and/or subtypes.
    ///
    /// - returns: The request.
    @discardableResult
    public func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Self where S.Iterator.Element == String {
        return validate { [unowned self] _, response, data in
            return self.validate(contentType: acceptableContentTypes, response: response, data: data)
        }
    }

    /// Validates that the response has a status code in the default acceptable range of 200...299, and that the content
    /// type matches any specified in the Accept HTTP header field.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - returns: The request.
    @discardableResult
    public func validate() -> Self {
        return validate(statusCode: self.acceptableStatusCodes).validate(contentType: self.acceptableContentTypes)
    }
}

// MARK: -

extension DownloadRequest {
    /// A closure used to validate a request that takes a URL request, a URL response, a temporary URL and a
    /// destination URL, and returns whether the request was valid.
    public typealias Validation = (
        _ request: URLRequest?,
        _ response: HTTPURLResponse,
        _ temporaryURL: URL?,
        _ destinationURL: URL?)
        -> ValidationResult

    /// Validates the request, using the specified closure.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter validation: A closure to validate the request.
    ///
    /// - returns: The request.
    @discardableResult
    public func validate(_ validation: @escaping Validation) -> Self {
        let validationExecution: () -> Void = { [unowned self] in
            let request = self.request
            let temporaryURL = self.downloadDelegate.temporaryURL
            let destinationURL = self.downloadDelegate.destinationURL

            if
                let response = self.response,
                self.delegate.error == nil,
                case let .failure(error) = validation(request, response, temporaryURL, destinationURL)
            {
                self.delegate.error = error
            }
        }

        validations.append(validationExecution)

        return self
    }

    /// Validates that the response has a status code in the specified sequence.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter range: The range of acceptable status codes.
    ///
    /// - returns: The request.
    @discardableResult
    public func validate<S: Sequence>(statusCode acceptableStatusCodes: S) -> Self where S.Iterator.Element == Int {
        return validate { [unowned self] _, response, _, _ in
            return self.validate(statusCode: acceptableStatusCodes, response: response)
        }
    }

    /// Validates that the response has a content type in the specified sequence.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - parameter contentType: The acceptable content types, which may specify wildcard types and/or subtypes.
    ///
    /// - returns: The request.
    @discardableResult
    public func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Self where S.Iterator.Element == String {
        return validate { [unowned self] _, response, _, _ in
            let fileURL = self.downloadDelegate.fileURL

            guard let validFileURL = fileURL else {
                return .failure(AFError.responseValidationFailed(reason: .dataFileNil))
            }

            do {
                let data = try Data(contentsOf: validFileURL)
                return self.validate(contentType: acceptableContentTypes, response: response, data: data)
            } catch {
                return .failure(AFError.responseValidationFailed(reason: .dataFileReadFailed(at: validFileURL)))
            }
        }
    }

    /// Validates that the response has a status code in the default acceptable range of 200...299, and that the content
    /// type matches any specified in the Accept HTTP header field.
    ///
    /// If validation fails, subsequent calls to response handlers will have an associated error.
    ///
    /// - returns: The request.
    @discardableResult
    public func validate() -> Self {
        return validate(statusCode: self.acceptableStatusCodes).validate(contentType: self.acceptableContentTypes)
    }
}
//
//  AFIError.swift
//
//  Copyright (c) 2015-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

/// `AFIError` is the error type returned by AlamofireImage.
///
/// - requestCancelled:         The request was explicitly cancelled.
/// - imageSerializationFailed: Response data could not be serialized into an image.
public enum AFIError: Error {
    case requestCancelled
    case imageSerializationFailed
}

// MARK: - Error Booleans

extension AFIError {
    /// Returns `true` if the `AFIError` is a request cancellation error, `false` otherwise.
    public var isRequestCancelledError: Bool {
        if case .requestCancelled = self { return true }
        return false
    }

    /// Returns `true` if the `AFIError` is an image serialization error, `false` otherwise.
    public var isImageSerializationFailedError: Bool {
        if case .imageSerializationFailed = self { return true }
        return false
    }
}

// MARK: - Error Descriptions

extension AFIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestCancelled:
            return "The request was explicitly cancelled."
        case .imageSerializationFailed:
            return "Response data could not be serialized into an image."
        }
    }
}
//
//  Image.swift
//
//  Copyright (c) 2015-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
public typealias Image = UIImage
#elseif os(macOS)
import Cocoa
public typealias Image = NSImage
#endif
//
//  ImageCache.swift
//
//  Copyright (c) 2015-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Alamofire
import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

// MARK: ImageCache

/// The `ImageCache` protocol defines a set of APIs for adding, removing and fetching images from a cache.
public protocol ImageCache {
    /// Adds the image to the cache with the given identifier.
    func add(_ image: Image, withIdentifier identifier: String)

    /// Removes the image from the cache matching the given identifier.
    func removeImage(withIdentifier identifier: String) -> Bool

    /// Removes all images stored in the cache.
    @discardableResult
    func removeAllImages() -> Bool

    /// Returns the image in the cache associated with the given identifier.
    func image(withIdentifier identifier: String) -> Image?
}

/// The `ImageRequestCache` protocol extends the `ImageCache` protocol by adding methods for adding, removing and
/// fetching images from a cache given an `URLRequest` and additional identifier.
public protocol ImageRequestCache: ImageCache {
    /// Adds the image to the cache using an identifier created from the request and identifier.
    func add(_ image: Image, for request: URLRequest, withIdentifier identifier: String?)

    /// Removes the image from the cache using an identifier created from the request and identifier.
    func removeImage(for request: URLRequest, withIdentifier identifier: String?) -> Bool

    /// Returns the image from the cache associated with an identifier created from the request and identifier.
    func image(for request: URLRequest, withIdentifier identifier: String?) -> Image?
}

// MARK: -

/// The `AutoPurgingImageCache` in an in-memory image cache used to store images up to a given memory capacity. When
/// the memory capacity is reached, the image cache is sorted by last access date, then the oldest image is continuously
/// purged until the preferred memory usage after purge is met. Each time an image is accessed through the cache, the
/// internal access date of the image is updated.
open class AutoPurgingImageCache: ImageRequestCache {
    class CachedImage {
        let image: Image
        let identifier: String
        let totalBytes: UInt64
        var lastAccessDate: Date

        init(_ image: Image, identifier: String) {
            self.image = image
            self.identifier = identifier
            self.lastAccessDate = Date()

            self.totalBytes = {
                #if os(iOS) || os(tvOS) || os(watchOS)
                    let size = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
                #elseif os(macOS)
                    let size = CGSize(width: image.size.width, height: image.size.height)
                #endif

                let bytesPerPixel: CGFloat = 4.0
                let bytesPerRow = size.width * bytesPerPixel
                let totalBytes = UInt64(bytesPerRow) * UInt64(size.height)

                return totalBytes
            }()
        }

        func accessImage() -> Image {
            lastAccessDate = Date()
            return image
        }
    }

    // MARK: Properties

    /// The current total memory usage in bytes of all images stored within the cache.
    open var memoryUsage: UInt64 {
        var memoryUsage: UInt64 = 0
        synchronizationQueue.sync { memoryUsage = self.currentMemoryUsage }

        return memoryUsage
    }

    /// The total memory capacity of the cache in bytes.
    open let memoryCapacity: UInt64

    /// The preferred memory usage after purge in bytes. During a purge, images will be purged until the memory
    /// capacity drops below this limit.
    open let preferredMemoryUsageAfterPurge: UInt64

    private let synchronizationQueue: DispatchQueue
    private var cachedImages: [String: CachedImage]
    private var currentMemoryUsage: UInt64

    // MARK: Initialization

    /// Initialies the `AutoPurgingImageCache` instance with the given memory capacity and preferred memory usage
    /// after purge limit.
    ///
    /// Please note, the memory capacity must always be greater than or equal to the preferred memory usage after purge.
    ///
    /// - parameter memoryCapacity:                 The total memory capacity of the cache in bytes. `100 MB` by default.
    /// - parameter preferredMemoryUsageAfterPurge: The preferred memory usage after purge in bytes. `60 MB` by default.
    ///
    /// - returns: The new `AutoPurgingImageCache` instance.
    public init(memoryCapacity: UInt64 = 100_000_000, preferredMemoryUsageAfterPurge: UInt64 = 60_000_000) {
        self.memoryCapacity = memoryCapacity
        self.preferredMemoryUsageAfterPurge = preferredMemoryUsageAfterPurge

        precondition(
            memoryCapacity >= preferredMemoryUsageAfterPurge,
            "The `memoryCapacity` must be greater than or equal to `preferredMemoryUsageAfterPurge`"
        )

        self.cachedImages = [:]
        self.currentMemoryUsage = 0

        self.synchronizationQueue = {
            let name = String(format: "org.alamofire.autopurgingimagecache-%08x%08x", arc4random(), arc4random())
            return DispatchQueue(label: name, attributes: .concurrent)
        }()

        #if os(iOS) || os(tvOS)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(AutoPurgingImageCache.removeAllImages),
                name: Notification.Name.UIApplicationDidReceiveMemoryWarning,
                object: nil
            )
        #endif
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Add Image to Cache

    /// Adds the image to the cache using an identifier created from the request and optional identifier.
    ///
    /// - parameter image:      The image to add to the cache.
    /// - parameter request:    The request used to generate the image's unique identifier.
    /// - parameter identifier: The additional identifier to append to the image's unique identifier.
    open func add(_ image: Image, for request: URLRequest, withIdentifier identifier: String? = nil) {
        let requestIdentifier = imageCacheKey(for: request, withIdentifier: identifier)
        add(image, withIdentifier: requestIdentifier)
    }

    /// Adds the image to the cache with the given identifier.
    ///
    /// - parameter image:      The image to add to the cache.
    /// - parameter identifier: The identifier to use to uniquely identify the image.
    open func add(_ image: Image, withIdentifier identifier: String) {
        synchronizationQueue.async(flags: [.barrier]) {
            let cachedImage = CachedImage(image, identifier: identifier)

            if let previousCachedImage = self.cachedImages[identifier] {
                self.currentMemoryUsage -= previousCachedImage.totalBytes
            }

            self.cachedImages[identifier] = cachedImage
            self.currentMemoryUsage += cachedImage.totalBytes
        }

        synchronizationQueue.async(flags: [.barrier]) {
            if self.currentMemoryUsage > self.memoryCapacity {
                let bytesToPurge = self.currentMemoryUsage - self.preferredMemoryUsageAfterPurge


                var sortedImages = self.cachedImages.map{$1}
                sortedImages.sort {
                    let date1 = $0.lastAccessDate
                    let date2 = $1.lastAccessDate

                    return date1.timeIntervalSince(date2) < 0.0
                }

                var bytesPurged = UInt64(0)

                for cachedImage in sortedImages {
                    self.cachedImages.removeValue(forKey: cachedImage.identifier)
                    bytesPurged += cachedImage.totalBytes

                    if bytesPurged >= bytesToPurge {
                        break
                    }
                }

                self.currentMemoryUsage -= bytesPurged
            }
        }
    }

    // MARK: Remove Image from Cache

    /// Removes the image from the cache using an identifier created from the request and optional identifier.
    ///
    /// - parameter request:    The request used to generate the image's unique identifier.
    /// - parameter identifier: The additional identifier to append to the image's unique identifier.
    ///
    /// - returns: `true` if the image was removed, `false` otherwise.
    @discardableResult
    open func removeImage(for request: URLRequest, withIdentifier identifier: String?) -> Bool {
        let requestIdentifier = imageCacheKey(for: request, withIdentifier: identifier)
        return removeImage(withIdentifier: requestIdentifier)
    }

    /// Removes all images from the cache created from the request.
    ///
    /// - parameter request: The request used to generate the image's unique identifier.
    ///
    /// - returns: `true` if any images were removed, `false` otherwise.
    @discardableResult
    open func removeImages(matching request: URLRequest) -> Bool {
        let requestIdentifier = imageCacheKey(for: request, withIdentifier: nil)
        var removed = false

        synchronizationQueue.sync {
            for key in self.cachedImages.keys where key.hasPrefix(requestIdentifier) {
                if let cachedImage = self.cachedImages.removeValue(forKey: key) {
                    self.currentMemoryUsage -= cachedImage.totalBytes
                    removed = true
                }
            }
        }

        return removed
    }

    /// Removes the image from the cache matching the given identifier.
    ///
    /// - parameter identifier: The unique identifier for the image.
    ///
    /// - returns: `true` if the image was removed, `false` otherwise.
    @discardableResult
    open func removeImage(withIdentifier identifier: String) -> Bool {
        var removed = false

        synchronizationQueue.sync {
            if let cachedImage = self.cachedImages.removeValue(forKey: identifier) {
                self.currentMemoryUsage -= cachedImage.totalBytes
                removed = true
            }
        }

        return removed
    }

    /// Removes all images stored in the cache.
    ///
    /// - returns: `true` if images were removed from the cache, `false` otherwise.
    @discardableResult @objc
    open func removeAllImages() -> Bool {
        var removed = false

        synchronizationQueue.sync {
            if !self.cachedImages.isEmpty {
                self.cachedImages.removeAll()
                self.currentMemoryUsage = 0

                removed = true
            }
        }

        return removed
    }

    // MARK: Fetch Image from Cache

    /// Returns the image from the cache associated with an identifier created from the request and optional identifier.
    ///
    /// - parameter request:    The request used to generate the image's unique identifier.
    /// - parameter identifier: The additional identifier to append to the image's unique identifier.
    ///
    /// - returns: The image if it is stored in the cache, `nil` otherwise.
    open func image(for request: URLRequest, withIdentifier identifier: String? = nil) -> Image? {
        let requestIdentifier = imageCacheKey(for: request, withIdentifier: identifier)
        return image(withIdentifier: requestIdentifier)
    }

    /// Returns the image in the cache associated with the given identifier.
    ///
    /// - parameter identifier: The unique identifier for the image.
    ///
    /// - returns: The image if it is stored in the cache, `nil` otherwise.
    open func image(withIdentifier identifier: String) -> Image? {
        var image: Image?

        synchronizationQueue.sync {
            if let cachedImage = self.cachedImages[identifier] {
                image = cachedImage.accessImage()
            }
        }

        return image
    }

    // MARK: Image Cache Keys

    /// Returns the unique image cache key for the specified request and additional identifier.
    ///
    /// - parameter request:    The request.
    /// - parameter identifier: The additional identifier.
    ///
    /// - returns: The unique image cache key.
    open func imageCacheKey(for request: URLRequest, withIdentifier identifier: String?) -> String {
        var key = request.url?.absoluteString ?? ""

        if let identifier = identifier {
            key += "-\(identifier)"
        }

        return key
    }
}
//
//  ImageDownloader.swift
//
//  Copyright (c) 2015-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Alamofire
import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

/// The `RequestReceipt` is an object vended by the `ImageDownloader` when starting a download request. It can be used
/// to cancel active requests running on the `ImageDownloader` session. As a general rule, image download requests
/// should be cancelled using the `RequestReceipt` instead of calling `cancel` directly on the `request` itself. The
/// `ImageDownloader` is optimized to handle duplicate request scenarios as well as pending versus active downloads.
open class RequestReceipt {
    /// The download request created by the `ImageDownloader`.
    open let request: Request

    /// The unique identifier for the image filters and completion handlers when duplicate requests are made.
    open let receiptID: String

    init(request: Request, receiptID: String) {
        self.request = request
        self.receiptID = receiptID
    }
}

// MARK: -

/// The `ImageDownloader` class is responsible for downloading images in parallel on a prioritized queue. Incoming
/// downloads are added to the front or back of the queue depending on the download prioritization. Each downloaded
/// image is cached in the underlying `NSURLCache` as well as the in-memory image cache that supports image filters.
/// By default, any download request with a cached image equivalent in the image cache will automatically be served the
/// cached image representation. Additional advanced features include supporting multiple image filters and completion
/// handlers for a single request.
open class ImageDownloader {
    /// The completion handler closure used when an image download completes.
    public typealias CompletionHandler = (DataResponse<Image>) -> Void

    /// The progress handler closure called periodically during an image download.
    public typealias ProgressHandler = DataRequest.ProgressHandler

    // MARK: Helper Types

    /// Defines the order prioritization of incoming download requests being inserted into the queue.
    ///
    /// - fifo: All incoming downloads are added to the back of the queue.
    /// - lifo: All incoming downloads are added to the front of the queue.
    public enum DownloadPrioritization {
        case fifo, lifo
    }

    class ResponseHandler {
        let urlID: String
        let handlerID: String
        let request: DataRequest
        var operations: [(receiptID: String, filter: ImageFilter?, completion: CompletionHandler?)]

        init(
            request: DataRequest,
            handlerID: String,
            receiptID: String,
            filter: ImageFilter?,
            completion: CompletionHandler?)
        {
            self.request = request
            self.urlID = ImageDownloader.urlIdentifier(for: request.request!)
            self.handlerID = handlerID
            self.operations = [(receiptID: receiptID, filter: filter, completion: completion)]
        }
    }

    // MARK: Properties

    /// The image cache used to store all downloaded images in.
    open let imageCache: ImageRequestCache?

    /// The credential used for authenticating each download request.
    open private(set) var credential: URLCredential?

    /// Response serializer used to convert the image data to UIImage.
    public var imageResponseSerializer = DataRequest.imageResponseSerializer()

    /// The underlying Alamofire `Manager` instance used to handle all download requests.
    open let sessionManager: SessionManager

    let downloadPrioritization: DownloadPrioritization
    let maximumActiveDownloads: Int

    var activeRequestCount = 0
    var queuedRequests: [Request] = []
    var responseHandlers: [String: ResponseHandler] = [:]

    private let synchronizationQueue: DispatchQueue = {
        let name = String(format: "org.alamofire.imagedownloader.synchronizationqueue-%08x%08x", arc4random(), arc4random())
        return DispatchQueue(label: name)
    }()

    private let responseQueue: DispatchQueue = {
        let name = String(format: "org.alamofire.imagedownloader.responsequeue-%08x%08x", arc4random(), arc4random())
        return DispatchQueue(label: name, attributes: .concurrent)
    }()

    // MARK: Initialization

    /// The default instance of `ImageDownloader` initialized with default values.
    open static let `default` = ImageDownloader()

    /// Creates a default `URLSessionConfiguration` with common usage parameter values.
    ///
    /// - returns: The default `URLSessionConfiguration` instance.
    open class func defaultURLSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default

        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.httpShouldSetCookies = true
        configuration.httpShouldUsePipelining = false

        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 60

        configuration.urlCache = ImageDownloader.defaultURLCache()

        return configuration
    }

    /// Creates a default `URLCache` with common usage parameter values.
    ///
    /// - returns: The default `URLCache` instance.
    open class func defaultURLCache() -> URLCache {
        return URLCache(
            memoryCapacity: 20 * 1024 * 1024, // 20 MB
            diskCapacity: 150 * 1024 * 1024,  // 150 MB
            diskPath: "org.alamofire.imagedownloader"
        )
    }

    /// Initializes the `ImageDownloader` instance with the given configuration, download prioritization, maximum active
    /// download count and image cache.
    ///
    /// - parameter configuration:          The `URLSessionConfiguration` to use to create the underlying Alamofire
    ///                                     `SessionManager` instance.
    /// - parameter downloadPrioritization: The download prioritization of the download queue. `.fifo` by default.
    /// - parameter maximumActiveDownloads: The maximum number of active downloads allowed at any given time.
    /// - parameter imageCache:             The image cache used to store all downloaded images in.
    ///
    /// - returns: The new `ImageDownloader` instance.
    public init(
        configuration: URLSessionConfiguration = ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: DownloadPrioritization = .fifo,
        maximumActiveDownloads: Int = 4,
        imageCache: ImageRequestCache? = AutoPurgingImageCache())
    {
        self.sessionManager = SessionManager(configuration: configuration)
        self.sessionManager.startRequestsImmediately = false

        self.downloadPrioritization = downloadPrioritization
        self.maximumActiveDownloads = maximumActiveDownloads
        self.imageCache = imageCache
    }

    /// Initializes the `ImageDownloader` instance with the given session manager, download prioritization, maximum
    /// active download count and image cache.
    ///
    /// - parameter sessionManager:         The Alamofire `SessionManager` instance to handle all download requests.
    /// - parameter downloadPrioritization: The download prioritization of the download queue. `.fifo` by default.
    /// - parameter maximumActiveDownloads: The maximum number of active downloads allowed at any given time.
    /// - parameter imageCache:             The image cache used to store all downloaded images in.
    ///
    /// - returns: The new `ImageDownloader` instance.
    public init(
        sessionManager: SessionManager,
        downloadPrioritization: DownloadPrioritization = .fifo,
        maximumActiveDownloads: Int = 4,
        imageCache: ImageRequestCache? = AutoPurgingImageCache())
    {
        self.sessionManager = sessionManager
        self.sessionManager.startRequestsImmediately = false

        self.downloadPrioritization = downloadPrioritization
        self.maximumActiveDownloads = maximumActiveDownloads
        self.imageCache = imageCache
    }

    // MARK: Authentication

    /// Associates an HTTP Basic Auth credential with all future download requests.
    ///
    /// - parameter user:        The user.
    /// - parameter password:    The password.
    /// - parameter persistence: The URL credential persistence. `.forSession` by default.
    open func addAuthentication(
        user: String,
        password: String,
        persistence: URLCredential.Persistence = .forSession)
    {
        let credential = URLCredential(user: user, password: password, persistence: persistence)
        addAuthentication(usingCredential: credential)
    }

    /// Associates the specified credential with all future download requests.
    ///
    /// - parameter credential: The credential.
    open func addAuthentication(usingCredential credential: URLCredential) {
        synchronizationQueue.sync {
            self.credential = credential
        }
    }

    // MARK: Download

    /// Creates a download request using the internal Alamofire `SessionManager` instance for the specified URL request.
    ///
    /// If the same download request is already in the queue or currently being downloaded, the filter and completion
    /// handler are appended to the already existing request. Once the request completes, all filters and completion
    /// handlers attached to the request are executed in the order they were added. Additionally, any filters attached
    /// to the request with the same identifiers are only executed once. The resulting image is then passed into each
    /// completion handler paired with the filter.
    ///
    /// You should not attempt to directly cancel the `request` inside the request receipt since other callers may be
    /// relying on the completion of that request. Instead, you should call `cancelRequestForRequestReceipt` with the
    /// returned request receipt to allow the `ImageDownloader` to optimize the cancellation on behalf of all active
    /// callers.
    ///
    /// - parameter urlRequest:     The URL request.
    /// - parameter receiptID:      The `identifier` for the `RequestReceipt` returned. Defaults to a new, randomly
    ///                             generated UUID.
    /// - parameter filter:         The image filter to apply to the image after the download is complete. Defaults
    ///                             to `nil`.
    /// - parameter progress:       The closure to be executed periodically during the lifecycle of the request.
    ///                             Defaults to `nil`.
    /// - parameter progressQueue:  The dispatch queue to call the progress closure on. Defaults to the main queue.
    /// - parameter completion:     The closure called when the download request is complete. Defaults to `nil`.
    ///
    /// - returns: The request receipt for the download request if available. `nil` if the image is stored in the image
    ///            cache and the URL request cache policy allows the cache to be used.
    @discardableResult
    open func download(
        _ urlRequest: URLRequestConvertible,
        receiptID: String = UUID().uuidString,
        filter: ImageFilter? = nil,
        progress: ProgressHandler? = nil,
        progressQueue: DispatchQueue = DispatchQueue.main,
        completion: CompletionHandler?)
        -> RequestReceipt?
    {
        var request: DataRequest!

        synchronizationQueue.sync {
            // 1) Append the filter and completion handler to a pre-existing request if it already exists
            let urlID = ImageDownloader.urlIdentifier(for: urlRequest)

            if let responseHandler = self.responseHandlers[urlID] {
                responseHandler.operations.append(receiptID: receiptID, filter: filter, completion: completion)
                request = responseHandler.request
                return
            }

            // 2) Attempt to load the image from the image cache if the cache policy allows it
            if let request = urlRequest.urlRequest {
                switch request.cachePolicy {
                case .useProtocolCachePolicy, .returnCacheDataElseLoad, .returnCacheDataDontLoad:
                    if let image = self.imageCache?.image(for: request, withIdentifier: filter?.identifier) {
                        DispatchQueue.main.async {
                            let response = DataResponse<Image>(
                                request: urlRequest.urlRequest,
                                response: nil,
                                data: nil,
                                result: .success(image)
                            )

                            completion?(response)
                        }

                        return
                    }
                default:
                    break
                }
            }

            // 3) Create the request and set up authentication, validation and response serialization
            request = self.sessionManager.request(urlRequest)

            if let credential = self.credential {
                request.authenticate(usingCredential: credential)
            }

            request.validate()

            if let progress = progress {
                request.downloadProgress(queue: progressQueue, closure: progress)
            }

            // Generate a unique handler id to check whether the active request has changed while downloading
            let handlerID = UUID().uuidString

            request.response(
                queue: self.responseQueue,
                responseSerializer: imageResponseSerializer,
                completionHandler: { [weak self] response in
                    guard let strongSelf = self, let request = response.request else { return }

                    defer {
                        strongSelf.safelyDecrementActiveRequestCount()
                        strongSelf.safelyStartNextRequestIfNecessary()
                    }

                    // Early out if the request has changed out from under us
                    let handler = strongSelf.safelyFetchResponseHandler(withURLIdentifier: urlID)
                    guard handler?.handlerID == handlerID else { return }

                    guard let responseHandler = strongSelf.safelyRemoveResponseHandler(withURLIdentifier: urlID) else {
                        return
                    }

                    switch response.result {
                    case .success(let image):
                        var filteredImages: [String: Image] = [:]

                        for (_, filter, completion) in responseHandler.operations {
                            var filteredImage: Image

                            if let filter = filter {
                                if let alreadyFilteredImage = filteredImages[filter.identifier] {
                                    filteredImage = alreadyFilteredImage
                                } else {
                                    filteredImage = filter.filter(image)
                                    filteredImages[filter.identifier] = filteredImage
                                }
                            } else {
                                filteredImage = image
                            }

                            strongSelf.imageCache?.add(filteredImage, for: request, withIdentifier: filter?.identifier)

                            DispatchQueue.main.async {
                                let response = DataResponse<Image>(
                                    request: response.request,
                                    response: response.response,
                                    data: response.data,
                                    result: .success(filteredImage),
                                    timeline: response.timeline
                                )

                                completion?(response)
                            }
                        }
                    case .failure:
                        for (_, _, completion) in responseHandler.operations {
                            DispatchQueue.main.async { completion?(response) }
                        }
                    }
                }
            )

            // 4) Store the response handler for use when the request completes
            let responseHandler = ResponseHandler(
                request: request,
                handlerID: handlerID,
                receiptID: receiptID,
                filter: filter,
                completion: completion
            )

            self.responseHandlers[urlID] = responseHandler

            // 5) Either start the request or enqueue it depending on the current active request count
            if self.isActiveRequestCountBelowMaximumLimit() {
                self.start(request)
            } else {
                self.enqueue(request)
            }
        }

        if let request = request {
            return RequestReceipt(request: request, receiptID: receiptID)
        }

        return nil
    }

    /// Creates a download request using the internal Alamofire `SessionManager` instance for each specified URL request.
    ///
    /// For each request, if the same download request is already in the queue or currently being downloaded, the
    /// filter and completion handler are appended to the already existing request. Once the request completes, all
    /// filters and completion handlers attached to the request are executed in the order they were added.
    /// Additionally, any filters attached to the request with the same identifiers are only executed once. The
    /// resulting image is then passed into each completion handler paired with the filter.
    ///
    /// You should not attempt to directly cancel any of the `request`s inside the request receipts array since other
    /// callers may be relying on the completion of that request. Instead, you should call
    /// `cancelRequestForRequestReceipt` with the returned request receipt to allow the `ImageDownloader` to optimize
    /// the cancellation on behalf of all active callers.
    ///
    /// - parameter urlRequests:   The URL requests.
    /// - parameter filter         The image filter to apply to the image after each download is complete.
    /// - parameter progress:      The closure to be executed periodically during the lifecycle of the request. Defaults
    ///                            to `nil`.
    /// - parameter progressQueue: The dispatch queue to call the progress closure on. Defaults to the main queue.
    /// - parameter completion:    The closure called when each download request is complete.
    ///
    /// - returns: The request receipts for the download requests if available. If an image is stored in the image
    ///            cache and the URL request cache policy allows the cache to be used, a receipt will not be returned
    ///            for that request.
    @discardableResult
    open func download(
        _ urlRequests: [URLRequestConvertible],
        filter: ImageFilter? = nil,
        progress: ProgressHandler? = nil,
        progressQueue: DispatchQueue = DispatchQueue.main,
        completion: CompletionHandler? = nil)
        -> [RequestReceipt]
    {
        return urlRequests.flatMap {
            download($0, filter: filter, progress: progress, progressQueue: progressQueue, completion: completion)
        }
    }

    /// Cancels the request in the receipt by removing the response handler and cancelling the request if necessary.
    ///
    /// If the request is pending in the queue, it will be cancelled if no other response handlers are registered with
    /// the request. If the request is currently executing or is already completed, the response handler is removed and
    /// will not be called.
    ///
    /// - parameter requestReceipt: The request receipt to cancel.
    open func cancelRequest(with requestReceipt: RequestReceipt) {
        synchronizationQueue.sync {
            let urlID = ImageDownloader.urlIdentifier(for: requestReceipt.request.request!)
            guard let responseHandler = self.responseHandlers[urlID] else { return }

            if let index = responseHandler.operations.index(where: { $0.receiptID == requestReceipt.receiptID }) {
                let operation = responseHandler.operations.remove(at: index)

                let response: DataResponse<Image> = {
                    let urlRequest = requestReceipt.request.request
                    let error = AFIError.requestCancelled

                    return DataResponse(request: urlRequest, response: nil, data: nil, result: .failure(error))
                }()

                DispatchQueue.main.async { operation.completion?(response) }
            }

            if responseHandler.operations.isEmpty && requestReceipt.request.task?.state == .suspended {
                requestReceipt.request.cancel()
                self.responseHandlers.removeValue(forKey: urlID)
            }
        }
    }

    // MARK: Internal - Thread-Safe Request Methods

    func safelyFetchResponseHandler(withURLIdentifier urlIdentifier: String) -> ResponseHandler? {
        var responseHandler: ResponseHandler?

        synchronizationQueue.sync {
            responseHandler = self.responseHandlers[urlIdentifier]
        }

        return responseHandler
    }

    func safelyRemoveResponseHandler(withURLIdentifier identifier: String) -> ResponseHandler? {
        var responseHandler: ResponseHandler?

        synchronizationQueue.sync {
            responseHandler = self.responseHandlers.removeValue(forKey: identifier)
        }

        return responseHandler
    }

    func safelyStartNextRequestIfNecessary() {
        synchronizationQueue.sync {
            guard self.isActiveRequestCountBelowMaximumLimit() else { return }

            while !self.queuedRequests.isEmpty {
                if let request = self.dequeue(), request.task?.state == .suspended {
                    self.start(request)
                    break
                }
            }
        }
    }

    func safelyDecrementActiveRequestCount() {
        self.synchronizationQueue.sync {
            if self.activeRequestCount > 0 {
                self.activeRequestCount -= 1
            }
        }
    }

    // MARK: Internal - Non Thread-Safe Request Methods

    func start(_ request: Request) {
        request.resume()
        activeRequestCount += 1
    }

    func enqueue(_ request: Request) {
        switch downloadPrioritization {
        case .fifo:
            queuedRequests.append(request)
        case .lifo:
            queuedRequests.insert(request, at: 0)
        }
    }

    @discardableResult
    func dequeue() -> Request? {
        var request: Request?

        if !queuedRequests.isEmpty {
            request = queuedRequests.removeFirst()
        }

        return request
    }

    func isActiveRequestCountBelowMaximumLimit() -> Bool {
        return activeRequestCount < maximumActiveDownloads
    }

    static func urlIdentifier(for urlRequest: URLRequestConvertible) -> String {
        return urlRequest.urlRequest?.url?.absoluteString ?? ""
    }
}
//
//  ImageFilter.swift
//
//  Copyright (c) 2015-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

// MARK: ImageFilter

/// The `ImageFilter` protocol defines properties for filtering an image as well as identification of the filter.
public protocol ImageFilter {
    /// A closure used to create an alternative representation of the given image.
    var filter: (Image) -> Image { get }

    /// The string used to uniquely identify the filter operation.
    var identifier: String { get }
}

extension ImageFilter {
    /// The unique identifier for any `ImageFilter` type.
    public var identifier: String { return "\(type(of: self))" }
}

// MARK: - Sizable

/// The `Sizable` protocol defines a size property intended for use with `ImageFilter` types.
public protocol Sizable {
    /// The size of the type.
    var size: CGSize { get }
}

extension ImageFilter where Self: Sizable {
    /// The unique idenitifier for an `ImageFilter` conforming to the `Sizable` protocol.
    public var identifier: String {
        let width = Int64(size.width.rounded())
        let height = Int64(size.height.rounded())

        return "\(type(of: self))-size:(\(width)x\(height))"
    }
}

// MARK: - Roundable

/// The `Roundable` protocol defines a radius property intended for use with `ImageFilter` types.
public protocol Roundable {
    /// The radius of the type.
    var radius: CGFloat { get }
}

extension ImageFilter where Self: Roundable {
    /// The unique idenitifier for an `ImageFilter` conforming to the `Roundable` protocol.
    public var identifier: String {
        let radius = Int64(self.radius.rounded())
        return "\(type(of: self))-radius:(\(radius))"
    }
}

// MARK: - DynamicImageFilter

/// The `DynamicImageFilter` class simplifies custom image filter creation by using a trailing closure initializer.
public struct DynamicImageFilter: ImageFilter {
    /// The string used to uniquely identify the image filter operation.
    public let identifier: String

    /// A closure used to create an alternative representation of the given image.
    public let filter: (Image) -> Image

    /// Initializes the `DynamicImageFilter` instance with the specified identifier and filter closure.
    ///
    /// - parameter identifier: The unique identifier of the filter.
    /// - parameter filter:     A closure used to create an alternative representation of the given image.
    ///
    /// - returns: The new `DynamicImageFilter` instance.
    public init(_ identifier: String, filter: @escaping (Image) -> Image) {
        self.identifier = identifier
        self.filter = filter
    }
}

// MARK: - CompositeImageFilter

/// The `CompositeImageFilter` protocol defines an additional `filters` property to support multiple composite filters.
public protocol CompositeImageFilter: ImageFilter {
    /// The image filters to apply to the image in sequential order.
    var filters: [ImageFilter] { get }
}

public extension CompositeImageFilter {
    /// The unique idenitifier for any `CompositeImageFilter` type.
    var identifier: String {
        return filters.map { $0.identifier }.joined(separator: "_")
    }

    /// The filter closure for any `CompositeImageFilter` type.
    var filter: (Image) -> Image {
        return { image in
            return self.filters.reduce(image) { $1.filter($0) }
        }
    }
}

// MARK: - DynamicCompositeImageFilter

/// The `DynamicCompositeImageFilter` class is a composite image filter based on a specified array of filters.
public struct DynamicCompositeImageFilter: CompositeImageFilter {
    /// The image filters to apply to the image in sequential order.
    public let filters: [ImageFilter]

    /// Initializes the `DynamicCompositeImageFilter` instance with the given filters.
    ///
    /// - parameter filters: The filters taking part in the composite image filter.
    ///
    /// - returns: The new `DynamicCompositeImageFilter` instance.
    public init(_ filters: [ImageFilter]) {
        self.filters = filters
    }

    /// Initializes the `DynamicCompositeImageFilter` instance with the given filters.
    ///
    /// - parameter filters: The filters taking part in the composite image filter.
    ///
    /// - returns: The new `DynamicCompositeImageFilter` instance.
    public init(_ filters: ImageFilter...) {
        self.init(filters)
    }
}

#if os(iOS) || os(tvOS) || os(watchOS)

// MARK: - Single Pass Image Filters (iOS, tvOS and watchOS only) -

/// Scales an image to a specified size.
public struct ScaledToSizeFilter: ImageFilter, Sizable {
    /// The size of the filter.
    public let size: CGSize

    /// Initializes the `ScaledToSizeFilter` instance with the given size.
    ///
    /// - parameter size: The size.
    ///
    /// - returns: The new `ScaledToSizeFilter` instance.
    public init(size: CGSize) {
        self.size = size
    }

    /// The filter closure used to create the modified representation of the given image.
    public var filter: (Image) -> Image {
        return { image in
            return image.af_imageScaled(to: self.size)
        }
    }
}

// MARK: -

/// Scales an image from the center while maintaining the aspect ratio to fit within a specified size.
public struct AspectScaledToFitSizeFilter: ImageFilter, Sizable {
    /// The size of the filter.
    public let size: CGSize

    /// Initializes the `AspectScaledToFitSizeFilter` instance with the given size.
    ///
    /// - parameter size: The size.
    ///
    /// - returns: The new `AspectScaledToFitSizeFilter` instance.
    public init(size: CGSize) {
        self.size = size
    }

    /// The filter closure used to create the modified representation of the given image.
    public var filter: (Image) -> Image {
        return { image in
            return image.af_imageAspectScaled(toFit: self.size)
        }
    }
}

// MARK: -

/// Scales an image from the center while maintaining the aspect ratio to fill a specified size. Any pixels that fall
/// outside the specified size are clipped.
public struct AspectScaledToFillSizeFilter: ImageFilter, Sizable {
    /// The size of the filter.
    public let size: CGSize

    /// Initializes the `AspectScaledToFillSizeFilter` instance with the given size.
    ///
    /// - parameter size: The size.
    ///
    /// - returns: The new `AspectScaledToFillSizeFilter` instance.
    public init(size: CGSize) {
        self.size = size
    }

    /// The filter closure used to create the modified representation of the given image.
    public var filter: (Image) -> Image {
        return { image in
            return image.af_imageAspectScaled(toFill: self.size)
        }
    }
}

// MARK: -

/// Rounds the corners of an image to the specified radius.
public struct RoundedCornersFilter: ImageFilter, Roundable {
    /// The radius of the filter.
    public let radius: CGFloat

    /// Whether to divide the radius by the image scale.
    public let divideRadiusByImageScale: Bool

    /// Initializes the `RoundedCornersFilter` instance with the given radius.
    ///
    /// - parameter radius:                   The radius.
    /// - parameter divideRadiusByImageScale: Whether to divide the radius by the image scale. Set to `true` when the
    ///                                       image has the same resolution for all screen scales such as @1x, @2x and
    ///                                       @3x (i.e. single image from web server). Set to `false` for images loaded
    ///                                       from an asset catalog with varying resolutions for each screen scale.
    ///                                       `false` by default.
    ///
    /// - returns: The new `RoundedCornersFilter` instance.
    public init(radius: CGFloat, divideRadiusByImageScale: Bool = false) {
        self.radius = radius
        self.divideRadiusByImageScale = divideRadiusByImageScale
    }

    /// The filter closure used to create the modified representation of the given image.
    public var filter: (Image) -> Image {
        return { image in
            return image.af_imageRounded(
                withCornerRadius: self.radius,
                divideRadiusByImageScale: self.divideRadiusByImageScale
            )
        }
    }

    /// The unique idenitifier for an `ImageFilter` conforming to the `Roundable` protocol.
    public var identifier: String {
        let radius = Int64(self.radius.rounded())
        return "\(type(of: self))-radius:(\(radius))-divided:(\(divideRadiusByImageScale))"
    }
}

// MARK: -

/// Rounds the corners of an image into a circle.
public struct CircleFilter: ImageFilter {
    /// Initializes the `CircleFilter` instance.
    ///
    /// - returns: The new `CircleFilter` instance.
    public init() {}

    /// The filter closure used to create the modified representation of the given image.
    public var filter: (Image) -> Image {
        return { image in
            return image.af_imageRoundedIntoCircle()
        }
    }
}

// MARK: -

#if os(iOS) || os(tvOS)

/// The `CoreImageFilter` protocol defines `parameters`, `filterName` properties used by CoreImage.
@available(iOS 9.0, *)
public protocol CoreImageFilter: ImageFilter {
    /// The filter name of the CoreImage filter.
	var filterName: String { get }

    /// The image filter parameters passed to CoreImage.
    var parameters: [String: Any] { get }
}

@available(iOS 9.0, *)
public extension ImageFilter where Self: CoreImageFilter {
	/// The filter closure used to create the modified representation of the given image.
	public var filter: (Image) -> Image {
		return { image in
            return image.af_imageFiltered(withCoreImageFilter: self.filterName, parameters: self.parameters) ?? image
		}
	}

	/// The unique idenitifier for an `ImageFilter` conforming to the `CoreImageFilter` protocol.
	public var identifier: String { return "\(type(of: self))-parameters:(\(self.parameters))" }
}

/// Blurs an image using a `CIGaussianBlur` filter with the specified blur radius.
@available(iOS 9.0, *)
public struct BlurFilter: ImageFilter, CoreImageFilter {
    /// The filter name.
    public let filterName = "CIGaussianBlur"

    /// The image filter parameters passed to CoreImage.
    public let parameters: [String: Any]

    /// Initializes the `BlurFilter` instance with the given blur radius.
    ///
    /// - parameter blurRadius: The blur radius.
    ///
    /// - returns: The new `BlurFilter` instance.
    public init(blurRadius: UInt = 10) {
        self.parameters = ["inputRadius": blurRadius]
    }
}

#endif

// MARK: - Composite Image Filters (iOS, tvOS and watchOS only) -

/// Scales an image to a specified size, then rounds the corners to the specified radius.
public struct ScaledToSizeWithRoundedCornersFilter: CompositeImageFilter {
    /// Initializes the `ScaledToSizeWithRoundedCornersFilter` instance with the given size and radius.
    ///
    /// - parameter size:                     The size.
    /// - parameter radius:                   The radius.
    /// - parameter divideRadiusByImageScale: Whether to divide the radius by the image scale. Set to `true` when the
    ///                                       image has the same resolution for all screen scales such as @1x, @2x and
    ///                                       @3x (i.e. single image from web server). Set to `false` for images loaded
    ///                                       from an asset catalog with varying resolutions for each screen scale.
    ///                                       `false` by default.
    ///
    /// - returns: The new `ScaledToSizeWithRoundedCornersFilter` instance.
    public init(size: CGSize, radius: CGFloat, divideRadiusByImageScale: Bool = false) {
        self.filters = [
            ScaledToSizeFilter(size: size),
            RoundedCornersFilter(radius: radius, divideRadiusByImageScale: divideRadiusByImageScale)
        ]
    }

    /// The image filters to apply to the image in sequential order.
    public let filters: [ImageFilter]
}

// MARK: -

/// Scales an image from the center while maintaining the aspect ratio to fit within a specified size, then rounds the
/// corners to the specified radius.
public struct AspectScaledToFillSizeWithRoundedCornersFilter: CompositeImageFilter {
    /// Initializes the `AspectScaledToFillSizeWithRoundedCornersFilter` instance with the given size and radius.
    ///
    /// - parameter size:                     The size.
    /// - parameter radius:                   The radius.
    /// - parameter divideRadiusByImageScale: Whether to divide the radius by the image scale. Set to `true` when the
    ///                                       image has the same resolution for all screen scales such as @1x, @2x and
    ///                                       @3x (i.e. single image from web server). Set to `false` for images loaded
    ///                                       from an asset catalog with varying resolutions for each screen scale.
    ///                                       `false` by default.
    ///
    /// - returns: The new `AspectScaledToFillSizeWithRoundedCornersFilter` instance.
    public init(size: CGSize, radius: CGFloat, divideRadiusByImageScale: Bool = false) {
        self.filters = [
            AspectScaledToFillSizeFilter(size: size),
            RoundedCornersFilter(radius: radius, divideRadiusByImageScale: divideRadiusByImageScale)
        ]
    }

    /// The image filters to apply to the image in sequential order.
    public let filters: [ImageFilter]
}

// MARK: -

/// Scales an image to a specified size, then rounds the corners into a circle.
public struct ScaledToSizeCircleFilter: CompositeImageFilter {
    /// Initializes the `ScaledToSizeCircleFilter` instance with the given size.
    ///
    /// - parameter size: The size.
    ///
    /// - returns: The new `ScaledToSizeCircleFilter` instance.
    public init(size: CGSize) {
        self.filters = [ScaledToSizeFilter(size: size), CircleFilter()]
    }

    /// The image filters to apply to the image in sequential order.
    public let filters: [ImageFilter]
}

// MARK: -

/// Scales an image from the center while maintaining the aspect ratio to fit within a specified size, then rounds the
/// corners into a circle.
public struct AspectScaledToFillSizeCircleFilter: CompositeImageFilter {
    /// Initializes the `AspectScaledToFillSizeCircleFilter` instance with the given size.
    ///
    /// - parameter size: The size.
    ///
    /// - returns: The new `AspectScaledToFillSizeCircleFilter` instance.
    public init(size: CGSize) {
        self.filters = [AspectScaledToFillSizeFilter(size: size), CircleFilter()]
    }

    /// The image filters to apply to the image in sequential order.
    public let filters: [ImageFilter]
}

#endif
//
//  Request+AlamofireImage.swift
//
//  Copyright (c) 2015-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Alamofire
import Foundation

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(watchOS)
import UIKit
import WatchKit
#elseif os(macOS)
import Cocoa
#endif

extension DataRequest {
    static var acceptableImageContentTypes: Set<String> = [
        "image/tiff",
        "image/jpeg",
        "image/gif",
        "image/png",
        "image/ico",
        "image/x-icon",
        "image/bmp",
        "image/x-bmp",
        "image/x-xbitmap",
        "image/x-ms-bmp",
        "image/x-win-bitmap"
    ]

    static let streamImageInitialBytePattern = Data(bytes: [255, 216]) // 0xffd8

    /// Adds the content types specified to the list of acceptable images content types for validation.
    ///
    /// - parameter contentTypes: The additional content types.
    public class func addAcceptableImageContentTypes(_ contentTypes: Set<String>) {
        DataRequest.acceptableImageContentTypes.formUnion(contentTypes)
    }

    // MARK: - iOS, tvOS and watchOS

#if os(iOS) || os(tvOS) || os(watchOS)

    /// Creates a response serializer that returns an image initialized from the response data using the specified
    /// image options.
    ///
    /// - parameter imageScale:           The scale factor used when interpreting the image data to construct
    ///                                   `responseImage`. Specifying a scale factor of 1.0 results in an image whose
    ///                                   size matches the pixel-based dimensions of the image. Applying a different
    ///                                   scale factor changes the size of the image as reported by the size property.
    ///                                   `Screen.scale` by default.
    /// - parameter inflateResponseImage: Whether to automatically inflate response image data for compressed formats
    ///                                   (such as PNG or JPEG). Enabling this can significantly improve drawing
    ///                                   performance as it allows a bitmap representation to be constructed in the
    ///                                   background rather than on the main thread. `true` by default.
    ///
    /// - returns: An image response serializer.
    public class func imageResponseSerializer(
        imageScale: CGFloat = DataRequest.imageScale,
        inflateResponseImage: Bool = true)
        -> DataResponseSerializer<Image>
    {
        return DataResponseSerializer { request, response, data, error in
            let result = serializeResponseData(response: response, data: data, error: error)

            guard case let .success(data) = result else { return .failure(result.error!) }

            do {
                try DataRequest.validateContentType(for: request, response: response)

                let image = try DataRequest.image(from: data, withImageScale: imageScale)
                if inflateResponseImage { image.af_inflate() }

                return .success(image)
            } catch {
                return .failure(error)
            }
        }
    }

    /// Adds a response handler to be called once the request has finished.
    ///
    /// - parameter imageScale:           The scale factor used when interpreting the image data to construct
    ///                                   `responseImage`. Specifying a scale factor of 1.0 results in an image whose
    ///                                   size matches the pixel-based dimensions of the image. Applying a different
    ///                                   scale factor changes the size of the image as reported by the size property.
    ///                                   This is set to the value of scale of the main screen by default, which
    ///                                   automatically scales images for retina displays, for instance.
    ///                                   `Screen.scale` by default.
    /// - parameter inflateResponseImage: Whether to automatically inflate response image data for compressed formats
    ///                                   (such as PNG or JPEG). Enabling this can significantly improve drawing
    ///                                   performance as it allows a bitmap representation to be constructed in the
    ///                                   background rather than on the main thread. `true` by default.
    /// - parameter completionHandler:    A closure to be executed once the request has finished. The closure takes 4
    ///                                   arguments: the URL request, the URL response, if one was received, the image,
    ///                                   if one could be created from the URL response and data, and any error produced
    ///                                   while creating the image.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseImage(
        imageScale: CGFloat = DataRequest.imageScale,
        inflateResponseImage: Bool = true,
        completionHandler: @escaping (DataResponse<Image>) -> Void)
        -> Self
    {
        return response(
            responseSerializer: DataRequest.imageResponseSerializer(
                imageScale: imageScale,
                inflateResponseImage: inflateResponseImage
            ),
            completionHandler: completionHandler
        )
    }

    /// Sets a closure to be called periodically during the lifecycle of the request as data is read from the server
    /// and converted into images.
    ///
    /// - parameter imageScale:           The scale factor used when interpreting the image data to construct
    ///                                   `responseImage`. Specifying a scale factor of 1.0 results in an image whose
    ///                                   size matches the pixel-based dimensions of the image. Applying a different
    ///                                   scale factor changes the size of the image as reported by the size property.
    ///                                   This is set to the value of scale of the main screen by default, which
    ///                                   automatically scales images for retina displays, for instance.
    ///                                   `Screen.scale` by default.
    /// - parameter inflateResponseImage: Whether to automatically inflate response image data for compressed formats
    ///                                   (such as PNG or JPEG). Enabling this can significantly improve drawing
    ///                                   performance as it allows a bitmap representation to be constructed in the
    ///                                   background rather than on the main thread. `true` by default.
    /// - parameter completionHandler:    A closure to be executed when the request has new image. The closure takes 1
    ///                                   argument: the image, if one could be created from the data.
    ///
    /// - returns: The request.
    @discardableResult
    public func streamImage(
        imageScale: CGFloat = DataRequest.imageScale,
        inflateResponseImage: Bool = true,
        completionHandler: @escaping (Image) -> Void)
        -> Self
    {
        var imageData = Data()

        return stream { chunkData in
            if chunkData.starts(with: DataRequest.streamImageInitialBytePattern) {
                imageData = Data()
            }

            imageData.append(chunkData)

            if let image = DataRequest.serializeImage(from: imageData) {
                completionHandler(image)
            }
        }
    }

    private class func serializeImage(
        from data: Data,
        imageScale: CGFloat = DataRequest.imageScale,
        inflateResponseImage: Bool = true)
        -> UIImage?
    {
        guard data.count > 0 else { return nil }

        do {
            let image = try DataRequest.image(from: data, withImageScale: imageScale)
            if inflateResponseImage { image.af_inflate() }

            return image
        } catch {
            return nil
        }
    }

    private class func image(from data: Data, withImageScale imageScale: CGFloat) throws -> UIImage {
        if let image = UIImage.af_threadSafeImage(with: data, scale: imageScale) {
            return image
        }

        throw AFIError.imageSerializationFailed
    }

    private class var imageScale: CGFloat {
        #if os(iOS) || os(tvOS)
            return UIScreen.main.scale
        #elseif os(watchOS)
            return WKInterfaceDevice.current().screenScale
        #endif
    }

#elseif os(macOS)

    // MARK: - macOS

    /// Creates a response serializer that returns an image initialized from the response data.
    ///
    /// - returns: An image response serializer.
    public class func imageResponseSerializer() -> DataResponseSerializer<Image> {
        return DataResponseSerializer { request, response, data, error in
            let result = serializeResponseData(response: response, data: data, error: error)

            guard case let .success(data) = result else { return .failure(result.error!) }

            do {
                try DataRequest.validateContentType(for: request, response: response)
            } catch {
                return .failure(error)
            }

            guard let bitmapImage = NSBitmapImageRep(data: data) else {
                return .failure(AFIError.imageSerializationFailed)
            }

            let image = NSImage(size: NSSize(width: bitmapImage.pixelsWide, height: bitmapImage.pixelsHigh))
            image.addRepresentation(bitmapImage)

            return .success(image)
        }
    }

    /// Adds a response handler to be called once the request has finished.
    ///
    /// - parameter completionHandler: A closure to be executed once the request has finished. The closure takes 4
    ///                                arguments: the URL request, the URL response, if one was received, the image, if
    ///                                one could be created from the URL response and data, and any error produced while
    ///                                creating the image.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseImage(completionHandler: @escaping (DataResponse<Image>) -> Void) -> Self {
        return response(
            responseSerializer: DataRequest.imageResponseSerializer(),
            completionHandler: completionHandler
        )
    }

    /// Sets a closure to be called periodically during the lifecycle of the request as data is read from the server
    /// and converted into images.
    ///
    /// - parameter completionHandler: A closure to be executed when the request has new image. The closure takes 1
    ///                                argument: the image, if one could be created from the data.
    ///
    /// - returns: The request.
    @discardableResult
    public func streamImage(completionHandler: @escaping (Image) -> Void) -> Self {
        var imageData = Data()

        return stream { chunkData in
            if chunkData.starts(with: DataRequest.streamImageInitialBytePattern) {
                imageData = Data()
            }

            imageData.append(chunkData)

            if let image = DataRequest.serializeImage(from: imageData) {
                completionHandler(image)
            }
        }
    }

    private class func serializeImage(from data: Data) -> NSImage? {
        guard data.count > 0 else { return nil }
        guard let bitmapImage = NSBitmapImageRep(data: data) else { return nil }

        let image = NSImage(size: NSSize(width: bitmapImage.pixelsWide, height: bitmapImage.pixelsHigh))
        image.addRepresentation(bitmapImage)

        return image
    }

#endif

    // MARK: - Content Type Validation

    /// Returns whether the content type of the response matches one of the acceptable content types.
    ///
    /// - parameter request: The request.
    /// - parameter response: The server response.
    ///
    /// - throws: An `AFError` response validation failure when an error is encountered.
    public class func validateContentType(for request: URLRequest?, response: HTTPURLResponse?) throws {
        if let url = request?.url, url.isFileURL { return }

        guard let mimeType = response?.mimeType else {
            let contentTypes = Array(DataRequest.acceptableImageContentTypes)
            throw AFError.responseValidationFailed(reason: .missingContentType(acceptableContentTypes: contentTypes))
        }

        guard DataRequest.acceptableImageContentTypes.contains(mimeType) else {
            let contentTypes = Array(DataRequest.acceptableImageContentTypes)

            throw AFError.responseValidationFailed(
                reason: .unacceptableContentType(acceptableContentTypes: contentTypes, responseContentType: mimeType)
            )
        }
    }
}
//
//  UIButton+AlamofireImage.swift
//
//  Copyright (c) 2015-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Alamofire
import Foundation

#if os(iOS) || os(tvOS)

import UIKit

extension UIButton {

    // MARK: - Private - AssociatedKeys

    private struct AssociatedKey {
        static var imageDownloader = "af_UIButton.ImageDownloader"
        static var sharedImageDownloader = "af_UIButton.SharedImageDownloader"
        static var imageReceipts = "af_UIButton.ImageReceipts"
        static var backgroundImageReceipts = "af_UIButton.BackgroundImageReceipts"
    }

    // MARK: - Properties

    /// The instance image downloader used to download all images. If this property is `nil`, the `UIButton` will
    /// fallback on the `af_sharedImageDownloader` for all downloads. The most common use case for needing to use a
    /// custom instance image downloader is when images are behind different basic auth credentials.
    public var af_imageDownloader: ImageDownloader? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.imageDownloader) as? ImageDownloader
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.imageDownloader, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The shared image downloader used to download all images. By default, this is the default `ImageDownloader`
    /// instance backed with an `AutoPurgingImageCache` which automatically evicts images from the cache when the memory
    /// capacity is reached or memory warning notifications occur. The shared image downloader is only used if the
    /// `af_imageDownloader` is `nil`.
    public class var af_sharedImageDownloader: ImageDownloader {
        get {
            guard let
                downloader = objc_getAssociatedObject(self, &AssociatedKey.sharedImageDownloader) as? ImageDownloader
            else {
                return ImageDownloader.default
            }

            return downloader
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.sharedImageDownloader, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var imageRequestReceipts: [UInt: RequestReceipt] {
        get {
            guard let
                receipts = objc_getAssociatedObject(self, &AssociatedKey.imageReceipts) as? [UInt: RequestReceipt]
            else {
                return [:]
            }

            return receipts
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.imageReceipts, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var backgroundImageRequestReceipts: [UInt: RequestReceipt] {
        get {
            guard let
                receipts = objc_getAssociatedObject(self, &AssociatedKey.backgroundImageReceipts) as? [UInt: RequestReceipt]
            else {
                return [:]
            }

            return receipts
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.backgroundImageReceipts, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - Image Downloads

    /// Asynchronously downloads an image from the specified URL and sets it once the request is finished.
    ///
    /// If the image is cached locally, the image is set immediately. Otherwise the specified placehoder image will be
    /// set immediately, and then the remote image will be set once the image request is finished.
    ///
    /// - parameter state:            The control state of the button to set the image on.
    /// - parameter url:              The URL used for your image request.
    /// - parameter placeholderImage: The image to be set initially until the image request finished. If `nil`, the
    ///                               image will not change its image until the image request finishes. Defaults
    ///                               to `nil`.
    /// - parameter filter:           The image filter applied to the image after the image request is finished.
    ///                               Defaults to `nil`.
    /// - parameter progress:         The closure to be executed periodically during the lifecycle of the request.
    ///                               Defaults to `nil`.
    /// - parameter progressQueue:    The dispatch queue to call the progress closure on. Defaults to the main queue.
    /// - parameter completion:       A closure to be executed when the image request finishes. The closure takes a
    ///                               single response value containing either the image or the error that occurred. If
    ///                               the image was returned from the image cache, the response will be `nil`. Defaults
    ///                               to `nil`.
    public func af_setImage(
        for state: UIControlState,
        url: URL,
        placeholderImage: UIImage? = nil,
        filter: ImageFilter? = nil,
        progress: ImageDownloader.ProgressHandler? = nil,
        progressQueue: DispatchQueue = DispatchQueue.main,
        completion: ((DataResponse<UIImage>) -> Void)? = nil)
    {
        af_setImage(
            for: state,
            urlRequest: urlRequest(with: url),
            placeholderImage: placeholderImage,
            filter: filter,
            progress: progress,
            progressQueue: progressQueue,
            completion: completion
        )
    }

    /// Asynchronously downloads an image from the specified URL request and sets it once the request is finished.
    ///
    /// If the image is cached locally, the image is set immediately. Otherwise the specified placehoder image will be
    /// set immediately, and then the remote image will be set once the image request is finished.
    ///
    /// - parameter state:            The control state of the button to set the image on.
    /// - parameter urlRequest:       The URL request.
    /// - parameter placeholderImage: The image to be set initially until the image request finished. If `nil`, the
    ///                               image will not change its image until the image request finishes. Defaults
    ///                               to `nil`.
    /// - parameter filter:           The image filter applied to the image after the image request is finished.
    ///                               Defaults to `nil`.
    /// - parameter progress:         The closure to be executed periodically during the lifecycle of the request.
    ///                               Defaults to `nil`.
    /// - parameter progressQueue:    The dispatch queue to call the progress closure on. Defaults to the main queue.
    /// - parameter completion:       A closure to be executed when the image request finishes. The closure takes a
    ///                               single response value containing either the image or the error that occurred. If
    ///                               the image was returned from the image cache, the response will be `nil`. Defaults
    ///                               to `nil`.
    public func af_setImage(
        for state: UIControlState,
        urlRequest: URLRequestConvertible,
        placeholderImage: UIImage? = nil,
        filter: ImageFilter? = nil,
        progress: ImageDownloader.ProgressHandler? = nil,
        progressQueue: DispatchQueue = DispatchQueue.main,
        completion: ((DataResponse<UIImage>) -> Void)? = nil)
    {
        guard !isImageURLRequest(urlRequest, equalToActiveRequestURLForState: state) else {
            let error = AFIError.requestCancelled
            let response = DataResponse<UIImage>(request: nil, response: nil, data: nil, result: .failure(error))

            completion?(response)

            return
        }

        af_cancelImageRequest(for: state)

        let imageDownloader = af_imageDownloader ?? UIButton.af_sharedImageDownloader
        let imageCache = imageDownloader.imageCache

        // Use the image from the image cache if it exists
        if
            let request = urlRequest.urlRequest,
            let image = imageCache?.image(for: request, withIdentifier: filter?.identifier)
        {
            let response = DataResponse<UIImage>(
                request: urlRequest.urlRequest,
                response: nil,
                data: nil,
                result: .success(image)
            )

            setImage(image, for: state)
            completion?(response)

            return
        }

        // Set the placeholder since we're going to have to download
        if let placeholderImage = placeholderImage { setImage(placeholderImage, for: state)  }

        // Generate a unique download id to check whether the active request has changed while downloading
        let downloadID = UUID().uuidString

        // Download the image, then set the image for the control state
        let requestReceipt = imageDownloader.download(
            urlRequest,
            receiptID: downloadID,
            filter: filter,
            progress: progress,
            progressQueue: progressQueue,
            completion: { [weak self] response in
                guard
                    let strongSelf = self,
                    strongSelf.isImageURLRequest(response.request, equalToActiveRequestURLForState: state) &&
                    strongSelf.imageRequestReceipt(for: state)?.receiptID == downloadID
                else {
                    completion?(response)
                    return
                }

                if let image = response.result.value {
                    strongSelf.setImage(image, for: state)
                }

                strongSelf.setImageRequestReceipt(nil, for: state)

                completion?(response)
            }
        )

        setImageRequestReceipt(requestReceipt, for: state)
    }

    /// Cancels the active download request for the image, if one exists.
    public func af_cancelImageRequest(for state: UIControlState) {
        guard let receipt = imageRequestReceipt(for: state) else { return }

        let imageDownloader = af_imageDownloader ?? UIButton.af_sharedImageDownloader
        imageDownloader.cancelRequest(with: receipt)

        setImageRequestReceipt(nil, for: state)
    }

    // MARK: - Background Image Downloads

    /// Asynchronously downloads an image from the specified URL and sets it once the request is finished.
    ///
    /// If the image is cached locally, the image is set immediately. Otherwise the specified placehoder image will be
    /// set immediately, and then the remote image will be set once the image request is finished.
    ///
    /// - parameter state:            The control state of the button to set the image on.
    /// - parameter url:              The URL used for the image request.
    /// - parameter placeholderImage: The image to be set initially until the image request finished. If `nil`, the
    ///                               background image will not change its image until the image request finishes.
    ///                               Defaults to `nil`.
    /// - parameter filter:           The image filter applied to the image after the image request is finished.
    ///                               Defaults to `nil`.
    /// - parameter progress:         The closure to be executed periodically during the lifecycle of the request.
    ///                               Defaults to `nil`.
    /// - parameter progressQueue:    The dispatch queue to call the progress closure on. Defaults to the main queue.
    /// - parameter completion:       A closure to be executed when the image request finishes. The closure takes a
    ///                               single response value containing either the image or the error that occurred. If
    ///                               the image was returned from the image cache, the response will be `nil`. Defaults
    ///                               to `nil`.
    public func af_setBackgroundImage(
        for state: UIControlState,
        url: URL,
        placeholderImage: UIImage? = nil,
        filter: ImageFilter? = nil,
        progress: ImageDownloader.ProgressHandler? = nil,
        progressQueue: DispatchQueue = DispatchQueue.main,
        completion: ((DataResponse<UIImage>) -> Void)? = nil)
    {
        af_setBackgroundImage(
            for: state,
            urlRequest: urlRequest(with: url),
            placeholderImage: placeholderImage,
            filter: filter,
            progress: progress,
            progressQueue: progressQueue,
            completion: completion
        )
    }

    /// Asynchronously downloads an image from the specified URL request and sets it once the request is finished.
    ///
    /// If the image is cached locally, the image is set immediately. Otherwise the specified placehoder image will be
    /// set immediately, and then the remote image will be set once the image request is finished.
    ///
    /// - parameter state:            The control state of the button to set the image on.
    /// - parameter urlRequest:       The URL request.
    /// - parameter placeholderImage: The image to be set initially until the image request finished. If `nil`, the
    ///                               background image will not change its image until the image request finishes.
    ///                               Defaults to `nil`.
    /// - parameter filter:           The image filter applied to the image after the image request is finished.
    ///                               Defaults to `nil`.
    /// - parameter progress:         The closure to be executed periodically during the lifecycle of the request.
    ///                               Defaults to `nil`.
    /// - parameter progressQueue:    The dispatch queue to call the progress closure on. Defaults to the main queue.
    /// - parameter completion:       A closure to be executed when the image request finishes. The closure takes a
    ///                               single response value containing either the image or the error that occurred. If
    ///                               the image was returned from the image cache, the response will be `nil`. Defaults
    ///                               to `nil`.
    public func af_setBackgroundImage(
        for state: UIControlState,
        urlRequest: URLRequestConvertible,
        placeholderImage: UIImage? = nil,
        filter: ImageFilter? = nil,
        progress: ImageDownloader.ProgressHandler? = nil,
        progressQueue: DispatchQueue = DispatchQueue.main,
        completion: ((DataResponse<UIImage>) -> Void)? = nil)
    {
        guard !isImageURLRequest(urlRequest, equalToActiveRequestURLForState: state) else {
            let error = AFIError.requestCancelled
            let response = DataResponse<UIImage>(request: nil, response: nil, data: nil, result: .failure(error))

            completion?(response)

            return
        }

        af_cancelBackgroundImageRequest(for: state)

        let imageDownloader = af_imageDownloader ?? UIButton.af_sharedImageDownloader
        let imageCache = imageDownloader.imageCache

        // Use the image from the image cache if it exists
        if
            let request = urlRequest.urlRequest,
            let image = imageCache?.image(for: request, withIdentifier: filter?.identifier)
        {
            let response = DataResponse<UIImage>(
                request: urlRequest.urlRequest,
                response: nil,
                data: nil,
                result: .success(image)
            )

            setBackgroundImage(image, for: state)
            completion?(response)

            return
        }

        // Set the placeholder since we're going to have to download
        if let placeholderImage = placeholderImage { self.setBackgroundImage(placeholderImage, for: state)  }

        // Generate a unique download id to check whether the active request has changed while downloading
        let downloadID = UUID().uuidString

        // Download the image, then set the image for the control state
        let requestReceipt = imageDownloader.download(
            urlRequest,
            receiptID: downloadID,
            filter: nil,
            progress: progress,
            progressQueue: progressQueue,
            completion: { [weak self] response in
                guard
                    let strongSelf = self,
                    strongSelf.isBackgroundImageURLRequest(response.request, equalToActiveRequestURLForState: state) &&
                    strongSelf.backgroundImageRequestReceipt(for: state)?.receiptID == downloadID
                else {
                    completion?(response)
                    return
                }

                if let image = response.result.value {
                    strongSelf.setBackgroundImage(image, for: state)
                }

                strongSelf.setBackgroundImageRequestReceipt(nil, for: state)

                completion?(response)
            }
        )

        setBackgroundImageRequestReceipt(requestReceipt, for: state)
    }

    /// Cancels the active download request for the background image, if one exists.
    public func af_cancelBackgroundImageRequest(for state: UIControlState) {
        guard let receipt = backgroundImageRequestReceipt(for: state) else { return }

        let imageDownloader = af_imageDownloader ?? UIButton.af_sharedImageDownloader
        imageDownloader.cancelRequest(with: receipt)

        setBackgroundImageRequestReceipt(nil, for: state)
    }

    // MARK: - Internal - Image Request Receipts

    func imageRequestReceipt(for state: UIControlState) -> RequestReceipt? {
        guard let receipt = imageRequestReceipts[state.rawValue] else { return nil }
        return receipt
    }

    func setImageRequestReceipt(_ receipt: RequestReceipt?, for state: UIControlState) {
        var receipts = imageRequestReceipts
        receipts[state.rawValue] = receipt

        imageRequestReceipts = receipts
    }

    // MARK: - Internal - Background Image Request Receipts

    func backgroundImageRequestReceipt(for state: UIControlState) -> RequestReceipt? {
        guard let receipt = backgroundImageRequestReceipts[state.rawValue] else { return nil }
        return receipt
    }

    func setBackgroundImageRequestReceipt(_ receipt: RequestReceipt?, for state: UIControlState) {
        var receipts = backgroundImageRequestReceipts
        receipts[state.rawValue] = receipt

        backgroundImageRequestReceipts = receipts
    }

    // MARK: - Private - URL Request Helpers

    private func isImageURLRequest(
        _ urlRequest: URLRequestConvertible?,
        equalToActiveRequestURLForState state: UIControlState)
        -> Bool
    {
        if
            let currentURL = imageRequestReceipt(for: state)?.request.task?.originalRequest?.url,
            let requestURL = urlRequest?.urlRequest?.url,
            currentURL == requestURL
        {
            return true
        }

        return false
    }

    private func isBackgroundImageURLRequest(
        _ urlRequest: URLRequestConvertible?,
        equalToActiveRequestURLForState state: UIControlState)
        -> Bool
    {
        if
            let currentRequestURL = backgroundImageRequestReceipt(for: state)?.request.task?.originalRequest?.url,
            let requestURL = urlRequest?.urlRequest?.url,
            currentRequestURL == requestURL
        {
            return true
        }

        return false
    }

    private func urlRequest(with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)

        for mimeType in DataRequest.acceptableImageContentTypes {
            urlRequest.addValue(mimeType, forHTTPHeaderField: "Accept")
        }

        return urlRequest
    }
}

#endif
//
//  UIImage+AlamofireImage.swift
//
//  Copyright (c) 2015-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

#if os(iOS) || os(tvOS) || os(watchOS)

import CoreGraphics
import Foundation
import UIKit

// MARK: Initialization

private let lock = NSLock()

extension UIImage {
    /// Initializes and returns the image object with the specified data in a thread-safe manner.
    ///
    /// It has been reported that there are thread-safety issues when initializing large amounts of images
    /// simultaneously. In the event of these issues occurring, this method can be used in place of
    /// the `init?(data:)` method.
    ///
    /// - parameter data: The data object containing the image data.
    ///
    /// - returns: An initialized `UIImage` object, or `nil` if the method failed.
    public static func af_threadSafeImage(with data: Data) -> UIImage? {
        lock.lock()
        let image = UIImage(data: data)
        lock.unlock()

        return image
    }

    /// Initializes and returns the image object with the specified data and scale in a thread-safe manner.
    ///
    /// It has been reported that there are thread-safety issues when initializing large amounts of images
    /// simultaneously. In the event of these issues occurring, this method can be used in place of
    /// the `init?(data:scale:)` method.
    ///
    /// - parameter data:  The data object containing the image data.
    /// - parameter scale: The scale factor to assume when interpreting the image data. Applying a scale factor of 1.0
    ///                    results in an image whose size matches the pixel-based dimensions of the image. Applying a
    ///                    different scale factor changes the size of the image as reported by the size property.
    ///
    /// - returns: An initialized `UIImage` object, or `nil` if the method failed.
    public static func af_threadSafeImage(with data: Data, scale: CGFloat) -> UIImage? {
        lock.lock()
        let image = UIImage(data: data, scale: scale)
        lock.unlock()

        return image
    }
}

// MARK: - Inflation

extension UIImage {
    private struct AssociatedKey {
        static var inflated = "af_UIImage.Inflated"
    }

    /// Returns whether the image is inflated.
    public var af_inflated: Bool {
        get {
            if let inflated = objc_getAssociatedObject(self, &AssociatedKey.inflated) as? Bool {
                return inflated
            } else {
                return false
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.inflated, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Inflates the underlying compressed image data to be backed by an uncompressed bitmap representation.
    ///
    /// Inflating compressed image formats (such as PNG or JPEG) can significantly improve drawing performance as it
    /// allows a bitmap representation to be constructed in the background rather than on the main thread.
    public func af_inflate() {
        guard !af_inflated else { return }

        af_inflated = true
        _ = cgImage?.dataProvider?.data
    }
}

// MARK: - Alpha

extension UIImage {
    /// Returns whether the image contains an alpha component.
    public var af_containsAlphaComponent: Bool {
        let alphaInfo = cgImage?.alphaInfo

        return (
            alphaInfo == .first ||
            alphaInfo == .last ||
            alphaInfo == .premultipliedFirst ||
            alphaInfo == .premultipliedLast
        )
    }

    /// Returns whether the image is opaque.
    public var af_isOpaque: Bool { return !af_containsAlphaComponent }
}

// MARK: - Scaling

extension UIImage {
    /// Returns a new version of the image scaled to the specified size.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    public func af_imageScaled(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, af_isOpaque, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return scaledImage
    }

    /// Returns a new version of the image scaled from the center while maintaining the aspect ratio to fit within
    /// a specified size.
    ///
    /// The resulting image contains an alpha component used to pad the width or height with the necessary transparent
    /// pixels to fit the specified size. In high performance critical situations, this may not be the optimal approach.
    /// To maintain an opaque image, you could compute the `scaledSize` manually, then use the `af_imageScaledToSize`
    /// method in conjunction with a `.Center` content mode to achieve the same visual result.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    public func af_imageAspectScaled(toFit size: CGSize) -> UIImage {
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height

        var resizeFactor: CGFloat

        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.width / self.size.width
        } else {
            resizeFactor = size.height / self.size.height
        }

        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return scaledImage
    }

    /// Returns a new version of the image scaled from the center while maintaining the aspect ratio to fill a
    /// specified size. Any pixels that fall outside the specified size are clipped.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    public func af_imageAspectScaled(toFill size: CGSize) -> UIImage {
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height

        var resizeFactor: CGFloat

        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.height / self.size.height
        } else {
            resizeFactor = size.width / self.size.width
        }

        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)

        UIGraphicsBeginImageContextWithOptions(size, af_isOpaque, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return scaledImage
    }
}

// MARK: - Rounded Corners

extension UIImage {
    /// Returns a new version of the image with the corners rounded to the specified radius.
    ///
    /// - parameter radius:                   The radius to use when rounding the new image.
    /// - parameter divideRadiusByImageScale: Whether to divide the radius by the image scale. Set to `true` when the
    ///                                       image has the same resolution for all screen scales such as @1x, @2x and
    ///                                       @3x (i.e. single image from web server). Set to `false` for images loaded
    ///                                       from an asset catalog with varying resolutions for each screen scale.
    ///                                       `false` by default.
    ///
    /// - returns: A new image object.
    public func af_imageRounded(withCornerRadius radius: CGFloat, divideRadiusByImageScale: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let scaledRadius = divideRadiusByImageScale ? radius / scale : radius

        let clippingPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerRadius: scaledRadius)
        clippingPath.addClip()

        draw(in: CGRect(origin: CGPoint.zero, size: size))

        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return roundedImage
    }

    /// Returns a new version of the image rounded into a circle.
    ///
    /// - returns: A new image object.
    public func af_imageRoundedIntoCircle() -> UIImage {
        let radius = min(size.width, size.height) / 2.0
        var squareImage = self

        if size.width != size.height {
            let squareDimension = min(size.width, size.height)
            let squareSize = CGSize(width: squareDimension, height: squareDimension)
            squareImage = af_imageAspectScaled(toFill: squareSize)
        }

        UIGraphicsBeginImageContextWithOptions(squareImage.size, false, 0.0)

        let clippingPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: squareImage.size),
            cornerRadius: radius
        )

        clippingPath.addClip()

        squareImage.draw(in: CGRect(origin: CGPoint.zero, size: squareImage.size))

        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return roundedImage
    }
}

#endif

#if os(iOS) || os(tvOS)

import CoreImage

// MARK: - Core Image Filters

@available(iOS 9.0, *)
extension UIImage {
    /// Returns a new version of the image using a CoreImage filter with the specified name and parameters.
    ///
    /// - parameter name:       The name of the CoreImage filter to use on the new image.
    /// - parameter parameters: The parameters to apply to the CoreImage filter.
    ///
    /// - returns: A new image object, or `nil` if the filter failed for any reason.
    public func af_imageFiltered(withCoreImageFilter name: String, parameters: [String: Any]? = nil) -> UIImage? {
        var image: CoreImage.CIImage? = ciImage

        if image == nil, let CGImage = self.cgImage {
            image = CoreImage.CIImage(cgImage: CGImage)
        }

        guard let coreImage = image else { return nil }

        let context = CIContext(options: [kCIContextPriorityRequestLow: true])

        var parameters: [String: Any] = parameters ?? [:]
        parameters[kCIInputImageKey] = coreImage

        guard let filter = CIFilter(name: name, withInputParameters: parameters) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        let cgImageRef = context.createCGImage(outputImage, from: outputImage.extent)

        return UIImage(cgImage: cgImageRef!, scale: scale, orientation: imageOrientation)
    }
}

#endif
//
//  UIImageView+AlamofireImage.swift
//
//  Copyright (c) 2015-2016 Alamofire Software Foundation (http://alamofire.org/)
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
//

import Alamofire
import Foundation

#if os(iOS) || os(tvOS)

import UIKit

extension UIImageView {

    // MARK: - ImageTransition

    /// Used to wrap all `UIView` animation transition options alongside a duration.
    public enum ImageTransition {
        case noTransition
        case crossDissolve(TimeInterval)
        case curlDown(TimeInterval)
        case curlUp(TimeInterval)
        case flipFromBottom(TimeInterval)
        case flipFromLeft(TimeInterval)
        case flipFromRight(TimeInterval)
        case flipFromTop(TimeInterval)
        case custom(
            duration: TimeInterval,
            animationOptions: UIViewAnimationOptions,
            animations: (UIImageView, Image) -> Void,
            completion: ((Bool) -> Void)?
        )

        /// The duration of the image transition in seconds.
        public var duration: TimeInterval {
            switch self {
            case .noTransition:
                return 0.0
            case .crossDissolve(let duration):
                return duration
            case .curlDown(let duration):
                return duration
            case .curlUp(let duration):
                return duration
            case .flipFromBottom(let duration):
                return duration
            case .flipFromLeft(let duration):
                return duration
            case .flipFromRight(let duration):
                return duration
            case .flipFromTop(let duration):
                return duration
            case .custom(let duration, _, _, _):
                return duration
            }
        }

        /// The animation options of the image transition.
        public var animationOptions: UIViewAnimationOptions {
            switch self {
            case .noTransition:
                return UIViewAnimationOptions()
            case .crossDissolve:
                return .transitionCrossDissolve
            case .curlDown:
                return .transitionCurlDown
            case .curlUp:
                return .transitionCurlUp
            case .flipFromBottom:
                return .transitionFlipFromBottom
            case .flipFromLeft:
                return .transitionFlipFromLeft
            case .flipFromRight:
                return .transitionFlipFromRight
            case .flipFromTop:
                return .transitionFlipFromTop
            case .custom(_, let animationOptions, _, _):
                return animationOptions
            }
        }

        /// The animation options of the image transition.
        public var animations: ((UIImageView, Image) -> Void) {
            switch self {
            case .custom(_, _, let animations, _):
                return animations
            default:
                return { $0.image = $1 }
            }
        }

        /// The completion closure associated with the image transition.
        public var completion: ((Bool) -> Void)? {
            switch self {
            case .custom(_, _, _, let completion):
                return completion
            default:
                return nil
            }
        }
    }

    // MARK: - Private - AssociatedKeys

    private struct AssociatedKey {
        static var imageDownloader = "af_UIImageView.ImageDownloader"
        static var sharedImageDownloader = "af_UIImageView.SharedImageDownloader"
        static var activeRequestReceipt = "af_UIImageView.ActiveRequestReceipt"
    }

    // MARK: - Associated Properties

    /// The instance image downloader used to download all images. If this property is `nil`, the `UIImageView` will
    /// fallback on the `af_sharedImageDownloader` for all downloads. The most common use case for needing to use a
    /// custom instance image downloader is when images are behind different basic auth credentials.
    public var af_imageDownloader: ImageDownloader? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.imageDownloader) as? ImageDownloader
        }
        set(downloader) {
            objc_setAssociatedObject(self, &AssociatedKey.imageDownloader, downloader, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The shared image downloader used to download all images. By default, this is the default `ImageDownloader`
    /// instance backed with an `AutoPurgingImageCache` which automatically evicts images from the cache when the memory
    /// capacity is reached or memory warning notifications occur. The shared image downloader is only used if the
    /// `af_imageDownloader` is `nil`.
    public class var af_sharedImageDownloader: ImageDownloader {
        get {
            if let downloader = objc_getAssociatedObject(self, &AssociatedKey.sharedImageDownloader) as? ImageDownloader {
                return downloader
            } else {
                return ImageDownloader.default
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.sharedImageDownloader, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var af_activeRequestReceipt: RequestReceipt? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.activeRequestReceipt) as? RequestReceipt
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.activeRequestReceipt, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - Image Download

    /// Asynchronously downloads an image from the specified URL, applies the specified image filter to the downloaded
    /// image and sets it once finished while executing the image transition.
    ///
    /// If the image is cached locally, the image is set immediately. Otherwise the specified placehoder image will be
    /// set immediately, and then the remote image will be set once the image request is finished.
    ///
    /// The `completion` closure is called after the image download and filtering are complete, but before the start of
    /// the image transition. Please note it is no longer the responsibility of the `completion` closure to set the
    /// image. It will be set automatically. If you require a second notification after the image transition completes,
    /// use a `.Custom` image transition with a `completion` closure. The `.Custom` `completion` closure is called when
    /// the image transition is finished.
    ///
    /// - parameter url:                        The URL used for the image request.
    /// - parameter placeholderImage:           The image to be set initially until the image request finished. If
    ///                                         `nil`, the image view will not change its image until the image
    ///                                         request finishes. Defaults to `nil`.
    /// - parameter filter:                     The image filter applied to the image after the image request is
    ///                                         finished. Defaults to `nil`.
    /// - parameter progress:                   The closure to be executed periodically during the lifecycle of the
    ///                                         request. Defaults to `nil`.
    /// - parameter progressQueue:              The dispatch queue to call the progress closure on. Defaults to the
    ///                                         main queue.
    /// - parameter imageTransition:            The image transition animation applied to the image when set.
    ///                                         Defaults to `.None`.
    /// - parameter runImageTransitionIfCached: Whether to run the image transition if the image is cached. Defaults
    ///                                         to `false`.
    /// - parameter completion:                 A closure to be executed when the image request finishes. The closure
    ///                                         has no return value and takes three arguments: the original request,
    ///                                         the response from the server and the result containing either the
    ///                                         image or the error that occurred. If the image was returned from the
    ///                                         image cache, the response will be `nil`. Defaults to `nil`.
    public func af_setImage(
        withURL url: URL,
        placeholderImage: UIImage? = nil,
        filter: ImageFilter? = nil,
        progress: ImageDownloader.ProgressHandler? = nil,
        progressQueue: DispatchQueue = DispatchQueue.main,
        imageTransition: ImageTransition = .noTransition,
        runImageTransitionIfCached: Bool = false,
        completion: ((DataResponse<UIImage>) -> Void)? = nil)
    {
        af_setImage(
            withURLRequest: urlRequest(with: url),
            placeholderImage: placeholderImage,
            filter: filter,
            progress: progress,
            progressQueue: progressQueue,
            imageTransition: imageTransition,
            runImageTransitionIfCached: runImageTransitionIfCached,
            completion: completion
        )
    }

    /// Asynchronously downloads an image from the specified URL Request, applies the specified image filter to the downloaded
    /// image and sets it once finished while executing the image transition.
    ///
    /// If the image is cached locally, the image is set immediately. Otherwise the specified placehoder image will be
    /// set immediately, and then the remote image will be set once the image request is finished.
    ///
    /// The `completion` closure is called after the image download and filtering are complete, but before the start of
    /// the image transition. Please note it is no longer the responsibility of the `completion` closure to set the
    /// image. It will be set automatically. If you require a second notification after the image transition completes,
    /// use a `.Custom` image transition with a `completion` closure. The `.Custom` `completion` closure is called when
    /// the image transition is finished.
    ///
    /// - parameter urlRequest:                 The URL request.
    /// - parameter placeholderImage:           The image to be set initially until the image request finished. If
    ///                                         `nil`, the image view will not change its image until the image
    ///                                         request finishes. Defaults to `nil`.
    /// - parameter filter:                     The image filter applied to the image after the image request is
    ///                                         finished. Defaults to `nil`.
    /// - parameter progress:                   The closure to be executed periodically during the lifecycle of the
    ///                                         request. Defaults to `nil`.
    /// - parameter progressQueue:              The dispatch queue to call the progress closure on. Defaults to the
    ///                                         main queue.
    /// - parameter imageTransition:            The image transition animation applied to the image when set.
    ///                                         Defaults to `.None`.
    /// - parameter runImageTransitionIfCached: Whether to run the image transition if the image is cached. Defaults
    ///                                         to `false`.
    /// - parameter completion:                 A closure to be executed when the image request finishes. The closure
    ///                                         has no return value and takes three arguments: the original request,
    ///                                         the response from the server and the result containing either the
    ///                                         image or the error that occurred. If the image was returned from the
    ///                                         image cache, the response will be `nil`. Defaults to `nil`.
    public func af_setImage(
        withURLRequest urlRequest: URLRequestConvertible,
        placeholderImage: UIImage? = nil,
        filter: ImageFilter? = nil,
        progress: ImageDownloader.ProgressHandler? = nil,
        progressQueue: DispatchQueue = DispatchQueue.main,
        imageTransition: ImageTransition = .noTransition,
        runImageTransitionIfCached: Bool = false,
        completion: ((DataResponse<UIImage>) -> Void)? = nil)
    {
        guard !isURLRequestURLEqualToActiveRequestURL(urlRequest) else {
            let error = AFIError.requestCancelled
            let response = DataResponse<UIImage>(request: nil, response: nil, data: nil, result: .failure(error))

            completion?(response)

            return
        }

        af_cancelImageRequest()

        let imageDownloader = af_imageDownloader ?? UIImageView.af_sharedImageDownloader
        let imageCache = imageDownloader.imageCache

        // Use the image from the image cache if it exists
        if
            let request = urlRequest.urlRequest,
            let image = imageCache?.image(for: request, withIdentifier: filter?.identifier)
        {
            let response = DataResponse<UIImage>(request: request, response: nil, data: nil, result: .success(image))

            if runImageTransitionIfCached {
                let tinyDelay = DispatchTime.now() + Double(Int64(0.001 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)

                // Need to let the runloop cycle for the placeholder image to take affect
                DispatchQueue.main.asyncAfter(deadline: tinyDelay) {
                    self.run(imageTransition, with: image)
                    completion?(response)
                }
            } else {
                self.image = image
                completion?(response)
            }

            return
        }

        // Set the placeholder since we're going to have to download
        if let placeholderImage = placeholderImage { self.image = placeholderImage }

        // Generate a unique download id to check whether the active request has changed while downloading
        let downloadID = UUID().uuidString

        // Download the image, then run the image transition or completion handler
        let requestReceipt = imageDownloader.download(
            urlRequest,
            receiptID: downloadID,
            filter: filter,
            progress: progress,
            progressQueue: progressQueue,
            completion: { [weak self] response in
                guard
                    let strongSelf = self,
                    strongSelf.isURLRequestURLEqualToActiveRequestURL(response.request) &&
                    strongSelf.af_activeRequestReceipt?.receiptID == downloadID
                else {
                    completion?(response)
                    return
                }

                if let image = response.result.value {
                    strongSelf.run(imageTransition, with: image)
                }

                strongSelf.af_activeRequestReceipt = nil

                completion?(response)
            }
        )

        af_activeRequestReceipt = requestReceipt
    }

    // MARK: - Image Download Cancellation

    /// Cancels the active download request, if one exists.
    public func af_cancelImageRequest() {
        guard let activeRequestReceipt = af_activeRequestReceipt else { return }

        let imageDownloader = af_imageDownloader ?? UIImageView.af_sharedImageDownloader
        imageDownloader.cancelRequest(with: activeRequestReceipt)

        af_activeRequestReceipt = nil
    }

    // MARK: - Image Transition

    /// Runs the image transition on the image view with the specified image.
    ///
    /// - parameter imageTransition: The image transition to ran on the image view.
    /// - parameter image:           The image to use for the image transition.
    public func run(_ imageTransition: ImageTransition, with image: Image) {
        UIView.transition(
            with: self,
            duration: imageTransition.duration,
            options: imageTransition.animationOptions,
            animations: { imageTransition.animations(self, image) },
            completion: imageTransition.completion
        )
    }

    // MARK: - Private - URL Request Helper Methods

    private func urlRequest(with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)

        for mimeType in DataRequest.acceptableImageContentTypes {
            urlRequest.addValue(mimeType, forHTTPHeaderField: "Accept")
        }

        return urlRequest
    }

    private func isURLRequestURLEqualToActiveRequestURL(_ urlRequest: URLRequestConvertible?) -> Bool {
        if
            let currentRequestURL = af_activeRequestReceipt?.request.task?.originalRequest?.url,
            let requestURL = urlRequest?.urlRequest?.url,
            currentRequestURL == requestURL
        {
            return true
        }

        return false
    }
}

#endif
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
	
    var title: String
	//Image string, Description
	var images: [(String, String)]?
    var thumbnailImage: String?
	var thumbnailText: String?
	var description: String
	
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
		self.description = ""
	}
	
	init (title: String?) {
		if title != nil {
			self.title = title!
		} else {
			self.title = "Excursion"
		}
		self.description = ""
	}
	//TODO: Fix shit
	init (title: String, images: [(String, String)]?, thumbnailImage: String?, thumbnailText: String, description: String?, isFavourite: Bool, type: String?, tableContent: [DetailTableContent], duration: String? , difficulty: String?, gpxFileURL: URL?, location: CLLocationCoordinate2D?, span: MKCoordinateSpan?, maxSpan: MKCoordinateSpan?) {
		
		self.title = title
		self.images = images
		if thumbnailImage == nil && images != nil && images!.count > 0{
			//self.thumbnailImage = images![0].0
		} else {
			self.thumbnailImage = thumbnailImage
		}
		self.thumbnailText = thumbnailText
		self.description = ""
		
		self.description = description ?? ""
		
		self.isFavourite = isFavourite
		self.type = type
		
		self.tableContent = tableContent
		
		self.gpxFileURL = gpxFileURL
		self.location = location
		self.span = span
		self.maxSpan = maxSpan
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
    @IBOutlet weak var descriptionView: UILabel!
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
    
    @IBOutlet weak var tableView: UIView!
    
    
	let tableCellHeightRatio: CGFloat = 0.1
    let tableIconHeightRatio: CGFloat = 0.07
    
    var tableCells = [ExcursionDetailTableViewCell]()
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.automaticallyAdjustsScrollViewInsets = false
		
		excursionTitle.title = excursion.title
        descriptionView.text = excursion.description
        setAttributes()
		
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
		
		
		setColors()
		selectText()
		
        
        inserTableView()
		/*tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 40*/
		//adjustTableViewHeight()
		//updateTableHeight()
	}
	
	/*override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateHeight()
	}*/
	
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
	}
	
	func setAttributes() {
		descriptionView.attributedText = NSAttributedString(string: descriptionView.text!, attributes: ViraViraFontAttributes.description)
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
	
	func smallImageSize() -> CGSize {
		return CGSize(width: 600, height: 600)
	}
	
	func fullImageSize() -> CGSize {
		return CGSize(width: 1200, height: 1200)
	}
	
	func createURL(withImage image: String, width: CGFloat, height: CGFloat) -> URL {
		let base = "https://hotelviravira.com/app/Images/getImage.php?"
		let urlString = "\(base)image=\(image)&w=\(width)&h=\(height)"
		let url = URL(string: urlString)
		
		assert(url != nil, "Invalid URL")
		return url!
	}
	
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageGallaryCollectionViewCell
		
		if let images = excursion.images {
			let imageURL = images[indexPath.item].0
			let url = createURL(withImage: imageURL, width: smallImageSize().width, height: smallImageSize().height)
			cell.imageView.tintColor = UIColor.primary
			DispatchQueue.global().async {
				cell.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "PlaceHolder").withRenderingMode(.alwaysTemplate))
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
				let url = createURL(withImage: element.0, width: fullImageSize().width, height: fullImageSize().height)
				images.append(url)
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
	
    
    //MARK: - Tableview
    
    func inserTableView() {
        guard excursion.tableContent != nil else {
            tableView.applyHeightConstraint(0)
            return
        }
        let view = createTable(tableContents: excursion.tableContent!)
		view.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(view)
        view.applyConstraintFitToSuperview()
    }
    
    func createTable(tableContents: [DetailTableContent]) -> UIView {
        let tableView = UIView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
        
        var views = [UIView]()
        
        for content in tableContents {
            views.append(createCell(tableContent: content))
        }
		
		for index in 0..<views.count {
			let currentView = views[index]
			tableView.addSubview(currentView)
			
			currentView.applyLeadingAndTrailingPinConstraint(toSuperview: 0)
			
			if index == 0 {
				currentView.applyTopPinConstraint(toSuperview: 0)
			} else {
				NSLayoutConstraint(item: currentView, attribute: .top, relatedBy: .equal, toItem: views[(index - 1)], attribute: .bottom, multiplier: 1, constant: 8).isActive = true
			}
			
			if index == (views.count - 1) {
				currentView.applyBottomPinConstraint(toSuperview: 0)
			}
		}
        
        /*var viewsDict: [String: Any] = [:]
        
        for (index, view) in views.enumerated() {
            tableView.addSubview(view)
            if index == 0 {
                view.applyTopPinConstraint(toSuperview: 0)
            } else if index == (views.count - 1) {
                view.applyBottomPinConstraint(toSuperview: 0)
            }
            
            view.applyLeadingAndTrailingPinConstraint(toSuperview: 0)
			
			let asciiInt = index + 65
			let char = Character(UnicodeScalar(asciiInt)!)
            
            viewsDict["\(char)"] = view
        }
        
        for index in 0..<viewsDict.count {
            
            guard index != 0 else {continue}
			
			let firstIndex = Character(UnicodeScalar(index+65-1)!)
			let secondIndex = Character(UnicodeScalar(index+65)!)
            
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-[\(firstIndex)]-[\(secondIndex)]-|",
                options: [],
                metrics: nil,
                views: viewsDict)
        }*/
        
        return tableView
    }
    
    func createCell(tableContent: DetailTableContent) -> UIView {
        let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		//view.backgroundColor = UIColor.green
		
        let image = UIImageView(image: tableContent.icon.withRenderingMode(.alwaysTemplate))
		image.tintColor = UIColor.primary
		image.translatesAutoresizingMaskIntoConstraints = false
		
        let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: tableContent.text, attributes: ViraViraFontAttributes.description)
        label.numberOfLines = 0
		
		let separator = UIView()
		separator.translatesAutoresizingMaskIntoConstraints = false
		separator.backgroundColor = UIColor.primary
		
		let imageLabelView = UIView()
		//imageLabelView.backgroundColor = UIColor.red
		imageLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        imageLabelView.addSubview(image)
        imageLabelView.addSubview(label)
		view.addSubview(imageLabelView)
		view.addSubview(separator)
		
        
        image.applyAspectRatioConstraint()
		image.applyCenterYPinConstraint(toSuperview: 0)
		
		//image.applyTopAndBottomPinConstraint(toSuperview: 0)
		image.applyLeadingPinConstraint(toSuperview: 0)
		
        label.applyTopAndBottomPinConstraint(toSuperview: 0)
		label.applyTrailingPinConstraint(toSuperview: 0)
		
		imageLabelView.applyTopPinConstraint(toSuperview: 0)
		imageLabelView.applyLeadingAndTrailingPinConstraint(toSuperview: 0)
		
		separator.applyHeightConstraint(1)
		separator.applyLeadingAndTrailingPinConstraint(toSuperview: 0)
		separator.applyBottomPinConstraint(toSuperview: 0)
		
		//NSLayoutConstraint(item: image, attribute: .bottom, relatedBy: .equal, toItem: separator, attribute: .top, multiplier: 1, constant: 8).isActive = true
		NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: imageLabelView, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
		NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: image, attribute: .trailing, multiplier: 1, constant: 32).isActive = true
		
		//Add image bottom constraint in case of too small cell
		let fixSizeBotConstraint = NSLayoutConstraint(item: imageLabelView, attribute: .bottom, relatedBy: .equal, toItem: image, attribute: .bottom, multiplier: 1, constant: 8)
		fixSizeBotConstraint.priority = 250
		fixSizeBotConstraint.isActive = true
		
		NSLayoutConstraint(item: imageLabelView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: image, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        
        return view
    }
}

/*extension ExcursionDetailView: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return excursion.tableContent?.count ?? 0
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
       // cell.descriptionText.setMaxFontSize(minSize: 7, maxSize: 21)
        
        if !tableCells.contains(cell) {
            tableCells.insert(cell, at: indexPath.row)
        }
		
        if (self.tableView(tableView, numberOfRowsInSection: 0) - 1) == indexPath.row {
           // updateTableHeight()
		}
		
		return cell
	}
	
	/*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}*/
	
/*	func updateHeight() {
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
	}*/
    
 /*   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * tableCellHeightRatio
    }*/
	
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        /*let minHeight = UIScreen.main.bounds.height * tableCellHeightRatio
        
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
        
        return textViewHeight > minHeight ? textViewHeight : minHeight*/
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
*/
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
//  ExcursionImageDownloader.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 29/05/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class ExcursionImageDownloader {
	
	static var shared = ExcursionImageDownloader()
	
	func getImage(from url: URL?, completion: @escaping (UIImage) -> Void) {
		guard url != nil else {return}
		
		let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000_000, preferredMemoryUsageAfterPurge: 60_000_000)
		
		if let image = imageCache.image(withIdentifier: url!.absoluteString) {
			completion(image)
		} else {
		
			//Download the image if not yet fetched
			Alamofire.request(url!, method: .get).responseImage { response in
				guard let image = response.result.value else {
					return
				}
				imageCache.add(image, withIdentifier: url!.absoluteString)
				completion(image)
			}
		}
	}
}
//
//  ExcursionManager.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 1/06/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation
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
//  ExcursionParser.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 17/05/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation
import MapKit

class ExcursionParser {
	static var shared = ExcursionParser()
	
	private var data: Data?
	private var models: [ExcursionDataModel]?
	private var downloadTask: URLSessionDataTask?
	
	private let url = URL(string: "http://www.hotelviravira.com/app/excursionsAPI.json")!
	
	var presentationStack = [UIViewController]()
	
	
	func parse(completion: @escaping (([ExcursionDataModel]) -> Void)) {
		let parserCompletion = {(models: [ExcursionDataModel]) -> Void in
			completion(models)
		}
		
		if models != nil {
			completion(models!)
		}
		else if data != nil {
			
			parse(data: data!, completion: parserCompletion)
		} else {
			//Download the data
			//parse it
			//Pass it
			
			let downloadCompletion = {(downloadedData: Data) -> Void in
				self.parse(data: downloadedData, completion: parserCompletion)
			}
			download(from: url, completion: downloadCompletion)
		}
	}
	
	func parse(data: Data, completion: ([ExcursionDataModel]) -> Void) {
		var json: [String: Any]?
		var models = [ExcursionDataModel]()
		
		do {
			json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
		} catch let error as NSError {
			self.displayError(error.localizedDescription)
		}
		
		guard json != nil else {completion(models); return}
		
		let list = json!["list"] as? NSArray
		guard list != nil else {completion(models); return}
		
		for index in 0..<list!.count {
			let element = list![index] as? [String: Any]
			if element != nil {
				models.append(excursion(from: element!))
			} else {
				displayError("Failed to create model from element: \(list![index])")
			}
		}
		
		//After parsing, call the completion with the created models
		self.models = models
		completion(models)
	}
	
	//Creates an excursion data model based of the element node passed.
	func excursion(from element: [String: Any]) -> ExcursionDataModel {
		let model = ExcursionDataModel()
		
		model.title = excursionTitle(from: element) ?? "Excursion"
		model.thumbnailImage = excursionThumbnailImage(from: element)
		model.images = excursionImagesDescriptionTouple(from: element)
		model.thumbnailText = excursionThumbnailDescription(from: element)
		model.description = excursionDescription(from: element) ?? ""
		model.tableContent = excursionDescriptionTable(from: element)
		model.type = excursionType(from: element)
		model.gpxFileURL = excursionGPXURL(from: element)
		model.location = excursionGPXLocation(from: element)
		model.span = excursionGPXSpan(from: element)
		model.maxSpan = excursionGPXMaxSpan(from: element)
		
		return model
	}
	
	//Parse the title of the excursion
	func excursionTitle(from node: [String: Any]) -> String? {
		return node["title"] as? String
	}
	
	//Parse the thumbnail image of the excursion
	func excursionThumbnailImage(from node: [String: Any]) -> String? {
		return excursionImages(from: node).0
	}
	
	//Parse the Image and its Description as a touple of the current excursion
	func excursionImagesDescriptionTouple(from node: [String: Any]) -> [(String, String)]? {
		return excursionImages(from: node).1
	}
	
	//Parses all images, the thumbnail and descriptive images in a double touple. 0 = Thumbnail Image and 1 = Image and its Description touple.
	func excursionImages(from node: [String: Any]) -> (String?, [(String, String)]?) {
		var thumbnailImage = node["thumbnailImage"] as? String
		
		let imagesDict = node["images"] as? NSArray
		guard imagesDict != nil else {return (thumbnailImage, nil)}
		
		var images = [(String, String)]()
		for index in 0..<imagesDict!.count {
			let image = imagesDict![index] as! [String: Any]
			var url: String? = image["url_name"] as? String
			let description = image["text"] as? String ?? ""
			images.append((url!, description))
		}
		
		if thumbnailImage == nil && images.count > 0 {
			thumbnailImage = (imagesDict![0] as! [String: Any])["url_name"] as? String
			//thumbnailImage = parseImage(from: (imagesDict![0] as! [String: Any]), isThumbnail: true)
			
			//thumbnailImage = images[0].0
		}
		
		return (thumbnailImage, images)
	}
	
	func imageNode(at index: Int, from node: NSArray) -> [String: Any]? {
		guard node.count > index else {return nil}
		return node[index] as? [String: Any]
	}
	
/*	func parseImage(from node: [String: Any], isThumbnail: Bool = false) -> String? {
		if isThumbnail {
			return node["url_name"] as? String
		}
		return nil
	}
	
	func parseImage(from node: [String: Any], isThumbnail: Bool = false) -> URL? {
		if isThumbnail {
			if let urlString = node["url_1x"] as? String {
				return URL(string: urlString)
			} else {
				return nil
			}
		} else {
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let viewController = appDelegate.window!.rootViewController!
			let trait = viewController.traitCollection
			
			var urlString: String?
			
			switch (trait.horizontalSizeClass, trait.verticalSizeClass) {
			case (.regular, .regular):
				urlString = node["url_3x"] as? String
				
			default:
				urlString = node["url_2x"] as? String
			}
			
			if urlString != nil {
				return URL(string: urlString!)
			} else {
				return nil
			}
		}
	}*/
	
	//Parse the thumbnail description
	func excursionThumbnailDescription(from node: [String: Any]) -> String? {
		return node["thumbnailDescription"] as? String
	}
	
	//Parse the detailed description of the excursion which is nested inside the description node
	func excursionDescription(from node: [String: Any]) -> String? {
		return (node["description"] as? [String: Any])?["text"] as? String
	}
	
	func excursionDescriptionTable(from node: [String: Any]) -> [DetailTableContent] {
		var descriptionTable = [DetailTableContent]()
		
		if let descriptionNode = node["description"] as? [String:Any] {
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
		}
		
		return descriptionTable
	}
	
	func excursionType(from node: [String: Any]) -> String? {
		return node["type"] as? String
	}
	
	func excursionGPX(from node: [String: Any]) -> [String: Any]? {
		return node["gpx"] as? [String: Any]
	}
	
	func excursionGPXURL(from node: [String: Any]) -> URL? {
		if let url = excursionGPX(from: node)?["gpxFile"] as? String {
			return URL(string: url)
		} else {
			return nil
		}
	}
	
	func excursionGPXLocation(from node: [String: Any]) -> CLLocationCoordinate2D? {
		let location = excursionGPX(from: node)?["location"] as? [String: Any]
		return location == nil ? nil : CLLocationCoordinate2D(latitude: location!["lat"] as! CLLocationDegrees, longitude: location!["lon"] as! CLLocationDegrees)
	}
	
	func excursionGPXSpan(from node: [String: Any]) -> MKCoordinateSpan? {
		let span = excursionGPX(from: node)?["span"] as? [String: Any]
		return span == nil ? nil : MKCoordinateSpan(latitudeDelta: span!["lat"] as! CLLocationDegrees, longitudeDelta: span!["lon"] as! CLLocationDegrees)
	}
	
	func excursionGPXMaxSpan(from node: [String: Any]) -> MKCoordinateSpan? {
		let maxSpan = excursionGPX(from: node)?["max span"] as? [String: Any]
		return maxSpan == nil ? nil : MKCoordinateSpan(latitudeDelta: maxSpan!["lat"] as! CLLocationDegrees, longitudeDelta: maxSpan!["lon"] as! CLLocationDegrees)
	}
	
	
	//MARK: - Download manager
	
	func download(from url: URL) {
		download(from: url, completion: nil)
	}
	
	func download(from url: URL, completion: ((Data) -> Void)?) {
		guard downloadTask == nil || downloadTask?.state == URLSessionTask.State.completed || downloadTask?.state == URLSessionTask.State.suspended else {return}
		displayAlert()
		
		let session = URLSession(configuration: .default)
		downloadTask = session.dataTask(with: url, completionHandler: {(downloadedData, response, error) in
			if error != nil {
				self.displayError(error!.localizedDescription)
			} else {
				if completion == nil {
					self.data = downloadedData
				} else if downloadedData != nil {
					completion!(downloadedData!)
				} else {
					self.displayError("Crititcal Error: Downloaded empty file. Please reload page. If this keeps occuring, please contact the developer.")
					return
				}
				self.removeAlert()
			}
			})
		
		downloadTask?.resume()
	}
	
	//MARK: - Notification manager
	
	func displayAlert() {
		let alert = UIAlertController(title: "Downloading necessary files...", message: "Downloading the excursions should not take more than a few seconds. If it does, please make sure to have a proper internet connection.", preferredStyle: .alert)
		
		
		//TODO: - Progress bar
	/*	let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = .white
		activityIndicator.startAnimating()
		
		alert.view.addSubview(activityIndicator)*/
		
		let action = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) -> Void in
			self.downloadTask?.suspend()
		})
		alert.addAction(action)
		
		display(alert)
	}
	
	func removeAlert() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let viewController = appDelegate.window!.rootViewController!
		
		guard viewController.presentedViewController != nil else {return}
		
		var completion: (() -> Void)?
		
		if presentationStack.count > 0 {
			completion = {
				viewController.present(self.presentationStack[0], animated: true, completion: {
					self.presentationStack.removeFirst()
				})
			}
		}
		
		if viewController.presentedViewController != nil {
			viewController.dismiss(animated: true, completion: completion)
		} else if completion != nil{
			completion!()
		}
	}
	
	func displayError(_ errorMessage: String) {
		let alert = UIAlertController(title: "An error occured", message: errorMessage, preferredStyle: .alert)
		let action = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) -> Void in
			self.downloadTask?.suspend()
		})
		alert.addAction(action)
		
		display(alert)
	}
	
	func display(_ alert: UIAlertController) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let viewController = appDelegate.window!.rootViewController!
		
		
		if viewController.presentedViewController != nil {
			if viewController.presentedViewController!.isBeingPresented {
				presentationStack.append(alert)
				removeAlert()
			} else {
				viewController.dismiss(animated: true, completion: {
					viewController.present(alert, animated: true, completion: nil)
				})
			}
		} else {
			viewController.present(alert, animated: true, completion: nil)
		}
	}
}
//
//  ExcursionSectionHeader.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 3/06/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class ExcursionSectionHeader: UIView {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var titleIcon: UIImageView!
	
	@IBOutlet weak var content: UIView!

}
//
//  ExcursionTable.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 14/08/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit
//import MapKit
//import DeviceKit
import KVConstraintExtensionsMaster

struct ExcursionSection {
	var excursionHeader: ExcursionHeader
	var excursions: [ExcursionDataModel]
}

class ExcursionTable: UIViewController, SWRevealViewControllerDelegate {

	//MARK: - Properties
	
    @IBOutlet weak var tableView: UITableView!
	
	//Selected cell to handle color change
    var currentSelectedCellIndexPath: IndexPath? = nil
	
	//Will animate Menu Button if true only.
	var comesFromSegue: Bool = false
	var menuButton: UIButtonAnimation!
	@IBOutlet weak var navBar: UINavigationItem!
	
	//Excursions with respective headers
	var excursionsSections = [ExcursionSection]() {
		didSet {
			DispatchQueue.main.async {
                self.updateRefreshViewDisplay()
				self.tableView.reloadData()
			}
		}
	}
	
	var excursionModels = [ExcursionDataModel]() {
		didSet {
			excursionsSections = createExcursionByType(excursions: excursionModels)
		}
	}
	
	//TODO: Change enum to closure
	var sortOrder: SortOrder = .TypeNameUp
	
	var refreshView: UIView?
	
	//MARK: - Initializing
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//Creates and Displays the overlay view that is presented when there are no excursions loaded.
		initializeRefreshView()
		updateRefreshViewDisplay()
		
		//Initialize the menu Button
		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		//Initialize the menu
		self.revealViewController().delegate = self
		
		//Animate the menu button if coming from the menu
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		//Set this view controller as the top view in the App Delegate
		(UIApplication.shared.delegate as! AppDelegate).currentViewController = self
		
		//Initializes the view with the corresponding default colors.
		setColor()
		
		//Parses the excursion API.
		//Creater parser class forfurther control.
		parse()
		
		//Call rotate() everytime the device is rotated
		NotificationCenter.default.addObserver(self, selector: #selector(ExcursionTable.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
		
		//Dynamic table height
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
		
		tableView.sectionHeaderHeight = UITableViewAutomaticDimension
		tableView.estimatedSectionHeaderHeight = 200
		
        tableView.delegate = self
        tableView.dataSource = self
		
		tableView.showsVerticalScrollIndicator = false
		tableView.showsVerticalScrollIndicator = false
	}
	
	//MARK: - Refreshview
	
	func createRefreshView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		let button = refreshButton()
		view.addSubview(button)
		view.backgroundColor = UIColor.secondary
		
		button.applyConstraintForCenterInSuperview()
		button.applyWidthConstraint(100)
        button.applyHeightConstraint(100)
		
		return view
	}
	
	func refreshButton() -> UIButton {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(ExcursionTable.parse), for: .touchUpInside)
        let image = #imageLiteral(resourceName: "Reload").withRenderingMode(.alwaysTemplate)
		button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.clear
		button.tintColor = UIColor.primary
		return button
	}
	
	func initializeRefreshView() {
        guard refreshView == nil else {return}
		refreshView = createRefreshView()
		self.view.addSubview(refreshView!)
		refreshView!.applyConstraintFitToSuperview()
	}
	
	//Displays or hides the refreshview depending if it should be displayed
	func updateRefreshViewDisplay() {
		refreshView?.isHidden = shouldDisplayRefreshView()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
	}
	
	func shouldDisplayRefreshView() -> Bool {
		return excursionsSections.count > 0
	}
	
	//MARK: - Parsing
	//Use the excursion parser to parse all the excursions
	func parse() {
		print("parse")
		ExcursionParser.shared.parse(completion: {(models: [ExcursionDataModel]) -> Void in
			self.excursionModels = models
		})
	}
	
	//MARK: - Tableview helper methods
	
	func setColor() {
		//Set default colors to views
		self.view.backgroundColor = UIColor.secondary
		self.tableView.separatorColor = UIColor.primary
	}
	
	func thumbnailSize() -> CGSize {
		return CGSize(width: 300, height: 300)
	}
	
	func createURL(withImage image: String, width: CGFloat, height: CGFloat) -> URL {
		let base = "https://hotelviravira.com/app/Images/getImage.php?"
		let urlString = "\(base)image=\(image)&w=\(width)&h=\(height)"
		let url = URL(string: urlString)
		
		assert(url != nil, "Invalid URL")
		return url!
	}
	
	//MARK: - Listeners
	
	func rotate() {
		
	}
	
	//Changes the color of a cell depending on its selected state
	func setColor(selected: Bool, cell: ExcursionTableCell) {
		
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

	//Called when a cell is selected.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//If the destination is a detail view, supply it with the correct excursion model.
		if segue.identifier == "ShowDetails" {
			//Currently the views are set up so the destination will be a navigation controller.
			let navController = segue.destination as! UINavigationController
			//Derive the top view of the navigation controller to get the Excursion Detail View.
			let detailView = navController.topViewController as! ExcursionDetailView
			
			//If the sender is actually a cell.
			//Checked just for safety to prevent crashes from future changes.
			if let selectedExcursionCell = sender as? ExcursionTableCell {
				//Get the index path of the selected cell.
				let indexPath = tableView.indexPath(for: selectedExcursionCell)
				//Set the excursion model of the detail view depending on the selected cell's index path.
				detailView.excursion = excursionsSections[indexPath!.section].excursions[indexPath!.row]
			}
		}
	}
	
	//Deselect the selected view when coming back from a detail view.
	@IBAction func unwindToExcursionTable(segue: UIStoryboardSegue) {
		if currentSelectedCellIndexPath != nil {
			tableView(tableView, didDeselectRowAt: currentSelectedCellIndexPath!)
		}
	}
	
	//MARK: - Menu Button
	
	//Animate the menu button.
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	//Called when the menu will be toggled.
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
	
	
	//MARK: - Sorting
	//TODO: REDO SORTING
	func sort(order: SortOrder) -> [ExcursionSection]{
		var tempExc = [ExcursionSection]()
		
		var excursionCreator: ([ExcursionDataModel]) -> [ExcursionSection]
		
		switch order {
		case .TypeNameUp, .TypeNameDown:
			excursionCreator = createExcursionByType
		}
		
		tempExc = excursionCreator(excursionModels)
		
		var excursionSorter: (ExcursionSection, ExcursionSection) -> Bool
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
	
	func createExcursionByType(excursions: [ExcursionDataModel]) -> [ExcursionSection] {
		var tempExc = [ExcursionSection]()
		for excursion in excursions {
			if let index = containsHeader(excursionModel: excursion, in: tempExc) {
				tempExc[index].excursions.append(excursion)
			} else {
				var title = excursion.title
				if excursion.type != nil {
					title = excursion.type!
				}
				let excursionHeader = header(from: title)
				tempExc.append(ExcursionSection(excursionHeader: excursionHeader, excursions: [excursion]))
			}
		}
		return tempExc
	}
	
	func containsHeader(excursionModel: ExcursionDataModel, in excursions: [ExcursionSection]) -> Int? {
		for (index, excursion) in excursions.enumerated() {
			if excursionModel.type == excursion.excursionHeader.title {
				return index
			}
		}
		return nil
	}
	
	func sortExcursionHeaderByNameUp(e1: ExcursionSection, e2: ExcursionSection) -> Bool {
		return e1.excursionHeader.title < e2.excursionHeader.title
	}
	
	func sortExcursionHeaderByNameDown(e1: ExcursionSection, e2: ExcursionSection) -> Bool {
		return e1.excursionHeader.title > e2.excursionHeader.title
	}
	
	func sortExcursionModelsByNameUp(e1: ExcursionDataModel, e2: ExcursionDataModel) -> Bool {
		return e1.title < e2.title
	}
	
	func sortExcursionModelsByNameDown(e1: ExcursionDataModel, e2: ExcursionDataModel) -> Bool {
		return e1.title > e2.title
	}
	
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
	//ENDTODO: UNTIL HERE
}

//Handle all table delegate and data source methods
extension ExcursionTable: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		//The number of sections that will be displayed
		return excursionsSections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//The number of excursions that each section will display
		return excursionsSections[section].excursions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//Safely downcast cell, if it's not existing due to any reason it will create and return an empty cell
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExcursionCell", for: indexPath) as? ExcursionTableCell else {return UITableViewCell()}
		
		//Since we are working with sections that have different amount of cells, we will get the correct excursion for this cell from the excursions array that is nested inside the excursionsSections array.
		let currentExcursion = self.excursionsSections[indexPath.section].excursions[indexPath.item]
		
		//Populate the cell
		//cell.title.text = currentExcursion.title
		cell.title.attributedText = NSAttributedString(string: currentExcursion.title, attributes: ViraViraFontAttributes.cellTitles)
		cell.descriptionText.attributedText = NSAttributedString(string: currentExcursion.thumbnailText ?? "", attributes: ViraViraFontAttributes.description)
		//cell.descriptionText.text = currentExcursion.thumbnailText
		cell.thumbnailImage.image = #imageLiteral(resourceName: "PlaceHolder").withRenderingMode(.alwaysTemplate)
		
		//Customize the cell
		cell.descriptionText.numberOfLines = 0
		cell.thumbnailImage.tintColor = UIColor.primary
		
		//Download image 
		
		if currentExcursion.thumbnailImage != nil {
			let url = createURL(withImage: currentExcursion.thumbnailImage!, width: thumbnailSize().width, height: thumbnailSize().height)
			ExcursionImageDownloader.shared.getImage(from: url, completion: {(image) in
				
				if let updateCell = tableView.cellForRow(at: indexPath) as? ExcursionTableCell {
					updateCell.thumbnailImage.image = image
				}
			})
		}
		
		setColor(selected: false, cell: cell)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		//Properties
		let marginDistance: CGFloat = 8
		// Initializing Background View
		let view = UIView()
		
		//Initializing Image View and adding it as subview to background View
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(image)
		
		//Initialize label and adding it as subview to background view.
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		view.addSubview(label)
		
		//Constraining views
		image.applyLeadingPinConstraint(toSuperview: marginDistance)
		image.applyTopAndBottomPinConstraint(toSuperview: marginDistance)
		image.applyAspectRatioConstraint()
		label.applyTopAndBottomPinConstraint(toSuperview: marginDistance)
		label.applyTrailingPinConstraint(toSuperview: marginDistance)
		
		NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: image, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
		
		//Populating header
		label.attributedText = NSAttributedString(string: excursionsSections[section].excursionHeader.title, attributes: ViraViraFontAttributes.sectionHeader)
		image.image = excursionsSections[section].excursionHeader.image
		
		//Setting Colors of views
		image.image = image.image?.withRenderingMode(.alwaysTemplate)
		image.tintColor = UIColor.primary
		view.backgroundColor = UIColor.tertiary
		
		
		return view
	}
	
	
	//MARK: Selection
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! ExcursionTableCell
		
		if currentSelectedCellIndexPath != nil {
			self.tableView(tableView, didDeselectRowAt: currentSelectedCellIndexPath!)
		}
		
		currentSelectedCellIndexPath = indexPath
		
		setColor(selected: true, cell: cell)
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? ExcursionTableCell else {return}
		
		setColor(selected: false, cell: cell)
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
    @IBOutlet weak var thumbnailImage: UIImageView!
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
		tableView.estimatedRowHeight = 75
		
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
		/*let bounds = UIScreen.main.bounds
		let height = bounds.width > bounds.height ? bounds.width : bounds.height
		return height * cellHeightMultiplier*/
		return UITableViewAutomaticDimension
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
import SDWebImage

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

	@IBOutlet weak var imageView: UIImageView!
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
			return 64
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
	static let excursion = JPMenuItem(title: "Excursions", image: #imageLiteral(resourceName: "excursion"), segueIdentifier: "ExcursionSegue")
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
		
		//self.revealViewController().delegate = self
		
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

class WeatherCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
		
		cell.timeStamp.attributedText = NSAttributedString(string: weatherModel.timeStamp(), attributes: ViraViraFontAttributes.smallInfo)
		
		var tempUnit = Weather.TemperatureUnits.Celsius
		if controllerView != nil {
			tempUnit = controllerView!.tempUnit
		}
		cell.temperature.attributedText = NSAttributedString(string: "\(weatherModel.temp(unit: tempUnit, roundToDecimal: 1))°", attributes: ViraViraFontAttributes.description)
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
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		switch UIScreen.traits {
		case (.regular, .regular):
			return CGSize(width: 150, height: 150)
		default:
			return CGSize(width: 75, height: 75)
		}
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
			NSUnderlineStyleAttributeName : 1
		]
		let attributedString = NSAttributedString(string: "Open Weather Map", attributes: attrs)
		openWeatherMapLink.setAttributedTitle(attributedString, for: .normal)
		
		setColors()
		setAttributes()
		
		
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
	
	func setAttributes() {
		cityLabel.attributedText = NSAttributedString(string: cityLabel.text!, attributes: ViraViraFontAttributes.title)
		condition.attributedText = NSAttributedString(string: condition.text!, attributes: ViraViraFontAttributes.description)
		currentTemp.attributedText = NSAttributedString(string: currentTemp.text!, attributes: ViraViraFontAttributes.temp)
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
			self.condition.attributedText = NSAttributedString(string: (self.currentWeatherMap?.weatherDescription)!)
			self.iconView.image = self.currentWeatherMap?.icon?.withRenderingMode(.alwaysTemplate)
			//iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
			if let temperature = self.currentWeatherMap?.temp(unit: self.tempUnit) {
				let convertedTemp = Double(round(temperature*10)/10)
				var degree = ""
				//self.currentTemp.attributedText = NSAttributedString(string: "\(convertedTemp)°")
				
				switch self.tempUnit {
				case .Celsius:
					degree = "C"
				case .Fahrenheit:
					degree = "F"
				case .Kelvin:
					degree = "K"
					
				}
				
				self.currentTemp.attributedText = NSAttributedString(string: "\(convertedTemp) \(degree)°", attributes: ViraViraFontAttributes.temp)
			} else {
				self.currentTemp.attributedText = NSAttributedString(string: "--", attributes: ViraViraFontAttributes.temp)
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
		
		cell.dayTag.attributedText = NSAttributedString(string: (weatherDays?[indexPath.item].day())!, attributes: ViraViraFontAttributes.cellTitles)
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
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch UIScreen.traits {
		case (.regular, .regular):
			return 200
			
		default:
			return 125
		}
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

