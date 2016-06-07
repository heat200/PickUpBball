//
//  LaunchScreenViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 6/6/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    @IBOutlet var appLogo:UIImageView!
    
    var currentImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(3, animations: {
            self.appLogo.frame.origin = CGPoint(x: 121, y: 181)
            self.appLogo.frame.size = CGSize(width: 80, height: 80)
            self.performSelector(#selector(LaunchScreenViewController.moveToNextPage), withObject: nil, afterDelay: 1.5)
        })
    }
    
    func moveToNextPage() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let MainVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainView") as! MainViewController
            self.view.window!.rootViewController?.presentViewController(MainVC, animated: true, completion: nil)
        } else {
            let LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            self.view.window!.rootViewController?.presentViewController(LoginVC, animated: true, completion: nil)
        }
    }
    
}