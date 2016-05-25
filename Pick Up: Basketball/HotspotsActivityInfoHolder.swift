//
//  HotspotsActivityInfoHolder.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/25/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class HotspotsActivityInfoHolder {
    var locationPic = UIImage()
    var locationRank:Int = 0
    var locationName = ""
    var locationAddress = ""
    var locationAmountCheckedIn:Int = 0
    
    init(name: String,address: String,thumb: UIImage,rank: Int,people: Int) {
        locationPic = thumb
        locationRank = rank
        locationAmountCheckedIn = people
        locationName = name
        locationAddress = address
    }
    
}