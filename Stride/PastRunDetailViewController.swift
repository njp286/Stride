//
//  PastRunDetailViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/12/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit

class PastRunDetailViewController: UIViewController {

    
    ///////////////////////////
    //MARK -- variables & UI //
    ///////////////////////////
    
    @IBOutlet weak var dateLabel: UILabel!
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
        initAppearance()
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(PastRunDetailViewController.sharePressed))
        
        self.navigationItem.rightBarButtonItem = shareButton
        
    }
    
    func initAppearance(){
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
    
    func setView() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        
        dateLabel.text = formatter.stringFromDate(run.timestamp)
        mapImage.image = run.map
        distanceLabel.text = run.distance
        timeLabel.text = run.duration
        paceLabel.text = run.pace
        goalPaceLabel.text = run.goalPace
        
        
    }
    
    
    
    //////////////////////
    // MARK -- share /////
    //////////////////////
    
    //generate image
    func generateImage() -> UIImage {
        // get size of image view
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0)
        // get snapshot of image view and nothing else
        view.drawViewHierarchyInRect(CGRectMake(-self.view.frame.origin.x,-self.view.frame.origin.y,view.bounds.size.width,view.bounds.size.height), afterScreenUpdates: true)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

    
    
    func sharePressed() {
        let imageToShare = generateImage()
        let vc = UIActivityViewController(activityItems: [imageToShare], applicationActivities: [])
        vc.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
}
