//
//  FriendActivityCell.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/25/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class FriendActivityCell: UITableViewCell {
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var friendPicture: UIImageView!
    @IBOutlet weak var postTime: UILabel!
    
    @IBOutlet weak var checkedIntoLabel: UILabel!
    
    var otherInformation:FriendActivityInfoHolder = FriendActivityInfoHolder(name: "",location: "",thumb: UIImage(),dateEffective:"01/01/2016 at  17:15:00")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
