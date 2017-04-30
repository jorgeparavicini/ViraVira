//
//  MapParser.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 9/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import Foundation
import SWXMLHash
import MapKit

class JPMapParser {
	var xmlURL: URL
	var location: CLLocationCoordinate2D
	var span: MKCoordinateSpan
	var maxSpan: MKCoordinateSpan
	
	var downloader: URLSessionDataTask?
	
	init (xmlURL: URL, location: CLLocationCoordinate2D, span: MKCoordinateSpan, maxSpan: MKCoordinateSpan) {
		self.xmlURL = xmlURL
		self.location = location
		self.span = span
		self.maxSpan = maxSpan
	}
	
	func parse(completion: @escaping (JPMapProperty) -> Void) {
		let configuration = URLSessionConfiguration.default
		configuration.requestCachePolicy = .reloadIgnoringCacheData
		let session = URLSession(configuration: configuration)
		downloader = session.dataTask(with: xmlURL) {(data, response, error) in
			guard
				data != nil
				else {fatalError("Data not found")}
			
			let xml = SWXMLHash.parse(data!)
			let gpx = xml["gpx"]
			var waypoints = [JPMapWaypoint]()
			
			for element in gpx["wpt"].all {
				var waypoint: JPMapWaypoint?
				do {
					waypoint = try JPMapWaypoint.deserialize(element)
				} catch {
					waypoint = nil
				}
				if waypoint != nil {
					waypoints.append(waypoint!)
				}
			}
			
			var tracks = [JPMapTrack]()
			for element in gpx["trk"].all {
				var track: JPMapTrack?
				do {
					track = try JPMapTrack.deserialize(element)
				} catch {
					print("Failed to load track")
					track = nil
				}
				if track != nil {
					tracks.append(track!)
				}
			}
			let overlays: JPMapOverlay = JPMapOverlay(waypoints: waypoints, tracks: tracks)
			let properties = JPMapProperty(location: self.location, span: self.span, maxSpan: self.maxSpan, mapOverlays: overlays)
			
			completion(properties)
			
		}
		self.downloader?.resume()
	}
}
