//
//  Annotation.h
//  MCP
//
//  Created by Nascenia on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//Working with Multiple Points
#define ARROW_ANNOTATION @"ARROW_ANNOTATION"
#define PIN_ANNOTATION @"PIN_ANNOTATION"

@interface Annotation : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D _coordinate;
}

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *territory;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate forTitle:(NSString *)title forSubTitle:(NSString *)territory;
- (CLLocation *) getLocation;

//Add a Callout
- (NSString*) title;
- (NSString*) subtitle;

//Working with Multiple Points
@property(nonatomic, strong) NSString *typeOfAnnotation;

//Determine the direction
@property CLLocationDirection direction;

@end
