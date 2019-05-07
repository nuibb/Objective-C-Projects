//
//  BeaconItem.h
//  iBeacon Example
//
//  Created by Rafay Hasan on 5/26/15.
//  Copyright (c) 2015 Rafay Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface BeaconItem : NSObject <NSCoding>


@property (strong, nonatomic,readonly) NSString *name;
@property (strong, nonatomic,readonly) NSUUID *uuid;
@property (assign, nonatomic,readonly) CLBeaconMajorValue majorValue;
@property (assign, nonatomic,readonly) CLBeaconMinorValue minorValue;

@property (strong, nonatomic) CLBeacon *lastSeenBeacon;


- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor;

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;

@end
