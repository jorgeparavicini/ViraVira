//
//  Time.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 8/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

extension Date {
    
    func timeName() -> String{
        let components = (Calendar.current as NSCalendar).components([.hour], from: self)
        let hour = components.hour!
        
        switch  hour {
		case 6..<12:
            return "Morning"
        case 12:
            return "Noon"
        case 13..<17:
            return "Afternoon"
        case 17..<22:
            return "Evening"
        default:
            return "Night"
        }
    }
}
