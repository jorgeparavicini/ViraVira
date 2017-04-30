//
//  ExpandableTableView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 20/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

struct ExpandableTableViewSection {
	var name: String!
	var icon: UIImage?
	var content: [UIView]!
	var collapsed: Bool!
	
	init(name: String, icon: UIImage?, content: [UIView], collapsed: Bool) {
		self.name = name
		self.icon = icon
		self.content = content
		self.collapsed = collapsed
		
	//	for view in content {
			//view.tag = ViewType.
	//	}
		//content.tag = ViewType.wellness.rawValue
	}
	
	init(name: String, icon: UIImage?, content: [UIView]) {
		self.init(name: name, icon: icon, content: content, collapsed: true)
	}
	
	init(name: String, content: [UIView], collapsed: Bool) {
		self.init(name: name, icon: nil, content: content, collapsed: collapsed)
	}
	
	init(name: String, content: [UIView]) {
		self.init(name: name, icon: nil, content: content, collapsed: true)
	}
}

class ExpandableTableView: UITableView, ExpandableTableViewHeaderDelegate {
	
	var headerHeight: CGFloat = 66
	
	override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
		self.delegate = self
		self.dataSource = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.dataSource = self
		self.delegate = self
	}

	var sections: [ExpandableTableViewSection]?
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let width = tableView.frame.width
		
		let header = ExpandableTableViewHeader(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: headerHeight)))
		
		
		
		header.iconView.image = sections?[section].icon
		header.titleLabel.text = sections?[section].name
		header.arrowLabel.text = ">"
		
		
		header.backgroundColor = UIColor.tertiary
		header.iconView.backgroundColor = UIColor.clear
		header.iconView.image = header.iconView.image?.withRenderingMode(.alwaysTemplate)
		header.iconView.tintColor = UIColor.primary
		header.titleLabel.backgroundColor = UIColor.clear
		header.titleLabel.textColor = UIColor.primary
		header.arrowLabel.backgroundColor = UIColor.clear
		header.arrowLabel.textColor = UIColor.primary
		
		header.section = section
		header.delegate = self
		
		let separator = UIView()
		separator.translatesAutoresizingMaskIntoConstraints = false
		separator.backgroundColor = UIColor.primary
		header.addSubview(separator)
		separator.applyHeightConstraint(0.75)
		separator.applyEqualWidthPinConstrainToSuperview()
		separator.applyBottomPinConstraint(toSuperview: 0)
		
	/*	header.layer.shadowColor = UIColor.primary.cgColor
		header.layer.shadowOpacity = 0.25
		header.layer.shadowOffset = CGSize(width: 0, height: 2)
		header.layer.masksToBounds = false*/
		
		return header
	}
	
	func toggleSection(header: ExpandableTableViewHeader, section: Int) {
		let collapsed = !sections![section].collapsed
		
		sections![section].collapsed = collapsed
		header.setCollapsed(collapsed: collapsed)
		
		self.beginUpdates()
		var indexPaths = [IndexPath]()
		for row in 0..<sections![section].content.count {
			indexPaths.append(IndexPath(row: row, section: section))
		}
		
		print(indexPaths)
		
		if collapsed {
			self.deleteRows(at: indexPaths, with: .automatic)
		} else {
			self.insertRows(at: indexPaths, with: .automatic)
		}
		
		//self.reloadRows(at: indexPaths, with: .automatic)
		self.endUpdates()
	}
	
	
}

extension ExpandableTableView: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return sections?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections![section].collapsed! ? 0 : sections![section].content.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = UINib(nibName: "ExpandableTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ExpandableTableViewCell else {return UITableViewCell()}
		
		let item = sections?[indexPath.section].content[indexPath.row]
		
		cell.sectionContent = item
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return headerHeight
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
}
