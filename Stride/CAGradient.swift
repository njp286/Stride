//
//  CAGradient.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/13/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func turquoiseColor() -> CAGradientLayer {
        let topColor = UIColor(red: (0/255.0), green: (255/255.0), blue: (0/255.0), alpha: 1)
        let bottomColor = UIColor(red: (0/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
        
        let gradientColors: Array <AnyObject> = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [NSNumber] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}