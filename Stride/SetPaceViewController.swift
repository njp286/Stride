//
//  SetPaceViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/19/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit

class SetPaceViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minutesTextField.delegate = self
        secondsTextField.delegate = self
        submitButton.enabled = false
        setButtonAppearance(submitButton)
        submitButton.layer.opacity = 0.2
        initAppearance()
        
    }
    
  
    
    @IBAction func submitPressed(sender: AnyObject) {
        
        let time = 60*(Int(minutesTextField.text!)!) + Int(secondsTextField.text!)!
        
        let distance = 1
        let mileTimeField = time
        let pace = time
        
        var info = [String : AnyObject]()
        info[RunSettingsStruct.mileTime] = mileTimeField
        info[RunSettingsStruct.goalDistance] = distance
        info[RunSettingsStruct.paceGoal] = pace
        
        let runnerInfo = RunnerSettings.init(dictionary: info)
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            RunnerSettings.updateRunInfo(runnerInfo) { (error) in
                if (error != nil) {
                    self.alertError(error!)
                }
            }
        })
        
        dismissViewControllerAnimated(true, completion: nil)

        
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
    
    
    func alertError(error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:  {(action: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }

    
    
    func initAppearance() -> Void {
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }

    
    //Mark -- Text Field Delegate Stuff
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        if !(minutesTextField.text?.isEmpty)! && !(secondsTextField.text?.isEmpty)!{
                submitButton.enabled = true
                submitButton.layer.opacity = 1.0
        }
    }

    
}
