//
//  ShipTrackerController.m
//  MCP
//
//  Created by Nascenia on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "ShipTrackerController.h"
#import "Annotation.h"

@interface ShipTrackerController ()

@property NSInteger currentShipId;
@property BOOL flag;
@property BOOL shipHasBeenChanged;
@property (strong, nonatomic) DataManager *dataManager;
@property (strong, nonatomic) Annotation *currentAnnotation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *changeShipClickListener;

//Array for Ship's history
@property (strong, nonatomic) NSMutableArray *arrayOfShip22;
@property (strong, nonatomic) NSMutableArray *arrayOfShip23;
@property (strong, nonatomic) NSMutableArray *arrayOfShip24;
@property (strong, nonatomic) NSMutableArray *arrayOfShip25;

@end

@implementation ShipTrackerController

- (CLLocationCoordinate2D) getLocationObject: (double)latitude toLong:(double)longitude {
    CLLocationCoordinate2D coordinate = {
        latitude,
        longitude
    };
    
    return coordinate;
}

- (void) makeOverlayPathBetweenConsecutiveLocation:(Annotation *)source toDest:(Annotation *)destination {
    MKMapPoint startPoint = MKMapPointForCoordinate(source.coordinate);
    MKMapPoint endPoint = MKMapPointForCoordinate(destination.coordinate);
    
    MKMapPoint *pointArray = malloc(sizeof(CLLocationCoordinate2D) * 2);
    pointArray[0] = startPoint;
    pointArray[1] = endPoint;
    MKPolyline *routeLine = [MKPolyline polylineWithPoints:pointArray count:2];
    [self.mapView addOverlay:routeLine];
}

- (CLLocationDirection) getDirection:(Annotation *)source toDest:(Annotation *)destination {
    CLLocation *startLocation = [source getLocation];
    CLLocation *endLocation = [destination getLocation];
    
    //Determine the direction
    double lat1 = startLocation.coordinate.latitude * M_PI / 180.0;
    double lon1 = startLocation.coordinate.longitude * M_PI / 180.0;
    double lat2 = endLocation.coordinate.latitude * M_PI / 180.0;
    double lon2 = endLocation.coordinate.longitude * M_PI / 180.0;
    
    double dLon = lon2 - lon1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double radiansBearing = atan2(y, x);
    
    CLLocationDirection directionBetweenPoints = radiansBearing * 180.0 / M_PI;
    
    return directionBetweenPoints;
}

- (void) makeRegionOnMap:(CLLocationCoordinate2D)location {
    [self.mapView setRegion:MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.05,0.05))
                   animated:YES];
}

- (void) createAnnotationForCurrentLocation : (NSDictionary *)locationObj {
    double latitude = [[locationObj valueForKey:@"latitude"] doubleValue];
    double longitude = [[locationObj valueForKey:@"longitude"] doubleValue];
    NSString *name = [locationObj valueForKey:@"name"];
    NSString *territory = [locationObj valueForKey:@"territory"];
    
    CLLocationCoordinate2D location = [self getLocationObject:latitude toLong:longitude];
    
    if (self.currentAnnotation != nil) {
        Annotation *annotation = [[Annotation alloc] initWithCoordinate:location forTitle:name forSubTitle:territory];
        [annotation setTypeOfAnnotation:ARROW_ANNOTATION];
        [annotation setDirection:[self getDirection:self.currentAnnotation toDest:annotation]];
        [self makeOverlayPathBetweenConsecutiveLocation:self.currentAnnotation toDest:annotation];
        [self.mapView removeAnnotation:self.currentAnnotation];
        self.currentAnnotation.typeOfAnnotation = PIN_ANNOTATION;
        [self.mapView addAnnotation:self.currentAnnotation];
        [self.mapView addAnnotation:annotation];
        self.currentAnnotation = annotation;
        [self makeRegionOnMap:location];
    } else {
        Annotation *annotation = [[Annotation alloc] initWithCoordinate:location forTitle:name forSubTitle:territory];
        [annotation setTypeOfAnnotation:PIN_ANNOTATION];
        self.currentAnnotation = annotation;
        [self.mapView addAnnotation:annotation];
        [self makeRegionOnMap:location];
    }
}

