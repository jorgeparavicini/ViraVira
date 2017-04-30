//
//  ExcursionDataModel.swift
//  ExcursionCreator
//
//  Created by Jorge Paravicini on 10/10/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation
import MapKit

class ExcursionDataModel {
	
	var uuid: String?
	
    var title: String
	var images: [(URL, String)]?
    var thumbnailImage: URL?
	var thumbnailText: String?
	var m_description: String
    
	var difficulty: String?
	
	var duration: String?
	
	var isFavourite: Bool = false
	var type: String?
	
	var tableContent: [DetailTableContent]?
	
	var doesGPXExist: Bool {
		get {
			return (gpxFileURL != nil && location != nil && span != nil && maxSpan != nil)
		}
	}
	
	var gpxFileURL: URL?
	var location: CLLocationCoordinate2D?
	var span: MKCoordinateSpan?
	var maxSpan: MKCoordinateSpan?
	
	init() {
		self.title = "Excursion"
		self.m_description = ""
	}
	
	init (title: String?) {
		if title != nil {
			self.title = title!
		} else {
			self.title = "Excursion"
		}
		self.m_description = ""
	}
	
	init (title: String, images: [(URL, String)]?, thumbnailImage: URL?, thumbnailText: String, description: String?, isFavourite: Bool, type: String?, tableContent: [DetailTableContent], duration: String? , difficulty: String?, gpxFileURL: URL?, location: CLLocationCoordinate2D?, span: MKCoordinateSpan?, maxSpan: MKCoordinateSpan?) {
		
		self.title = title
		self.images = images
		if thumbnailImage == nil && images != nil && images!.count > 0{
			self.thumbnailImage = images![0].0
		} else {
			self.thumbnailImage = thumbnailImage
		}
		self.thumbnailText = thumbnailText
		self.m_description = ""
		
		self.m_description = description ?? ""
		
		self.difficulty = difficulty
		self.duration = duration
		self.isFavourite = isFavourite
		self.type = type
		
		self.tableContent = tableContent
		
		self.gpxFileURL = gpxFileURL
		self.location = location
		self.span = span
		self.maxSpan = maxSpan
	}
	
	var description: String {
		get {
			return "Title: \(title)\nImages: \(String(describing: images))\nThumbnail Image: \(String(describing: thumbnailImage))\nThumbnail Text: \(String(describing: thumbnailText))\nComplete Text: \(m_description)\nDifficulty: \(String(describing: difficulty))\nDuration: \(String(describing: duration))\nIs Favourite = \(isFavourite)\nType: \(String(describing: type))"
		}
	}
}

struct DetailTableContent {
	var icon: UIImage
	var text: String
}


