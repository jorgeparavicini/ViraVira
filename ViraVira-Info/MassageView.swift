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
