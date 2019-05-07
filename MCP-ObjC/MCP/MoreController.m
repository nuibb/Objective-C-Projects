//
//  MoreController.m
//  MCP
//
//  Created by Nascenia on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "MoreController.h"
#import "Annotation.h"

@interface MoreController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Annotation *destination;
@end

@implementation MoreController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CLLocationCoordinate2D sourceCoordinate = {
        51.0455555556,
        1.94722222222
    };

    CLLocationCoordinate2D destCoordinate = {
        51.0491666667,
        1.80805555556
    };
    
    CLLocationCoordinate2D dest = {
        52.0491666667,
        -6.80805555556
    };
    
    Annotation *sourceAnnotation = [[Annotation alloc] initWithCoordinate:sourceCoordinate forTitle:@"Source" forSubTitle:@"From"];
    [sourceAnnotation setTypeOfAnnotation:PIN_ANNOTATION];
    
    
    Annotation *destAnno = [[Annotation alloc] initWithCoordinate:dest forTitle:@"Source" forSubTitle:@"From"];
    [sourceAnnotation setTypeOfAnnotation:PIN_ANNOTATION];
    
    Annotation *destAnnotation = [[Annotation alloc] initWithCoordinate:destCoordinate forTitle:@"Destination" forSubTitle:@"To"];
    [destAnnotation setTypeOfAnnotation:ARROW_ANNOTATION];
    
    [destAnnotation setDirection:[self getDirection:sourceAnnotation toDest:destAnnotation]];
    [self makeOverlayPathBetweenConsecutiveLocation:sourceAnnotation toDest:destAnnotation];
    
    [self.mapView addAnnotation:sourceAnnotation];
    [self.mapView addAnnotation:destAnnotation];
    [self.mapView addAnnotation:destAnno];
    [self.mapView setRegion:MKCoordinateRegionMake(destCoordinate, MKCoordinateSpanMake(0.3, 0.3)) animated:YES];
    
    self.destination = destAnnotation;
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
    NSString *reuseId = @"custom";
    
    if ([annotation isKindOfClass:[Annotation class]]){
        Annotation *_annotation = (Annotation*)annotation;
        if ([[_annotation typeOfAnnotation] isEqualToString:PIN_ANNOTATION]) {
            customAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            [customAnnotationView setCanShowCallout:YES];
        } else {
            customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            
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

/*- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MKMapCamera *camera = self.mapView.camera;
    CLLocationDirection mapAngle = camera.heading;
    NSLog(@"map angle :  %f", mapAngle);

    if (mapAngle && (self.destination != nil)) {
        //Determine the arrow icon direction
        [self.mapView removeAnnotation:self.destination];
        [self.destination setDirection:mapAngle];
        [self.mapView addAnnotation:self.destination];
    }
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
