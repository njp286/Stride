//
//  PastRunDetailViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/12/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class PastRunDetailViewController: UIViewController {

    
    ///////////////////////////
    //MARK -- variables & UI //
    ///////////////////////////

    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var goalPaceLabel: UILabel!

    
    var run: Run!
    
    
    ///////////////////////
    //    MARK -- view   //
    ///////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAChevronLeft, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(PastRunDetailViewController.backPressed))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)


    }
    

    
    func setView() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        
        self.navigationItem.title =  "Run: " +  formatter.stringFromDate(run.timestamp)
        distanceLabel.text = run.distance
        timeLabel.text = run.duration
        paceLabel.text = run.pace
        goalPaceLabel.text = run.goalPace
        
        let identifier = String(run.timestamp).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let imageFile = fileInDocumentsDirectory("\(identifier).png")
        let image = UIImage(contentsOfFile: imageFile)
        
        
        mapImage.image = image
        

    }


    
    func backPressed(){
        navigationController?.popViewControllerAnimated(true)

    }
    

    

    
    
}
