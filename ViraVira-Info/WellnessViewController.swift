//
//  WellnessViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 9/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit
import KVConstraintExtensionsMaster

class WellnessViewController: UIViewController {
	
//	MARK: - Outlets
	//@IBOutlet weak var tableView: UITableView!
	
    @IBOutlet weak var tableView: UITableView!
	
	
//	MARK: - Properties
	let estiamtedTableViewRowHeight: CGFloat = 100
	var headerHeight: CGFloat {
		return 66
	}
	
	var sections: [WellnessSection] = []
	
	var identifier: String = "cell"
	
	var labelFontSize: CGFloat {
		get {
			switch (self.view.traitCollection.horizontalSizeClass, self.view.traitCollection.verticalSizeClass) {
			case (.regular, .regular):
				return 24
			case (.compact, .compact):
				return 17
				
			default:
				return 17
			}
		}
	}
	
//	MARK: - System functions
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//Link the tableView to this class
		tableView.delegate = self
		tableView.dataSource = self
		//Set the tableview cells to use auto layout to determine height
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = estiamtedTableViewRowHeight
		
		tableView.separatorStyle = .none
		let cell = UINib(nibName: "WellnessTableViewCell", bundle: nil)
		tableView.register(cell, forCellReuseIdentifier: identifier)
		
		
		sections = sectionItems()
		setColors()
    }
	
//	MARK: - Setup
	
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
		tableView.backgroundColor = UIColor.secondary
		
	}
	
//	MARK: - Populating
	
	func sectionItems() -> [WellnessSection] {
		var sections = [WellnessSection]()
		let massage = massageView()
		sections.append(WellnessSection(name: "Massage", content: massage))
		let hotTub = hotTubView()
		sections.append(WellnessSection(name: "Hot Tubs", content: hotTub))
		
		return sections
	}
	
	func massageView() -> UIView {
		let massageView = Bundle.main.loadNibNamed("Massage", owner: MassageView(), options: nil)?[0] as! MassageView
		massageView.translatesAutoresizingMaskIntoConstraints = false
		return massageView
	}
	
	func hotTubView() -> UIView {
		let view = UIView()
		let label = UILabel()
		
		view.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.textColor = UIColor.primary
		label.textAlignment = .justified
		label.font = label.font.withSize(labelFontSize)
		view.addSubview(label)
		label.applyTopAndBottomPinConstraint(toSuperview: 16)
		label.applyCenterXPinConstraint(toSuperview: 0)
		label.numberOfLines = 0
		NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
		
		label.text = "We have 4 hot tubs in different spots of the hacienda. If you wish to use any of them, please let us know 6 hours in advance, so we can pre- pare it on time and you can enjoy it at the perfect temperature (40oC)."
		
		return view
	}
}

//MARK: -

extension WellnessViewController: UITableViewDelegate, UITableViewDataSource {
	//	MARK: - Table View Data source and Delegate
	func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].collapsed! ? 0 : 1
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let width = tableView.frame.width
		
		let header = WellnessHeaderView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: headerHeight)))
		
		
		
		header.iconView.image = sections[section].icon
		header.titleLabel.text = sections[section].name
		header.titleLabel.font = header.titleLabel.font.withSize(headerFontSize())
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
		
		return header
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = (UINib(nibName: "WellnessTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? WellnessTableViewCell) else {return UITableViewCell()}
		let item = sections[indexPath.section]
		
		cell.section = item
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return headerHeight
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func headerFontSize() -> CGFloat {
		switch (self.view.traitCollection.horizontalSizeClass, self.view.traitCollection.verticalSizeClass) {
		case(.regular, .regular):
			return 24
		case(.compact, .compact):
			return 21
			
		default:
			return 17
		}
	}
}

//MARK: -
extension WellnessViewController: WellnessTableViewHeaderDelegate {
//	MARK: - Table view collapsing delegate
	
	func toggleSection(header: WellnessHeaderView, section: Int) {
		let collapsed = !sections[section].collapsed
		
		sections[section].collapsed = collapsed
		header.setCollapsed(collapsed: collapsed)
		
		tableView.beginUpdates()
		let indexPaths = [IndexPath(row: 0, section: section)]
		if collapsed {
			tableView.deleteRows(at: indexPaths, with: .automatic)
		} else {
			tableView.insertRows(at: indexPaths, with: .automatic)
		}
		//tableView.reloadRows(at: indexPaths, with: .automatic)
		tableView.endUpdates()
	}
}


//MARK: - Custom view identifier enum
enum ViewType: Int {
	case defaultView = 0
	case wellness = 1
}
