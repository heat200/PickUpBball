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
    
    var friendHolders = [FriendHolder]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
    }
    
    override func viewDidAppear(animated:Bool) {
        if friendHolders.count == 0 {
            let noFilesAlert = UIAlertController(title: "Friends List is empty!", message: "Uh Oh, Seems you haven't added any friends or our servers are down, please come back in a bit if you believe it's on our end and not that you have no friends, thanks!", preferredStyle: .Alert)
            noFilesAlert.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
            presentViewController(noFilesAlert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadInfo() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                userFriends = result.valueForKey("data")
                var x = 0
                while x < userFriends.count {
                    let friendName = userFriends[x].valueForKey("name") as? String
                    var urlString = "https://graph.facebook.com/" + (userFriends[x].valueForKey("id") as! String) + "/picture?type=large&redirect=false"
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: NSURL(string: urlString)!)!, options: .MutableLeaves)
                        let data = dictionary.objectForKey("data")!
                        urlString = data.valueForKey("url") as! String
                        print(urlString)
                    } catch {
                        print("Could not parse JSON: \(error)")
                    }
                    var friendPicture:UIImage!
                    friendPicture = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)!
                    
                    let friendHolder1 = FriendHolder(name: friendName!,rep: 10,location: "",thumb: friendPicture)
                    self.friendHolders += [friendHolder1]
                    print("Friend Count:" + String(self.friendHolders.count))
                    x += 1
                    
                    if x == userFriends.count {
                        self.friendsTableView?.reloadData()
                    }
                }
            }
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Adding " + String(friendHolders.count) + " Cells to the View")
        return friendHolders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.friendsTableView!.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FriendCell
        
        let friendCell = friendHolders[indexPath.row]
        
        cell.friendName.text = friendCell.friendName
        
        if friendCell.locationName == "Not Checked In" || friendCell.locationName == "" {
            cell.friendLocation.text = "Not Checked In"
            cell.friendLocation.textColor = UIColor.grayColor()
        }
        
        cell.friendLocation.text = friendCell.locationName
        cell.friendPicture.image = friendCell.friendPic
        cell.friendRep.text = String(friendCell.friendRep)
        return cell
    }
}