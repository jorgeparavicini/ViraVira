//
//  ExcursionTable.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 14/08/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit
//import MapKit
//import DeviceKit
import KVConstraintExtensionsMaster

struct ExcursionSection {
	var excursionHeader: ExcursionHeader
	var excursions: [ExcursionDataModel]
}

class ExcursionTable: UIViewController, SWRevealViewControllerDelegate {

	//MARK: - Properties
	
    @IBOutlet weak var tableView: UITableView!
	
	//Selected cell to handle color change
    var currentSelectedCellIndexPath: IndexPath? = nil
	
	//Will animate Menu Button if true only.
	var comesFromSegue: Bool = false
	var menuButton: UIButtonAnimation!
	@IBOutlet weak var navBar: UINavigationItem!
	
	//Excursions with respective headers
	var excursionsSections = [ExcursionSection]() {
		didSet {
			DispatchQueue.main.async {
                self.updateRefreshViewDisplay()
				self.tableView.reloadData()
			}
		}
	}
	
	var excursionModels = [ExcursionDataModel]() {
		didSet {
			excursionsSections = createExcursionByType(excursions: excursionModels)
		}
	}
	
	//TODO: Change enum to closure
	var sortOrder: SortOrder = .TypeNameUp
	
	var refreshView: UIView?
	
	//MARK: - Initializing
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//Creates and Displays the overlay view that is presented when there are no excursions loaded.
		initializeRefreshView()
		updateRefreshViewDisplay()
		
		//Initialize the menu Button
		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		//Initialize the menu
		self.revealViewController().delegate = self
		
		//Animate the menu button if coming from the menu
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		//Set this view controller as the top view in the App Delegate
		Menu.currentRootViewController = self
		
		//Initializes the view with the corresponding default colors.
		setColor()
		
		//Parses the excursion API.
		//Creater parser class forfurther control.
		parse()
		
		//Call rotate() everytime the device is rotated
		NotificationCenter.default.addObserver(self, selector: #selector(ExcursionTable.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
		
		//Dynamic table height
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
		
		tableView.sectionHeaderHeight = UITableViewAutomaticDimension
		tableView.estimatedSectionHeaderHeight = 200
		
        tableView.delegate = self
        tableView.dataSource = self
		
		tableView.showsVerticalScrollIndicator = false
		tableView.showsVerticalScrollIndicator = false
	}
	
	//MARK: - Refreshview
	
	func createRefreshView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		let button = refreshButton()
		view.addSubview(button)
		view.backgroundColor = UIColor.secondary
		
		button.applyConstraintForCenterInSuperview()
		button.applyWidthConstraint(100)
        button.applyHeightConstraint(100)
		
