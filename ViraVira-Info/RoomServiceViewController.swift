//
//  RoomServiceViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 22/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class RoomServiceViewController: UIViewController {
	
    @IBOutlet weak var contentView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.secondary
		
		for subview in contentView.subviews {
			guard let view = subview as? UILabel else {continue}
			view.textColor = UIColor.primary
		}
	}

}
