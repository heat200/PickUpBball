//
//  FriendsListViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 6/1/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var friendsTableView:UITableView?
    
    var friendHolders = [FriendHolder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleInfo()
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
    
    func loadSampleInfo() {
        let photo1 = UIImage(named:"testPerson")!
        let friendHolder1 = FriendHolder(name: "Chris Vila",rep: 10,location: "Bird Lakes Park",thumb: photo1)
        let friendHolder2 = FriendHolder(name: "Pedro Alarcon",rep:1000,location: "LA Fitness",thumb: photo1)
        let friendHolder3 = FriendHolder(name: "Bryan Mazariegos",rep: 50,location: "Not Checked In",thumb: photo1)
        friendHolders += [friendHolder1,friendHolder2,friendHolder3]
    }
    
    func loadRealInfo() {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Adding " + String(friendActivityHolders.count) + " Cells to the View")
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