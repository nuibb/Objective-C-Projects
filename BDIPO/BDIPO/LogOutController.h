//
//  LogOutController.h
//  bdipo
//
//  Created by Nascenia on 4/24/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LogOutController : NSObject
@property UIAlertController *actionSheetController;
-(UIAlertController *) getActionSheet;
@end
