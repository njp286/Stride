//
//  HomeViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/12/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startRunButton: UIButton!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var pastRunsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonAppearance(startRunButton)
        setButtonAppearance(settingsButton)
        setButtonAppearance(pastRunsButton)
        setButtonAppearance(statisticsButton)
        setButtonAppearance(infoButton)
        
        
        initAppearance()
        
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
    
    func initAppearance() -> Void {
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
    
    
}
