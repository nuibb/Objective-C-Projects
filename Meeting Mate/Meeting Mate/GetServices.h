//
//  GetServices.h
//  bdipo
//
//  Created by Nascenia on 3/30/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetServices : NSObject
- (void) apiCallToGet: (NSString *)url callback: (void(^)(NSDictionary *))handler;
@end
