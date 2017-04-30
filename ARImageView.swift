//
//  ARImageView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 30/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class ARImageView: UIImageView {
	
	func resizeImage(size: CGSize) {
		DispatchQueue.global().async {
			let tempImage = self.image?.resizedImage(size, interpolationQuality: .default)
			
			DispatchQueue.main.async {
				self.image = tempImage
			}
		}
		
	}
}
