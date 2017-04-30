//
//  ExcursionTable.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 14/08/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit
import SDWebImage
import MapKit
import DeviceKit

struct Excursion {
	var excursionHeader: ExcursionHeader
	var excursions: [ExcursionDataModel]
}

class ExcursionTable: UITableViewController, SWRevealViewControllerDelegate {

	//MARK: - Properties
	
	let headerHeight: CGFloat = 50
	let headerTextHeight: CGFloat = 30
	let marginDistance: CGFloat = 8
	
	
	let cellHeightMultiplier: CGFloat = 0.2
	
	var currentSelectedCellIndexPath: IndexPath? = nil
	
	var comesFromSegue: Bool = false
	
	var menuButton: UIButtonAnimation!
	@IBOutlet weak var navBar: UINavigationItem!
	
	var excursionsToDisplay = [Excursion]() {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	var excursionModels = [ExcursionDataModel]()
	var download: URLSessionDataTask?
	var sortOrder: SortOrder = .TypeNameUp
	
	var alwaysUseBiggerRelation = true
	var tableCells = [ExcursionTableCell]()
	let tableCellHeightRatio: CGFloat = 0.1
	let tableIconHeightRatio: CGFloat = 0.08
	let cellExtraHeight: CGFloat = 48
	
	//MARK: - Initializing
	
	override func viewDidLoad() {
		super.viewDidLoad()
		clearsSelectionOnViewWillAppear = true
		
		menuButton = Menu.menuButton(self, animation: Menu.Animation.HamburgerToCross)
		navBar.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
		
		self.revealViewController().delegate = self
		
		if comesFromSegue {
			menuButton.animate(animationType: .Force_Close)
			comesFromSegue = false
		}
		
		(UIApplication.shared.delegate as! AppDelegate).currentViewController = self
		
		self.view.backgroundColor = UIColor.secondary
		self.tableView.separatorColor = UIColor.primary
		
		//defaultExcursions()
		parse()
		
		NotificationCenter.default.addObserver(self, selector: #selector(ExcursionTable.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
		
		//printFonts()
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
	}
	
	func defaultExcursions() {
		
		//Rafting Excursions
		let raftingHeader = ExcursionHeader(title: "Rafting", image: #imageLiteral(resourceName: "floating"))
		var raftingExcursions = [ExcursionDataModel]()
		raftingExcursions.append(ExcursionDataModel(title: "Liucura"))
		raftingExcursions.append(ExcursionDataModel(title: "Otro rio"))
		
		excursionsToDisplay.append(Excursion(excursionHeader: raftingHeader, excursions: raftingExcursions))
		
		//Hiking Excursions
		let hikingHeader = ExcursionHeader(title: "Hiking", image: #imageLiteral(resourceName: "hiking"))
		var hikingExcursions = [ExcursionDataModel]()
		hikingExcursions.append(ExcursionDataModel(title: "Volcano"))
		hikingExcursions.append(ExcursionDataModel(title: "Por el pastito"))
		hikingExcursions.append(ExcursionDataModel(title: "Villarica"))
		
		excursionsToDisplay.append(Excursion(excursionHeader: hikingHeader, excursions: hikingExcursions))
	}
	
	//MARK: Listeners
	
	func rotate() {
		//tableView.reloadData()
		
	}
	
	//MARK: - TableView Setup
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return excursionsToDisplay.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return excursionsToDisplay[section].excursions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ExcursionCell", for: indexPath) as! ExcursionTableCell
		
		let currentExcursion = self.excursionsToDisplay[indexPath.section].excursions[indexPath.item]
		
		cell.title.text = currentExcursion.title
		cell.descriptionText.text = currentExcursion.thumbnailText
		cell.descriptionText.font = cell.descriptionText.font.withSize(fontSize())
		cell.thumbnailImage.clipsToBounds = true
		//cell.descriptionText.setMaxFontSize()
		
		if currentExcursion.thumbnailImage != nil {
			DispatchQueue.global().async {
			cell.thumbnailImage.sd_setImage(with: currentExcursion.thumbnailImage, placeholderImage: #imageLiteral(resourceName: "PlaceHolder"), options: .avoidAutoSetImage, completed: {(image, error, cacheType, url) -> Void in
				let scale = UIScreen.main.scale
				let ar = image!.size.width / image!.size.height
				let size = CGSize(width: ar >= 1 ? cell.thumbnailImage.frame.width * scale : cell.thumbnailImage.frame.width * ar * scale, height: ar <= 1 ? cell.thumbnailImage.frame.height * scale : cell.thumbnailImage.frame.height / ar * scale)
				
				
				
				DispatchQueue.global().async {
					let tempImage = image?.resizedImage(size, interpolationQuality: .default)
					
					DispatchQueue.main.async {
						cell.thumbnailImage.image = tempImage
					}
				}
				
				//cell.arConstraint = cell.arConstraint.constraintWithMultiplier(multiplier: ar)
				//cell.layoutIfNeeded()
				//print("\(image!.size), \(size)")
				//cell.thumbnailImage.resizeImage(size: size)
				//cell.thumbnailImage.contentMode = .scaleAspectFit
			})
			}
		}
		
		//cell.height.constant = screenWidth() * tableIconHeightRatio
		
		
		setColor(selected: false, cell: cell)
		
		if !tableCells.contains(cell) {
			tableCells.insert(cell, at: indexPath.row)
		}
		
		return cell
	}
	
	func screenWidth() -> CGFloat {
		let screen = UIScreen.main.bounds
		if alwaysUseBiggerRelation {
			let ar = screen.width / screen.height
			if ar >= 1 {
				return screen.width
			} else {
				return screen.height
			}
		} else {
			return screen.height
		}
	}
	
	func fontSize() -> CGFloat {
		let bounds = UIScreen.main.bounds
		let width = bounds.width < bounds.height ? bounds.width : bounds.height
		
		let scaleFactor: CGFloat = 26.5
		
		return width / scaleFactor
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let imageLength: CGFloat = headerHeight - marginDistance * 2
		
		let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight))
		view.backgroundColor = UIColor.viraviraBrownColor
		
		let image = UIImageView(frame: CGRect(x: marginDistance, y: (headerHeight / 2) - (imageLength / 2), width: imageLength, height: imageLength))
		view.addSubview(image)
		
		let label = UILabel(frame: CGRect(x: image.frame.origin.x + image.frame.width + marginDistance, y: (headerHeight / 2) - (headerTextHeight / 2), width: view.frame.width - image.frame.origin.x - image.frame.width - marginDistance, height: headerTextHeight))
		
		label.textColor = UIColor.viraviraGoldColor
		label.textAlignment = NSTextAlignment.left
		label.font = UIFont(name: "Verdana", size: 27)
		view.addSubview(label)
		
		//Populating header
		label.text = excursionsToDisplay[section].excursionHeader.title
		image.image = excursionsToDisplay[section].excursionHeader.image
		
		image.image = image.image?.withRenderingMode(.alwaysTemplate)
		image.tintColor = UIColor.primary
		label.textColor = UIColor.primary
		view.backgroundColor = UIColor.tertiary
		
		
		return view
	}
	
