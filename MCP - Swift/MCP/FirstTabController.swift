//
//  FirstTabController.swift
//  MCP
//
//  Created by Nascenia on 5/18/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit
import MapKit

class FirstTabController: UIViewController, MKMapViewDelegate, DelegateForUpdateCurrentLocation {
    
    @IBOutlet weak var mapView: MKMapView!
    //var gpsLocations : [[String: AnyObject]]!
    var dataManager : DataManager!
    var currentAnnotation : Annotation!
    
    func deleteAllAnnotationsFromMapView(){
        let annotationsToRemove = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
        self.mapView.removeAnnotations(annotationsToRemove)
    }
    
    //Return CLLocation Coordinate
    func getLocationObject(latitude:Double, longitude:Double) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
    
    func getDirection(source : Annotation, destination : Annotation) -> CLLocationDirection {
        var startLocation = source.getLocation()
        var endLocation = destination.getLocation()
        
        // 17 - Determine the direction
        let lat1  = startLocation.coordinate.latitude * M_PI / 180.0;
        let lon1 = startLocation.coordinate.longitude * M_PI / 180.0;
        let lat2 = endLocation.coordinate.latitude * M_PI / 180.0;
        let lon2 = endLocation.coordinate.longitude * M_PI / 180.0;
        
        let dLon = lon2 - lon1;
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        
        let directionBetweenPoints : CLLocationDirection = radiansBearing * 180.0 / M_PI
        return directionBetweenPoints
    }
    
    func makeOverlayPathBetweenConsecutiveLocation(source : Annotation, destination : Annotation){
        var startPoint = MKMapPointForCoordinate(source.coordinate)
        var endPoint = MKMapPointForCoordinate(destination.coordinate)
        
        var points: [MKMapPoint] = [startPoint, endPoint]
        let line = MKPolyline(points: &points, count: points.count)
        
        self.mapView.addOverlay(line)
    }
    
    func setDirection(source : Annotation, destination : Annotation){
        if source.typeOfAnnotation == ARROW_ANNOTATION {
            var startAnnotation = source
            var startLocation = CLLocation(latitude: source.coordinate.latitude, longitude: destination.coordinate.longitude)
            var endLocation = CLLocation(latitude: source.coordinate.latitude, longitude: destination.coordinate.longitude)
            let meters = startLocation.distanceFromLocation(endLocation)
            //println("Distance : \(meters) Km")
            
            // 17 - Determine the direction
            let lat1  = startLocation.coordinate.latitude * M_PI / 180.0;
            let lon1 = startLocation.coordinate.longitude * M_PI / 180.0;
            let lat2 = endLocation.coordinate.latitude * M_PI / 180.0;
            let lon2 = endLocation.coordinate.longitude * M_PI / 180.0;
            
            let dLon = lon2 - lon1;
            let y = sin(dLon) * cos(lat2);
            let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
            let radiansBearing = atan2(y, x);
            
            let directionBetweenPoints : CLLocationDirection = radiansBearing * 180.0 / M_PI
            startAnnotation.direction = directionBetweenPoints
            self.mapView.removeAnnotation(startAnnotation)
            self.mapView.addAnnotation(startAnnotation)
        }
    }
    
    func makeRegionOnMapView(location : CLLocationCoordinate2D){
        //Set zoom span
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        //Create region on map view & show
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    //Create annotaion for current ship position
    func createAnnotationForCurrentPosition(location:[String: AnyObject]) {
        let latitude = (location["latitude"] as? Double)!
        let longitude = (location["longitude"] as? Double)!
        let name = (location["locationName"] as? String)!
        let territory = (location["territory"] as? String)!
        let location = self.getLocationObject(latitude, longitude: longitude)
        
        if self.currentAnnotation != nil {
            var annotation : Annotation = Annotation(coordinate: location, title: name, subTitle: territory)
            annotation.typeOfAnnotation = ARROW_ANNOTATION as String
            annotation.direction = self.getDirection(self.currentAnnotation, destination: annotation)
            self.makeOverlayPathBetweenConsecutiveLocation(self.currentAnnotation, destination: annotation)
            self.setDirection(self.currentAnnotation, destination: annotation)
            self.mapView.removeAnnotation(self.currentAnnotation)
            self.currentAnnotation.typeOfAnnotation = PIN_ANNOTATION as String
            self.mapView.addAnnotation(self.currentAnnotation)
            self.mapView.addAnnotation(annotation)
            self.currentAnnotation = annotation
            self.makeRegionOnMapView(location)
        } else {
            var annotation : Annotation = Annotation(coordinate: location, title: name, subTitle: territory)
            annotation.typeOfAnnotation = PIN_ANNOTATION as String
            self.currentAnnotation = annotation
            self.makeRegionOnMapView(location)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    //This function will fire when ship's current location has been updated
    func currentLocationHasBeenUpdated(location:[String: AnyObject]){
        dispatch_async(dispatch_get_main_queue()){
            self.createAnnotationForCurrentPosition(location)
        }
    }
    
    //Update map view by scheduling time if current location is changed yet
    func updateMapView() {
        self.dataManager.getCurrentLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get gps locations from data manager
        self.dataManager = DataManager()
        self.dataManager.delegate2 = self
        self.dataManager.getCurrentLocation()
        
        //Get GPS location by scheduling time
        NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("updateMapView"), userInfo: nil, repeats: true)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!{
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 2
            return polylineRenderer
        }
        
        return nil
    }
    
    func rotatedImage(sourceImage:UIImage, byDegreesFromNorth degrees:Double) -> UIImage {
        var rotateSize : CGSize = sourceImage.size
        UIGraphicsBeginImageContext(rotateSize)
        let context  = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, rotateSize.width/2, rotateSize.height/2);
        CGContextRotateCTM(context, CGFloat(M_PI*degrees/180))
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(UIGraphicsGetCurrentContext(),
            CGRectMake(-rotateSize.width/2,-rotateSize.height/2,rotateSize.width, rotateSize.height),
            sourceImage.CGImage)
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
    
    //Make custom annotaion pin if the annotation is of ship's current position
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!{
        let reuseId = "custom"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        var customAnnotationView : MKAnnotationView!
        
        if let _annotation = annotation as? Annotation {
            if _annotation.typeOfAnnotation == PIN_ANNOTATION {
                customAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                customAnnotationView.canShowCallout = true
                //customAnnotationView.draggable = true
            } else {
                customAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                // 17 - Determine the direction
                let arrowImage = UIImage(named:"arrow")!
                let direction = _annotation.direction
                customAnnotationView.image = self.rotatedImage(arrowImage, byDegreesFromNorth: direction)
                customAnnotationView.canShowCallout = true
            }
        } else {
            return nil
        }
        
        return customAnnotationView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
