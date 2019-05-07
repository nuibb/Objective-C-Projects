//
//  CheckInternetConnection.h
//  bdipo
//
//  Created by Nascenia on 3/30/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface CheckInternetConnection : NSObject
+ (BOOL) connectedToNetwork;
@end
