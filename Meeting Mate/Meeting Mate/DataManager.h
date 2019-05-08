//
//  DataManager.h
//  MCP
//
//  Created by Nascenia on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DelegateForUpdateMeetingInfo;
@protocol DelegateForMeetingParticipants;

@interface DataManager : NSObject

@property (nonatomic, weak) IBOutlet id <DelegateForUpdateMeetingInfo> delegate;
@property (nonatomic, weak) IBOutlet id <DelegateForMeetingParticipants> delegate1;
-(void) getMeetingInfos;
-(void) getMeetingParticipantsList:(NSString *)_id;

@end

#pragma mark -

@protocol DelegateForUpdateMeetingInfo <NSObject>

@optional
- (void)meetingInfoHasBeenUpdated:(NSDictionary *)meeting_info;

@end


#pragma mark -

@protocol DelegateForMeetingParticipants <NSObject>

@optional
- (void)getMeetingParticipants:(NSDictionary *)participantsInfo;

@end