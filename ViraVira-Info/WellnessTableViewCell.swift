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
