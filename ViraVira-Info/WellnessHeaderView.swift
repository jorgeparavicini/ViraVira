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
