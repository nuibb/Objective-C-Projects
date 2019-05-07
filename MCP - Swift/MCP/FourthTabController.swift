//
//  FourthTabController.swift
//  MCP
//
//  Created by Nascenia on 5/20/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit
import MapKit

class FourthTabController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    var source:MKMapItem?
    var destination: MKMapItem?
    
    func getLocationObject(latitude:Double, longitude:Double) -> CLLocationCoordinate2D {
       /* return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )*/
        
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    func getDirections() {
        let sourceCoordinate = self.getLocationObject(51.558650000000000000, longitude: -0.107430000000022120)
        var sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate, addressDictionary: nil)
        source = MKMapItem(placemark: sourcePlacemark)
        
        let destinationCoordinate = self.getLocationObject(51.485093000000000000, longitude: -0.174936000000002420)
        var desitnationPlacemark = MKPlacemark(coordinate:destinationCoordinate, addressDictionary: nil)
        destination = MKMapItem(placemark: desitnationPlacemark)
        
        let request = MKDirectionsRequest()
        //request.setSource(MKMapItem.mapItemForCurrentLocation())
        request.setSource(source!)
        request.setDestination(destination!)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler({(response:
            MKDirectionsResponse!, error: NSError!) in
            
            if error != nil {
                println(error)
            } else {
                self.showRoute(response)
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.getDirections()

    }
    
    func makeRegionOnMapView(location : CLLocationCoordinate2D){
        //Set zoom span
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        //Create region on map view & show
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func showRoute(response: MKDirectionsResponse) {
        for route in response.routes as! [MKRoute] {
            
            self.mapView.addOverlay(route.polyline,
                level: MKOverlayLevel.AboveRoads)
            
            for step in route.steps {
                println(step.instructions)
            }
        }
        //let userLocation = self.mapView.userLocation
        //self.makeRegionOnMapView(self.getLocationObject(23.766647, longitude: 90.415210))
        
        let sourceCoordinate = self.getLocationObject(51.558650000000000000, longitude: -0.107430000000022120)
        let region = MKCoordinateRegionMakeWithDistance(
            sourceCoordinate, 2000, 2000)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay
        overlay: MKOverlay!) -> MKOverlayRenderer! {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 3.0
            return renderer
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
