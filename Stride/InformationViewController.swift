//
//  InformationViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/20/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import MessageUI

class InformationViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Gill Sans", size: 20)!]
        
        navBar.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .Plain, target: self, action: #selector(InformationViewController.toHome))
        
        navBar.rightBarButtonItem = UIBarButtonItem(title: "Contact Me!", style: .Plain, target: self, action: #selector(InformationViewController.composeEmail))
        
        
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