		return view
	}
	
	func refreshButton() -> UIButton {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(ExcursionTable.parse), for: .touchUpInside)
        let image = #imageLiteral(resourceName: "Reload").withRenderingMode(.alwaysTemplate)
		button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.clear
		button.tintColor = UIColor.primary
		return button
	}
	
	func initializeRefreshView() {
        guard refreshView == nil else {return}
		refreshView = createRefreshView()
		self.view.addSubview(refreshView!)
		refreshView!.applyConstraintFitToSuperview()
	}
	
	//Displays or hides the refreshview depending if it should be displayed
	func updateRefreshViewDisplay() {
		refreshView?.isHidden = shouldDisplayRefreshView()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
	}
	
	func shouldDisplayRefreshView() -> Bool {
		return excursionsSections.count > 0
	}
	
	//MARK: - Parsing
	//Use the excursion parser to parse all the excursions
	func parse() {
		print("parse")
		ExcursionParser.shared.parse(completion: {(models: [ExcursionDataModel]) -> Void in
			self.excursionModels = models
		})
	}
	
	//MARK: - Tableview helper methods
	
	func setColor() {
		//Set default colors to views
		self.view.backgroundColor = UIColor.secondary
		self.tableView.separatorColor = UIColor.primary
	}
	
	func thumbnailSize() -> CGSize {
		return CGSize(width: 300, height: 300)
	}
	
	func createURL(withImage image: String, width: CGFloat, height: CGFloat) -> URL {
		let base = "https://hotelviravira.com/app/Images/getImage.php?"
		let urlString = "\(base)image=\(image)&w=\(width)&h=\(height)"
		let url = URL(string: urlString)
		
		assert(url != nil, "Invalid URL")
		return url!
	}
	
	//MARK: - Listeners
	
	func rotate() {
		
	}
	
	//Changes the color of a cell depending on its selected state
	func setColor(selected: Bool, cell: ExcursionTableCell) {
		
		if !selected {
			cell.descriptionText.textColor = UIColor.primary
			cell.title.textColor = UIColor.primary
			cell.backgroundColor = UIColor.secondary
			cell.content.backgroundColor = UIColor.secondary
		} else {
			cell.descriptionText.textColor = UIColor.primary
			cell.title.textColor = UIColor.primary
			cell.backgroundColor = UIColor.tertiary
			cell.content.backgroundColor = UIColor.tertiary
		}
		
		//return cell
	}
	
	//MARK: - Navigation

	//Called when a cell is selected.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//If the destination is a detail view, supply it with the correct excursion model.
		if segue.identifier == "ShowDetails" {
			//Currently the views are set up so the destination will be a navigation controller.
			let navController = segue.destination as! UINavigationController
			//Derive the top view of the navigation controller to get the Excursion Detail View.
			let detailView = navController.topViewController as! ExcursionDetailView
			
			//If the sender is actually a cell.
			//Checked just for safety to prevent crashes from future changes.
			if let selectedExcursionCell = sender as? ExcursionTableCell {
				//Get the index path of the selected cell.
				let indexPath = tableView.indexPath(for: selectedExcursionCell)
				//Set the excursion model of the detail view depending on the selected cell's index path.
				detailView.excursion = excursionsSections[indexPath!.section].excursions[indexPath!.row]
			}
		}
	}
	
	//Deselect the selected view when coming back from a detail view.
	@IBAction func unwindToExcursionTable(segue: UIStoryboardSegue) {
		if currentSelectedCellIndexPath != nil {
			tableView(tableView, didDeselectRowAt: currentSelectedCellIndexPath!)
		}
	}
	
	//MARK: - Menu Button
	
	//Animate the menu button.
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	//Called when the menu will be toggled.
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
	
	
	//MARK: - Sorting
	//TODO: REDO SORTING
	func sort(order: SortOrder) -> [ExcursionSection]{
		var tempExc = [ExcursionSection]()
		
		var excursionCreator: ([ExcursionDataModel]) -> [ExcursionSection]
		
		switch order {
		case .TypeNameUp, .TypeNameDown:
			excursionCreator = createExcursionByType
		}
		
		tempExc = excursionCreator(excursionModels)
		
		var excursionSorter: (ExcursionSection, ExcursionSection) -> Bool
		var excursionModelSorter: (ExcursionDataModel, ExcursionDataModel) -> Bool
		
		switch order {
		case .TypeNameUp:
			excursionSorter = sortExcursionHeaderByNameUp
			excursionModelSorter = sortExcursionModelsByNameUp
		case .TypeNameDown:
			excursionSorter = sortExcursionHeaderByNameDown
			excursionModelSorter = sortExcursionModelsByNameDown
		}
		
		tempExc.sort(by: excursionSorter)
		for index in 0..<tempExc.count {
			tempExc[index].excursions.sort(by: excursionModelSorter)
		}
		
		return tempExc
	}
	
	func createExcursionByType(excursions: [ExcursionDataModel]) -> [ExcursionSection] {
		var tempExc = [ExcursionSection]()
		for excursion in excursions {
			if let index = containsHeader(excursionModel: excursion, in: tempExc) {
				tempExc[index].excursions.append(excursion)
			} else {
				var title = excursion.title
				if excursion.type != nil {
					title = excursion.type!
				}
				let excursionHeader = header(from: title)
				tempExc.append(ExcursionSection(excursionHeader: excursionHeader, excursions: [excursion]))
			}
		}
		return tempExc
	}
	
	func containsHeader(excursionModel: ExcursionDataModel, in excursions: [ExcursionSection]) -> Int? {
		for (index, excursion) in excursions.enumerated() {
			if excursionModel.type == excursion.excursionHeader.title {
				return index
			}
		}
		return nil
	}
	
	func sortExcursionHeaderByNameUp(e1: ExcursionSection, e2: ExcursionSection) -> Bool {
		return e1.excursionHeader.title < e2.excursionHeader.title
	}
	
	func sortExcursionHeaderByNameDown(e1: ExcursionSection, e2: ExcursionSection) -> Bool {
		return e1.excursionHeader.title > e2.excursionHeader.title
	}
	
	func sortExcursionModelsByNameUp(e1: ExcursionDataModel, e2: ExcursionDataModel) -> Bool {
		return e1.title < e2.title
	}
	
	func sortExcursionModelsByNameDown(e1: ExcursionDataModel, e2: ExcursionDataModel) -> Bool {
		return e1.title > e2.title
	}
	
	func header(from title: String) -> ExcursionHeader {
		let excursionHeader = ExcursionHeader.headers[title]
		if excursionHeader != nil {
			return excursionHeader!
		} else {
			return ExcursionHeader(title: title)
		}
	}

	enum SortOrder {
		case TypeNameUp
		case TypeNameDown
	}
	//ENDTODO: UNTIL HERE
}

