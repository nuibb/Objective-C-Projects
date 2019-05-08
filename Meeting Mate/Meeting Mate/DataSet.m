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

-(void) getMeetingInfos:(void (^)(NSDictionary *))handler {
    [self.getService apiCallToGet:[self.settings getMeetingInfo] callback:^(NSDictionary *response){
        if ([response objectForKey:@"agenda_list"]) {
            handler([response objectForKey:@"agenda_list"]);
        }
    }];
}

-(void) getMeetingParticipantsList:(NSString *)_id callback:(void (^)(NSDictionary *))handler {
    NSLog(@"id   : %@", _id);
    [self.getService apiCallToGet:[self.settings getMeetingMemberList:_id] callback:^(NSDictionary *response){
        handler([response objectForKey:@"user_info"]);
    }];
}

@end
