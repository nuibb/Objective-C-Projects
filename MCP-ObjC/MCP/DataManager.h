//
//  DataManager.h
//  MCP
//
//  Created by Nascenia on 6/1/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DelegateForUpdateCurrentLocation;

@interface DataManager : NSObject

@property (nonatomic, weak) IBOutlet id <DelegateForUpdateCurrentLocation> delegate;
-(void) getCurrentLocation:(NSInteger)_id;

@end

#pragma mark -

@protocol DelegateForUpdateCurrentLocation <NSObject>

@optional
- (void)currentLocationHasBeenUpdated:(NSDictionary *)location;
@end