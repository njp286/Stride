//
//  StrideCalculatorViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/12/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Font_Awesome_Swift


class StrideCalculatorViewController: UIViewController, UITextFieldDelegate {

    
    /////////////////////////////
    //MARK --- Variables and UI//
    /////////////////////////////
    
    @IBOutlet var distanceTextField: SkyFloatingLabelTextField!
    @IBOutlet var mileTimeSeconds: SkyFloatingLabelTextField!
    @IBOutlet var mileTime: SkyFloatingLabelTextField!
    @IBOutlet weak var submitButtton: UIButton!
    
    
    ///////////////////////
    ///   MARK -- VIEW  ///
    ///////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mileTime.delegate = self
        distanceTextField.delegate = self
        submitButtton.enabled = false
        setButtonAppearance(submitButtton)
        submitButtton.layer.opacity = 0.2
        
        applySkyscannerTheme(distanceTextField)
        applySkyscannerTheme(mileTimeSeconds)
        applySkyscannerTheme(mileTime)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .Center
        let image = UIImage(named: "StrideHeader")
        imageView.image = image
        navigationItem.titleView = imageView
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAChevronLeft, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(StrideCalculatorViewController.backPressed))
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

    func applySkyscannerTheme(textField: SkyFloatingLabelTextField) {
        
        // Set custom fonts for the title, placeholder and textfield labels
        textField.titleLabel.font = UIFont(name: "Gill Sans", size: 12)
        textField.placeholderFont = UIFont(name: "Gill Sans", size: 22)
        textField.font = UIFont(name: "Gill Sans", size: 22)
    }

    
    ////////////////////////////////
    ///   MARK -- Submit Button  ///
    ////////////////////////////////
    
    @IBAction func submitPressed(sender: AnyObject) {
        
        let distance = Float(distanceTextField.text!)!
        let mileTimeField = (Int(mileTime.text!)! * 60) + Int(mileTimeSeconds.text!)!
        let pace = calculatePace()
        
        print(pace, mileTimeField, distance)
        
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
    
    
    func backPressed(){
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    //calculate pace given information
    func calculatePace() -> Float {
        var distance = Float(distanceTextField.text!)
        if distance > 1 { distance = distance! - 1 }
        else{
            return (Float(mileTime.text!)!*60 + Float(mileTimeSeconds.text!)!)/distance!
        }
        print(distance)
        let additionalseconds = 6 * (distance!*(1609.34/200))
        print(additionalseconds)
        
        let pace = (additionalseconds + ((60*Float(mileTime.text!)! + Float(mileTimeSeconds.text!)!) * Float(distanceTextField.text!)!) / Float(distanceTextField.text!)!)
        
        return pace
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
        if textField == distanceTextField {
            if !(distanceTextField.text?.isEmpty)! && !(mileTime.text?.isEmpty)!{
                submitButtton.enabled = true
                submitButtton.layer.opacity = 1.0
            }
        }
    }
    

    
}
