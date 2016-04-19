//
//  NewRunViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/12/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NewRunViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var goalPaceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var runActionButton: UIButton!
    
    var seconds = 0
    var mins = 0
    var distance = 0.0
    var isPaused = true
    var myGoalPace: String!
    
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 1.0
        return _locationManager
    }()
    
    var annotations = [MKPointAnnotation]()
    var locations = [CLLocation]()
    lazy var timer = NSTimer()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        runActionButton.hidden = false
        locationManager.requestAlwaysAuthorization()
        getPace()
        distanceLabel.hidden = true
        paceLabel.hidden = true
        goalPaceLabel.hidden = true
        timeLabel.hidden = true
        
    }
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .Plain, target: self, action: #selector(NewRunViewController.toHome))
        
        runActionButton.setTitle("Start Running", forState: .Normal)
        map.delegate = self
        map.userTrackingMode = .Follow
        initAppearance()
        
    }
    

    
    func getPace(){
        let runSets = RunnerSettingsInfo.sharedInstance().runSettings.first
        if((runSets?.paceGoal) != nil){
            let minPaceGoal = Int(Int((runSets?.paceGoal)!) / 60)
            let secPaceGoal = Int((Int((runSets?.paceGoal)!) % 60) * 6/10)
            
            let myPaceMins = String(format: "%02d", minPaceGoal)
            let myPaceSecs = String (format: "%02d", secPaceGoal)
            
            myGoalPace = myPaceMins + ":" + myPaceSecs + "/mile"
            
            
        }
        else{
            myGoalPace = "N/A"
        }
    }
    
    
    //timer helper function
    func eachSecond() {
        if seconds == 59 {
            seconds = 0
            mins += 1
        }
        else{
            seconds += 1
        }
        
        timeLabel.text = String(format: "%02d", mins) + ":" + String(format: "%02d", seconds)
        distanceLabel.text = String(format: "%.3f", distance)
        
        let totalTime = Double(mins*60 + seconds)

        if (totalTime > 60 &&  seconds%20 == 0){
            //STRIDE COACH
        }
        
        
        // PACE INFORMATION
        let myPace = (totalTime / distance)

        var PaceSecs = (myPace % 60)  * (6/10)
        
        let myPaceMins = String(format: "%.0f", myPace/60)
        var myPaceSecs = String (format: "%.0f", PaceSecs)
        if (PaceSecs < 10){
            myPaceSecs = "0" + myPaceSecs
        }
    
        
        paceLabel.text = myPaceMins + ":" + myPaceSecs + "/mile"
        
    }
    
    // Lazily instantiate locationManager
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    
    //TO DO CHANGE THIS TO BE PAUSE
    //stop location updates
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    
    //Invalidate timer
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    

    
    //Nav bar function to dismiss view controller
    func toHome(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //sets background to gradient
    func initAppearance() {
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
    }
    
    
    
    //end run
    func endRun(){
        //stop timer
        timer.invalidate()
        //get rid of running action button
        runActionButton.hidden = true
        //stop updating locations
        stopLocationUpdates()
        //edit map to show all points
        fixMap()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.saveRun()
        }
        
    }
    
    
    
    
    func generateMapImage() -> UIImage {
        // get size of image view
        UIGraphicsBeginImageContextWithOptions(self.map.frame.size, false, 0)
        // get snapshot of image view and nothing else
        view.drawViewHierarchyInRect(CGRectMake(-self.map.frame.origin.x,-self.map.frame.origin.y,view.bounds.size.width,view.bounds.size.height), afterScreenUpdates: true)
        let mapImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return mapImage
    }
    
    
    //Fits map to size of path run
    func fixMap(){
        //add all locations to map in form of annotations
        for location in locations{
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            self.annotations.append(annotation)
        }
        self.map.addAnnotations(self.annotations)
        
        var topLeftCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 90, longitude: -180)
 
        //find annotations that are furthest apart
        for annotation in self.map.annotations {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
        }
        
        //find center
        let centerLocation = CLLocationCoordinate2D(latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5, longitude: topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5)
        
        //find span given center
        let span = MKCoordinateSpan(latitudeDelta: fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1, longitudeDelta: fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1)
        
        //set region
        var region: MKCoordinateRegion = MKCoordinateRegionMake(centerLocation, span)

        //change map region
        region = map.regionThatFits(region)
        map.setRegion(region, animated: true)
        
        ///REMOVE ALL ANNOTATIONS
        self.map.removeAnnotations(annotations)
       
    }
    
    
    //save map run
    func saveRun() {
        
        //generate map image
        let mapImage = generateMapImage()
     
        var thisRun = [String : AnyObject]()
        thisRun[RunningCategories.distance] = distanceLabel.text!
        thisRun[RunningCategories.duration] = timeLabel.text!
        thisRun[RunningCategories.goalPace] = "7:00"//Change to goal pace
        thisRun[RunningCategories.pace] = paceLabel.text!
        thisRun[RunningCategories.timestamp] = NSDate()
        thisRun[RunningCategories.map] = mapImage
    
        
        myRuns.sharedInstance().runsArray.append(Run(dictionary: thisRun))
        
        
    }
    
    
    //Running button Pressed
    @IBAction func runActionPressed(sender: AnyObject) {
        //if resume run or start running
        if(runActionButton.currentTitle == "Start Running" || runActionButton.currentTitle == "Resume Run"){
            locations.removeAll(keepCapacity: false)
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(eachSecond), userInfo: nil, repeats: true)
            isPaused = false
            startLocationUpdates()
            
            distanceLabel.hidden = false
            paceLabel.hidden = false
            goalPaceLabel.hidden = false
            timeLabel.hidden = false
            goalPaceLabel.text = myGoalPace
            
            
            runActionButton.setTitle("Pause Run", forState: .Normal)
            navBar.rightBarButtonItem = UIBarButtonItem(title: "End Run", style: .Plain, target: self, action: #selector(NewRunViewController.endRun))
        }
        //if 'pause run'
        else{
            timer.invalidate()
            isPaused = true
            runActionButton.setTitle("Resume Run", forState: .Normal)
            stopLocationUpdates()
        }
    }
    
    
    //draw route on map
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        if !overlay.isKindOfClass(MKPolyline) {
            return nil
        }
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3
        return renderer
    }

    
    
    //location manager
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let howRecent = location.timestamp.timeIntervalSinceNow
            
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += 0.00062137*location.distanceFromLocation(self.locations.last!)
                    
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    
                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                    map.setRegion(region, animated: true)
                    
                    map.addOverlay(MKPolyline(coordinates: &coords, count: coords.count))
                }
                
                //save location
                self.locations.append(location)
            }
        }
    }

    

}
