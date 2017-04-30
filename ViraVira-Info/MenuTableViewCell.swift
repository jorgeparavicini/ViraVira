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
