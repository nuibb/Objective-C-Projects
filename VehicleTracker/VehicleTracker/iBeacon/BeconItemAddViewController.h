//
//  BeconItemAddViewController.h
//  MCP
//
//  Created by Rafay Hasan on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BeaconItem;

typedef void(^BeaconItemAddItemCompletion)(BeaconItem *newItem);

@interface BeconItemAddViewController : UIViewController

@property (nonatomic, copy) BeaconItemAddItemCompletion itemAddedCompletion;

@end