- (void) drawRoute:(NSArray *) path {
    NSInteger numberOfSteps = path.count;
    CLLocationCoordinate2D coordinates[numberOfSteps];
    
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [path objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        coordinates[index] = coordinate;
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [self.mapView addOverlay:polyLine];
}

-(void) createAnnotationsWithHistoryCoordinates:(NSMutableArray *)array {
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    double latitude;
    double longitude;
    NSString *name;
    NSString *territory;
    CLLocationCoordinate2D locationObj2D;
    NSInteger length = [array count];
    
    for (NSInteger i=0; i<length; i++) {
        latitude = [[array[i] valueForKey:@"latitude"] doubleValue];
        longitude = [[array[i] valueForKey:@"longitude"] doubleValue];
        name = [array[i] valueForKey:@"name"];
        territory = [array[i] valueForKey:@"territory"];
        locationObj2D = [self getLocationObject:latitude toLong:longitude];
        Annotation *annotation = [[Annotation alloc] initWithCoordinate:locationObj2D forTitle:name forSubTitle:territory];
        [annotation setTypeOfAnnotation:PIN_ANNOTATION];
        [locations addObject:annotation];
        [locationArray addObject:[annotation getLocation]];
    }
    
    if (length > 1) {
        Annotation *lastAnnotation = (Annotation *)[locations lastObject];
        [lastAnnotation setTypeOfAnnotation:ARROW_ANNOTATION];
        [lastAnnotation setDirection:[self getDirection:(Annotation *)locations[length-2] toDest:lastAnnotation]];
        [self drawRoute:locationArray];
    }
    
    [self.mapView addAnnotations:locations];
    [self makeRegionOnMap:locationObj2D];
    self.currentAnnotation = (Annotation *)[locations lastObject];
}

-(void) drawAnnotationsAndOverlayPath:(NSDictionary *)location {
    if (self.currentShipId == 22) {
        if ([self.arrayOfShip22 count] != 0) {
            NSDictionary *lastPosition = [self.arrayOfShip22 lastObject];
            if (![[lastPosition valueForKey:@"latitude"] isEqualToString:[location valueForKey:@"latitude"]] && ![[lastPosition valueForKey:@"longitude"] isEqualToString:[location valueForKey:@"longitude"]]) {
                [self.arrayOfShip22 addObject:location];
                [self createAnnotationsWithHistoryCoordinates:self.arrayOfShip22];
            } else {
                [self createAnnotationsWithHistoryCoordinates:self.arrayOfShip22];
            }
        } else {
            [self.arrayOfShip22 addObject:location];
            [self createAnnotationForCurrentLocation:location];
        }
    } else if (self.currentShipId == 23) {
        if ([self.arrayOfShip23 count] != 0) {
            NSDictionary *lastPosition = [self.arrayOfShip23 lastObject];
            if (![[lastPosition valueForKey:@"latitude"] isEqualToString:[location valueForKey:@"latitude"]] && ![[lastPosition valueForKey:@"longitude"] isEqualToString:[location valueForKey:@"longitude"]]) {
                [self.arrayOfShip23 addObject:location];
                [self createAnnotationsWithHistoryCoordinates:self.arrayOfShip23];
            } else {
                [self createAnnotationsWithHistoryCoordinates:self.arrayOfShip23];
            }
        } else {
            [self.arrayOfShip23 addObject:location];
            [self createAnnotationForCurrentLocation:location];
        }
    } else if (self.currentShipId == 24) {
        if ([self.arrayOfShip24 count] != 0) {
            NSDictionary *lastPosition = [self.arrayOfShip24 lastObject];
            if (![[lastPosition valueForKey:@"latitude"] isEqualToString:[location valueForKey:@"latitude"]] && ![[lastPosition valueForKey:@"longitude"] isEqualToString:[location valueForKey:@"longitude"]]) {
                [self.arrayOfShip24 addObject:location];
                [self createAnnotationsWithHistoryCoordinates:self.arrayOfShip24];
            } else {
                [self createAnnotationsWithHistoryCoordinates:self.arrayOfShip24];
            }
        } else {
            [self.arrayOfShip24 addObject:location];
            [self createAnnotationForCurrentLocation:location];
        }
    } else if (self.currentShipId == 25) {
        if ([self.arrayOfShip25 count] != 0) {
            NSDictionary *lastPosition = [self.arrayOfShip25 lastObject];
            if (![[lastPosition valueForKey:@"latitude"] isEqualToString:[location valueForKey:@"latitude"]] && ![[lastPosition valueForKey:@"longitude"] isEqualToString:[location valueForKey:@"longitude"]]) {
                [self.arrayOfShip25 addObject:location];
                [self createAnnotationsWithHistoryCoordinates:self.arrayOfShip25];
            } else {
                [self createAnnotationsWithHistoryCoordinates:self.arrayOfShip25];
            }
        } else {
            [self.arrayOfShip25 addObject:location];
            [self createAnnotationForCurrentLocation:location];
        }
    }
}

- (void) addToHistoryArray:(NSDictionary *)location {
    if (self.currentShipId == 22) {
        [self.arrayOfShip22 addObject:location];
    } else if (self.currentShipId == 23) {
        [self.arrayOfShip23 addObject:location];
    } else if (self.currentShipId == 24) {
        [self.arrayOfShip24 addObject:location];
    } else if (self.currentShipId == 25) {
        [self.arrayOfShip25 addObject:location];
    }
}

- (void)currentLocationHasBeenUpdated:(NSDictionary *)location {
    self.flag = NO;
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (self.shipHasBeenChanged) {
            [self drawAnnotationsAndOverlayPath:location];
            self.shipHasBeenChanged = NO;
        } else {
            [self addToHistoryArray:location];
            [self createAnnotationForCurrentLocation:location];
        }
    });
}

