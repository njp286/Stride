//
//  TwilioSendMessage.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/28/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class TwilioSendMessage: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var sendVerificationButton: UIButton!

    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAppearance(sendVerificationButton)
        applySkyscannerTheme(phoneTextField)
        sendVerificationButton.layer.opacity = 0.2
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        sendVerificationButton.layer.opacity = 0.2
        sendVerificationButton.enabled = false

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



    @IBAction func buttonPressed(sender: AnyObject) {
        phoneTextField.enabled = false
        sendVerificationButton.enabled = false
        sendVerificationButton.layer.opacity = 0.2

        TwilioClient.sharedInstance().sendVerification(phoneNumber, completionHandler: { success, msg in
            
            if (success == true){
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("TwilioVerifyCode") as! TwilioVerifyCode
                vc.phoneNumber = self.phoneNumber
                self.presentViewController(vc, animated: true, completion: nil)
                
            }
    
        })
    }
    
    
    
  
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
        textFieldDidEndEditing(phoneTextField)
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
        if phoneTextField.text?.characters.count == 10 {
            var charArray : Array<Character> = Array(phoneTextField.text!.characters)
            charArray.insert("-", atIndex: 3)
            charArray.insert("-", atIndex: 7)
            let updatedNumber = charArray.map({"\($0)"}).joinWithSeparator("")
            print(updatedNumber)
            phoneNumber = updatedNumber
            phoneTextField.text = updatedNumber
            
            sendVerificationButton.enabled = true
            sendVerificationButton.layer.opacity = 1.0
        }
    }
    
    

    
}
