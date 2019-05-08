//
//  AlertController.h
//  Meeting Mate
//
//  Created by nuibb on 8/5/15.
//  Copyright (c) 2015 mobioapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertController : NSObject<UIAlertViewDelegate>

@property UIAlertController *alertController;
-(UIAlertController *) showAlertForPdfDownload;

@end
