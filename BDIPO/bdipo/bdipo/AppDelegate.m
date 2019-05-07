//
//  AppDelegate.m
//  bdipo
//
//  Created by Nascenia on 2/24/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void) setInitialViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BOOL loggedIn = NO;
    if (loggedIn) {
        UIViewController *tabBarControllerView = [sb instantiateViewControllerWithIdentifier:@"tabBarController"];
        [self.window setRootViewController:tabBarControllerView];
    }else{
        UIViewController *logInControllerView = [sb instantiateViewControllerWithIdentifier:@"logInViewController"];
        [self.window setRootViewController:logInControllerView];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setInitialViewController];
    
    //Set navigation bar tint color to change arrow color
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //Set navigation bar tint color to change background color
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed: 83.0f/255.0f green:80.0f/255.0f blue:162.0f/255.0f alpha:1.0]];
    
    //Set navigation bar title color
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0]}];
    
    //Set tab bar tint color
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed: 107.0f/255.0f green:199.0f/255.0f blue:190.0f/255.0f alpha:1.0]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed: 83.0f/255.0f green:80.0f/255.0f blue:162.0f/255.0f alpha:1.0]];
    
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
}

@end
