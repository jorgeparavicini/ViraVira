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
