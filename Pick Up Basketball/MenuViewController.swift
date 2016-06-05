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
        
        pictureFrameOrigin = userPicture.frame.origin
        pictureFrameSize = userPicture.frame.size
        
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
        print("Pic Size: " + String(pictureFrameSize))
        print("Pic Origin: " + String(pictureFrameOrigin))
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let newImage = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)?.roundImage()
            dispatch_async(dispatch_get_main_queue()) {
                self.userPicture.image = newImage
                print("Pic Size (After New Image): " + String(self.pictureFrameSize))
                print("Pic Origin (After New Image): " + String(self.pictureFrameOrigin))
            }
        }
    }
    
    func fixLayoutIssues() {
        self.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        if repFrameOrigin != nil {
            self.userRep.frame.origin = self.repFrameOrigin
            self.userRep.frame.size = self.repFrameSize
        }
        self.userName.frame.origin = self.nameFrameOrigin
        self.userPicture.frame.origin = self.pictureFrameOrigin
        self.userPicture.frame.size = self.pictureFrameSize
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
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let data = self.updateData()
            dispatch_async(dispatch_get_main_queue()) {
                do {
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
                self.userRep.text = String(repScore) + " Rep"
                
                self.fixLayoutIssues()
                
                print("Pic Size (After Updating Data): " + String(self.pictureFrameSize))
                print("Pic Origin (After Updating Data): " + String(self.pictureFrameOrigin))
            }
        }
    }
    
    func switchServer() {
        if server == "10.0.0.86" {
            server = "66.229.197.76"
        } else {
            server = "10.0.0.86"
        }
        print("Menu: Switching Server To " + server)
    }
    
    func updateData() -> NSData? {
        let urlString = "http://" + server + "/PikUpServer/users/" + (userData.valueForKey("id") as! String) + "/user.json"
        print("Checking location: " + urlString)
        var returnData = NSData(contentsOfURL: NSURL(string: urlString)!)
        if returnData == nil {
            switchServer()
            returnData = updateData()
        } else {
            print("Menu: Good 2 Go")
        }
        
        return returnData
    }
    
}

protocol MenuViewControllerDelegate {
    func updateVisibility(PageToShow:String)
}