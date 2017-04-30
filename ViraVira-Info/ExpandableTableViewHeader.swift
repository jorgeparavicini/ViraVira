//
//  ExpandableTableViewHeader.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 20/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

protocol ExpandableTableViewHeaderDelegate {
	func toggleSection(header: ExpandableTableViewHeader, section: Int)
}

class ExpandableTableViewHeader: UIView {
	
	var delegate: ExpandableTableViewHeaderDelegate?
	var section: Int = 0
	
	let iconView = UIImageView()
	let titleLabel = UILabel()
	let arrowLabel = UILabel()

	let heightRatio: CGFloat = 0.8
	
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
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutIfNeeded()
		
		
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
	
	func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
		guard let cell = gestureRecognizer.view as? ExpandableTableViewHeader else {return}
		delegate?.toggleSection(header: self, section: cell.section)
	}
	
	func setCollapsed(collapsed: Bool) {
		arrowLabel.rotate(toValue: collapsed ? 0.0 : (CGFloat.pi / 2))
	}
}
