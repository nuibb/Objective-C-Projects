//
//  PostService.h
//  bdipo
//
//  Created by Nascenia on 3/31/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostService : NSObject
- (void) apiCallToPost: (NSString *)url serializedData:(NSData *)data callback: (void(^)(NSDictionary *))handler;
@end
