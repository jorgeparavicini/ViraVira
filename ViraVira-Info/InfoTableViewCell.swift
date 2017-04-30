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
