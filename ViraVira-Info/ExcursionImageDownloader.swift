//
//  ExcursionImageDownloader.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 29/05/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class ExcursionImageDownloader {
	
	static var shared = ExcursionImageDownloader()
	
	func getImage(from url: URL?, completion: @escaping (UIImage) -> Void) {
		guard url != nil else {return}
		
		let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000_000, preferredMemoryUsageAfterPurge: 60_000_000)
		
		if let image = imageCache.image(withIdentifier: url!.absoluteString) {
			completion(image)
		} else {
		
			//Download the image if not yet fetched
			Alamofire.request(url!, method: .get).responseImage { response in
				guard let image = response.result.value else {
					return
				}
				imageCache.add(image, withIdentifier: url!.absoluteString)
				completion(image)
			}
		}
	}
}
