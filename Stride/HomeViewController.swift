//
//  HomeViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/12/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import CircleMenu
import Font_Awesome_Swift



class HomeViewController: UIViewController, CircleMenuDelegate {

    
    let items: [(icon: FAType, color: UIColor, board: String)] = [
        (FAType.FARoad, UIColor(red: 234/255.0, green: 116/255.0, blue: 116/255.0, alpha:  1.0), "currentRuns"),
        (FAType.FAHistory, UIColor(red: 234/255.0, green: 221/255.0, blue: 116/255.0, alpha:  1.0), "pastRuns"),
        (FAType.FALineChart, UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha:  1.0), "stats"),
        (FAType.FAGear, UIColor(red: 185/255.0, green: 137/255.0, blue: 201/255.0, alpha:  1.0), "settings"),
        (FAType.FAInfo, UIColor(red: 78/255.0, green: 157/255.0, blue: 129/255.0, alpha: 1.0), "info"),
        ]

    
    @IBOutlet var myView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button = CircleMenu(
            frame: CGRect(x: (myView.frame.width/2) - 25, y: ((2 * myView.frame.height)/3) - 25, width: 50, height: 50),
            normalIcon: "",
            selectedIcon:"",
            buttonsCount: 5,
            duration: 0.5,
            distance: 120)
        button.setFAIcon(FAType.FANavicon, forState: .Normal)
        button.setFAIcon(FAType.FATimes, forState: .Selected)
        button.backgroundColor = UIColor(red: 5/255.0, green: 46/255.0, blue: 56/255.0, alpha:  1.0)
        button.delegate = self
        button.layer.cornerRadius = button.frame.size.width / 2.0
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOffset = CGSizeMake(1.5, 1.5);
        button.layer.shadowOpacity = 0.35;
        button.layer.shadowRadius = 0.0;
        view.addSubview(button)
        
        
    }
    
        
    
    
    

    
    ////////////////////////////
    ///MARK -- CIRCLE menu//////
    ////////////////////////////
    
    
    func circleMenu(circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(icon: items[atIndex].icon, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), forState: .Normal)
        
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOffset = CGSizeMake(1.5, 1.5);
        button.layer.shadowOpacity = 0.35;
        button.layer.shadowRadius = 0.0;
        button.layer.masksToBounds = false

        
        // set highlited image
        let highlightedImage  = UIImage(icon: items[atIndex].icon, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()).imageWithRenderingMode(.AlwaysTemplate)
        button.setImage(highlightedImage, forState: .Highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonWillSelected button: CircleMenuButton, atIndex: Int) {
        print("selected")
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier(self.items[atIndex].board, sender: self)
        }
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        print("sent")
        performSegueWithIdentifier(items[atIndex].board, sender: self)
    }
    
    
}
