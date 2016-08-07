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
    var refreshControl:UIRefreshControl!
    
    var recentActivityHolders = [RecentActivityInfoHolder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(RecentViewController.refresh), for: UIControlEvents.valueChanged)
        recentActivityTableView!.addSubview(refreshControl)
        loadSampleInfo()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        if recentActivityHolders.count == 0 {
            let noFilesAlert = UIAlertController(title: "Feed is empty!", message: "Uh Oh, Seems you haven't met anyone or our servers are down, please come back in a bit if you believe it's on our end and not that you have met no one while using the app, thanks!", preferredStyle: .alert)
            noFilesAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            present(noFilesAlert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh() {
        loadSampleInfo()
        self.perform(#selector(RecentViewController.endRefresh), with: nil, afterDelay: 0.5)
    }
    
    func endRefresh() {
        self.refreshControl.endRefreshing()
        print("Completed!")
    }
    
    
    func runRecentsActivityViewerSetup(_ sender:AnyObject?) {
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
        recentActivityHolders = [RecentActivityInfoHolder]()
        let photo1 = UIImage(named:"person")!
        let recentActivityInfoHolder1 = RecentActivityInfoHolder(location: "Bird Lakes Park",thumb: photo1,person:"Chris Vila",dateEffective:"05/25/2016 at 16:55:00")
        let recentActivityInfoHolder2 = RecentActivityInfoHolder(location: "AAA",thumb: photo1,person:"Lebron James",dateEffective:"05/23/2016 at 14:00:00")
        let recentActivityInfoHolder3 = RecentActivityInfoHolder(location: "LA Fitness",thumb: photo1,person:"Pedro Alarcon",dateEffective:"05/05/2016 at 10:45:00")
        let recentActivityInfoHolder4 = RecentActivityInfoHolder(location: "Bird Lakes Park",thumb: photo1,person:"Billy Bob",dateEffective:"05/04/2016 at 12:30:00")
        recentActivityHolders += [recentActivityInfoHolder1,recentActivityInfoHolder2,recentActivityInfoHolder3,recentActivityInfoHolder4]
        self.recentActivityTableView?.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Adding " + String(recentActivityHolders.count) + " Cells to the View")
        return recentActivityHolders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.recentActivityTableView!.dequeueReusableCell(withIdentifier: "recentActivityCell", for: indexPath) as! RecentActivityCell
        
        let recentActivityCell = recentActivityHolders[(indexPath as NSIndexPath).row]
        
        cell.profilePic.image = recentActivityCell.profilePic
        var timePassed = (Date(timeIntervalSinceNow: 0).timeIntervalSince(recentActivityCell.dateCheckedIn as Date))
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
        cell.personMetLabel.text = recentActivityCell.personMet
        
        return cell
    }
}
