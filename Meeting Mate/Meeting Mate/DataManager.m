//
//  DataManager.m
//  MCP
//
//  Created by Nascenia on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "DataManager.h"
#include "DataSet.h"

@interface DataManager()

@property (strong, nonatomic) DataSet *dataSet;

@end

@implementation DataManager

- (id)init
{
    self = [super init];
    if (self) {
        _dataSet = [DataSet new];
    }
    return self;
}

-(void) getMeetingInfos {
    [self.dataSet getMeetingInfos:^(NSDictionary *response) {
        [self.delegate meetingInfoHasBeenUpdated:response];
    }];
}

-(void) getMeetingParticipantsList:(NSString *)_id {
    [self.dataSet getMeetingParticipantsList:_id callback:^(NSDictionary *response) {
        [self.delegate1 getMeetingParticipants:response];
    }];
}


@end
