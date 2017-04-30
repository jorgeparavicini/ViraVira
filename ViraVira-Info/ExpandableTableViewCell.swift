//
//  ExpandableTableViewCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 20/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class ExpandableTableViewCell: UITableViewCell {
	
	@IBOutlet weak var content: UIView!
	
	
	var sectionContent: UIView! {
		didSet {
			
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
