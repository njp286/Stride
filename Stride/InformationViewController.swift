//
//  InformationViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/20/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import MessageUI
import Font_Awesome_Swift

class InformationViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 38, height: 38))
        imageView.contentMode = .Center
        let logo = UIImage(named: "StrideHeader")
        imageView.image = logo
        self.navBar.titleView = imageView
        

        
        navBar.leftBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAHome, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(InformationViewController.toHome))
        navBar.leftBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
        
    
        
        
        navBar.rightBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAEnvelopeO, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(InformationViewController.composeEmail))
        navBar.rightBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
        
        
    }
    
    
    
    //Nav bar function to dismiss view controller
    func toHome(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func composeEmail(){
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject("Stride Comment")
        picker.setToRecipients(["stride-appsolutely@gmail.com"])
        
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("saved")
        case MFMailComposeResultSent.rawValue:
            print("Sent")
        case MFMailComposeResultFailed.rawValue:
            print("Failed")
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
