//
//  PillowMenuViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 22/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class PillowMenuViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
	@IBOutlet weak var duvetImageView: UIImageView!
	@IBOutlet weak var microFiberImageView: UIImageView!
	@IBOutlet weak var tecnogelImageView: UIImageView!
	@IBOutlet weak var viscoFiberImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.backgroundColor = UIColor.secondary
		
		for subview in contentView.subviews {
			if let view = subview as? UILabel {
				view.textColor = UIColor.primary
			}
		}
		
		let scale = UIScreen.main.scale
		
		let duvetSize = duvetImageView.frame.size
		let scaledSize = CGSize(width: duvetSize.width * scale, height: duvetSize.height * scale)
		duvetImageView.image = duvetImageView.image?.resizedImage(scaledSize, interpolationQuality: .default)
		microFiberImageView.image = microFiberImageView.image?.resizedImage(scaledSize, interpolationQuality: .default)
		tecnogelImageView.image = tecnogelImageView.image?.resizedImage(scaledSize, interpolationQuality: .default)
		viscoFiberImageView.image = viscoFiberImageView.image?.resizedImage(scaledSize, interpolationQuality: .default)
    }

}
