//
//  HotspotsActivityCell.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/25/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class HotspotsActivityCell: UITableViewCell {
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationRank: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationPicture: UIImageView!
    @IBOutlet weak var amountCheckedIn: UILabel!
    //@IBOutlet weak var locationAmountCheckedIn: UILabel!
    
    var otherInformation:HotspotsActivityInfoHolder = HotspotsActivityInfoHolder(name: "",address: "",thumb: UIImage(),rank:0,people:0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}