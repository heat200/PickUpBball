//
//  LoginViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 2/25/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

var userData:AnyObject!

class LoginViewController: UIViewController,UITextFieldDelegate, FBSDKLoginButtonDelegate {
    @IBOutlet var loginView:FBSDKLoginButton!
    @IBOutlet var bottomConstraint2:NSLayoutConstraint!
    @IBOutlet var bottomConstraint:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomConstraint.constant = -100
        self.bottomConstraint2.constant = 100
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        }
        let animationSpeed:Double = 1.5
        UIView.animateWithDuration(animationSpeed, animations: {
            self.bottomConstraint.constant = 144
            self.bottomConstraint2.constant = 8
            self.view.layoutIfNeeded()
        })
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //print("User Logged In")
        if ((error) != nil) {
            
        } else if result.isCancelled {
            
        } else {
            if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("user_friends") && result.grantedPermissions.contains("public_profile") {
                self.returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //print("User Logged Out")
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":""])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                userData = result
                //print("fetched user: " + String(result))
                if (FBSDKAccessToken.currentAccessToken() != nil) {
                    if self.presentingViewController == nil {
                        let MainVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainView") as! MainViewController
                        self.view.window!.rootViewController?.presentViewController(MainVC, animated: true, completion: nil)
                    } else {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}