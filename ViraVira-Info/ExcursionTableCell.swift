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
