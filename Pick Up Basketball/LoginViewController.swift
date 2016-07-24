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
        if (FBSDKAccessToken.current() == nil) {
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        }
        let animationSpeed:Double = 1.5
        UIView.animate(withDuration: animationSpeed, animations: {
            self.bottomConstraint.constant = 144
            self.bottomConstraint2.constant = 8
            self.view.layoutIfNeeded()
        })
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //print("User Logged In")
        if ((error) != nil) {
            
        } else if result.isCancelled {
            
        } else {
            if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("user_friends") && result.grantedPermissions.contains("public_profile") {
                self.returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //print("User Logged Out")
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":""])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                userData = result
                //print("fetched user: " + String(result))
                if (FBSDKAccessToken.current() != nil) {
                    if self.presentingViewController == nil {
                        let MainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as! MainViewController
                        self.view.window!.rootViewController?.present(MainVC, animated: true, completion: nil)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
