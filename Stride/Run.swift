//
//  Run.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/13/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import CoreLocation


class myRuns {
    
    var runsArray = [Run]()
    
    class func sharedInstance() -> myRuns {
        
        struct Singleton {
            static var sharedInstance = myRuns()
        }
        
        return Singleton.sharedInstance
    }
    
    func at(index: Int) -> Run {
        return runsArray[index]
    }
    
    func add(run: Run) {
        runsArray.insert(run, atIndex: 0)  
    }
    
    func delete(index: Int) {
        runsArray.removeAtIndex(index)
    }
    
    var count: Int {
        return runsArray.count
    }

}

struct Run {

    var duration: String
    var distance: String
    var pace: String
    var goalPace: String
    var timestamp: NSDate
    var map: UIImage

    
    init(dictionary: [String:AnyObject]) {
        duration = dictionary[RunningCategories.duration] as! String
        distance = dictionary[RunningCategories.distance] as! String
        pace = dictionary[RunningCategories.pace] as! String
        goalPace = dictionary[RunningCategories.goalPace] as! String
        timestamp = dictionary[RunningCategories.timestamp] as! NSDate
        map = dictionary[RunningCategories.map] as! UIImage
    }

    
    
}

struct RunningCategories {
    
    static let duration: String = "duration"
    static let distance: String = "distance"
    static let pace: String = "pace"
    static let goalPace: String = "goalPace"
    static let timestamp: String = "timestamp"
    static let map: String = "map"
    
}