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
	
    var title: String
	//Image string, Description
	var images: [(String, String)]?
    var thumbnailImage: String?
	var thumbnailText: String?
	var description: String
	
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
		self.description = ""
	}
	
	init (title: String?) {
		if title != nil {
			self.title = title!
		} else {
			self.title = "Excursion"
		}
		self.description = ""
	}
	//TODO: Fix shit
	init (title: String, images: [(String, String)]?, thumbnailImage: String?, thumbnailText: String, description: String?, isFavourite: Bool, type: String?, tableContent: [DetailTableContent], duration: String? , difficulty: String?, gpxFileURL: URL?, location: CLLocationCoordinate2D?, span: MKCoordinateSpan?, maxSpan: MKCoordinateSpan?) {
		
		self.title = title
		self.images = images
		if thumbnailImage == nil && images != nil && images!.count > 0{
			//self.thumbnailImage = images![0].0
		} else {
			self.thumbnailImage = thumbnailImage
		}
		self.thumbnailText = thumbnailText
		self.description = ""
		
		self.description = description ?? ""
		
		self.isFavourite = isFavourite
		self.type = type
		
		self.tableContent = tableContent
		
		self.gpxFileURL = gpxFileURL
		self.location = location
		self.span = span
		self.maxSpan = maxSpan
	}
}

struct DetailTableContent {
	var icon: UIImage
	var text: String
}


