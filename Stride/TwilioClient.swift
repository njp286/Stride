//
//  TwilioClient.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/28/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit

class TwilioClient: NSObject {
    
    /* Shared Session */
    var session: NSURLSession
    
    
    //MARK: Initializer
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    /////////////////////////////
    //MARK -- send Verification//
    /////////////////////////////
    
    func sendVerification(phoneNumber: String, completionHandler: (success: Bool, msg: String?) -> Void) {
        let verStringUrl = TwilioConstants.TwilioSendVerLink + TwilioConstants.TwilioAPIKey
        
        let request = NSMutableURLRequest(URL: NSURL(string: verStringUrl)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let text = "{\"" + TwilioSendParameters.via + "\":\"sms\",\"" + TwilioSendParameters.phoneNumber + "\":\"" + phoneNumber + "\", \"" + TwilioSendParameters.countryCode + "\": 1}"
        
        request.HTTPBody = text.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func displayError(error: String) {
                print(error)
                completionHandler(success: false, msg: error)
            }

            
            if error != nil {
                displayError(String(error))
            }
            
           
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 400 else {
                if ((response as? NSHTTPURLResponse)?.statusCode) == 401 {
                    displayError(" Verification Code is invalid")
                }
                else{
                    displayError("Service Unavailable")
                }
                return
            }

            
            
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            //Parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let message: String! = parsedResult["message"] as! String else {
                displayError("cannot get success response")
                return
            }
            
            guard let successResponse: Int! = parsedResult["success"] as! Int else {
                displayError("cannot get message")
                return
            }
            
            var isSuccess: Bool!
            if successResponse == 1 {
                isSuccess = true
            }
            else{
                isSuccess = false
            }
            
            
            completionHandler(success: isSuccess, msg: message)
        }
        task.resume()
    }
        
    ///////////////////////
    //MARK -- check code //
    ///////////////////////
    
    func checkCode(phoneNumber: String, verificationCode: String, completionHandler: (success: Bool, msg: String) -> Void){
        
        let requestString = "https://api.authy.com/protected/json/phones/verification/check?api_key=" + TwilioConstants.TwilioAPIKey + "&phone_number=" + phoneNumber + "&country_code=1&verification_code=" + verificationCode
        let request = NSMutableURLRequest(URL: NSURL(string: requestString)!)
        
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func displayError(error: String) {
                print(error)
                completionHandler(success: false, msg: error)
            }
            
            
            if error != nil {
                displayError(String(error))
            }
            
            
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 400 else {
                if ((response as? NSHTTPURLResponse)?.statusCode) == 401 {
                    displayError(" Verification Code is invalid")
                }
                else{
                    displayError("Service Unavailable")
                }
                return
            }
            
            
            
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            //Parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let message: String! = parsedResult["message"] as! String else {
                displayError("cannot get success response")
                return
            }
            
            guard let successResponse: Int! = parsedResult["success"] as! Int else {
                displayError("cannot get message")
                return
            }
            
            var isSuccess: Bool!
            if successResponse == 1 {
                isSuccess = true
            }
            else{
                isSuccess = false
            }
            
            
            completionHandler(success: isSuccess, msg: message)
        }
        task.resume()
    }

    
    class func sharedInstance() -> TwilioClient {
        
        struct Singleton {
            static var sharedInstance = TwilioClient()
        }
        
        return Singleton.sharedInstance
    }

}