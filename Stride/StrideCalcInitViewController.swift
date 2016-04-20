//
//  StrideCalcInitViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/19/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit

class StrideCalcInitViewController: UIViewController {

    @IBOutlet weak var strideCalculatorButton: UIButton!
    
    @IBOutlet weak var setOwnPaceButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAppearance(strideCalculatorButton)
        setButtonAppearance(setOwnPaceButton)
   
        initAppearance()
        
    }
    
    func initAppearance() -> Void {
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
    
    func setButtonAppearance(button: UIButton){
        button.hidden = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOffset = CGSizeMake(1.5, 1.5);
        button.layer.shadowOpacity = 0.35;
        button.layer.shadowRadius = 0.0;
        button.layer.masksToBounds = false
        
    }
    

    
}
