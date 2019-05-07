//
//  ShowAlert.m
//  bdipo
//
//  Created by Nascenia on 3/25/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "ShowAlert.h"

@implementation ShowAlert
+ (void)alertWithMessage:(NSString *)title message:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