- (void) updateMapView {
    [self.dataManager getCurrentLocation:self.currentShipId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set Current Ship Id
    self.currentShipId = 22;
    
    //Initializing ship's history array
    self.arrayOfShip22 = [NSMutableArray new];
    self.arrayOfShip23 = [NSMutableArray new];
    self.arrayOfShip24 = [NSMutableArray new];
    self.arrayOfShip25 = [NSMutableArray new];
    
    //Get gps locations from data manager
    self.dataManager = [DataManager new];
    self.dataManager.delegate = self;
    [self.dataManager getCurrentLocation:self.currentShipId];
    
    //Get GPS location by scheduling time
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateMapView) userInfo:nil repeats:YES];
    self.mapView.rotateEnabled = NO;
}

- (MKOverlayRenderer *) mapView:(MKMapView *) mapView viewForOverlay:(id) overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        routeRenderer.lineWidth = 2.0;
        return routeRenderer;
    } else {
        return nil;
    }
}


//Determine the direction of arrow icon
- (UIImage*)rotatedImage:(UIImage*)sourceImage byDegreesFromNorth:(double)degrees {
    CGSize rotateSize =  sourceImage.size;
    UIGraphicsBeginImageContext(rotateSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rotateSize.width/2, rotateSize.height/2);
    CGContextRotateCTM(context, ( degrees * M_PI/180.0 ) );
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(-rotateSize.width/2,-rotateSize.height/2,rotateSize.width, rotateSize.height),
                       sourceImage.CGImage);
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rotatedImage;
}

//Make custom annotaion pin if the annotation is of ship's current position
- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation: (id) annotation {
    MKAnnotationView *customAnnotationView;
    static NSString *reusePin = @"pin";
    static NSString *reuseArrow = @"arrow";
    
    if ([annotation isKindOfClass:[Annotation class]]){
        Annotation *_annotation = (Annotation*)annotation;
        if ([[_annotation typeOfAnnotation] isEqualToString:PIN_ANNOTATION]) {
            customAnnotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:reusePin];
            
            if (customAnnotationView == nil) {
                customAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusePin];
            }
            
            [customAnnotationView setCanShowCallout:YES];
        } else {
            customAnnotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:reuseArrow];
            
            if (customAnnotationView == nil) {
                customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseArrow];
            }
            
            //Determine the direction
            UIImage *arrowImage = [UIImage imageNamed:@"arrow"];
            double direction = [_annotation direction];
            [customAnnotationView setImage:[self rotatedImage:arrowImage byDegreesFromNorth:direction]];
            [customAnnotationView setCanShowCallout:YES];
        }
    } else {
        return nil;
    }
    
    return customAnnotationView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) ship22 {
    if (self.currentShipId != 22) {
        self.currentShipId = 22;
        self.shipHasBeenChanged = YES;
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView removeAnnotations:[self.mapView annotations]];
        self.currentAnnotation = nil;
        [self.dataManager getCurrentLocation:self.currentShipId];
    }
}

-(void) ship23 {
    if (self.currentShipId != 23) {
        self.currentShipId = 23;
        self.shipHasBeenChanged = YES;
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView removeAnnotations:[self.mapView annotations]];
        self.currentAnnotation = nil;
        [self.dataManager getCurrentLocation:self.currentShipId];
    }
}
-(void) ship24 {
    if (self.currentShipId != 24) {
        self.currentShipId = 24;
        self.shipHasBeenChanged = YES;
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView removeAnnotations:[self.mapView annotations]];
        self.currentAnnotation = nil;
        [self.dataManager getCurrentLocation:self.currentShipId];
    }
}

-(void) ship25 {
    if (self.currentShipId != 25) {
        self.currentShipId = 25;
        self.shipHasBeenChanged = YES;
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView removeAnnotations:[self.mapView annotations]];
        self.currentAnnotation = nil;
        [self.dataManager getCurrentLocation:self.currentShipId];
    }
}

- (IBAction)changeShipClickListener:(id)sender {
    UIAlertController *_actionSheetController = [UIAlertController alertControllerWithTitle:@"Do you want to change the ship to track ?" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *ship22 = [UIAlertAction actionWithTitle:@"Ship No - 22" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self performSelector:@selector(ship22) withObject:nil];
    }];
    
    UIAlertAction *ship23 = [UIAlertAction actionWithTitle:@"Ship No - 23" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self performSelector:@selector(ship23) withObject:nil];
    }];
    
    UIAlertAction *ship24 = [UIAlertAction actionWithTitle:@"Ship No - 24" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self performSelector:@selector(ship24) withObject:nil];
    }];
    
    UIAlertAction *ship25 = [UIAlertAction actionWithTitle:@"Ship No - 25" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self performSelector:@selector(ship25) withObject:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [_actionSheetController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [_actionSheetController addAction:ship22];
    [_actionSheetController addAction:ship23];
    [_actionSheetController addAction:ship24];
    [_actionSheetController addAction:ship25];
    [_actionSheetController addAction:cancel];
    [self presentViewController:_actionSheetController animated:YES completion:nil];
}

@end