	func descriptionFontSize() -> CGFloat {
		let screenWidth = UIScreen.main.bounds.width
		
		return CGFloat(Int(screenWidth / 27))
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return headerHeight
	}
	
	/*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let screen = UIScreen.main.bounds
		let ar = screen.width / screen.height
		return (ar > 1 ? screen.width : screen.height) * cellHeightMultiplier
	}*/
	
/*	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let minHeight = UIScreen.main.bounds.height * tableCellHeightRatio
		let startTime = CACurrentMediaTime()
		
		guard tableCells.count > indexPath.row else {return minHeight}
		let cell = tableCells[indexPath.row]
		
		//let cell = self.tableView(tableView, cellForRowAt: indexPath) as! ExcursionDetailTableViewCell
		
		let topBottomIndent: CGFloat = 16
		var contentHeight = self.labelHeight(cell.descriptionText)
		if !UIDevice.current.orientation.isLandscape {
			contentHeight += cellExtraHeight
		}
		//  print(contentHeight)
		
		let textViewHeight = contentHeight + topBottomIndent
		
		print("height calculation: \(CACurrentMediaTime() - startTime)")
		print(textViewHeight)
		
		let result = textViewHeight > minHeight ? textViewHeight : minHeight
		
		tableCells[indexPath.row].height.constant = result
		
		return result
	}
	
	func labelHeight(_ label: UILabel) -> CGFloat {
		label.numberOfLines = 0
		let insets: CGFloat = 32
		let cellwidth: CGFloat = UIScreen.main.bounds.size.height * tableCellHeightRatio
		let fixedWidth = UIScreen.main.bounds.size.width - cellwidth - insets
		
		let sizeThatFits = label.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
		return sizeThatFits.height
	}*/
	
	
	//MARK: Selection
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! ExcursionTableCell
		
