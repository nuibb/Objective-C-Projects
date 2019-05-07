//
//  DataSet.m
//  MCP
//
//  Created by Nascenia on 5/28/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "DataSet.h"
#import "Settings.h"
#import "GetServices.h"

@interface DataSet ()//Extensions

@property (strong, nonatomic) Settings *settings;
@property (strong, nonatomic) GetServices *getService;
@property NSMutableDictionary *currentLocation;

@end

@implementation DataSet

- (id)init
{
    self = [super init];
    if (self) {
        _settings = [Settings new];
        _getService = [GetServices new];
    }
    return self;
}

- (void) getCurrentLocation:(NSInteger)_id callback:(void (^)(NSDictionary *))handler {
    [self.getService apiCallToGet:[self.settings getCoordinatesById:_id] callback:^(id response){
        NSArray *tempArray = [[NSArray alloc] initWithArray:response];
        if (tempArray.count != 0) {
            NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *item = tempArray[0];
            if ([item objectForKey:@"Lat"]) {
                [location setValue:[item objectForKey:@"Lat"] forKey:@"latitude"];
            }
            
            if ([item objectForKey:@"Long"]) {
                [location setValue:[item objectForKey:@"Long"] forKey:@"longitude"];
            }
            
            if ([item objectForKey:@"Name"]) {
                [location setValue:[item objectForKey:@"Name"] forKey:@"name"];
            }
            
            if ([item objectForKey:@"Territory"]) {
                [location setValue:[item objectForKey:@"Territory"] forKey:@"territory"];
            }
            
            //NSLog(@"Lat 1 : %@", [location valueForKey:@"latitude"]);
            //NSLog(@"Long 1 : %@", [location valueForKey:@"longitude"]);
            
            if (self.currentLocation != nil) {
                if (![[self.currentLocation valueForKey:@"latitude"] isEqualToString:[location valueForKey:@"latitude"]] && ![[self.currentLocation valueForKey:@"longitude"] isEqualToString:[location valueForKey:@"longitude"]]) {
                    //NSLog(@"Lat 2 : %@", [self.currentLocation valueForKey:@"latitude"]);
                    //NSLog(@"Long 2 : %@", [self.currentLocation valueForKey:@"longitude"]);
                    self.currentLocation = location;
                    handler(location);
                }
            } else {
                self.currentLocation = location;
                handler(location);
            }
        }
    }];
}

@end
