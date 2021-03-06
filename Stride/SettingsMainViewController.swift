//
//  SettingsMainViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/19/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import Whisper

class SettingsMainViewController: UIViewController {

    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var strideCalculatorButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonAppearance(strideCalculatorButton)
        setButtonAppearance(updateButton)
        setButtonAppearance(resetButton)
    
        
        navBar.leftBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAHome, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(SettingsMainViewController.toHome))
        navBar.leftBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .Center
        let logo = UIImage(named: "StrideHeader")
        imageView.image = logo
        self.navBar.titleView = imageView
        
    }
    
    //Nav bar function to dismiss view controller
    func toHome(){
        self.dismissViewControllerAnimated(true, completion: nil)
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

    @IBAction func resetButtonPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Reset Stride Settings", message: "Are you sure you want to reset all settings?", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Yes. Reset the settings.", style: .Destructive, handler: { action in
                RunnerSettingsInfo.sharedInstance().runSettings.removeAll()
                StrideCoachSettingsClass.sharedInstance().scSettings.removeAll()
                let message = Message(title: "Reset all settings", textColor: UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha:  1.0), backgroundColor: UIColor(red: 5/255.0, green: 46/255.0, blue: 56/255.0, alpha: 1.0), images: nil)
                Whisper(message, to: self.navigationController!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil ))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}
