//
//  SetPaceViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/19/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SetPaceViewController: UIViewController, UITextFieldDelegate {

    
    /////////////////////////////
    //MARK --- Variables and UI//
    /////////////////////////////
    
    @IBOutlet weak var minutesTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var secondsTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    ///////////////////////
    ///   MARK -- VIEW  ///
    ///////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minutesTextField.delegate = self
        secondsTextField.delegate = self
        submitButton.enabled = false
        setButtonAppearance(submitButton)
        submitButton.layer.opacity = 0.2
        
        applySkyscannerTheme(minutesTextField)
        applySkyscannerTheme(secondsTextField)
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Gill Sans", size: 20)!]
        
    }
   
    func applySkyscannerTheme(textField: SkyFloatingLabelTextField) {
        
        // Set custom fonts for the title, placeholder and textfield labels
        textField.titleLabel.font = UIFont(name: "Gill Sans", size: 12)
        textField.placeholderFont = UIFont(name: "Gill Sans", size: 22)
        textField.font = UIFont(name: "Gill Sans", size: 22)
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
    
    ////////////////////////////////
    ///   MARK -- Submit Button  ///
    ////////////////////////////////
    
    @IBAction func submitPressed(sender: AnyObject) {
        
        let time = 60*(Int(minutesTextField.text!)!) + Int(secondsTextField.text!)!
        
        let distance = 1
        let mileTimeField = time
        let pace = time
        
        var info = [String : AnyObject]()
        info[RunSettingsStruct.mileTime] = mileTimeField
        info[RunSettingsStruct.goalDistance] = distance
        info[RunSettingsStruct.paceGoal] = pace
        
        print(distance, mileTimeField, pace)
        
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
    

    //////////////////////////////
    ///   MARK -- Alert Error  ///
    //////////////////////////////
    
    func alertError(error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:  {(action: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }

    
    

    //////////////////////////////////////
    //Mark -- Text Field Delegate Stuff///
    //////////////////////////////////////
    
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
