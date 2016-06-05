//
//  FriendsListViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 6/1/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

var userFriends:AnyObject!

class FriendsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var friendsTableView:UITableView?
    var refreshControl:UIRefreshControl!
    
    var friendHolders = [FriendHolder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(FriendsListViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        friendsTableView!.addSubview(refreshControl)
        loadInfo()
    }
    
    override func viewDidAppear(animated:Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh() {
        loadInfo()
    }
    
    func endRefresh() {
        self.refreshControl.endRefreshing()
        print("Completed!")
    }
    
    func loadInfo() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields":""])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                userFriends = result.valueForKey("data")
                self.friendHolders = [FriendHolder]()
                
                if userFriends == nil {
                    let noFilesAlert = UIAlertController(title: "Friends List is empty!", message: "Uh Oh, Seems you haven't added any friends or our servers are down, please come back in a bit if you believe it's on our end and not that you have no friends, thanks!", preferredStyle: .Alert)
                    noFilesAlert.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
                    self.presentViewController(noFilesAlert, animated: true, completion: nil)
                }
                
                var x = 0
                while x < userFriends.count {
                    let friendName = userFriends[x].valueForKey("name") as? String
                    let friendID = userFriends[x].valueForKey("id") as! String
                    var urlString = "https://graph.facebook.com/" + friendID + "/picture?type=large&redirect=false"
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: NSURL(string: urlString)!)!, options: .MutableLeaves)
                        let data = dictionary.objectForKey("data")!
                        urlString = data.valueForKey("url") as! String
                    } catch {
                        print("Could not parse JSON: \(error)")
                    }
                    
                    var repScore = 0
                    var friendLocation = ""
                    do {
                        let data = self.updateData(friendID)
                        
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
                        let checkedIn = dictionary.valueForKey("checkedIn") as! Bool
                        if checkedIn {
                            let data = dictionary.objectForKey("location")!
                            friendLocation = (data.valueForKey("name") as! String)
                            if friendLocation == "" {
                                friendLocation = "Unknown Location"
                            }
                            print(friendLocation)
                        }
                        repScore = dictionary.valueForKey("rep") as! Int
                    } catch {
                        print("Could not parse JSON: \(error)" + "Trying again")
                    }
                    
                    var friendPicture:UIImage!
                    friendPicture = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)!
                    
                    let friendHolder = FriendHolder(name: friendName!,rep: repScore,location: friendLocation,thumb: friendPicture)
                    self.friendHolders += [friendHolder]
                    x += 1
                    
                    if x == userFriends.count {
                        self.friendsTableView?.reloadData()
                        self.performSelector(#selector(FriendsListViewController.endRefresh), withObject: nil, afterDelay: 0.5)
                    }
                }
            }
        })
    }
    
    func switchServer() {
        if server == "10.0.0.86" {
            server = "66.229.197.76"
        } else {
            server = "10.0.0.86"
        }
        print("Friends List: Switching Server To " + server)
    }
    
    func updateData(friendID:String) -> NSData? {
        let urlString = "http://" + server + "/PikUpServer/users/" + friendID + "/user.json"
        print("Checking location: " + urlString)
        var returnData = NSData(contentsOfURL: NSURL(string: urlString)!)
        if returnData == nil {
            switchServer()
            returnData = updateData(friendID)
        } else {
            print("Friends List: Good 2 Go")
        }
        return returnData
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Adding " + String(friendHolders.count) + " Cells to the View")
        return friendHolders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.friendsTableView!.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FriendCell
        let friendCell = friendHolders[indexPath.row]
        
        cell.friendName.text = friendCell.friendName
        
        if friendCell.locationName == "Not Checked In" || friendCell.locationName == "" {
            cell.friendLocation.text = "Not Checked In"
            cell.friendLocation.textColor = UIColor.grayColor()
        } else {
            cell.friendLocation.text = friendCell.locationName
            cell.friendLocation.textColor = cell.usualColor
        }
        
        cell.friendPicture.image = friendCell.friendPic.roundImage()
        cell.friendRep.text = String(friendCell.friendRep)  + " Rep"
        
        return cell
    }
}