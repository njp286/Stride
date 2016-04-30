//
//  TwilioVerifyCode.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/28/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Font_Awesome_Swift

class TwilioVerifyCode: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var codeLabel: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var verificationCode: String!
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAppearance(verifyButton)
        applySkyscannerTheme(codeLabel)
        verifyButton.layer.opacity = 0.2
        verifyButton.enabled = false
        backButton.setImage(UIImage(icon: FAType.FAChevronLeft, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), forState: .Normal)
        
        

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        verifyButton.layer.opacity = 0.2
        verifyButton.enabled = false
        
    }
    
    func applySkyscannerTheme(textField: SkyFloatingLabelTextField) {
        
        // Set custom fonts for the title, placeholder and textfield labels
        textField.titleLabel.font = UIFont(name: "Gill Sans", size: 12)
        textField.placeholderFont = UIFont(name: "Gill Sans", size: 22)
        textField.font = UIFont(name: "Gill Sans", size: 22)
    }
    
    @IBAction func verifyPressed(sender: AnyObject) {
        codeLabel.enabled = false
        verifyButton.layer.opacity = 0.2
        verifyButton.enabled = false
        TwilioClient.sharedInstance().checkCode(phoneNumber, verificationCode: verificationCode) { success, msg in
            if success == true {
                User.sharedInstance().verified = true
                NSUserDefaults.standardUserDefaults().setBool(User.sharedInstance().verified, forKey: User.myUser.verified)
                
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
            print(success)
            print(msg)
        }
        
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
    
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
        textFieldDidEndEditing(codeLabel)
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
        if codeLabel.text?.characters.count > 2 {
            verificationCode = codeLabel.text
            
            verifyButton.enabled = true
            verifyButton.layer.opacity = 1.0
        }
    }

    
    
  


}
