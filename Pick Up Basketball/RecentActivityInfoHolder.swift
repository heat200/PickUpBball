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
    var personMet = String()
    var dateCheckedIn = Date()
    
    init(location: String,thumb:UIImage,person: String,dateEffective:String) {
        profilePic = thumb
        personMet = person
        let date = DateFormatter()
        date.dateFormat = "MM/dd/yyyy 'at' HH:mm:ss"
        dateCheckedIn = date.date(from: dateEffective)!
    }
    
}
