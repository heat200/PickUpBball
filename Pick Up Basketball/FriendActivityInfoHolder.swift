//
//  FriendActivityInfoHolder.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/25/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class FriendActivityInfoHolder {
    var friendPic = UIImage()
    var friendName = ""
    var locationName = ""
    var checkInDate = Date()
    
    init(name: String,location: String,thumb:UIImage,dateEffective: String) {
        friendPic = thumb
        friendName = name
        locationName = location
        let date = DateFormatter()
        date.dateFormat = "MM/dd/yyyy 'at' HH:mm:ss"
        checkInDate = date.date(from: dateEffective)!
    }
    
}
