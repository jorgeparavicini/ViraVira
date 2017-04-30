//
//  ExcursionHeader.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 28/12/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

class ExcursionHeader {

	var title: String
	var image: UIImage?
	
	
	init (title: String) {
		self.title = title
	}
	
	init (title: String, image: UIImage) {
		self.title = title
		self.image = image
	}
	
	
	//MARK: Prebuilt options

	static let floating = ExcursionHeader(title: "Floating", image: #imageLiteral(resourceName: "floating"))
	static let hiking = ExcursionHeader(title: "Hiking", image: #imageLiteral(resourceName: "Hiking"))
	static let biking = ExcursionHeader(title: "Bicycle", image: #imageLiteral(resourceName: "biking"))
	static let horseBack = ExcursionHeader(title: "Horseback Riding", image: #imageLiteral(resourceName: "Horse"))
	static let adventure = ExcursionHeader(title: "Adventure", image: #imageLiteral(resourceName: "adventure"))
	static let kayak = ExcursionHeader(title: "Kayak", image: #imageLiteral(resourceName: "kayak"))
	static let fishing = ExcursionHeader(title: "Fishing", image: #imageLiteral(resourceName: "fishing"))
	static let other = ExcursionHeader(title: "Others")
	
	
	//Modify
	static let headers: [String: ExcursionHeader] = ["Hiking": ExcursionHeader.hiking, "Bicycle": ExcursionHeader.biking, "Adventure": ExcursionHeader.adventure, "Horseback Riding": ExcursionHeader.horseBack, "Floating": ExcursionHeader.floating, "Kayak": ExcursionHeader.kayak, "Fishing": ExcursionHeader.fishing]
}
