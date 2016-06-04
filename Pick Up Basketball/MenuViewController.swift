//
//  StartScreenViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/7/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, MainViewControllerDelegate {
    @IBOutlet var userName:UILabel!
    @IBOutlet var userRep:UILabel!
    @IBOutlet var userPicture:UIImageView!
    
    @IBAction func signOut() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("Logging out")
            FBSDKAccessToken.setCurrentAccessToken(nil)
            FBSDKProfile.setCurrentProfile(nil)
            if self.presentingViewController == nil {
                self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func showHomeView() {
        delegate.updateVisibility("Home")
    }
    
    @IBAction func showFriendsList() {
        delegate.updateVisibility("Friends")
    }
    
    var delegate:MenuViewControllerDelegate!
    var pictureFrameOrigin:CGPoint!
    var pictureFrameSize:CGSize!
    var nameFrameOrigin:CGPoint!
    var nameFrameSize:CGSize!
    var repFrameOrigin:CGPoint!
    var repFrameSize:CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = userData.valueForKey("name") as? String
        
        var urlString = "https://graph.facebook.com/" + String(FBSDKAccessToken.currentAccessToken().userID) + "/picture?type=large&redirect=false"
        do {
            let dictionary = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: NSURL(string: urlString)!)!, options: .MutableLeaves)
            let data = dictionary.objectForKey("data")!
            urlString = data.valueForKey("url") as! String
        } catch {
            print("Could not parse JSON: \(error)")
        }
        
        updateUserData()
        
        nameFrameOrigin = userName.frame.origin
        nameFrameSize = userName.frame.size
        pictureFrameOrigin = userPicture.frame.origin
        pictureFrameSize = userPicture.frame.size
        userPicture.image = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)?.roundImage()
    }
    
    override func viewDidLayoutSubviews() {
        userPicture.frame.origin = pictureFrameOrigin
        userPicture.frame.size = pictureFrameSize
        userRep.frame.origin = repFrameOrigin
        userRep.frame.size = repFrameSize
        userName.frame.origin = nameFrameOrigin
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func updateUserData() {
        var repScore = 0
        var userLocation = ""
        var server = "66.229.197.76"
        do {
            var urlString2 = "http://" + server + "/PikUpServer/users/" + (userData.valueForKey("id") as! String) + "/user.json"
            var data = NSData(contentsOfURL: NSURL(string: urlString2)!)
            
            if data == nil {
                if server == "10.0.0.86" {
                    server = "66.229.197.76"
                } else {
                    server = "10.0.0.86"
                }
                
                //print("Menu: Switching Server To " + server)
                
                urlString2 = "http://" + server + "/PikUpServer/users/" + (userData.valueForKey("id") as! String) + "/user.json"
                data = NSData(contentsOfURL: NSURL(string: urlString2)!)
            } else {
                //print("Good 2 Go")
            }
            
            let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
            let checkedIn = dictionary.valueForKey("checkedIn") as! Bool
            if checkedIn {
                let data = dictionary.objectForKey("location")!
                userLocation = (data.valueForKey("name") as! String)
            }
            repScore = dictionary.valueForKey("rep") as! Int
        } catch {
            print("Could not parse JSON: \(error)")
        }
        
        print("User is at: " + userLocation)
        userRep.text = String(repScore) + " Rep"
        
        repFrameOrigin = userRep.frame.origin
        repFrameSize = userRep.frame.size
    }
}

protocol MenuViewControllerDelegate {
    func updateVisibility(PageToShow:String)
}