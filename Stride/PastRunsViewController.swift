//
//  PastRunsViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/12/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import DZNEmptyDataSet


class PastRunsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        
        navBar.leftBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAHome, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(NewRunViewController.toHome))
        
        initAppearance()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Gill Sans", size: 20)!]
        tableView.reloadData()
    }
    
    func initAppearance() -> Void {
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    
    }
    
    //Nav bar function to dismiss view controller
    func toHome(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    //////////////////////
    //MARK -- TableView///
    //////////////////////
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myRuns.sharedInstance().count()
    }
    

    //add runs to cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("pastRunCell", forIndexPath: indexPath) as! PastRunsTableViewCell
        
        cell.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 0.3)

        
        let runObject = myRuns.sharedInstance().at(indexPath.row)
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        
        
        cell.mapImage.image = runObject.map
        cell.dateLabel.text = formatter.stringFromDate(runObject.timestamp)
        cell.distanceLabel.text = runObject.distance
        cell.paceLabel.text = runObject.pace
        cell.goalPaceLabel.text = runObject.goalPace
        cell.timeLabel.text = runObject.duration
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("PastRunDetailViewController") as! PastRunDetailViewController
        detailController.run = myRuns.sharedInstance().at(indexPath.row)
        self.presentViewController(detailController, animated: true, completion: nil) 
    }
    
    //allow deletion of runs
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    //delete run by swiping left
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            myRuns.sharedInstance().delete(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        } 
    }
    
    
}
