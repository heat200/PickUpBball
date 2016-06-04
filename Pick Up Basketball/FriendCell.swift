//
//  FriendCell.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 6/1/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendPicture: UIImageView!
    @IBOutlet weak var friendRep: UILabel!
    @IBOutlet weak var friendLocation: UILabel!
    
    var usualColor:UIColor!
    
    var otherInformation:FriendHolder = FriendHolder(name: "",rep: 0,location: "",thumb: UIImage())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usualColor = friendLocation.textColor
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}