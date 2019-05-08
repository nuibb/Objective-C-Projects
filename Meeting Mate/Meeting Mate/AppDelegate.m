//
//  AppDelegate.m
//  Meeting Mate
/// Nuibb/Office/Meeting Mate/Meeting Mate 2/Meeting Mate.xcodeproj
//  Created by Ashik Mahmud on 8/4/15.
//  Copyright (c) 2015 mobioapp. All rights reserved.
//
#import <PSPDFKit/PSPDFKit.h>
#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [PSPDFKit setLicenseKey:@"yhEqu8TGdp0MRteGAALnoIV7uSsOREMTjvHMsL0/XTB+gGvSQL/3bAAA45xMXmuEAJh3IDsbtnievlJrFGkXkNKD5JzHAm+lGuqyVbdubmQ5WTAuegDEEulMf15IXL8TXffinhbn5DJUEQpg+j+gdRE5vJzzK0tKWvFS7jOMzmekzsQGI/fKnH2pATN3vmD95ZSZ7/hc4AzBjfQl67pA21EwbTqSM2QQJMK7XS2eokDH3iuNZdzwkNClUGJKsGgEA+sVtn8vND8L3gNY8lsbCM57fXpinlBIgFVzh3mjHUSFhsp2+jf6BJcoVtpeDw67m4w+gvjQLtJBrYdu3GGNmgEClQtZ+3YHOeWdjf/eR+gZfrpTH9LnmI7gTpV4FgmjaxQSgAvcohUfexwvFzjJSgxByvGRFXj4Vo6lbQFnc2CCZ3LKrVfHZfCr3etyXJm"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Set navigation bar title color
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed: 255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]}];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   //  PlugPDFUninit();
}

#pragma mark - Split view

/*- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}*/
 
 

@end
