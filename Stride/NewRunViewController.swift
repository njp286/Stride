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
import AVFoundation
import Font_Awesome_Swift
import Whisper


////////////////////////////////////
///MARK -- Global helper functions//
////////////////////////////////////


func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
    
}

/////////////////////////
//MARK-- start class/////
/////////////////////////


class NewRunViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, AVAudioPlayerDelegate {
    
    /////////////////////////////
    //MARK --- Variables and UI//
    /////////////////////////////
    
    @IBOutlet weak var distanceLabelLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var paceLabelLabel: UILabel!
    @IBOutlet weak var timeLabelLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var goalPaceLabelLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var goalPaceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var runActionButton: UIButton!
    
    var seconds = 0
    var mins = 0
    var distance = 0.0
    var myGoalPace: String!
    
    var paceGoalSeconds: Int!
    var currentPaceSeconds: Int!
    
    var isCoachNotSet: Bool!
    var isCoachOn: Bool!
    
    var coachIntensity: String!
    var coachGender: String!
    
    var annotations = [MKPointAnnotation]()
    var locations = [CLLocation]()
    lazy var timer = NSTimer()
    
    var audioPlayer = AVAudioPlayer()
    
    var savedMapImage = UIImage()
    
    ///////////////////////
    ///   MARK -- VIEW  ///
    ///////////////////////
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        runActionButton.hidden = false
        runActionButton.layer.cornerRadius = 10
        runActionButton.clipsToBounds = true
        runActionButton.layer.shadowColor = UIColor.blackColor().CGColor
        runActionButton.layer.shadowOffset = CGSizeMake(1.5, 1.5);
        runActionButton.layer.shadowOpacity = 0.35;
        runActionButton.layer.shadowRadius = 0.0;
        runActionButton.layer.masksToBounds = false
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .Center
        let logo = UIImage(named: "StrideHeader")
        imageView.image = logo
        self.navBar.titleView = imageView
    
        
        locationManager.requestAlwaysAuthorization()
        getPace()
        getCoachInfo()
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceLabel.hidden = true
        paceLabel.hidden = true
        goalPaceLabel.hidden = true
        timeLabel.hidden = true
        distanceLabelLabel.hidden = true
        paceLabelLabel.hidden = true
        timeLabelLabel.hidden = true
        goalPaceLabelLabel.hidden = true
        
        
        navBar.leftBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAHome, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(NewRunViewController.toHome))
        navBar.leftBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
        
        
        runActionButton.setTitle("Start Running", forState: .Normal)
        map.delegate = self
        map.userTrackingMode = .Follow
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: .DuckOthers)
        }
        catch {
            //error
        }


    }
    
 
    
    
    //Nav bar function to dismiss view controller
    func toHome(){
        timer.invalidate()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //fill in coach info
    func getCoachInfo(){
        isCoachNotSet = StrideCoachSettingsClass.sharedInstance().scSettings.first == nil
        isCoachOn = StrideCoachSettingsClass.sharedInstance().scSettings.first?.isOn == true
        
        if isCoachNotSet == true {
            coachIntensity = "3"
            coachGender = "Man"
        }
        
        if isCoachOn == true {
            let coach = StrideCoachSettingsClass.sharedInstance().scSettings.first!.coach
            let num = coach.characters.last!
            if ((coach.containsString("Woman")) == true){
                coachGender = "Woman"
            }
            else{
                coachGender = "Man"
            }
            
            var value = ""
            value.append(num)
            coachIntensity = value
            
        }

    }
    

    
    ///////////////////////////
    ///   MARK -- LOCATION   //
    ///////////////////////////
    
    // Lazily instantiate locationManager
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    
    //locationManager setup
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .Fitness
        manager.allowsBackgroundLocationUpdates = true
        // Movement threshold for new events
        manager.distanceFilter = 0.5
        return manager
    }()
        
    //stop location updates
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    
    //location manager
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let howRecent = location.timestamp.timeIntervalSinceNow
            
            if abs(howRecent) < 10 && location.horizontalAccuracy < 30 {
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
    

    /////////////////////////
    //MARK -- Run functions//
    /////////////////////////
    
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
        navBar.leftBarButtonItem?.enabled = false
        
        let message = Message(title: "Saving...", textColor: UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha:  1.0), backgroundColor: UIColor(red: 5/255.0, green: 46/255.0, blue: 56/255.0, alpha: 1.0), images: nil)
        Whisper(message, to: self.navigationController!)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.saveRun() { error in
                if error == nil {
                    self.navBar.leftBarButtonItem?.enabled = true
                    let message = Message(title: "Saved!", textColor: UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha:  1.0), backgroundColor: UIColor(red: 5/255.0, green: 46/255.0, blue: 56/255.0, alpha: 1.0), images: nil)
                    Whisper(message, to: self.navigationController!)
                    
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAShare, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(NewRunViewController.share))
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
                    
                }
            }
        }
    }
    
    
    //Helper function to endRun -- generates an image of Map
    func generateMapImage(completionHandler: (image: UIImage, error: String?) -> Void){
        // get size of image view
        UIGraphicsBeginImageContextWithOptions(self.map.frame.size, false, 0)
        // get snapshot of image view and nothing else
        view.drawViewHierarchyInRect(CGRectMake(-self.map.frame.origin.x,-self.map.frame.origin.y,view.bounds.size.width,view.bounds.size.height), afterScreenUpdates: true)
        let mapImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        completionHandler(image: mapImage, error: nil)
    }
    
    /////////////////////
    //MARK -- save run //
    /////////////////////
    
    func saveRun(completionHandler: (error:String?) -> Void) {
        generateMapImage(){ (image, error) in
            self.savedMapImage = image
            
            var thisRun = [String : AnyObject]()
            thisRun[Run.RunningCategories.distance] = self.distanceLabel.text!
            thisRun[Run.RunningCategories.duration] = self.timeLabel.text!
            thisRun[Run.RunningCategories.goalPace] = self.myGoalPace
            thisRun[Run.RunningCategories.pace] = self.paceLabel.text!
            thisRun[Run.RunningCategories.timestamp] = NSDate()
            
           
            
            var identifier: String = String(thisRun[Run.RunningCategories.timestamp]!)
            identifier = identifier.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!

            
            let pngImageData = UIImagePNGRepresentation(image)
            let fileName = fileInDocumentsDirectory("\(identifier).png")
            pngImageData!.writeToFile(fileName, atomically: true)
            
            
            User.sharedInstance().add(Run.init(dictionary: thisRun))
            NSKeyedArchiver.archiveRootObject(User.sharedInstance().runsArray, toFile: self.runsPath)
            completionHandler(error: nil)
        }
        
    }
    
    //runs path helper
    var runsPath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return url.URLByAppendingPathComponent("runArray").path!
    }
    
    //////////////////////////////////
    //MARK -- no goal pace set alert//
    //////////////////////////////////
    
    func noGoalPaceAlert( completionHandler: (toDo: String?) -> Void){
        //create alert for no goal pace
        let alert = UIAlertController(title: "Heads Up", message: "You dont have a goal pace set! To use Stride to its full potential you should set a goal pace  for yourself.", preferredStyle: .Alert)
        //set goal pace pressed in alert
        alert.addAction(UIAlertAction(title: "Use StrideCalculator", style: UIAlertActionStyle.Default) { (action: UIAlertAction!)  in
            //dismiss alert
            
            completionHandler(toDo: "calc")
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        //set goal pace pressed in alert
        alert.addAction(UIAlertAction(title: "Set pace manually", style: UIAlertActionStyle.Default) { (action: UIAlertAction!)  in
            //dismiss alert
            
            completionHandler(toDo: "pace")
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        //ignore alert and continue
        alert.addAction(UIAlertAction(title: "Continue without a goal pace", style: UIAlertActionStyle.Cancel, handler:  {(action: UIAlertAction!) in
            completionHandler(toDo: nil)
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        //present alarm alert
        presentViewController(alert, animated: true, completion: nil)

    }
    
    ///////////////////////
    //   MARK -- start  ///
    ///////////////////////
    
    func start(){
        
        distanceLabel.hidden = false
        paceLabel.hidden = false
        goalPaceLabel.hidden = false
        timeLabel.hidden = false
        
        distanceLabelLabel.hidden = false
        paceLabelLabel.hidden = false
        timeLabelLabel.hidden = false
        goalPaceLabelLabel.hidden = false
        
    
        locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(eachSecond), userInfo: nil, repeats: true)
        startLocationUpdates()
        
        runActionButton.setTitle("End Run", forState: .Normal)
        runActionButton.backgroundColor = UIColor(red: 234/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1.0)
        
    }
    
    //////////////////////////////
    //MARK -- run button pressed//
    //////////////////////////////
    
    @IBAction func runActionPressed(sender: AnyObject) {
        //if resume run or start running
        if(runActionButton.currentTitle == "Start Running"){
            if(myGoalPace == "N/A"){
                noGoalPaceAlert() { toDo in
                    if toDo == nil {
                        self.start()
                    }
                    else if toDo == "pace"{
                        
                        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("SetPaceViewController") as! SetPaceViewController
                        self.presentViewController(viewController, animated: true, completion:  nil)
                    }
                    else {
                        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("StrideCalculatorViewController") as! StrideCalculatorViewController
                        self.presentViewController(viewController, animated: true, completion:  nil)
                    }
                }
            }
            else{
                start()
            }
            
        }
        //if 'end run'
        else{
            endRun()
        }
    }
    
    
    //////////////////////////
    /// MARK -- set goalpace//
    //////////////////////////
    
    func getPace(){
        let runSets = RunnerSettingsInfo.sharedInstance().runSettings.first
        if((runSets?.paceGoal) != nil){
            paceGoalSeconds = Int((runSets?.paceGoal)!)
            
            let minPaceGoal = Int(Int((runSets?.paceGoal)!) / 60)
            let secPaceGoal = Int((Int((runSets?.paceGoal)!) % 60))
            
            let myPaceMins = String(format: "%02d", minPaceGoal)
            let myPaceSecs = String (format: "%02d", secPaceGoal)
            
            myGoalPace = myPaceMins + ":" + myPaceSecs + "/mile"
            
        }
        else{
            myGoalPace = "N/A"
        }
        goalPaceLabel.text = myGoalPace
    }
    
    
    ////////////////////////////////////
    ///MARK -- run active w/ coaching //
    ////////////////////////////////////
    
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
        
        
        // pace
        let myPace = (totalTime / distance)
  
        let PaceSecs = (myPace % 60)
        let myPaceMins = String(format: "%.0f", myPace/60)
        var myPaceSecs = String (format: "%.0f", PaceSecs)
        if (PaceSecs < 10.000){
            myPaceSecs = "0" + myPaceSecs
        }
        if (myPaceMins == "inf"){
            paceLabel.text = "--"
            currentPaceSeconds = 0
        }else{
            paceLabel.text = myPaceMins + ":" + myPaceSecs + "/mile"
            currentPaceSeconds = Int(myPace)
        }
        
       
        
        ////////COACHING SHIT
        if (seconds%20 == 0 && (isCoachNotSet || isCoachOn) &&  totalTime > 60  && currentPaceSeconds > 0 && myGoalPace != "N/A" ){
            let paceDiff = currentPaceSeconds - paceGoalSeconds
            
            let randomNum = Int(arc4random_uniform(3) + 1)
            let ranNumStr = String(randomNum)
            var adviceNum: String!
            
            //significant difference in pace
            if(abs(paceDiff) > 10){
                //running significantly faster than goal pace
                if paceDiff < 0 {
                    adviceNum = "1"
                }
                //running significantly slower than goal pace
                else {
                    adviceNum = "2"
                }
            }
            //not a significant difference in pace & goal pace
            else{
                adviceNum = "3"
            }
            
            let coachAdvice = coachIntensity + coachGender + adviceNum + ranNumStr
            let coachSpeech = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(coachAdvice, ofType: "mp3")!)
            
            do{
                //set audioSession to quiet
                try AVAudioSession.sharedInstance().setActive(true, withOptions: .NotifyOthersOnDeactivation)
                let speak = try AVAudioPlayer(contentsOfURL: coachSpeech)
                speak.delegate = self
                audioPlayer = speak
                speak.play()
            } catch {
                print("Couldn't play file or set active")
            }
            
        }
    }
    
    
    ///////////////////
    //MARK -- share ///
    ///////////////////
    func share(){
        var sharingItems = [AnyObject]()
        
        let imageToShare = savedMapImage
        sharingItems.append(imageToShare)
        let textToShare = "I just ran \(distanceLabel.text) with a pace of \(paceLabel.text) on the Stride app!"
        sharingItems.append(textToShare)
        
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeCopyToPasteboard,UIActivityTypeAirDrop,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToWeibo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
        

    }

    

    ////////////////////////////////
    //MARK-- map related functions//
    ////////////////////////////////
    
    //draw route on map
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3
        return renderer
    }

    //Fits map to size of path run
    func fixMap(){
        //add all locations to map in form of annotations
        for location in locations{
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotations.append(annotation)
        }
        map.addAnnotations(annotations)
        
        var topLeftCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        //find annotations that are furthest apart
        for annotation in map.annotations {
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
    
    
    
    //////////////////////////
    /// MARK -- audio player//
    //////////////////////////
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true{
            do{
                //set audioSession to quiet
                //try AVAudioSessionCategoryPlayback
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: .MixWithOthers)
            } catch {
                print("Couldn't set unactive")
            }
        }
    }
    



}
