//
//  ExcursionExtension.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 8/07/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

extension Excursion {
	var imageURLs: [String] {
		get {
			return nsImageURLs as? [String] ?? []
		} set {
			nsImageURLs = newValue as NSArray
		}
	}
}
