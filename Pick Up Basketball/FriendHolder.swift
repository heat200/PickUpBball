//
//  FriendHolders.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 6/1/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class FriendHolder {
    var friendPic = UIImage()
    var friendName = ""
    var friendRep = 0
    var locationName = ""
    
    init(name: String,rep: Int,location: String,thumb:UIImage) {
        friendPic = thumb
        friendName = name
        friendRep = rep
        locationName = location
    }
    
}