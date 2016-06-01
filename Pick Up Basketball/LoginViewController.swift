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
    @IBOutlet var loginView : FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("Logged in")
            FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
            returnUserData()
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("user_friends") && result.grantedPermissions.contains("public_profile") {
                self.returnUserData()
                self.removeFromParentViewController()
                let MainVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainView") as! MainViewController
                self.presentViewController(MainVC, animated: true, completion: { self.removeFromParentViewController()})
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            } else {
                userData = result
                print("fetched user: " + String(result))
                if (FBSDKAccessToken.currentAccessToken() != nil) {
                    self.removeFromParentViewController()
                    let MainVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainView") as! MainViewController
                    self.presentViewController(MainVC, animated: true, completion: {
                        self.removeFromParentViewController()
                    })
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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