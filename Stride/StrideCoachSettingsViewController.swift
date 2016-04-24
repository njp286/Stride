//
//  StrideCoachSettingsViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/20/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import LTMorphingLabel


class StrideCoachSettingsViewController: UIViewController, LTMorphingLabelDelegate {
    

    
    ///////////////////////
    // MARK -- UI & vars //
    ///////////////////////
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var strideCoachSwitch: UISwitch!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var coach1Button: UIButton!
    
    @IBOutlet weak var intensitySlider: UISlider!
    
    @IBOutlet var coachName: LTMorphingLabel!
    @IBOutlet weak var coach2Button: UIButton!
    
    var numbers = [1, 2, 3, 4]  //Add your values here
    var oldIndex = 0
    
    var coachGender = "Man"
    var coachNumber = "3"
    
    
    //////////////////////////////
    /// MARK -- Initial View /////
    //////////////////////////////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coachName.delegate = self
        coachName.textAlignment = .Center
       // self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Gill Sans", size: 20)!]
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "STRIDEpng")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
        coachSetUP()
        
        initAppearance()
        
    }
    
    
    func initAppearance() -> Void {
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
    
    
    func coachSetUP(){
        volumeSlider.continuous = true
        volumeSlider.maximumValue = 1.0
        volumeSlider.minimumValue = 0.0

        
        intensitySlider.continuous = true
        let numberOfSteps = Float(numbers.count - 1)
        intensitySlider.maximumValue = numberOfSteps;
        intensitySlider.minimumValue = 0;
        intensitySlider.addTarget(self, action: Selector(self.intensityChanged(self)), forControlEvents: .ValueChanged)

    
        if StrideCoachSettingsClass.sharedInstance().scSettings.isEmpty {
            volumeSlider.setValue(0.7, animated: false)
            strideCoachSwitch.setOn(true, animated: false)
            coach1Button.setImage(UIImage(named: "colorMan3"), forState: .Normal)
            coach2Button.setImage(UIImage(named: "grayWoman3"), forState: .Normal)
            coachGender = "Man"
            coachNumber = "3"
            intensitySlider.setValue(2.0, animated: false)
            
        }
        else{
            volumeSlider.setValue((StrideCoachSettingsClass.sharedInstance().scSettings.first?.volume)!, animated: true)
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

   
            intensitySlider.value = flValue
        }
        if coachGender == "Man" {
            if let effect = LTMorphingEffect(rawValue: 5) {
                coachName.morphingEffect = effect
                coachName.text = "Bryan"
            }
            
        }
        else{
            if let effect = LTMorphingEffect(rawValue: 6) {
                coachName.morphingEffect = effect
                coachName.text = "Whitney"
            }
        }
    }
    
    
    ////////////////////////
    /// MARK -- save ///////
    ////////////////////////
    
    func saveChanges(){
        
        let myCoach = "color" + coachGender + coachNumber
        
        var coachSettings = [String : AnyObject]()
        coachSettings[SCSettingsStruct.isOn] = strideCoachSwitch.on
        coachSettings[SCSettingsStruct.volume] = volumeSlider.value
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
    }
   
    //volume changed
    @IBAction func volumeChanged(sender: AnyObject) {
        navBar.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(StrideCoachSettingsViewController.saveChanges))
    }
    
    //male coach pressed
    @IBAction func coach1ButtonPressed(sender: AnyObject) {
            coachGender = "Man"
            
            let woman = "grayWoman" + coachNumber
            let man = "colorMan" + coachNumber
            
            coach1Button.setImage(UIImage(named: man), forState: .Normal)
            coach2Button.setImage(UIImage(named: woman), forState: .Normal)
        
            navBar.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(StrideCoachSettingsViewController.saveChanges))
            if let effect = LTMorphingEffect(rawValue: 5) {
                coachName.morphingEffect = effect
            }
            coachName.text = "Bryan"
        
    }
    
    //female coach pressed
    @IBAction func coach2ButtonPressed(sender: AnyObject) {
            coachGender = "Woman"
            
            let woman = "colorWoman" + coachNumber
            let man = "grayMan" + coachNumber
        
            coach1Button.setImage(UIImage(named: man), forState: .Normal)
            coach2Button.setImage(UIImage(named: woman), forState: .Normal)
        
            navBar.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(StrideCoachSettingsViewController.saveChanges))
            if let effect = LTMorphingEffect(rawValue: 6) {
                coachName.morphingEffect = effect
            }
            coachName.text = "Whitney"
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
        
        if coachGender == "Man" {
            coach1ButtonPressed(sender)
            
        }
        else{
            coach2ButtonPressed(sender)
        }
        
    }
    
    func morphingDidStart(label: LTMorphingLabel) {
        
    }
    
    func morphingDidComplete(label: LTMorphingLabel) {
        
    }
    
    func morphingOnProgress(label: LTMorphingLabel, progress: Float) {
        
    }

}
