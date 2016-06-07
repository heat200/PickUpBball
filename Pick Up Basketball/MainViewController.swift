//
//  MainViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/7/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

var server = "10.0.0.86"

class MainViewController: UIViewController, MenuViewControllerDelegate {
    @IBOutlet var pageControl:UISegmentedControl!
    @IBOutlet var menuContainer:UIView!
    @IBOutlet var recentViewContainer:UIView!
    @IBOutlet var hotspotsViewContainer:UIView!
    @IBOutlet var friendsViewContainer:UIView!
    @IBOutlet var friendsListViewContainer:UIView!
    @IBOutlet var navbar:UINavigationBar!
    @IBOutlet var menuBtn:UIButton!
    @IBOutlet var statusbar:UIView!
    
    var settingsMenuShouldShow = false
    var delegate:MainViewControllerDelegate!
    
    @IBOutlet var menuWidthConstraint:NSLayoutConstraint!
    @IBOutlet var friendsXOriginConstraint:NSLayoutConstraint!
    
    @IBAction func toggleSettingsMenuVisibility() {
        if menuContainer.bounds.width == 0 {
            settingsMenuShouldShow = true
            menuBtn.selected = true
        } else {
            settingsMenuShouldShow = false
            menuBtn.selected = false
        }
    }
    
    func updateVisibility(PageToShow:String) {
        settingsMenuShouldShow = false
        menuBtn.selected = false
        delegate.updateUserData()
        if PageToShow == "Home" {
            pageControl.hidden = false
            friendsListViewContainer.hidden = true
        } else if PageToShow == "Friends" {
            friendsListViewContainer.hidden = false
            pageControl.hidden = true
            navbar.backItem?.title = PageToShow
            recentViewContainer.hidden = true
            hotspotsViewContainer.hidden = true
            friendsViewContainer.hidden = true
        }
    }
    
    @IBAction func hideSettingsMenuVisibility() {
        settingsMenuShouldShow = false
        menuBtn.selected = false
    }
    
    @IBAction func hideSettingsMenuVisibilityViaTap() {
        settingsMenuShouldShow = false
        menuBtn.selected = false
    }
    
    @IBAction func showSettingsMenuVisibility() {
        settingsMenuShouldShow = true
        menuBtn.selected = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbar.setBackgroundImage(UIImage(named: "barGradient"),forBarMetrics: .Default)
        menuContainer.bounds.size.width = 0
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(MainViewController.scheduledAdjustments), userInfo: nil, repeats: true)
        let menuController = self.childViewControllers[3] as! MenuViewController
        menuController.delegate = self
        self.delegate = menuController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func scheduledAdjustments() {
        updateViews()
    }
    
    func updateViews() {
        let animationSpeed:Double = 0.25
        
        if settingsMenuShouldShow && menuContainer.bounds.width < (self.view.bounds.width/3) * 2 {
            let position = (self.view.bounds.width/3) * 2
            UIView.animateWithDuration(animationSpeed, animations: {
                //self.navbar.setBackgroundImage(UIImage(named: "barGradient2"),forBarMetrics: .Default)
                self.menuWidthConstraint.constant = position
                self.friendsXOriginConstraint.constant = position
                self.view.layoutIfNeeded()
            })
        } else if !settingsMenuShouldShow && menuContainer.bounds.width > 0 {
            let position:CGFloat = 0
            UIView.animateWithDuration(animationSpeed, animations: {
                //self.navbar.setBackgroundImage(UIImage(named: "barGradient"),forBarMetrics: .Default)
                self.menuWidthConstraint.constant = position
                self.friendsXOriginConstraint.constant = position
                self.view.layoutIfNeeded()
            })
        }
        
        if pageControl.selectedSegmentIndex == 0 && !pageControl.hidden {
            recentViewContainer.hidden = true
            hotspotsViewContainer.hidden = false
            friendsViewContainer.hidden = true
        } else if pageControl.selectedSegmentIndex == 1 && !pageControl.hidden {
            recentViewContainer.hidden = true
            hotspotsViewContainer.hidden = true
            friendsViewContainer.hidden = false
        } else if pageControl.selectedSegmentIndex == 2 && !pageControl.hidden {
            recentViewContainer.hidden = false
            hotspotsViewContainer.hidden = true
            friendsViewContainer.hidden = true
        }
    }
}

protocol MainViewControllerDelegate {
    func updateUserData()
}

struct userDefaults {
    static let lastServer = "lastServer"
}

extension UIImage {
    func roundImage() -> UIImage {
        let newImage = self.copy() as! UIImage
        let cornerRadius = self.size.height/2
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
        let bounds = CGRect(origin: CGPointZero, size: self.size)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        newImage.drawInRect(bounds)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
}