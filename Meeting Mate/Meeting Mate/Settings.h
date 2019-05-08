//
//  Settings.h
//  bdipo
//
//  Created by Nascenia on 3/30/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property NSString *hostName;
-(NSString *) getLogInUrl;
-(NSString *) getMeetingInfo;
-(NSString *) getMeetingMemberList:(NSString *)_id;

@end
