//
//  JPMap.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 12/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation
import MapKit
import SWXMLHash

struct JPMapProperty {
	var location: CLLocationCoordinate2D
	var span: MKCoordinateSpan
	var maxSpan: MKCoordinateSpan
	var mapOverlays: JPMapOverlay
	
	var region: MKCoordinateRegion {
		return MKCoordinateRegion(center: location, span: span)
	}
}

struct JPMapOverlay {
	var waypoints: [JPMapWaypoint]
	var tracks: [JPMapTrack]
}

struct JPMapWaypoint: XMLIndexerDeserializable {
	var location: CLLocationCoordinate2D
	var name: String?
	var subtitle: String?
	var iconName: String?
	var imageURL: String?
	
	var icon: UIImage? {
		guard iconName != nil else {return nil}
		return JPMapWaypoint.icons[iconName!]
	}
	static let icons: [String: UIImage] = ["Start": #imageLiteral(resourceName: "Start")]
	
	var annotation: JPPointAnnotation {
		return JPPointAnnotation(coordinate: location, title: name, subtitle: subtitle, image: icon, detailImageURL: imageURL)
	}
	
	static func deserialize(_ node: XMLIndexer) throws -> JPMapWaypoint {
		return try JPMapWaypoint(
			location: CLLocationCoordinate2D.deserialize(node),
			name: node["name"].value(),
			subtitle: node["subtitle"].value(),
			iconName: node["sym"].value(),
			imageURL: node["image"].value())
	}
}

class JPPointAnnotation: MKPointAnnotation {
	var image: UIImage?
	
	var detailImageURL: String?
	
	init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil, image: UIImage? = nil, detailImageURL: String? = nil) {
		super.init()
		self.coordinate = coordinate
		self.title = title
		self.subtitle = subtitle
		self.image = image
		self.detailImageURL = detailImageURL
	}
}

struct JPMapTrack: XMLIndexerDeserializable {
	var name: String
	var trackPoints: [CLLocationCoordinate2D]
	
	var polyline: MKPolyline {
		return MKPolyline(coordinates: trackPoints, count: trackPoints.count)
	}
	
	var polylineRenderer: MKPolylineRenderer {
		let renderer = MKPolylineRenderer(polyline: polyline)
		return renderer
	}
	
	init (name: String, trackPoints: [CLLocationCoordinate2D]) {
		self.name = name
		self.trackPoints = trackPoints
	}
	
	static func deserialize(_ node: XMLIndexer) throws -> JPMapTrack {
		return try JPMapTrack(name: node["name"].value(), trackPoints: node["trkseg"]["trkpt"].value())
	}
}

extension CLLocationCoordinate2D: XMLIndexerDeserializable {
	public static func deserialize(_ node: XMLIndexer) throws -> CLLocationCoordinate2D {
		return try CLLocationCoordinate2DMake(node.value(ofAttribute: "lat"), node.value(ofAttribute: "lon"))
	}
}
