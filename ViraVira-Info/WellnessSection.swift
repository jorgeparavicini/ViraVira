//
//  WellnessStruct.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 13/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation

struct WellnessSection {
	var name: String!
	var icon: UIImage?
	var content: UIView!
	var collapsed: Bool!
	
	 init(name: String, icon: UIImage?, content: UIView, collapsed: Bool) {
		self.name = name
		self.icon = icon
		self.content = content
		self.collapsed = collapsed
		
		content.tag = ViewType.wellness.rawValue
	}
	
	init(name: String, icon: UIImage?, content: UIView) {
		self.init(name: name, icon: icon, content: content, collapsed: true)
	}
	
	init(name: String, content: UIView, collapsed: Bool) {
		self.init(name: name, icon: nil, content: content, collapsed: collapsed)
	}
	
	init(name: String, content: UIView) {
		self.init(name: name, icon: nil, content: content, collapsed: true)
	}
}
