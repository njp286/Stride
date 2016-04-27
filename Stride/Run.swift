//
//  Run.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/13/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//
/*
import UIKit
import CoreLocation


class Runs: NSObject, NSCoding {
    
    struct Keys {
        static let Name = "name"
        static let FacebookName = "fbName"
        static let fbPassword = "fbPassword"
        static let runs = "runs"
    }
    
    var name = ""
    var runsArray = [Run]()
   
    
    init(dictionary: [String : AnyObject]) {

        if let userName = dictionary[Keys.Name] as? String {
            name = userName
        }
    }
    
    
    func at(index: Int) -> Run {
        return runsArray[index]
    }
    
    func add(run: Run) {
        runsArray.insert(run, atIndex: 0)  
    }
    
    func deleteFromRuns(index: Int) {
        runsArray.removeAtIndex(index)
    }
    
    func count() ->  Int {
        return runsArray.count
    }
    
    /////////////////////////
    //MARK -- NSCoding /////
    /////////////////////////
    
    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(name, forKey: Keys.Name)
        archiver.encodeObject(runsArray, forKey: Keys.runs)
    }
    
    required init(coder unarchiver: NSCoder) {
        super.init()
        
        // Unarchive the data, one property at a time
        name = unarchiver.decodeObjectForKey(Keys.Name) as? String
        runsArray = unarchiver.decodeObjectForKey(Keys.runs) as! [Run]
    }


}
 */



