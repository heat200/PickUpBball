//
//  RecentActivityInfoHolder.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/25/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class RecentActivityInfoHolder {
    var profilePic = UIImage()
    var locationName = ""
    var peopleMet = [String]()
    var dateCheckedIn = NSDate()
    
    init(location: String,thumb:UIImage,people: [String],dateEffective:String) {
        profilePic = thumb
        locationName = location
        peopleMet = people
        let date = NSDateFormatter()
        date.dateFormat = "MM/dd/yyyy 'at' HH:mm:ss"
        dateCheckedIn = date.dateFromString(dateEffective)!
    }
    
}