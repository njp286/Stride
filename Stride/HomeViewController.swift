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
        (FAType.FARoad, UIColor.redColor(), "currentRuns"),
        (FAType.FAHistory, UIColor.blueColor(), "pastRuns"),
        (FAType.FALineChart, UIColor.greenColor(), "statistics"),
        (FAType.FAGear, UIColor.blackColor(), "settings"),
        (FAType.FAInfo, UIColor.darkGrayColor(), "info"),
        ]

    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button = CircleMenu(
            frame: CGRect(x: (myView.frame.width/2) - 25, y: ((2 * myView.frame.height)/3) - 25, width: 50, height: 50),
            normalIcon:"icon_menu",
            selectedIcon:"icon_close",
            buttonsCount: 5,
            duration: 0.5,
            distance: 120)
        button.backgroundColor = UIColor.whiteColor()
        button.delegate = self
        button.layer.cornerRadius = button.frame.size.width / 2.0
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOffset = CGSizeMake(1.5, 1.5);
        button.layer.shadowOpacity = 0.35;
        button.layer.shadowRadius = 0.0;
        view.addSubview(button)
        
        initAppearance()
        
    }
    
        
    
    
    
    func initAppearance() -> Void {
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
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

    }
    
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        performSegueWithIdentifier(items[atIndex].board, sender: self)
    }
    
    
}
