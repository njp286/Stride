//
//  RunnerSettings.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/13/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import Foundation

struct RunnerSettings {
    
    var mileTime: NSNumber
    var goalDistance: NSNumber
    var paceGoal: NSNumber
    
    init(dictionary: [String:AnyObject]) {
        //objectId = dictionary[ParseConstants.StudentLocationKeys.objectId] as! String
        mileTime = dictionary[RunSettingsStruct.mileTime] as! NSNumber
        goalDistance = dictionary[RunSettingsStruct.goalDistance] as! NSNumber
        paceGoal = dictionary[RunSettingsStruct.paceGoal] as! NSNumber
    }

    static func updateRunInfo(info: RunnerSettings, completionHandler: (error: String?) -> Void) {
        
        RunnerSettingsInfo.sharedInstance().runSettings.removeAll()
        
        RunnerSettingsInfo.sharedInstance().runSettings.append(info)
        
        completionHandler(error: nil)
    }



}

struct RunSettingsStruct {
    
    static let mileTime: String = "mileTime"
    static let goalDistance: String = "goalDistance"
    static let paceGoal: String = "paceGoal"
    
}

class RunnerSettingsInfo {
    var runSettings = [RunnerSettings]()
    
    class func sharedInstance() -> RunnerSettingsInfo {
        
        struct Singleton {
            static var sharedInstance = RunnerSettingsInfo()
        }
        
        return Singleton.sharedInstance
    }

    
}


