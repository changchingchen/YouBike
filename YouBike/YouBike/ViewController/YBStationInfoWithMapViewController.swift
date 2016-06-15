//
//  YBStationInfoWithMapViewController.swift
//  YouBike
//
//  Created by SK on 4/28/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


enum MapType: Int {
    case Standard
    case Satellite
    case Hybrid
}

class YBStationInfoWithMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    var ybStationInfo = YBStationInfo()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
      
    @IBOutlet weak var ybStationMapView: MKMapView!
      
    @IBOutlet weak var stationNameCnLabel: UILabel!
    @IBOutlet weak var stationAddressCnLabel: UILabel!
    @IBOutlet weak var stationAvailableBikeLabel: UILabel!
  
    
    @IBOutlet weak var availableBikeDescriptionPrefixLabel: UILabel!
    @IBOutlet weak var availableBikeDescriptionSuffixLabel: UILabel!

    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    
    @IBAction func mapTypeChanged(sender: UISegmentedControl) {
        
        guard let mapType = MapType(rawValue: mapTypeSegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        switch mapType {
        case .Standard:
            ybStationMapView.mapType = MKMapType.Standard
        case .Satellite:
            ybStationMapView.mapType = MKMapType.Satellite
        case .Hybrid:
            ybStationMapView.mapType = MKMapType.Hybrid
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(view.frame.size.width)
        print(view.frame.size.height)
        self.navigationController?.navigationBar.tintColor = UIColor.ybkPaleGoldColor()
        
        initYBStationInfoView()
        initMapView()
        
        self.tabBarController?.tabBar.hidden = true

        // For current location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
        self.ybStationMapView.showsUserLocation = true
        
        // For draw the route
        self.ybStationMapView.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initYBStationInfoView() {
 
//        let bundle = NSBundle(forClass: self.dynamicType)
//        let nib = UINib(nibName: "YBStationInfoTableViewCell", bundle: nil)
//        let ybStationInfoView = nib.instantiateWithOwner(self, options: nil)[0] as! YBStationInfoTableViewCell
        
        stationNameCnLabel.text = ybStationInfo.area + " / " + ybStationInfo.name
        stationNameCnLabel.textColor = UIColor.ybkBrownishColor()
        stationNameCnLabel.font = UIFont.ybkTextStylePingFangTCMedium(20)
        stationNameCnLabel.textAlignment = NSTextAlignment.Left
        
        stationAddressCnLabel.text = ybStationInfo.address
        stationAddressCnLabel.textColor = UIColor.ybkSandBrownColor()
        stationAddressCnLabel.font = UIFont.ybkTextStylePingFangTCRegular(14)
        stationAddressCnLabel.textAlignment = NSTextAlignment.Left
        
        stationAvailableBikeLabel.text = "\(ybStationInfo.availableBike)"
        stationAvailableBikeLabel.textColor = UIColor.ybkDarkSalmonColor()
        stationAvailableBikeLabel.font = UIFont.ybkTextStyleHelveticaBold(80)
        stationAvailableBikeLabel.textAlignment = NSTextAlignment.Center
    
        availableBikeDescriptionPrefixLabel.text = "Available Bikes Prefix".localized
        availableBikeDescriptionPrefixLabel.textColor = UIColor.ybkSandBrownColor()
        availableBikeDescriptionPrefixLabel.font = UIFont.ybkTextStylePingFangTCMedium(20)
        
        availableBikeDescriptionSuffixLabel.text = "Available Bikes Suffix".localized
        availableBikeDescriptionSuffixLabel.textColor = UIColor.ybkSandBrownColor()
        availableBikeDescriptionSuffixLabel.font = UIFont.ybkTextStylePingFangTCMedium(20)
        
        mapTypeSegmentedControl.setTitle("Standard".localized, forSegmentAtIndex: 0)
        mapTypeSegmentedControl.setTitle("Satellite".localized, forSegmentAtIndex: 1)
        mapTypeSegmentedControl.setTitle("Hybrid".localized, forSegmentAtIndex: 2)

    }

    func initMapView() {
        let location = CLLocationCoordinate2D(latitude: ybStationInfo.latitude, longitude: ybStationInfo.longitude)
        let region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Coordinate"
        annotation.subtitle = "Latitude  = \(ybStationInfo.latitude), Longitude = \(ybStationInfo.longitude)"
        ybStationMapView.addAnnotation(annotation)
        ybStationMapView.setRegion(region, animated: true)
    }
    

    
    
    // MARK: - Location Delegate Methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)

        let region = MKCoordinateRegionMakeWithDistance(center, 1000, 1000)
        
        self.ybStationMapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        print("Current Location")
        
        showRoute(center)
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    

    // MARK: - Request Route
    func showRoute(currentLocation: CLLocationCoordinate2D) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: ybStationInfo.latitude, longitude: ybStationInfo.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .Walking
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.ybStationMapView.addOverlay(route.polyline)
                self.ybStationMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }

    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.ybkBarneyColor()
        renderer.lineWidth = 5.0
        return renderer
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
