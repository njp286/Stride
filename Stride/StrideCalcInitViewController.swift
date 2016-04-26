//
//  StrideCalcInitViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/19/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class StrideCalcInitViewController: UIViewController {

    ///////////////////////
    // MARK -- UI & vars //
    ///////////////////////
    
    @IBOutlet weak var strideCalculatorButton: UIButton!
    
    @IBOutlet weak var setOwnPaceButton: UIButton!
    
    
    //////////////////////////////
    /// MARK --         View /////
    //////////////////////////////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAppearance(strideCalculatorButton)
        setButtonAppearance(setOwnPaceButton)
        

        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .Center
        let image = UIImage(named: "StrideHeader")
        imageView.image = image
        navigationItem.titleView = imageView
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAChevronLeft, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(StrideCalcInitViewController.backPressed))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
   
        
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
    
    func backPressed(){
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    

    
}
