//
//  FriendsActivityViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/7/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var friendActivityTableView:UITableView?
    
    var friendActivityHolders = [FriendActivityInfoHolder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleInfo()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated:Bool) {
        if friendActivityHolders.count == 0 {
            let noFilesAlert = UIAlertController(title: "Feed is empty!", message: "Uh Oh, Seems you haven't added any friends or our servers are down, please come back in a bit if you believe it's on our end and not that you have no friends, thanks!", preferredStyle: .Alert)
            noFilesAlert.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
            presentViewController(noFilesAlert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func runFriendActivityViewerSetup(sender:AnyObject?) {
        /*
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateBegun = (sender as! FriendActivityCell).otherInformation.checkInDate
        let dateModifier = NSDateComponents()
        dateModifier.year = 1
        dateModifier.day = -1
        
        let calendarType = NSCalendar.currentCalendar()
        
        let dateExpired = calendarType.dateByAddingComponents(dateModifier, toDate: dateBegun, options: .MatchLast)!
        
        friend = "Insured: " + (sender as! friendActivityCell).otherInformation.insureeName
        insuranceTypeDisplay = "Insurance: " + (sender as! friendActivityCell).otherInformation.insuranceType
        effectiveDateDisplay = "Effective Date: " + dateFormatter.stringFromDate(dateBegun) + " - " + dateFormatter.stringFromDate(dateExpired)
        
        print("Moving Data To Inspector")
        (sender as! FriendActivityCell).setSelected(false, animated: true)
        print("Deselecting FriendInfoCell")
        */
    }
    
    func loadSampleInfo() {
        let photo1 = UIImage(named:"testPerson")!
        let friendActivityInfoHolder1 = FriendActivityInfoHolder(name: "Chris Vila",location: "Bird Lakes Park",thumb: photo1,dateEffective:"05/25/2016 at 17:15:00")
        let friendActivityInfoHolder2 = FriendActivityInfoHolder(name: "Pedro Alarcon",location: "LA Fitness",thumb: photo1,dateEffective:"05/25/2016 at 17:10:00")
        let friendActivityInfoHolder3 = FriendActivityInfoHolder(name: "Bryan Mazariegos",location: "Bird Lakes Park",thumb: photo1,dateEffective:"05/25/2016 at 13:04:00")
        let friendActivityInfoHolder4 = FriendActivityInfoHolder(name: "Lebron James",location: "AAA",thumb: photo1,dateEffective:"05/23/2016 at 14:00:00")
        let friendActivityInfoHolder5 = FriendActivityInfoHolder(name: "Billy Bob",location: "Bent Tree Park",thumb: photo1,dateEffective:"05/05/2016 at 10:45:00")
        friendActivityHolders += [friendActivityInfoHolder1,friendActivityInfoHolder2,friendActivityInfoHolder3,friendActivityInfoHolder4,friendActivityInfoHolder5]
        print("Sample Info Loaded")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Adding " + String(friendActivityHolders.count) + " Cells to the View")
        return friendActivityHolders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.friendActivityTableView!.dequeueReusableCellWithIdentifier("friendActivityCell", forIndexPath: indexPath) as! FriendActivityCell
        
        // Configure the cell...
        let friendActivityCell = friendActivityHolders[indexPath.row]
        
        cell.friendName.text = friendActivityCell.friendName
        
        if friendActivityCell.friendName.characters.count > 10 {
            cell.checkedIntoLabel.text = "->"
            dispatch_async(dispatch_get_main_queue(), {
                cell.checkedIntoLabel.sizeToFit()
                cell.friendName.sizeToFit()
                cell.checkedIntoLabel.frame.origin.x += 50
                cell.friendName.frame.origin.y += 2
            })
        }
        
        
        cell.locationName.text = friendActivityCell.locationName
        cell.friendPicture.image = friendActivityCell.friendPic
        var timePassed = (NSDate(timeIntervalSinceNow: 0).timeIntervalSinceDate(friendActivityCell.checkInDate))
        var timeAsString = ""
        
        if timePassed < 60 {
            if timePassed != 1 {
                timeAsString = String(Int(timePassed)) + " secs ago"
            } else {
                timeAsString = "1 sec ago"
            }
        } else if round(timePassed/60) < 60 {
            timePassed = round(timePassed/60)
            if timePassed > 1 {
                timeAsString = String(Int(timePassed)) + " mins ago"
            } else {
                timeAsString = "1 min ago"
            }
        } else if round(timePassed/3600) < 24 {
            timePassed = round(timePassed/3600)
            if timePassed > 1 {
                timeAsString = String(Int(timePassed)) + " hours ago"
            } else {
                timeAsString = "1 hour ago"
            }
        } else {
            timePassed = round(timePassed/216000)
            if timePassed > 1 {
                timeAsString = String(Int(timePassed)) + " days ago"
            } else {
                timeAsString = "1 day ago"
            }
        }
        
        cell.postTime.text = timeAsString
        print("Propagated View")
        return cell
    }
}