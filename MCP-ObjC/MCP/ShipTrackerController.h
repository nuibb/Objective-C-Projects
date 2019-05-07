//
//  ShipTrackerController.h
//  MCP
//
//  Created by Nascenia on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DataManager.h"

@interface ShipTrackerController : UIViewController <MKMapViewDelegate, DelegateForUpdateCurrentLocation>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
