//
//  AppDelegate.m
//  MCP
//
//  Created by Nascenia on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "AppDelegate.h"
#import "BeaconItem.h"



@import CoreLocation;

//NSString * const kRWTStoredItemsKey = @"storedItems";

@interface AppDelegate ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.beaconStatusArray = [NSMutableArray new];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    NSString *name,*major,*minor;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"20CAE8A0-A9CF-11E3-A5E2-0800200C9A66"];
    
    name = @"Nascenia Beacon";
    
    major = @"213";
    
    minor = @"2386";
    
    
    BeaconItem *newItem = [[BeaconItem alloc] initWithName:name
                                                      uuid:uuid
                                                     major:[major intValue]
                                                     minor:[minor intValue]];
    
    
    [tempArray addObject:newItem];
    
    
    uuid = [[NSUUID alloc] initWithUUIDString:@"20CAE8A0-A9CF-11E3-A5E2-0800200C9A66"];
    
    name = @"MCP Beacon";
    
    major = @"213";
    
    minor = @"1355";
    
    
    BeaconItem *newItem1 = [[BeaconItem alloc] initWithName:name
                                                      uuid:uuid
                                                     major:[major intValue]
                                                     minor:[minor intValue]];
    
    [tempArray addObject:newItem1];
    
    
    
    NSMutableArray *itemsDataArray = [NSMutableArray array];
    for (BeaconItem *item in tempArray) {
        NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
        [itemsDataArray addObject:itemData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:itemsDataArray forKey:@"storedItems"];


    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Just Exited a beacon region";
        notification.soundName = @"Default";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        
        NSLog(@"local notification called on exit...");
    }
}


-(void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Just Entered a beacon region";
        notification.soundName = @"Default";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        NSLog(@"local notification called on entering...");
        
    }
}

@end
