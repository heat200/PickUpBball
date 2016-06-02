//
//  MainViewController.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 5/7/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MenuViewControllerDelegate {
    @IBOutlet var pageControl:UISegmentedControl!
    @IBOutlet var settingsContainer:UIView!
    @IBOutlet var recentViewContainer:UIView!
    @IBOutlet var hotspotsViewContainer:UIView!
    @IBOutlet var friendsViewContainer:UIView!
    @IBOutlet var friendsListViewContainer:UIView!
    @IBOutlet var navbar:UINavigationBar!
    @IBOutlet var statusbar:UIView!
    
    var settingsMenuShouldShow = false
    
    @IBAction func toggleSettingsMenuVisibility() {
        if settingsContainer.bounds.width == 0 {
            settingsMenuShouldShow = true
        } else {
            settingsMenuShouldShow = false
        }
    }
    
    func updateVisibility(PageToShow:String) {
        settingsMenuShouldShow = false
        
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
    }
    
    @IBAction func hideSettingsMenuVisibilityViaTap() {
        settingsMenuShouldShow = false
    }
    
    @IBAction func showSettingsMenuVisibility() {
        settingsMenuShouldShow = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsContainer.bounds.size.width = 0
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(MainViewController.scheduledAdjustments), userInfo: nil, repeats: true)
        let menuController = self.childViewControllers[3] as! MenuViewController
        menuController.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func scheduledAdjustments() {
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
        updateViews()
    }
    
    func updateViews() {
        let animationSpeed:CGFloat = 1
        if settingsMenuShouldShow && settingsContainer.bounds.width < (self.view.bounds.width/3) * 2 {
            var newFrameContainer = settingsContainer.frame
            newFrameContainer.size.width += animationSpeed
            settingsContainer.frame = newFrameContainer
            
            var newFrameStatusbar = statusbar.frame
            newFrameStatusbar.origin.x += animationSpeed
            statusbar.frame = newFrameStatusbar
            
            var newFrameNavbar = navbar.frame
            newFrameNavbar.origin.x += animationSpeed
            navbar.frame = newFrameNavbar
            
            recentViewContainer.frame.origin.x += animationSpeed
            hotspotsViewContainer.frame.origin.x += animationSpeed
            friendsViewContainer.frame.origin.x += animationSpeed
            friendsListViewContainer.frame.origin.x += animationSpeed
        } else if !settingsMenuShouldShow && settingsContainer.bounds.width > 0 {
            var newFrameContainer = settingsContainer.frame
            newFrameContainer.size.width -= animationSpeed
            settingsContainer.frame = newFrameContainer
            
            var newFrameStatusbar = statusbar.frame
            newFrameStatusbar.origin.x -= animationSpeed
            statusbar.frame = newFrameStatusbar
            
            var newFrameNavbar = navbar.frame
            newFrameNavbar.origin.x -= animationSpeed
            navbar.frame = newFrameNavbar
            
            recentViewContainer.frame.origin.x -= animationSpeed
            hotspotsViewContainer.frame.origin.x -= animationSpeed
            friendsViewContainer.frame.origin.x -= animationSpeed
            friendsListViewContainer.frame.origin.x -= animationSpeed
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
    func updateVisibility()
}