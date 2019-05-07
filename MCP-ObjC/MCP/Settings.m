//
//  Settings.m
//  bdipo
//
//  Created by Nascenia on 3/30/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "Settings.h"

@implementation Settings

- (id)init
{
    self = [super init];
    if (self) {
        _hostName = @"http://console.mcp.com";
    }
    return self;
}

- (NSString*) getCoordinates {
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/mtracking.php?ship=25"];//22/25/23
}

- (NSString*) getCoordinatesById:(NSInteger)_id {
    return [NSString stringWithFormat:@"%@%@%ld", _hostName, @"/mtracking.php?ship=", (long)_id];//22/25/23
}

@end
