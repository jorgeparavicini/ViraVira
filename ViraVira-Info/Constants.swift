//
//  Constants.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 6/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation
import MapKit

struct Constants {
    //MARK: - Sizes
    static let menuWidth: CGFloat = 150
    
    //MARK: - Fonts
    static let navigationFont = [ NSFontAttributeName: UIFont(name: "Verdana", size: 24)!, NSForegroundColorAttributeName: NavigationController.fontColor] as [String : Any]
    
    //MARK: - Locations
    static let hotelLocation = CLLocation(latitude: -39.2520306, longitude: -071.8415417)
	static let hotelRegion = MKMapRect(origin: MKMapPoint(x: Constants.hotelLocation.coordinate.longitude, y: Constants.hotelLocation.coordinate.latitude), size: MKMapSize(width: 1, height: 1))
    
    //MARK: - Helper Functions
    static func locationToMapPoint(_ location: CLLocation, regionRadius: CLLocationDistance) -> MKCoordinateRegion {
        return MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
    }
	
	//MARK: - Rects
	static let navigationItemRect = CGRect(x: 0, y: 0, width: 30, height: 30)
}
