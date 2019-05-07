//
//  Annotation.swift
//  MCP
//
//  Created by Nascenia on 5/26/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

import UIKit
import MapKit

var ARROW_ANNOTATION : NSString = "ARROW_ANNOTATION"
var PIN_ANNOTATION  : NSString = "PIN_ANNOTATION"

class Annotation: NSObject, MKAnnotation {
    var currentLocation: CLLocationCoordinate2D
    var _title : String
    var subTitle : String
    var direction : CLLocationDirection!
    var typeOfAnnotation : String!
    
    init(coordinate: CLLocationCoordinate2D, title : String, subTitle : String) {
        self.currentLocation = coordinate
        self._title = title
        self.subTitle = subTitle
    }
    
    func getLocation() -> CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    var coordinate: CLLocationCoordinate2D {
        return self.currentLocation
    }
    
    var title : String {
        return self._title
    }
    
    var subtitle : String {
        return self.subTitle
    }
}