//Handle all table delegate and data source methods
extension ExcursionTable: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		//The number of sections that will be displayed
		return excursionsSections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//The number of excursions that each section will display
		return excursionsSections[section].excursions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//Safely downcast cell, if it's not existing due to any reason it will create and return an empty cell
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExcursionCell", for: indexPath) as? ExcursionTableCell else {return UITableViewCell()}
		
		//Since we are working with sections that have different amount of cells, we will get the correct excursion for this cell from the excursions array that is nested inside the excursionsSections array.
		let currentExcursion = self.excursionsSections[indexPath.section].excursions[indexPath.item]
		
		//Populate the cell
		//cell.title.text = currentExcursion.title
		cell.title.attributedText = NSAttributedString(string: currentExcursion.title, attributes: ViraViraFontAttributes.cellTitles)
		cell.descriptionText.attributedText = NSAttributedString(string: currentExcursion.thumbnailText ?? "", attributes: ViraViraFontAttributes.description)
		//cell.descriptionText.text = currentExcursion.thumbnailText
		cell.thumbnailImage.image = #imageLiteral(resourceName: "PlaceHolder").withRenderingMode(.alwaysTemplate)
		
		//Customize the cell
		cell.descriptionText.numberOfLines = 0
		cell.thumbnailImage.tintColor = UIColor.primary
		
		//Download image 
		
		if currentExcursion.thumbnailImage != nil {
			let url = createURL(withImage: currentExcursion.thumbnailImage!, width: thumbnailSize().width, height: thumbnailSize().height)
			ExcursionImageDownloader.shared.getImage(from: url, completion: {(image) in
				
				if let updateCell = tableView.cellForRow(at: indexPath) as? ExcursionTableCell {
					updateCell.thumbnailImage.image = image
				}
			})
		}
		
		setColor(selected: false, cell: cell)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		//Properties
		let marginDistance: CGFloat = 8
		// Initializing Background View
		let view = UIView()
		
		//Initializing Image View and adding it as subview to background View
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(image)
		
		//Initialize label and adding it as subview to background view.
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		view.addSubview(label)
		
		//Constraining views
		image.applyLeadingPinConstraint(toSuperview: marginDistance)
		image.applyTopAndBottomPinConstraint(toSuperview: marginDistance)
		image.applyAspectRatioConstraint()
		label.applyTopAndBottomPinConstraint(toSuperview: marginDistance)
		label.applyTrailingPinConstraint(toSuperview: marginDistance)
		
		NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: image, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
		
		//Populating header
		label.attributedText = NSAttributedString(string: excursionsSections[section].excursionHeader.title, attributes: ViraViraFontAttributes.sectionHeader)
		image.image = excursionsSections[section].excursionHeader.image
		
		//Setting Colors of views
		image.image = image.image?.withRenderingMode(.alwaysTemplate)
		image.tintColor = UIColor.primary
		view.backgroundColor = UIColor.tertiary
		
		
		return view
	}
	
	
	//MARK: Selection
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! ExcursionTableCell
		
		if currentSelectedCellIndexPath != nil {
			self.tableView(tableView, didDeselectRowAt: currentSelectedCellIndexPath!)
		}
		
		currentSelectedCellIndexPath = indexPath
		
		setColor(selected: true, cell: cell)
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? ExcursionTableCell else {return}
		
		setColor(selected: false, cell: cell)
	}

}

