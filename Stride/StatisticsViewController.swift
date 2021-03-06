//
//  StatisticsViewController.swift
//  Stride
//
//  Created by Nathaniel PiSierra on 4/24/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import UIKit
import BEMSimpleLineGraph
import Font_Awesome_Swift

class StatisticsViewController: UIViewController, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource {

    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var simpleLineGraphPace: BEMSimpleLineGraphView!
    @IBOutlet weak var simpleLineGraphDistance: BEMSimpleLineGraphView!
    var dates = NSMutableArray()
    var paces = NSMutableArray()
    var distance = NSMutableArray()
    var touch = -1
    var graphNum = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 38, height: 38))
        imageView.contentMode = .Center
        let logo = UIImage(named: "StrideHeader")
        imageView.image = logo
        navigationItem.titleView = imageView
        
        
        simpleLineGraphDistance.dataSource = self
        simpleLineGraphDistance.delegate = self
        simpleLineGraphPace.dataSource = self
        simpleLineGraphPace.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(icon: FAType.FAHome, size: CGSize(width: 35.0, height: 35.0), textColor: UIColor.whiteColor() , backgroundColor: UIColor.clearColor()), style: .Plain, target: self, action: #selector(StatisticsViewController.toHome))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 97/255.0, green: 171/255.0, blue: 201/255.0, alpha: 1.0)
        

        updateArrays() { (count) in
            if self.dates.count > 2{

                self.setLineGraph(self.simpleLineGraphDistance)
                self.setLineGraph(self.simpleLineGraphPace)
            }
            else{
                self.simpleLineGraphDistance.removeFromSuperview()
                self.simpleLineGraphPace.removeFromSuperview()
                self.distanceLabel.removeFromSuperview()
                self.paceLabel.removeFromSuperview()
                
                
                // Tell them you must go on 3 runs to display graphs
                let imageName = "RunnerGray"
                let image = UIImage(named: imageName)
                let imageView = UIImageView(image: image!)
                
                let height = image?.size.height
                let width = image?.size.width
                
                let viewCenterX = self.view.frame.width/2
                let viewCenterY = self.view.frame.height/2
                
                imageView.frame = CGRect(x: 0, y: 0, width: width!, height: height!)
                imageView.center = CGPointMake(viewCenterX, 2*viewCenterY/3)
                self.view.addSubview(imageView)
                
                //Add Title
                
                let title = UILabel(frame: CGRectMake(0, 0, self.view.frame.width - 20, 40))
                title.center = CGPointMake(viewCenterX, viewCenterY + height!/4 )
                title.textAlignment = NSTextAlignment.Center
                title.textColor = UIColor(red: 160/255.0, green: 160/255.0, blue: 149/255.0, alpha: 1.0)
                title.font = UIFont(name: "Gill Sans", size: 30)
                title.text = "Not enough data."
                self.view.addSubview(title)

                
                //Add Label
                let label = UILabel(frame: CGRectMake(0, 0, self.view.frame.width - 50, 60))
                label.center = CGPointMake(viewCenterX, viewCenterY + height!/2 )
                label.textAlignment = NSTextAlignment.Center
                label.numberOfLines = 3
                label.textColor = UIColor(red: 160/255.0, green: 160/255.0, blue: 149/255.0, alpha: 1.0)
                label.font = UIFont(name: "Gill Sans", size: 18)
                label.lineBreakMode = .ByWordWrapping
                label.text = "You must go on 3 runs before you can display statistics."
                self.view.addSubview(label)
            }
        }
    }
    
    func setLineGraph(lineGraph: BEMSimpleLineGraphView){
        lineGraph.enableXAxisLabel = true
        lineGraph.enableYAxisLabel = true
        lineGraph.enablePopUpReport = true
        lineGraph.enableTouchReport = true
        lineGraph.enableBezierCurve = true
        lineGraph.averageLine.enableAverageLine = true
        lineGraph.formatStringForValues = "%.3f"
        lineGraph.enableReferenceAxisFrame = true
        lineGraph.colorBackgroundXaxis = UIColor(red: 5/255.0, green: 46/255.0, blue: 56/255.0, alpha: 1.0)
        lineGraph.colorBackgroundYaxis = UIColor(red: 5/255.0, green: 46/255.0, blue: 56/255.0, alpha: 1.0)
        lineGraph.colorTop = UIColor(red: 5/255.0, green: 46/255.0, blue: 56/255.0, alpha: 1.0)
        lineGraph.colorBottom = UIColor(red: 5/255.0, green: 46/255.0, blue: 56/255.0, alpha: 1.0)
        lineGraph.colorXaxisLabel = UIColor(red: 234/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1.0)
        lineGraph.colorYaxisLabel = UIColor(red: 234/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1.0)
        lineGraph.colorPoint = UIColor(red: 234/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1.0)
        

    }
    
    func updateArrays(completionHandler: (count: Int) -> Void){
        let count = User.sharedInstance().runsArray.count
        if count > 0 {
            for i in 0 ..< count {
                //get date
                let formatter = NSDateFormatter()
                formatter.dateStyle = .ShortStyle
                formatter.timeStyle = .NoStyle
                
                
                let runObject = User.sharedInstance().at(i)
                let dateToAdd = formatter.stringFromDate(runObject.timestamp)
                dates.addObject(dateToAdd)
                
                //get distance
                distance.addObject(Float(User.sharedInstance().at(i).distance)!)
                
                //TODO  PACE
                var pace = User.sharedInstance().at(i).pace
                
                if (pace == "--" || pace == "00:00") {
                    dates.removeLastObject()
                    distance.removeLastObject()
                }
                else{
                    let range = pace.rangeOfString("/mile")
                    let index = range?.startIndex
                    pace = pace.substringToIndex(index!)
                    let char = pace.rangeOfString(":")
                    let cIndex = char?.startIndex
                    let mins = pace.substringToIndex(cIndex!)
                    let secs = pace.substringFromIndex((cIndex?.successor())!)
                    
                    let paceInSeconds = Int(mins)!*60 + Int(secs)!
                    let overAllPace = Float(paceInSeconds)/60.0
                    
                    paces.addObject(overAllPace)
                }
                
            }
            completionHandler(count: count)

        }
        else{
            completionHandler(count: 0)
        }
    }


    
    //Nav bar function to dismiss view controller
    func toHome(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        let min = (dates.count < 15) ? dates.count : 15
        
        return min
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        if graph == simpleLineGraphDistance {
            return CGFloat(distance[index] as! Float)
        }
        else {
            return CGFloat(paces[index] as! Float)
        }
    }
    
  
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        return dates[index] as! String
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, didTouchGraphWithClosestIndex index: Int) {
    }
    func lineGraph(graph: BEMSimpleLineGraphView, didReleaseTouchFromGraphWithClosestIndex index: CGFloat) {
    }
    
    
    func popUpSuffixForlineGraph(graph: BEMSimpleLineGraphView) -> String {
        if graph == simpleLineGraphPace {
            return "/mile"
        }
        else {
            return " miles"
        }
    }
    
    func baseValueForYAxisOnLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return CGFloat(0)
    }
    
    func maxValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        let points = numberOfPointsInLineGraph(graph)
        var max: Float = 0.0
        if graph == simpleLineGraphDistance {
            for i in 0 ..< points {
                if distance[i] as! Float > max  {
                    max = distance[i] as! Float
                }
            }
        }
        else {
            for i in 0 ..< points {
                if paces[i] as! Float > max  {
                    max = paces[i] as! Float
                }
            }
        }
        return CGFloat(max + (max * 0.1))
    }
    
    func incrementValueForYAxisOnLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        let minValue = graph.calculateMinimumPointValue()
        let maxValue = graph.calculateMaximumPointValue()
        
        let range = maxValue.floatValue - minValue.floatValue
        
        var increment: Float! = 0.01
        if(range < 0.1){
            increment = 0.01
        } else if (range <  1) {
            increment = 0.1;
        } else if (range < 2) {
            increment = 0.25;
        } else if (range < 10) {
            increment = 1.0;
        } else if (range < 100) {
            increment = 10;
        } else {
            increment = 100;
        }
        return CGFloat(increment)
        
        
        
    }

    
}
