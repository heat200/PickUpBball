//
//  ProfileViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/7/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet var userName:UILabel!
    @IBOutlet var userRep:UILabel!
    @IBOutlet var userPicture:UIImageView!
    
    var pictureFrameOrigin:CGPoint!
    var pictureFrameSize:CGSize!
    var nameFrameOrigin:CGPoint!
    var nameFrameSize:CGSize!
    var repFrameOrigin:CGPoint!
    var repFrameSize:CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = userData.value(forKey: "name") as? String
        
        pictureFrameOrigin = userPicture.frame.origin
        pictureFrameSize = userPicture.frame.size
        
        var urlString = "https://graph.facebook.com/" + String(FBSDKAccessToken.current().userID!) + "/picture?type=large&redirect=false"
        print(urlString)
        let priority = DispatchQueue.GlobalAttributes.qosDefault
        DispatchQueue.global(attributes: priority).async {
            let fbData = try? Data(contentsOf: URL(string: urlString)!)
            DispatchQueue.main.async {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: fbData!, options: .mutableLeaves)
                    let data = dictionary.object(forKey: "data")!
                    urlString = data.value(forKey: "url") as! String
                } catch {
                    print("Could not parse JSON: \(error)")
                }
                
                DispatchQueue.global(attributes: priority).async {
                    let newImage = UIImage(data: try! Data(contentsOf: URL(string: urlString)!))?.roundImage()
                    DispatchQueue.main.async {
                        self.userPicture.image = newImage
                    }
                }
            }
        }
        
        updateUserData()
        
        nameFrameOrigin = userName.frame.origin
        nameFrameSize = userName.frame.size
        repFrameSize = userRep.frame.size
        repFrameOrigin = userRep.frame.origin
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
    
    
    func updateUserData() {
        var repScore = 0
        var userLocation = ""
        let priority = DispatchQueue.GlobalAttributes.qosDefault
        DispatchQueue.global(attributes: priority).async {
            let data = self.updateData()
            DispatchQueue.main.async {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
                    let checkedIn = dictionary.value(forKey: "checkedIn") as! Bool
                    if checkedIn {
                        let data = dictionary.object(forKey: "location")!
                        userLocation = (data.value(forKey: "name") as! String)
                    }
                    repScore = dictionary.value(forKey: "rep") as! Int
                    
                } catch {
                    print("Could not parse JSON: \(error)")
                }
                
                //print("User is at: " + userLocation)
                self.userRep.text = String(repScore) + " Rep"
                
                self.fixLayoutIssues()
            }
        }
    }
    
    func switchServer() {
        if server == "10.0.0.91" {
            server = "66.229.197.76"
        } else {
            server = "10.0.0.91"
        }
        
        if atFIU {
            server = "10.109.28.197"
        }
        //print("Menu: Switching Server To " + server)
    }
    
    func updateData() -> Data? {
        let urlString = "http://" + server + "/PikUpServer/users/" + (userData.value(forKey: "id") as! String) + "/user.json"
        //print("Checking location: " + urlString)
        var returnData = try? Data(contentsOf: URL(string: urlString)!)
        if returnData == nil {
            switchServer()
            returnData = updateData()
        } else {
            print("Menu: Good 2 Go")
        }
        return returnData
    }
    
    @IBAction func dismissProfilePage() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
