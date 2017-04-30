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
