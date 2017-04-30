//
//  WeatherDescriptionLabel.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 14/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class WeatherDescriptionLabel: UILabel {

	override var text: String? {
		didSet {
			self.sizeToFit()
			super.text = text
		}
	}
}
