//
//  UITextView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 1/03/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension UITextView {
	
	//MARK: - Sizing
	func setMaxFontSize(minSize: CGFloat = 10, maxSize: CGFloat = 28) {
		var maxSize = maxSize
		while (maxSize > minSize && self.sizeThatFits(CGSize(width: self.frame.size.width, height: CGFloat(Float.greatestFiniteMagnitude))).height >= self.frame.size.height) {
			maxSize -= 1.0;
			self.font = self.font?.withSize(maxSize)
		}
	}
	
	func centerVertically() {
		var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
		topCorrect = topCorrect > 0.0 ? topCorrect : 0
		print(topCorrect)
		self.contentOffset = CGPoint(x: 0, y: -topCorrect)
		self.contentInset = UIEdgeInsets(top: topCorrect, left: 0, bottom: 0, right: 0)
	}
}
