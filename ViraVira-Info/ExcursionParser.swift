//
//  ExcursionParser.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 17/05/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation
import MapKit

class ExcursionParser {
	static var shared = ExcursionParser()
	
	private var data: Data?
	private var models: [ExcursionDataModel]?
	private var downloadTask: URLSessionDataTask?
	
	private let url = URL(string: "http://www.hotelviravira.com/app/excursionsAPI.json")!
	
	var presentationStack = [UIViewController]()
	
	
	func parse(completion: @escaping (([ExcursionDataModel]) -> Void)) {
		let parserCompletion = {(models: [ExcursionDataModel]) -> Void in
			completion(models)
		}
		
		if models != nil {
			completion(models!)
		}
		else if data != nil {
			
			parse(data: data!, completion: parserCompletion)
		} else {
			//Download the data
			//parse it
			//Pass it
			
			let downloadCompletion = {(downloadedData: Data) -> Void in
				self.parse(data: downloadedData, completion: parserCompletion)
			}
			download(from: url, completion: downloadCompletion)
		}
	}
	
	func parse(data: Data, completion: ([ExcursionDataModel]) -> Void) {
		var json: [String: Any]?
		var models = [ExcursionDataModel]()
		
		do {
			json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
		} catch let error as NSError {
			self.displayError(error.localizedDescription)
		}
		
		guard json != nil else {completion(models); return}
		
		let list = json!["list"] as? NSArray
		guard list != nil else {completion(models); return}
		
		for index in 0..<list!.count {
			let element = list![index] as? [String: Any]
			if element != nil {
				models.append(excursion(from: element!))
			} else {
				displayError("Failed to create model from element: \(list![index])")
			}
		}
		
		//After parsing, call the completion with the created models
		self.models = models
		completion(models)
	}
	
	//Creates an excursion data model based of the element node passed.
	func excursion(from element: [String: Any]) -> ExcursionDataModel {
		let model = ExcursionDataModel()
		
		model.title = excursionTitle(from: element) ?? "Excursion"
		model.thumbnailImage = excursionThumbnailImage(from: element)
		model.images = excursionImagesDescriptionTouple(from: element)
		model.thumbnailText = excursionThumbnailDescription(from: element)
		model.description = excursionDescription(from: element) ?? ""
		model.tableContent = excursionDescriptionTable(from: element)
		model.type = excursionType(from: element)
		model.gpxFileURL = excursionGPXURL(from: element)
		model.location = excursionGPXLocation(from: element)
		model.span = excursionGPXSpan(from: element)
		model.maxSpan = excursionGPXMaxSpan(from: element)
		
		return model
	}
	
	//Parse the title of the excursion
	func excursionTitle(from node: [String: Any]) -> String? {
		return node["title"] as? String
	}
	
	//Parse the thumbnail image of the excursion
	func excursionThumbnailImage(from node: [String: Any]) -> String? {
		return excursionImages(from: node).0
	}
	
	//Parse the Image and its Description as a touple of the current excursion
	func excursionImagesDescriptionTouple(from node: [String: Any]) -> [(String, String)]? {
		return excursionImages(from: node).1
	}
	
	//Parses all images, the thumbnail and descriptive images in a double touple. 0 = Thumbnail Image and 1 = Image and its Description touple.
	func excursionImages(from node: [String: Any]) -> (String?, [(String, String)]?) {
		var thumbnailImage = node["thumbnailImage"] as? String
		
		let imagesDict = node["images"] as? NSArray
		guard imagesDict != nil else {return (thumbnailImage, nil)}
		
		var images = [(String, String)]()
		for index in 0..<imagesDict!.count {
			let image = imagesDict![index] as! [String: Any]
			var url: String? = image["url_name"] as? String
			let description = image["text"] as? String ?? ""
			images.append((url!, description))
		}
		
		if thumbnailImage == nil && images.count > 0 {
			thumbnailImage = (imagesDict![0] as! [String: Any])["url_name"] as? String
			//thumbnailImage = parseImage(from: (imagesDict![0] as! [String: Any]), isThumbnail: true)
			
			//thumbnailImage = images[0].0
		}
		
		return (thumbnailImage, images)
	}
	
	func imageNode(at index: Int, from node: NSArray) -> [String: Any]? {
		guard node.count > index else {return nil}
		return node[index] as? [String: Any]
	}
	
/*	func parseImage(from node: [String: Any], isThumbnail: Bool = false) -> String? {
		if isThumbnail {
			return node["url_name"] as? String
		}
		return nil
	}
	
	func parseImage(from node: [String: Any], isThumbnail: Bool = false) -> URL? {
		if isThumbnail {
			if let urlString = node["url_1x"] as? String {
				return URL(string: urlString)
			} else {
				return nil
			}
		} else {
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let viewController = appDelegate.window!.rootViewController!
			let trait = viewController.traitCollection
			
			var urlString: String?
			
			switch (trait.horizontalSizeClass, trait.verticalSizeClass) {
			case (.regular, .regular):
				urlString = node["url_3x"] as? String
				
			default:
				urlString = node["url_2x"] as? String
			}
			
			if urlString != nil {
				return URL(string: urlString!)
			} else {
				return nil
			}
		}
	}*/
	
