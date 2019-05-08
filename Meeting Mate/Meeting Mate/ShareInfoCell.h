//
//  ShareInfoCell.h
//  Meeting Mate
//
//  Created by nuibb on 8/7/15.
//  Copyright (c) 2015 mobioapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DelegateForShareMeetingInfo;

@interface ShareInfoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id <DelegateForShareMeetingInfo> delegate;

@end


#pragma mark -

@protocol DelegateForShareMeetingInfo <NSObject>

@optional

- (void)shareMeetingInfoToParticipants;
- (void)cancelSharingMeetingInfo;

@end