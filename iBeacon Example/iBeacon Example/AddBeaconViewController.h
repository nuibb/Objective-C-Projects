//
//  AddBeaconViewController.h
//  iBeacon Example
//
//  Created by Rafay Hasan on 5/26/15.
//  Copyright (c) 2015 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BeaconItem;

typedef void(^BeaconItemAddItemCompletion)(BeaconItem *newItem);

@interface AddBeaconViewController : UIViewController


@property (nonatomic, copy) BeaconItemAddItemCompletion itemAddedCompletion;

@end