	//Parse the thumbnail description
	func excursionThumbnailDescription(from node: [String: Any]) -> String? {
		return node["thumbnailDescription"] as? String
	}
	
	//Parse the detailed description of the excursion which is nested inside the description node
	func excursionDescription(from node: [String: Any]) -> String? {
		return (node["description"] as? [String: Any])?["text"] as? String
	}
	
	func excursionDescriptionTable(from node: [String: Any]) -> [DetailTableContent] {
		var descriptionTable = [DetailTableContent]()
		
		if let descriptionNode = node["description"] as? [String:Any] {
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
		}
		
		return descriptionTable
	}
	
	func excursionType(from node: [String: Any]) -> String? {
		return node["type"] as? String
	}
	
	func excursionGPX(from node: [String: Any]) -> [String: Any]? {
		return node["gpx"] as? [String: Any]
	}
	
	func excursionGPXURL(from node: [String: Any]) -> URL? {
		if let url = excursionGPX(from: node)?["gpxFile"] as? String {
			return URL(string: url)
		} else {
			return nil
		}
	}
	
	func excursionGPXLocation(from node: [String: Any]) -> CLLocationCoordinate2D? {
		let location = excursionGPX(from: node)?["location"] as? [String: Any]
		return location == nil ? nil : CLLocationCoordinate2D(latitude: location!["lat"] as! CLLocationDegrees, longitude: location!["lon"] as! CLLocationDegrees)
	}
	
	func excursionGPXSpan(from node: [String: Any]) -> MKCoordinateSpan? {
		let span = excursionGPX(from: node)?["span"] as? [String: Any]
		return span == nil ? nil : MKCoordinateSpan(latitudeDelta: span!["lat"] as! CLLocationDegrees, longitudeDelta: span!["lon"] as! CLLocationDegrees)
	}
	
	func excursionGPXMaxSpan(from node: [String: Any]) -> MKCoordinateSpan? {
		let maxSpan = excursionGPX(from: node)?["max span"] as? [String: Any]
		return maxSpan == nil ? nil : MKCoordinateSpan(latitudeDelta: maxSpan!["lat"] as! CLLocationDegrees, longitudeDelta: maxSpan!["lon"] as! CLLocationDegrees)
	}
	
	
	//MARK: - Download manager
	
	func download(from url: URL) {
		download(from: url, completion: nil)
	}
	
	func download(from url: URL, completion: ((Data) -> Void)?) {
		guard downloadTask == nil || downloadTask?.state == URLSessionTask.State.completed || downloadTask?.state == URLSessionTask.State.suspended else {return}
		displayAlert()
		
		let session = URLSession(configuration: .default)
		downloadTask = session.dataTask(with: url, completionHandler: {(downloadedData, response, error) in
			if error != nil {
				self.displayError(error!.localizedDescription)
			} else {
				if completion == nil {
					self.data = downloadedData
				} else if downloadedData != nil {
					completion!(downloadedData!)
				} else {
					self.displayError("Crititcal Error: Downloaded empty file. Please reload page. If this keeps occuring, please contact the developer.")
					return
				}
				self.removeAlert()
			}
			})
		
		downloadTask?.resume()
	}
	
	//MARK: - Notification manager
	
	func displayAlert() {
		let alert = UIAlertController(title: "Downloading necessary files...", message: "Downloading the excursions should not take more than a few seconds. If it does, please make sure to have a proper internet connection.", preferredStyle: .alert)
		
		
		//TODO: - Progress bar
	/*	let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = .white
		activityIndicator.startAnimating()
		
		alert.view.addSubview(activityIndicator)*/
		
		let action = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) -> Void in
			self.downloadTask?.suspend()
		})
		alert.addAction(action)
		
		display(alert)
	}
	
	func removeAlert() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let viewController = appDelegate.window!.rootViewController!
		
		guard viewController.presentedViewController != nil else {return}
		
		var completion: (() -> Void)?
		
		if presentationStack.count > 0 {
			completion = {
				viewController.present(self.presentationStack[0], animated: true, completion: {
					self.presentationStack.removeFirst()
				})
			}
		}
		
		if viewController.presentedViewController != nil {
			viewController.dismiss(animated: true, completion: completion)
		} else if completion != nil{
			completion!()
		}
	}
	
	func displayError(_ errorMessage: String) {
		let alert = UIAlertController(title: "An error occured", message: errorMessage, preferredStyle: .alert)
		let action = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) -> Void in
			self.downloadTask?.suspend()
		})
		alert.addAction(action)
		
		display(alert)
	}
	
	func display(_ alert: UIAlertController) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let viewController = appDelegate.window!.rootViewController!
		
		
		if viewController.presentedViewController != nil {
			if viewController.presentedViewController!.isBeingPresented {
				presentationStack.append(alert)
				removeAlert()
			} else {
				viewController.dismiss(animated: true, completion: {
					viewController.present(alert, animated: true, completion: nil)
				})
			}
		} else {
			viewController.present(alert, animated: true, completion: nil)
		}
	}
}
