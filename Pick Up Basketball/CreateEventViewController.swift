//
//  CreateEventViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 7/25/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
    @IBOutlet var userName:UILabel!
    @IBOutlet var userRep:UILabel!
    @IBOutlet var userPicture:UIImageView!
    
    var pictureFrameOrigin:CGPoint!
    var pictureFrameSize:CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    /*
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    */
}
