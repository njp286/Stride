//
//  StrideCoachSettings.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/20/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import Foundation

struct StrideCoachSettings {
    
    var isOn: Bool = true
    var volume: Float = 1.0
    var coach: String = "colorMan3"
    
    init(dictionary: [String:AnyObject]) {
        isOn = dictionary[SCSettingsStruct.isOn] as! Bool
        volume = dictionary[SCSettingsStruct.volume] as! Float
        coach = dictionary[SCSettingsStruct.coach] as! String
    }
    
    static func updateStrideCoachSettings(info: StrideCoachSettings) {
        
        StrideCoachSettingsClass.sharedInstance().scSettings.removeAll()
        
        StrideCoachSettingsClass.sharedInstance().scSettings.append(info)
    }
    
}

struct SCSettingsStruct {
    
    static let isOn: String = "isOn"
    static let volume: String = "volume"
    static let coach: String = "coach"
    
}




class StrideCoachSettingsClass {
    var scSettings = [StrideCoachSettings]()
    
    class func sharedInstance() -> StrideCoachSettingsClass {
        
        struct Singleton {
            static var sharedInstance = StrideCoachSettingsClass()
        }
        
        return Singleton.sharedInstance
    }
    
    
}


