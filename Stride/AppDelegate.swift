//
//  AppDelegate.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/6/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var runsPath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return url.URLByAppendingPathComponent("runArray").path!
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self])
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey(User.myUser.verified) == true{
            
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
            
            //Load runs
            User.sharedInstance().runsArray = NSKeyedUnarchiver.unarchiveObjectWithFile(runsPath) as? [Run] ?? [Run]()
            
            //set saved pace/
            if NSUserDefaults.standardUserDefaults().integerForKey(RunSettingsStruct.mileTime) != 0 {
                let mileTime = NSUserDefaults.standardUserDefaults().integerForKey(RunSettingsStruct.mileTime)
                let distance = NSUserDefaults.standardUserDefaults().floatForKey(RunSettingsStruct.goalDistance)
                let pace = NSUserDefaults.standardUserDefaults().floatForKey(RunSettingsStruct.paceGoal)
                
                var info = [String : AnyObject]()
                info[RunSettingsStruct.mileTime] = mileTime
                info[RunSettingsStruct.goalDistance] = distance
                info[RunSettingsStruct.paceGoal] = pace
                
                let runnerInfo = RunnerSettings.init(dictionary: info)
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    RunnerSettings.updateRunInfo(runnerInfo) { (error) in
                        if error != nil {
                            print(error)
                        }
                        else{
                            print("loaded running info")
                        }
                    }
                })
                
                
            }
            
            //set saved coachsettings
            if NSUserDefaults.standardUserDefaults().stringForKey(SCSettingsStruct.coach) != nil {
                let coach = NSUserDefaults.standardUserDefaults().stringForKey(SCSettingsStruct.coach)
                print(coach)
                let isOn = NSUserDefaults.standardUserDefaults().boolForKey(SCSettingsStruct.isOn)
                
                var coachSettings = [String : AnyObject]()
                coachSettings[SCSettingsStruct.isOn] = isOn
                coachSettings[SCSettingsStruct.coach] =  coach
                
                let updatedSettings = StrideCoachSettings(dictionary: coachSettings)
                
                StrideCoachSettings.updateStrideCoachSettings(updatedSettings)
                
                print("loaded coach info")
            }
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()

        }
        else {
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("TwilioSendMessage") as! TwilioSendMessage
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
        }
        
        
        

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
     
        
        
        if RunnerSettingsInfo.sharedInstance().runSettings.count > 0{
            NSUserDefaults.standardUserDefaults().setInteger(Int((RunnerSettingsInfo.sharedInstance().runSettings.first?.mileTime)!), forKey: RunSettingsStruct.mileTime)
            NSUserDefaults.standardUserDefaults().setFloat(Float((RunnerSettingsInfo.sharedInstance().runSettings.first?.goalDistance)!), forKey: RunSettingsStruct.goalDistance)
            NSUserDefaults.standardUserDefaults().setFloat(Float((RunnerSettingsInfo.sharedInstance().runSettings.first?.paceGoal)!), forKey: RunSettingsStruct.paceGoal)
            print("saved running info")
        }
        
        if StrideCoachSettingsClass.sharedInstance().scSettings.count > 0 {
            NSUserDefaults.standardUserDefaults().setBool((StrideCoachSettingsClass.sharedInstance().scSettings.first?.isOn)!, forKey: SCSettingsStruct.isOn)
            NSUserDefaults.standardUserDefaults().setValue(StrideCoachSettingsClass.sharedInstance().scSettings.first?.coach, forKey: SCSettingsStruct.coach)
            print("saved coach")
        }
        
        NSKeyedArchiver.archiveRootObject(User.sharedInstance().runsArray, toFile: runsPath)

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    }

    
    



}

