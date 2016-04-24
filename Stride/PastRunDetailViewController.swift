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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var goalPaceLabel: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var run: Run!
    
    
    ///////////////////////
    //    MARK -- view   //
    ///////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
        exitButton.setImage(UIImage(icon: FAType.FAArrowCircleLeft, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor(red: 5/255.0, green: 45/255.0, blue:  56/255.0, alpha: 1.0) , backgroundColor: UIColor.clearColor()), forState: .Normal)
        exitButton.setImage(UIImage(icon: FAType.FATimes, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor(red: 5/255.0, green: 45/255.0, blue:  56/255.0, alpha: 1.0) , backgroundColor: UIColor.clearColor()), forState: .Selected)
        
    }
    

    
    func setView() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        
        dateLabel.text = formatter.stringFromDate(run.timestamp)
        distanceLabel.text = run.distance
        timeLabel.text = run.duration
        paceLabel.text = run.pace
        goalPaceLabel.text = run.goalPace
        
        
        //Border around map
        let size = run.map.size
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRectMake(0, 0, size.width, size.height)
        run.map.drawInRect(rect, blendMode: .Normal, alpha: 1.0)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0)
        CGContextStrokeRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        mapImage.image = newImage

    }
    
    
    
    //////////////////////
    // MARK -- share /////
    //////////////////////
    
    //generate image
    func generateImage() -> UIImage {
        exitButton.hidden = true
        shareButton.hidden = true
        // get size of image view
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0)
        // get snapshot of image view and nothing else
        view.drawViewHierarchyInRect(CGRectMake(-self.view.frame.origin.x,-self.view.frame.origin.y,view.bounds.size.width,view.bounds.size.height), afterScreenUpdates: true)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        exitButton.hidden = false
        shareButton.hidden = false
        
        return image
    }

    @IBAction func shareButtonPressed(sender: AnyObject) {
        let imageToShare = generateImage()
        let vc = UIActivityViewController(activityItems: [imageToShare], applicationActivities: [])
        vc.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func exitButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    
}
