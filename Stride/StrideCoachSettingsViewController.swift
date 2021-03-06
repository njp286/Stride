//
//  StrideCoachSettingsViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/20/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import Font_Awesome_Swift


class StrideCoachSettingsViewController: UIViewController {
    

    
    ///////////////////////
    // MARK -- UI & vars //
    ///////////////////////
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var strideCoachSwitch: UISwitch!
    @IBOutlet weak var coach1Button: UIButton!
    
    @IBOutlet weak var intensitySlider: UISlider!
    
    @IBOutlet weak var coach2Button: UIButton!
    
    var numbers = [1, 2, 3, 4]  //Add your values here
    var oldIndex = 0
    
    var coachGender = "Man"
    var coachNumber = "3"
    
    var sliderImages = ["Hard-Ass", "Difficult", "Forgiving", "Sweet"]
    
    //////////////////////////////
    /// MARK -- Initial View /////
    //////////////////////////////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .Center
        let image = UIImage(named: "StrideHeader")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
        coach1Button.contentMode = .ScaleAspectFit
        coach2Button.contentMode = .ScaleAspectFit
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAChevronLeft, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(StrideCoachSettingsViewController.backPressed))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
        
        
        coachSetUP()
        
        
    }
    
    
   
    
    
    func coachSetUP(){
        intensitySlider.continuous = true
        let numberOfSteps = Float(numbers.count - 1)
        intensitySlider.maximumValue = numberOfSteps;
        intensitySlider.minimumValue = 0;
        intensitySlider.addTarget(self, action: Selector(self.intensityChanged(self)), forControlEvents: .ValueChanged)

    
        if StrideCoachSettingsClass.sharedInstance().scSettings.isEmpty {
            strideCoachSwitch.setOn(true, animated: false)
            coach1Button.setImage(UIImage(named: "colorMan3"), forState: .Normal)
            coach2Button.setImage(UIImage(named: "grayWoman3"), forState: .Normal)
            coachGender = "Man"
            coachNumber = "3"
            intensitySlider.setValue(2.0, animated: false)
            intensitySlider.setThumbImage(UIImage(named: sliderImages[2]), forState: .Normal)
            
        }
        else{
            strideCoachSwitch.setOn((StrideCoachSettingsClass.sharedInstance().scSettings.first?.isOn)!, animated: true)
            
            let coachNamer = (StrideCoachSettingsClass.sharedInstance().scSettings.first?.coach)!
            let num = coachNamer.characters.last!
            var woman: String!
            var man: String!
            if ((coachNamer.containsString("Woman")) == true){
                woman = "colorWoman"
                man = "grayMan"
                coachGender = "Woman"
            }
            else{
                coachGender = "Man"
                woman = "grayWoman"
                man = "colorMan"
            }
            woman.append(num)
            man.append(num)
            
            coach1Button.setImage(UIImage(named: man), forState: .Normal)
            coach2Button.setImage(UIImage(named: woman), forState: .Normal)
            
            
            var value = ""
            value.append(num)
            coachNumber = value
            let flValue = Float(value)! - 1
            let intVal = Int(value)
            intensitySlider.setThumbImage(UIImage(named: sliderImages[intVal! - 1]), forState: .Normal)
   
            intensitySlider.value = flValue
        }

    }
    
    func backPressed(){
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    ////////////////////////
    /// MARK -- save ///////
    ////////////////////////
    
    func saveChanges(){
        
        let myCoach = "color" + coachGender + coachNumber
        
        var coachSettings = [String : AnyObject]()
        coachSettings[SCSettingsStruct.isOn] = strideCoachSwitch.on
        coachSettings[SCSettingsStruct.coach] =  myCoach
                
        let updatedSettings = StrideCoachSettings(dictionary: coachSettings)
        
        StrideCoachSettings.updateStrideCoachSettings(updatedSettings)
        
        dismissViewControllerAnimated(true, completion: nil)

        
    }
    
    //////////////////////////////
    /// MARK-- Settings Changed //
    //////////////////////////////
    
    //coach turned on/off
    @IBAction func scSwitched(sender: AnyObject) {
        navBar.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(StrideCoachSettingsViewController.saveChanges))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
    }
   

    
    //male coach pressed
    @IBAction func coach1ButtonPressed(sender: AnyObject) {
            coachGender = "Man"
            
            let woman = "grayWoman" + coachNumber
            let man = "colorMan" + coachNumber
            
            coach1Button.setImage(UIImage(named: man), forState: .Normal)
            coach2Button.setImage(UIImage(named: woman), forState: .Normal)
        
            navBar.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(StrideCoachSettingsViewController.saveChanges))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
        
    }
    
    //female coach pressed
    @IBAction func coach2ButtonPressed(sender: AnyObject) {
            coachGender = "Woman"
            
            let woman = "colorWoman" + coachNumber
            let man = "grayMan" + coachNumber
        
            coach1Button.setImage(UIImage(named: man), forState: .Normal)
            coach2Button.setImage(UIImage(named: woman), forState: .Normal)
        
            navBar.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(StrideCoachSettingsViewController.saveChanges))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
        
    }
    
    //intensity slider changed
    @IBAction func intensityChanged(sender: AnyObject) {
        let index = (Int)(intensitySlider.value + 0.5);
        intensitySlider.setValue(Float(index), animated: false)
        let number = numbers[index];
        if oldIndex != index {
            oldIndex = index
        }
        coachNumber = String(number)
        
        intensitySlider.setThumbImage(UIImage(named: sliderImages[number - 1]), forState: .Normal)
        if coachGender == "Man" {
            coach1ButtonPressed(sender)
            
        }
        else{
            coach2ButtonPressed(sender)
        }
        
    }
    
}
