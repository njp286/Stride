//
//  User.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/26/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import CoreLocation


class User {
    
    var verified: Bool!
    var name = ""
    var runsArray = [Run]()
    
    struct myUser {
        static let verified = "verified"
    }
    
    
    class func sharedInstance() -> User {
        
        struct Singleton {
            static var sharedInstance = User()
        }
        
        return Singleton.sharedInstance
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
    
    
}



