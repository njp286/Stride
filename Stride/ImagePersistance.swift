//
//  ImagePersistance.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/26/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit

class ImagePersistance {
    
    
    //Shared Insance
    class func sharedInstance() -> ImagePersistance {
        
        struct Singleton {
            static var sharedInstance = ImagePersistance()
        }
        
        return Singleton.sharedInstance
    }

    
    /////////////////////////////
    //MARK -- Retrieving Images//
    /////////////////////////////
    
    func imageWithIdentifier(identifier: String?) -> UIImage? {
        // If the identifier is nil, or empty, return nil
        if identifier == nil || identifier! == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        
        // Next Try the hard drive
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    //////////////////////////
    //MARK -- Saving images //
    //////////////////////////
    
    func storeImage(image: UIImage?, withIdentifier identifier: String){
        let path = pathForIdentifier(identifier)
        
        if image == nil {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch _ {}
            
            return
        }
        
        // And in documents directory
        let data = UIImagePNGRepresentation(image!)!
        data.writeToFile(path, atomically: true)
  
    }
    

    //helper method 
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }
}