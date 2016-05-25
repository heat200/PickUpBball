//
//  ActivityViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/7/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var recentActivityTableView:UITableView?
    
    var recentActivityHolders = [RecentActivityInfoHolder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleInfo()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated:Bool) {
        if recentActivityHolders.count == 0 {
            let noFilesAlert = UIAlertController(title: "Feed is empty!", message: "Uh Oh, Seems you haven't met anyone or our servers are down, please come back in a bit if you believe it's on our end and not that you have met no one while using the app, thanks!", preferredStyle: .Alert)
            noFilesAlert.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
            presentViewController(noFilesAlert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func runRecentsActivityViewerSetup(sender:AnyObject?) {
        /*
         let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = "MM/dd/yyyy"
         let dateBegun = (sender as! recentActivityCell).otherInformation.checkInDate
         let dateModifier = NSDateComponents()
         dateModifier.year = 1
         dateModifier.day = -1
         
         let calendarType = NSCalendar.currentCalendar()
         
         let dateExpired = calendarType.dateByAddingComponents(dateModifier, toDate: dateBegun, options: .MatchLast)!
         
         recent = "Insured: " + (sender as! recentActivityCell).otherInformation.insureeName
         insuranceTypeDisplay = "Insurance: " + (sender as! recentActivityCell).otherInformation.insuranceType
         effectiveDateDisplay = "Effective Date: " + dateFormatter.stringFromDate(dateBegun) + " - " + dateFormatter.stringFromDate(dateExpired)
         
         print("Moving Data To Inspector")
         (sender as! recentActivityCell).setSelected(false, animated: true)
         print("Deselecting recentInfoCell")
         */
    }
    
    func loadSampleInfo() {
        let photo1 = UIImage(named:"person")!
        let recentActivityInfoHolder1 = RecentActivityInfoHolder(location: "Bird Lakes Park",thumb: photo1,people:["Chris Vila"],dateEffective:"05/25/2016 at 16:55:00")
        let recentActivityInfoHolder2 = RecentActivityInfoHolder(location: "AAA",thumb: photo1,people:["Lebron James","Chris Bosh","Dwayne Wade"],dateEffective:"05/23/2016 at 14:00:00")
        let recentActivityInfoHolder3 = RecentActivityInfoHolder(location: "LA Fitness",thumb: photo1,people:["Pedro Alarcon","Micheal Miranda", ""],dateEffective:"05/05/2016 at 10:45:00")
        let recentActivityInfoHolder4 = RecentActivityInfoHolder(location: "Bird Lakes Park",thumb: photo1,people:[],dateEffective:"05/04/2016 at 12:30:00")
        recentActivityHolders += [recentActivityInfoHolder1,recentActivityInfoHolder2,recentActivityInfoHolder3,recentActivityInfoHolder4]
        print("Sample Info Loaded")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Adding " + String(recentActivityHolders.count) + " Cells to the View")
        return recentActivityHolders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.recentActivityTableView!.dequeueReusableCellWithIdentifier("recentActivityCell", forIndexPath: indexPath) as! RecentActivityCell
        
        // Configure the cell...
        let recentActivityCell = recentActivityHolders[indexPath.row]
        
        cell.locationName.text = recentActivityCell.locationName
        /*
        if recentActivityCell.recentName.characters.count > 10 {
            cell.checkedIntoLabel.text = "->"
            dispatch_async(dispatch_get_main_queue(), {
                cell.checkedIntoLabel.sizeToFit()
                cell.recentName.sizeToFit()
                cell.checkedIntoLabel.frame.origin.x += 50
                cell.recentName.frame.origin.y += 2
            })
        }
        */
        
        cell.profilePic.image = recentActivityCell.profilePic
        var timePassed = (NSDate(timeIntervalSinceNow: 0).timeIntervalSinceDate(recentActivityCell.dateCheckedIn))
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
        if recentActivityCell.peopleMet.count == 0 {
            cell.peopleMetLabel.text = "No one was met :("
        } else if recentActivityCell.peopleMet.count == 1 {
            cell.peopleMetLabel.text = recentActivityCell.peopleMet[0]
        } else if recentActivityCell.peopleMet.count == 2 {
            cell.peopleMetLabel.text = recentActivityCell.peopleMet[0] + " and " + recentActivityCell.peopleMet[1]
        } else {
            cell.peopleMetLabel.text = recentActivityCell.peopleMet[0] + ", " + recentActivityCell.peopleMet[1] + ", and others."
        }
        
        print("Propagated View")
        return cell
    }
}