//
//  YBStationMapViewController.swift
//  YouBike
//
//  Created by SK on 4/27/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import MapKit

class YBStationMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var ybStationInfo = YBStationInfo()
//    var isSelectedByRow = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.ybkPaleGoldColor()
        self.title = ybStationInfo.name
            
        let location = CLLocationCoordinate2D(latitude: ybStationInfo.latitude, longitude: ybStationInfo.longitude)
    //        let span = MKCoordinateSpanMake(0.01, 0.01)
    //        let region = MKCoordinateRegion(center: location, span: span)
        let region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Coordinate"
        annotation.subtitle = "Latitude  = \(ybStationInfo.latitude), Longitude = \(ybStationInfo.longitude)"
        mapView.addAnnotation(annotation)
            

        mapView.setRegion(region, animated: true)

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
