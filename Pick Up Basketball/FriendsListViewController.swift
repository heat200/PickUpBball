//
//  FriendsListViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 6/1/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

var userFriends:AnyObject!
var purpleColor:UIColor!


class FriendsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var friendsTableView:UITableView?
    var refreshControl:UIRefreshControl!
    
    var friendHolders = [FriendHolder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = AttributedString(string: "Pull to Refresh")
        if purpleColor != nil {
            refreshControl.tintColor = purpleColor
        }
        refreshControl.addTarget(self, action: #selector(FriendsListViewController.refresh), for: UIControlEvents.valueChanged)
        friendsTableView!.addSubview(refreshControl)
        loadInfo()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh() {
        loadInfo()
    }
    
    func endRefresh() {
        self.refreshControl.endRefreshing()
        //print("Completed!")
    }
    
    func loadInfo() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields":""])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                userFriends = result?.value(forKey: "data")
                self.friendHolders = [FriendHolder]()
                
                if userFriends == nil {
                    let noFilesAlert = UIAlertController(title: "Friends List is empty!", message: "Uh Oh, Seems you haven't added any friends or our servers are down, please come back in a bit if you believe it's on our end and not that you have no friends, thanks!", preferredStyle: .alert)
                    noFilesAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    self.present(noFilesAlert, animated: true, completion: nil)
                }
                
                var x = 0
                while x < userFriends.count {
                    let friendName = userFriends[x].value(forKey: "name") as? String
                    let friendID = userFriends[x].value(forKey: "id") as! String
                    var urlString = "https://graph.facebook.com/" + friendID + "/picture?type=large&redirect=false"
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(string: urlString)!), options: .mutableLeaves)
                        let data = dictionary.object(forKey: "data")!
                        urlString = data.value(forKey: "url") as! String
                    } catch {
                        print("Could not parse JSON: \(error)")
                    }
                    
                    var repScore = 0
                    var friendLocation = ""
                    let priority = DispatchQueue.GlobalAttributes.qosDefault
                    DispatchQueue.global(attributes: priority).async {
                        let data = self.updateData(friendID)
                        
                        var friendPicture:UIImage!
                        friendPicture = UIImage(data: try! Data(contentsOf: URL(string: urlString)!))!
                        
                        
                        DispatchQueue.main.async {
                            // update some UI
                            do {
                                let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
                                let checkedIn = dictionary.value(forKey: "checkedIn") as! Bool
                                if checkedIn {
                                    let data = dictionary.object(forKey: "location")!
                                    friendLocation = (data.value(forKey: "name") as! String)
                                    if friendLocation == "" {
                                        friendLocation = "Unknown Location"
                                    }
                                }
                                repScore = dictionary.value(forKey: "rep") as! Int
                            } catch {
                                print("Could not parse JSON: \(error)" + "Trying again")
                            }
                            
                            let friendHolder = FriendHolder(name: friendName!,rep: repScore,location: friendLocation,thumb: friendPicture)
                            self.friendHolders += [friendHolder]
                            
                            if x == userFriends.count {
                                self.friendsTableView?.reloadData()
                                self.perform(#selector(FriendsListViewController.endRefresh), with: nil, afterDelay: 0.5)
                            }
                        }
                    }
                    
                    x += 1
                }
            }
        })
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
        print("Friends List: Switching Server To " + server)
    }
    
    func updateData(_ friendID:String) -> Data? {
        let urlString = "http://" + server + "/PikUpServer/users/" + friendID + "/user.json"
        //print("Checking location: " + urlString)
        var returnData = try? Data(contentsOf: URL(string: urlString)!)
        if returnData == nil {
            switchServer()
            returnData = updateData(friendID)
        } else {
            print("Friends List: Good 2 Go")
        }
        return returnData
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Adding " + String(friendHolders.count) + " Cells to the View")
        return friendHolders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.friendsTableView!.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        let friendCell = friendHolders[(indexPath as NSIndexPath).row]
        
        cell.friendName.text = friendCell.friendName
        
        if friendCell.locationName == "Not Checked In" || friendCell.locationName == "" {
            cell.friendLocation.text = "Not Checked In"
            cell.friendLocation.textColor = UIColor.gray()
        } else {
            cell.friendLocation.text = friendCell.locationName
            cell.friendLocation.textColor = cell.usualColor
            purpleColor = cell.usualColor
            refreshControl.tintColor = purpleColor
            let attributedStringColor = [NSForegroundColorAttributeName : purpleColor]
            refreshControl.attributedTitle = AttributedString(string: "Pull To Refresh")
        }
        
        cell.friendPicture.image = friendCell.friendPic.roundImage()
        cell.friendRep.text = String(friendCell.friendRep)  + " Rep"
        
        return cell
    }
}
