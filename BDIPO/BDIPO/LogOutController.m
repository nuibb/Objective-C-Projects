//
//  LogOutController.m
//  bdipo
//
//  Created by Nascenia on 4/24/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "LogOutController.h"
#import "AppDelegate.h"

@implementation LogOutController

-(void)logOut{
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *logInControllerView = [sb instantiateViewControllerWithIdentifier:@"logInViewController"];
    [appDelegateTemp.window setRootViewController:logInControllerView];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _actionSheetController = [UIAlertController alertControllerWithTitle:@"Do you want to logout ?" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *finish = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self performSelector:@selector(logOut) withObject:nil];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [_actionSheetController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [_actionSheetController addAction:finish];
        [_actionSheetController addAction:cancel];
        //_actionSheetController.view.tintColor = [UIColor blackColor];
    }
    return self;
}

-(UIAlertController *)getActionSheet{
    return _actionSheetController;
}

@end
