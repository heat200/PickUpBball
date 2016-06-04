//
//  AppDelegate.swift
//  Pick Up: Basketball
//
//  Created by Bryan Mazariegos on 2/25/16.
//  Copyright © 2016 Pedro Alarcon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let serverToCheck = defaults.stringForKey(userDefaults.lastServer) {
            server = serverToCheck
            print("Will Load From Last Server: " + server)
        }
        
        let ready = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        self.checkIfLoggedIn()
        return ready
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(server, forKey: userDefaults.lastServer)
        defaults.synchronize()
    }

    func checkIfLoggedIn() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            //print("Logged in")
            FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
            
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":""])
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                
                if ((error) != nil) {
                    print("Error: \(error)")
                } else {
                    userData = result
                    //print("fetched user: " + String(result))
                    if (FBSDKAccessToken.currentAccessToken() != nil) {
                        self.window!.rootViewController = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("mainView")as? MainViewController
                    }
                }
            })
        }
    }
}

