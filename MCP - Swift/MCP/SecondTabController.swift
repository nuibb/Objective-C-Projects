//
//  SecondTabController.swift
//  MCP
//
//  Created by Nascenia on 5/18/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit
import MapKit

class SecondTabController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        * To show current user location on map view
        * Check if sdk is iOS 8 or not
        * Initilize location manager
        */
        
        let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        if(iOS8) {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    // Tell MKMapView to zoom to current location when found
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!){
        let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(1.0, 1.0))
        self.mapView.setRegion(region, animated: true)
    }
    
    /*func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!){
        for view in views{
            if let annotationView = view as? MKAnnotationView{
                if annotationView.annotation === mapView.userLocation{
                    self.mapView.userLocation.title = "Current"
                    self.mapView.userLocation.subtitle = "Location"
                    
                    //Create region on map view & show
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.regionThatFits(region)
                    self.mapView.selectAnnotation(annotationView.annotation, animated: true)
                }
            }
        }
    }*/
    
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
