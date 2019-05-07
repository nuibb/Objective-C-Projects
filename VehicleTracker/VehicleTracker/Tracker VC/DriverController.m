//
//  DriverController.m
//  MCP
//
//  Created by Nascenia on 6/26/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "DriverController.h"
#import "Annotation.h"
#import "VehicleTracker.h"

@interface DriverController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stepsButton;
- (IBAction)stepsBtnClickListener:(id)sender;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *stepsArray;

@end

@implementation DriverController


- (CLLocationCoordinate2D) getLocationObject: (double)latitude toLong:(double)longitude {
    CLLocationCoordinate2D coordinate = {
        latitude,
        longitude
    };
    
    return coordinate;
}

- (void) makeRegionOnMap {
    CLLocationCoordinate2D sourceCoordinate = [self getLocationObject:51.558650000000000000 toLong:-0.107430000000022120];
    [self.mapView setRegion:MKCoordinateRegionMake(sourceCoordinate, MKCoordinateSpanMake(0.05,0.05))
                   animated:YES];
}

- (void) showRoute:(MKDirectionsResponse *) response {
    for (MKRoute *route in response.routes) {
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps) {
            [self.stepsArray addObject:step.instructions];
        }
    }
    
    [self makeRegionOnMap];
}

- (void) addAnnotation:(CLLocationCoordinate2D) location toName:(NSString *)name {
    Annotation *annotation = [[Annotation alloc] initWithCoordinate:location forTitle:name forSubTitle:@""];
    [self.mapView addAnnotation:annotation];
}

- (void) getDirections {
    
    CLLocationCoordinate2D sourceCoordinate = [self getLocationObject:51.558650000000000000 toLong:-0.107430000000022120];
    
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoordinate addressDictionary:nil];
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    
    CLLocationCoordinate2D destinationCoordinate = [self getLocationObject:51.485093000000000000 toLong:-0.174936000000002420];
    [self addAnnotation:destinationCoordinate toName:@"Destination"];
    
    MKPlacemark *desitnationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoordinate addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:desitnationPlacemark];
    //[source setName:@"Source Location"];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:source];
    [request setDestination:destination];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    request.requestsAlternateRoutes = NO;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"%@", error);
         } else {
             [self showRoute:response];
         }
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.stepsArray = [NSMutableArray new];
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    [self getDirections];
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
}

- (MKOverlayRenderer *) mapView:(MKMapView *) mapView viewForOverlay:(id) overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        routeRenderer.lineWidth = 3.0;
        return routeRenderer;
    } else {
        return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepsBtnClickListener:(id)sender {
    if (self.stepsArray.count != 0) {
        [self performSegueWithIdentifier:@"Steps" sender:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    VehicleTracker *vc = [segue destinationViewController];
    vc.stepsArray = self.stepsArray;
}


@end
