//
//  MasterViewController.h
//  Meeting Mate
//
//  Created by Ashik Mahmud on 8/4/15.
//  Copyright (c) 2015 mobioapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#include "DataManager.h"
#include "ShareInfoCell.h"
#include "UserInfoCell.h"
#import "AFNetworking.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController<DelegateForUpdateMeetingInfo, DelegateForShareMeetingInfo, DelegateForMeetingParticipants, MFMailComposeViewControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UIScrollViewDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

