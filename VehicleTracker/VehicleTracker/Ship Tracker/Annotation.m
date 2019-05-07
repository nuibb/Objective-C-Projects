//
//  Annotation.m
//  MCP
//
//  Created by Nascenia on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//


#import "Annotation.h"

@implementation Annotation

@synthesize coordinate=_coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate forTitle:(NSString *)title forSubTitle:(NSString *)territory {
    self = [super init];
    
    if (self != nil) {
        _coordinate = coordinate;
        _name = title;
        _territory = territory;
    }
    
    return self;
}

-(CLLocation *) getLocation {
    return [[CLLocation alloc] initWithLatitude: _coordinate.latitude longitude: _coordinate.longitude];
}


//Add a Callout
- (NSString*) title {
    return self.name;
}

//Add a Callout
- (NSString*) subtitle {
    return self.territory;
}

@end
