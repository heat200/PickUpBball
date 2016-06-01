//
//  StartScreenViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/7/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet var userName:UILabel!
    @IBOutlet var userRep:UILabel!
    @IBOutlet var userPicture:UIImageView!
    
    @IBAction func signOut() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("Logging out")
            FBSDKAccessToken.setCurrentAccessToken(nil)
            FBSDKProfile.setCurrentProfile(nil)
            self.dismissViewControllerAnimated(true, completion: nil)
            /*
            let LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            self.view.window!.rootViewController?.presentViewController(LoginVC, animated: true, completion: {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            */
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
        
        //print(urlString)
        repFrameOrigin = userRep.frame.origin
        repFrameSize = userRep.frame.size
        nameFrameOrigin = userName.frame.origin
        nameFrameSize = userName.frame.size
        pictureFrameOrigin = userPicture.frame.origin
        pictureFrameSize = userPicture.frame.size
        userPicture.image = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)
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
}

protocol MenuViewControllerDelegate {
    func updateVisibility(PageToShow:String)
}