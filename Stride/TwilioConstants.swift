//
//  TwilioConstants.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/28/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import Foundation

struct TwilioConstants {
    static let TwilioAPIKey = "KjkJIYUx89JUW8xR3etVt5SoePwQ4i9s"
    static let TwilioSendVerLink = "https://api.authy.com/protected/json/phones/verification/start?api_key="
    
}

struct TwilioSendParameters {
    static let via = "via"
    static let countryCode = "country_code"
    static let phoneNumber = "phone_number"
    static let locale = "locale"
    static let customMessage = "custom_message"
  
}