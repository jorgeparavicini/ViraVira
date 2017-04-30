//
//  ImageViewExtension.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 11/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

extension UIImageView {
	func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
		contentMode = mode
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
				else { print("Failed to download image."); return }
			DispatchQueue.main.async() { () -> Void in
				self.image = image
			}
		}.resume()
	}
}

extension UIImage {
	
	func with(size: CGSize) -> UIImage? {
		UIGraphicsBeginImageContext(size)
		self.draw(in: CGRect(origin: CGPoint.zero, size: size))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}
