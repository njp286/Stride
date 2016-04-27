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

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAShare, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(PastRunDetailViewController.share))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
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
        mapImage.image = ImagePersistance.sharedInstance().imageWithIdentifier(String(run.timestamp))
        

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


    func share(){
        let imageToShare = generateImage()
        let vc = UIActivityViewController(activityItems: [imageToShare], applicationActivities: [])
        vc.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(vc, animated: true, completion: nil)

    }
    
    func backPressed(){
        navigationController?.popViewControllerAnimated(true)

    }
    

    

    
    
}