		//deselectAllCells(tableView: tableView)
		if currentSelectedCellIndexPath != nil {
			self.tableView(tableView, didDeselectRowAt: currentSelectedCellIndexPath!)
		}
		
		currentSelectedCellIndexPath = indexPath
		
		setColor(selected: true, cell: cell)
	}
	
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? ExcursionTableCell else {return}
		
		setColor(selected: false, cell: cell)
	}
	
	/*func selectCell(cell: ExcursionTableCell) -> ExcursionTableCell {
		cell.backgroundColor = UIColor.viraviraGoldColor
		cell.content?.backgroundColor = UIColor.viraviraGoldColor
		cell.thumbnailText?.textColor = UIColor.viraviraDarkBrownColor
		cell.title?.textColor = UIColor.viraviraDarkBrownColor
		
		return cell
	}
	
	func deselectCell(cell: ExcursionTableCell?) -> ExcursionTableCell? {
		
		if cell != nil {
			cell!.backgroundColor = UIColor.viraviraDarkBrownColor
			cell!.content?.backgroundColor = UIColor.viraviraDarkBrownColor
			cell!.thumbnailText?.textColor = UIColor.viraviraGoldColor
			cell!.title?.textColor = UIColor.viraviraGoldColor
		}
		
		return cell
	}*/
	
	func setColor(selected: Bool, cell: ExcursionTableCell){
		
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetails" {
			let navController = segue.destination as! UINavigationController
			let detailView = navController.topViewController as! ExcursionDetailView
			
			if let selectedExcursionCell = sender as? ExcursionTableCell {
				let indexPath = tableView.indexPath(for: selectedExcursionCell)
				
				detailView.excursion = excursionsToDisplay[indexPath!.section].excursions[indexPath!.row]
			}
		}
	}
	
	@IBAction func unwindToExcursionTable(segue: UIStoryboardSegue) {
		if currentSelectedCellIndexPath != nil {
			tableView(tableView, didDeselectRowAt: currentSelectedCellIndexPath!)
		}
	}
	
	func toggle(_ sender: AnyObject!) {
		self.menuButton.animate(animationType: .Automatic)
	}
	
	func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
		toggle(self)
	}
	
	//MARK: - DetailView Parse
	
	func parse() {
		let url = URL(string: "http://hotelviravira.com/app/excursionsAPI.json")
		
		var failed = false
		
		if url == nil {
			print("Api not found. This is a bug, please report to developers.")
			
			let alert = UIAlertController(title: "Invalid URL", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {(alert: UIAlertAction) in
				return
			}))
			present(alert, animated: true, completion: nil)
		} else {
			addOverlay()
			let configuration = URLSessionConfiguration.default
			configuration.requestCachePolicy = .reloadIgnoringCacheData
			let session = URLSession(configuration: configuration)
			download = session.dataTask(with:url!) { (data, response, error) in
				if error != nil {
					failed = true
					let urlError = error as! URLError
					print(urlError.localizedDescription)
					
					self.displayError(error: urlError.localizedDescription)
					
					
					
				} else {
					do {
						//self.refreshControl?.beginRefreshing()
						self.excursionModels.removeAll()
						
						let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
						
						let list = parsedData["list"] as! NSArray
						
						for index in 0..<list.count {
							let element = list[index] as? Dictionary<String, Any>
							if element == nil {
								return
							}
							let title = element!["title"] as? String
							let thumbnailImage = element!["thumbnailImage"] as? String
							let thumbnailDescription = element!["thumbnailDescription"] as? String
							
							/*var descriptionText = NSAttributedString()
							if let descriptionArray = element!["description"] as? NSArray {
								descriptionText = self.description(from: descriptionArray)
							}*/
							
							//MARK: Table
							var descriptionTable = [DetailTableContent]()
							var descriptionText = ""
							if let descriptionNode = element!["description"] as? [String:Any] {
								if let table = descriptionNode["table"] as? [String: Any] {
									//2: Car time
									if let carTime = table["car-duration"] as? String {
										let image = #imageLiteral(resourceName: "car-time")
										descriptionTable.append(DetailTableContent(icon: image, text: carTime))
									}
									//3: Car distance
									if let carDistance = table["car-distance"] as? String {
										let image = #imageLiteral(resourceName: "car-distance")
										descriptionTable.append(DetailTableContent(icon: image, text: carDistance))
									}
									//4: Excursion Distance
									if let excursionDistance = table["excursion-distance"] as? String {
										let image = #imageLiteral(resourceName: "excursion-distance")
										descriptionTable.append(DetailTableContent(icon: image, text: excursionDistance))
									}
									//5: Excursion time
									if let excursionTime = table["excursion-duration"] as? String {
										let image = #imageLiteral(resourceName: "excursion-time")
										descriptionTable.append(DetailTableContent(icon: image, text: excursionTime))
									}
									//1: Difficulty
									if let difficulty = table["difficulty"] as? String {
										let image = #imageLiteral(resourceName: "difficulty")
										descriptionTable.append(DetailTableContent(icon: image, text: difficulty))
									}
									//6: Elevation gain
									if let elevationGain = table["elevation-gain"] as? String {
										let image = #imageLiteral(resourceName: "elevation-gain")
										descriptionTable.append(DetailTableContent(icon: image, text: elevationGain))
									}
									//7: Season
									if let season = table["season"] as? String {
										let image = #imageLiteral(resourceName: "season")
										descriptionTable.append(DetailTableContent(icon: image, text: season))
									}
									//8: Equipment
									if let equipment = table["equipment"] as? String {
										let image = #imageLiteral(resourceName: "equipment")
										descriptionTable.append(DetailTableContent(icon: image, text: equipment))
									}
									//9: Price
									if let price = table["price"] as? String {
										let image = #imageLiteral(resourceName: "Dollar ")
										descriptionTable.append(DetailTableContent(icon: image, text: price))
									}
								}
								
								descriptionText = descriptionNode["text"] as? String ?? ""
							}
							//End table parsing
							
							let difficulty = element!["difficulty"] as? String
							let duration = element!["duration"] as? String
							let type = element!["type"] as? String
							
							let gpx = element!["gpx"] as? [String: Any]
							let gpxFile = gpx?["gpxFile"] as? String
							let gpxURL = gpxFile != nil ? URL(string: gpxFile!) : nil
							
							let locationTree = gpx?["location"] as? [String: Any]
							let location = locationTree == nil ? nil : CLLocationCoordinate2D(latitude: locationTree!["lat"] as! CLLocationDegrees, longitude: locationTree!["lon"] as! CLLocationDegrees)
							
							let spanTree = gpx?["span"] as? [String: Any]
							let span = spanTree == nil ? nil : MKCoordinateSpan(latitudeDelta: spanTree!["lat"] as! CLLocationDegrees, longitudeDelta: spanTree!["lon"] as! CLLocationDegrees)
							
							let maxSpanTree = gpx?["max span"] as? [String: Any]
							let maxSpan = maxSpanTree == nil ? nil : MKCoordinateSpan(latitudeDelta: maxSpanTree!["lat"] as! CLLocationDegrees, longitudeDelta: maxSpanTree!["lon"] as! CLLocationDegrees)
							
							let excursionModel = ExcursionDataModel(title: title)
							excursionModel.images = [(URL, String)]()
							
							let imagesDict = element!["images"] as? NSArray
							if imagesDict != nil {
								for index in 0..<imagesDict!.count {
									let image = imagesDict![index] as! Dictionary<String, Any>
									let touple: (URL, String) = (URL(string: (image["url"] as! String))!, (image["text"] as? String) ?? String())
									excursionModel.images?.append(touple)
								}
							}
							if thumbnailImage != nil {
								excursionModel.thumbnailImage = URL(string: thumbnailImage!)
							} else if excursionModel.images!.count > 0 {
								excursionModel.thumbnailImage = excursionModel.images!.first!.0
							}
							excursionModel.thumbnailText = thumbnailDescription
							excursionModel.m_description = descriptionText
							excursionModel.difficulty = difficulty
							excursionModel.duration = duration
							excursionModel.type = type
							
							excursionModel.gpxFileURL = gpxURL
							excursionModel.location = location
							excursionModel.span = span
							excursionModel.maxSpan = maxSpan
							
							excursionModel.tableContent = descriptionTable
							
							
							//print(excursionModel.description)
							self.excursionModels.append(excursionModel)
						
						
						}
						
					} catch let error as NSError {
						print(error)
						
						self.displayError(error: error.localizedDescription)
					}
				}
				if !failed {
					self.removeOverlay()
				}
				//self.inject(excursionModels: excursionModels)
				
				self.excursionsToDisplay = self.sort(order: self.sortOrder)
				
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
				}
			download?.resume()
		}
	}
	
	
	func addOverlay() {
		let alert = UIAlertController(title: "Updating", message: "Please Wait", preferredStyle: .alert)
		//xalert.view.tintColor = UIColor.viraviraGoldColor
		
		let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = .white
		activityIndicator.startAnimating()
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
			self.download?.cancel()
			//self.refreshControl?.endRefreshing()
		}))
		
		alert.view.addSubview(activityIndicator)
		DispatchQueue.main.async {
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func displayError(error: String) {
		let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
		DispatchQueue.main.async {
			self.dismiss(animated: true, completion:  ({
				self.present(alert, animated: true, completion: nil)
				print("displaying")
			}))
		}
	}



	func removeOverlay() {
		DispatchQueue.main.async {
			//self.refreshControl?.endRefreshing()
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	func description(from data: NSArray) -> NSAttributedString {
		let text = NSMutableAttributedString()
		
		for element in data {
			if let elementDict = element as? [String: Any] {
				text.append(node(from: elementDict))
			}
		}
		
		return text
	}
	
	func node(from data: [String : Any]) -> NSAttributedString {
		let attributedText = NSMutableAttributedString()
		
		
		if data["text"] == nil && data["image"] == nil {
			print("Unsupported tree found. Trees without text nor images are unsupported. Tree data: \(data)")
		} else if data["text"] != nil && data["image"] != nil {
			print("Unsupported tree found, it is not allowed to have text and an image in the same tree. Tree data: \(data)")
		} else if data["image"] != nil {
			
//			Implement image retrieval
			let imageName = data["image"] as! String
			let template = data["template"] as? Bool != nil ? data["template"] as! Bool : true
			var image = UIImage()
			
			switch imageName {
			case "Bike", "Bicycle":
				image = #imageLiteral(resourceName: "biking")
			case "Trekking", "Hiking":
				image = #imageLiteral(resourceName: "Hiking")
			case "Car":
				image = #imageLiteral(resourceName: "Car")
				
			default:
				image = #imageLiteral(resourceName: "PlaceHolder")
			}
			
			let imageSize = CGSize(width: 100, height: 100)
		
			let textAttachment = TextAttachment()
			textAttachment.bounds = CGRect(origin: CGPoint.zero, size: imageSize)
			image = image.with(size: imageSize)!
			if template {
				let templatedImage = image.withRenderingMode(.alwaysTemplate)
				textAttachment.image = templatedImage
			} else {
				textAttachment.image = image
			}
			
			//textAttachment.bounds = CGRect(origin: CGPoint.zero, size: imageSize)
			//textAttachment.image
			
			let imageAsText = NSAttributedString(attachment: textAttachment)
			attributedText.append(imageAsText)
			
		} else {
//			Implement text retrieval
			let text = data["text"] as? String
			if text == nil {
				return NSAttributedString()
			}
//			Initialize the attributed text with our downloaded text.
			attributedText.setAttributedString(NSAttributedString(string: text!))
			
			var fontSize: CGFloat = 17
			
			if let fontSizeString = data["FontSize"] {
				if let fontSizeFromJSON = fontSizeString as? Double {
					fontSize = CGFloat(fontSizeFromJSON)
				} else {
					print("Font size is not a number and cannot be converted to one. Please revise the API")
				}
			}
			
			var isBold = false
			
			if let isBoldStringFromJSON = data["isBold"] {
				if let isBoldFromJSON = isBoldStringFromJSON as? Bool {
					isBold = isBoldFromJSON
				} else {
					print("The is bold attribute does not contain a valid boolean and thus cannot be converted to one. Please revise the API")
				}
			}
			
			var isItalic = false
			
			if let isItalicStringFromJSON = data["isItalic"] {
				if let isItalicFromJSON = isItalicStringFromJSON as? Bool {
					isItalic = isItalicFromJSON
				} else {
					print("The is italic attribute does not contain a valid boolean and thus cannot be converted to one. Please revise the API")
				}
			}
			
			
//			Create the font with the downloaded properties like, bold italic etc.
			var font = UIFont()
			
			
			
			switch (isBold, isItalic) {
			case (false, false):
				font = UIFont(name: "Verdana", size: fontSize)!
				
			case (true, false):
				font = UIFont(name: "Verdana-Bold", size: fontSize)!
				
			case (false, true):
				font = UIFont(name: "Verdana-Italic", size: fontSize)!
				
			case (true, true):
				font = UIFont(name: "Verdana-BoldItalic", size: fontSize)!
			}
			
			var isUnderlined = false
			
			if let isUnderlinedStringFromJSON = data["isUnderlined"] {
				if let isUnderlinedFromJSON = isUnderlinedStringFromJSON as? Bool {
					isUnderlined = isUnderlinedFromJSON
				} else {
					print("The is underlined attribute does not contain a valid boolean and thus cannot be converted to one. Please revise the API")
				}
			}
			
			var color = UIColor.primary
			
			if let colorFromJSON = data["color"] {
				if let colorHexFromJSON = colorFromJSON as? Int {
					color = UIColor(netHex: colorHexFromJSON)
				} else if let colorStringFromJSON = colorFromJSON as? String {
					switch colorStringFromJSON {
					case "blue":
						color = UIColor.blue
					default:
						color = UIColor.viraviraGoldColor
					}
				}
			}
			
			
			//Adding the attributes to the attributed string
			let range = NSMakeRange(0, attributedText.length)
			//Adding the font
			attributedText.addAttribute(NSFontAttributeName, value: font, range: range)
			//Adding the underline
			if isUnderlined {
				attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
			}
			//Adding the color
			attributedText.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
		}
		
		return attributedText
	}
	
	
	//MARK: - Sorting
	
	func sort(order: SortOrder) -> [Excursion]{
		var tempExc = [Excursion]()
		
		var excursionCreator: ([ExcursionDataModel]) -> [Excursion]
		
		switch order {
		case .TypeNameUp, .TypeNameDown:
			excursionCreator = createExcursionByType
		}
		
		tempExc = excursionCreator(excursionModels)
		
		var excursionSorter: (Excursion, Excursion) -> Bool
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
	
	func createExcursionByType(excursions: [ExcursionDataModel]) -> [Excursion] {
		var tempExc = [Excursion]()
		for excursion in excursions {
			if let index = containsHeader(excursionModel: excursion, in: tempExc) {
				tempExc[index].excursions.append(excursion)
			} else {
				var title = excursion.title
				if excursion.type != nil {
					title = excursion.type!
				}
				let excursionHeader = header(from: title)
				tempExc.append(Excursion(excursionHeader: excursionHeader, excursions: [excursion]))
			}
		}
		return tempExc
	}
	
	func containsHeader(excursionModel: ExcursionDataModel, in excursions: [Excursion]) -> Int? {
		for (index, excursion) in excursions.enumerated() {
			if excursionModel.type == excursion.excursionHeader.title {
				return index
			}
		}
		return nil
	}
	
	func sortExcursionHeaderByNameUp(e1: Excursion, e2: Excursion) -> Bool {
		return e1.excursionHeader.title < e2.excursionHeader.title
	}
	
	func sortExcursionHeaderByNameDown(e1: Excursion, e2: Excursion) -> Bool {
		return e1.excursionHeader.title > e2.excursionHeader.title
	}
	
	func sortExcursionModelsByNameUp(e1: ExcursionDataModel, e2: ExcursionDataModel) -> Bool {
		return e1.title < e2.title
	}
	
	func sortExcursionModelsByNameDown(e1: ExcursionDataModel, e2: ExcursionDataModel) -> Bool {
		return e1.title > e2.title
	}
	
	
	/*func createExcursionHeader(title: String) -> ExcursionHeader {
		return ExcursionHeader(title: title)
	}
	*/
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
	
	func printFonts() {
		let fontFamilyNames = UIFont.familyNames
		for familyName in fontFamilyNames {
			print("------------------------------")
			print("Font Family Name = [\(familyName)]")
			let names = UIFont.fontNames(forFamilyName: familyName)
			print("Font Names = [\(names)]")
		}
	}
}

