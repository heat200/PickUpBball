//
//  HotspotsViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/7/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class HotspotsViewController: UIViewController {
    @IBOutlet var hotspotsActivityTableView:UITableView?
    var refreshControl:UIRefreshControl!
    
    var hotspotsActivityHolders = [HotspotsActivityInfoHolder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = AttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(HotspotsViewController.refresh), for: UIControlEvents.valueChanged)
        hotspotsActivityTableView!.addSubview(refreshControl)
        loadSampleInfo()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        if hotspotsActivityHolders.count == 0 {
            let noFilesAlert = UIAlertController(title: "Feed is empty!", message: "Uh Oh, Seems you haven't added any hotspots or our servers are down, please come back in a bit if you believe it's on our end and not that you have no hotspotss, thanks!", preferredStyle: .alert)
            noFilesAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            present(noFilesAlert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh() {
        loadSampleInfo()
        self.perform(#selector(HotspotsViewController.endRefresh), with: nil, afterDelay: 0.5)
    }
    
    func endRefresh() {
        self.refreshControl.endRefreshing()
        print("Completed!")
    }
    
    func runhotspotsActivityViewerSetup(_ sender:AnyObject?) {
        /*
         let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = "MM/dd/yyyy"
         let dateBegun = (sender as! hotspotsActivityCell).otherInformation.checkInDate
         let dateModifier = NSDateComponents()
         dateModifier.year = 1
         dateModifier.day = -1
         
         let calendarType = NSCalendar.currentCalendar()
         
         let dateExpired = calendarType.dateByAddingComponents(dateModifier, toDate: dateBegun, options: .MatchLast)!
         
         hotspots = "Insured: " + (sender as! hotspotsActivityCell).otherInformation.insureeName
         insuranceTypeDisplay = "Insurance: " + (sender as! hotspotsActivityCell).otherInformation.insuranceType
         effectiveDateDisplay = "Effective Date: " + dateFormatter.stringFromDate(dateBegun) + " - " + dateFormatter.stringFromDate(dateExpired)
         
         print("Moving Data To Inspector")
         (sender as! hotspotsActivityCell).setSelected(false, animated: true)
         print("Deselecting hotspotsInfoCell")
         */
    }
    
    func loadSampleInfo() {
        hotspotsActivityHolders = [HotspotsActivityInfoHolder]()
        let photo1 = UIImage(named:"testPlace")!
        let hotspotsActivityInfoHolder1 = HotspotsActivityInfoHolder(name: "Bird Lakes Park",address: "14365 SW 48th Ln, Miami, FL 33175",thumb: photo1,rank:1,people:50)
        let hotspotsActivityInfoHolder2 = HotspotsActivityInfoHolder(name: "Bent Tree Park",address: "13850 SW 47th St, Miami, FL 33175",thumb: photo1,rank:2,people:25)
        let hotspotsActivityInfoHolder3 = HotspotsActivityInfoHolder(name: "LA Fitness",address: "16339 SW 88th St, Miami, FL 33196",thumb: photo1,rank:3,people:20)
        hotspotsActivityHolders += [hotspotsActivityInfoHolder1,hotspotsActivityInfoHolder2,hotspotsActivityInfoHolder3]
        self.hotspotsActivityTableView?.reloadData()
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Adding " + String(hotspotsActivityHolders.count) + " Cells to the View")
        return hotspotsActivityHolders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = self.hotspotsActivityTableView!.dequeueReusableCell(withIdentifier: "hotspotsActivityCell", for: indexPath) as! HotspotsActivityCell
        
        let hotspotsActivityCell = hotspotsActivityHolders[(indexPath as NSIndexPath).row]
        
        cell.locationName.text = hotspotsActivityCell.locationName
        cell.locationAddress.text = hotspotsActivityCell.locationAddress
        cell.locationPicture.image = hotspotsActivityCell.locationPic
        cell.locationRank.text = String(hotspotsActivityCell.locationRank)
        cell.amountCheckedIn.text = String(hotspotsActivityCell.locationAmountCheckedIn) + " People"
        
        return cell
    }
}
