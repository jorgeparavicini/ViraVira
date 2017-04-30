//
//  ExcursionMapViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 9/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit
import MapKit
import KVConstraintExtensionsMaster

class ExcursionMapViewController: UIViewController, MKMapViewDelegate {
	
	@IBOutlet weak var mapView: MKMapView!

	var mapProperties: JPMapProperty? {
		didSet {
			if initialized {
				setProperties()
			}
		}
	}
	
	var initialized: Bool = false
	
	var parser: JPMapParser?
	
	let annotationIdentifier = "AnnotationID"
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		mapView.delegate = self
		
		mapView.mapType = .satellite
		
		if mapProperties != nil {
			setProperties()
		} else {
			showAlert()
			
			parser?.parse {(properties) in
				self.mapProperties = properties
			}
		}
		
		initialized = true
    }
	
	func setProperties() {
		guard mapProperties != nil && mapView != nil else {dismissAlert(errorMessage: "Failed to download"); return}
		mapView.region = mapProperties!.region
		let mapOverlays = mapProperties!.mapOverlays
		for waypoint in mapOverlays.waypoints {
			mapView.addAnnotation(waypoint.annotation)
		}
		for track in mapOverlays.tracks {
			DispatchQueue.main.async {
				self.mapView.add(track.polyline)
			}
		}
		
		dismissAlert(errorMessage: nil)
	}
	
	func showAlert() {
		guard parser != nil else {return}
		let alert = UIAlertController(title: "Updating", message: "Please Wait", preferredStyle: .alert)
		//xalert.view.tintColor = UIColor.viraviraGoldColor
		
		let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = .white
		activityIndicator.startAnimating()
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
			self.parser!.downloader?.cancel()
		}))
		
		alert.view.addSubview(activityIndicator)
		DispatchQueue.main.async {
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func dismissAlert(errorMessage: String?) {
		DispatchQueue.main.async {
			if self.presentedViewController != nil {
				self.dismiss(animated: true, completion: errorMessage == nil ? nil : {
					self.displayErrorMessage(errorMessage: errorMessage!)
					})
			} else if errorMessage != nil {
				self.displayErrorMessage(errorMessage: errorMessage!)
			}
		}
	}
	
	func displayErrorMessage(errorMessage: String) {
		let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKPolyline {
			let polylineRenderer = MKPolylineRenderer(overlay: overlay)
			polylineRenderer.lineWidth = 3
			polylineRenderer.strokeColor = UIColor.red
			return polylineRenderer
		} else {
			return MKOverlayRenderer(overlay: overlay)
		}
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let jpAnnotation = annotation as? JPPointAnnotation else {return nil}
		
		var annotationView: MKAnnotationView?
		let fixedSize = CGSize(width: 35, height: 35)
		
		if jpAnnotation.image != nil {
			
			annotationView = MKAnnotationView(annotation: jpAnnotation, reuseIdentifier: annotationIdentifier)
			annotationView?.image = jpAnnotation.image
			annotationView?.frame = CGRect(x: -fixedSize.width / 2, y: -fixedSize.height / 2, width: fixedSize.width, height: fixedSize.height)
			
		} else {
			annotationView = MKPinAnnotationView(annotation: jpAnnotation, reuseIdentifier: annotationIdentifier)
		}
		
		if jpAnnotation.detailImageURL != nil {
			
			let customView = UIImageView()
			customView.contentMode = .scaleAspectFit
			
			let url = URL(string: jpAnnotation.detailImageURL!)
			customView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "PlaceHolder"))
			
			if #available(iOS 9.0, *) {
				annotationView?.detailCalloutAccessoryView = customView
			} else {
				// Fallback on earlier versions
			}
			if #available(iOS 9.0, *) {
				annotationView?.detailCalloutAccessoryView?.backgroundColor = UIColor.red
			} else {
				// Fallback on earlier versions
			}
		}
		
		
		
		annotationView?.canShowCallout = true
		
		return annotationView
	}
}
