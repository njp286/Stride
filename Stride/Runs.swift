//
//  Runs.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/26/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit

class Run: NSObject, NSCoding {
    
    struct RunningCategories {
        
        static let duration: String = "duration"
        static let distance: String = "distance"
        static let pace: String = "pace"
        static let goalPace: String = "goalPace"
        static let timestamp: String = "timestamp"
        static let map: String = "map"
        
    }
    
    var duration: String
    var distance: String
    var pace: String
    var goalPace: String
    var timestamp: NSDate
    
    

    
    
    init(dictionary: [String:AnyObject]) {
        duration = dictionary[RunningCategories.duration] as! String
        distance = dictionary[RunningCategories.distance] as! String
        pace = dictionary[RunningCategories.pace] as! String
        goalPace = dictionary[RunningCategories.goalPace] as! String
        timestamp = dictionary[RunningCategories.timestamp] as! NSDate

    }
    
    /////////////////////
    // MARK: - NSCoding//
    /////////////////////
    
    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(duration, forKey: RunningCategories.duration)
        archiver.encodeObject(distance, forKey: RunningCategories.distance)
        archiver.encodeObject(pace, forKey: RunningCategories.pace)
        archiver.encodeObject(goalPace, forKey: RunningCategories.goalPace)
        archiver.encodeObject(timestamp, forKey: RunningCategories.timestamp)
    }
    
    required init(coder unarchiver: NSCoder) {
        duration = unarchiver.decodeObjectForKey(RunningCategories.duration) as! String
        distance = unarchiver.decodeObjectForKey(RunningCategories.distance) as! String
        pace = unarchiver.decodeObjectForKey(RunningCategories.pace) as! String
        goalPace = unarchiver.decodeObjectForKey(RunningCategories.goalPace) as! String
        timestamp = unarchiver.decodeObjectForKey(RunningCategories.timestamp) as! NSDate
        
        super.init()
        
    }

    
    
}