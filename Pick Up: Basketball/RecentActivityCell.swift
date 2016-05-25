//
//  RecentActivityCell.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/25/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class RecentActivityCell: UITableViewCell {
    
    @IBOutlet weak var playedAtLabel: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var andMetLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var peopleMetLabel: UILabel!
    
    var otherInformation:RecentActivityInfoHolder = RecentActivityInfoHolder(location: "",thumb: UIImage(),people:["Bobby Cram","Billy Joe"],dateEffective:"01/01/2016 at  17:15:00")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}